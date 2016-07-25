//
//  QYXLunBoTuView.m
//  QYXLunBoTuDemo
//
//  Created by 邱云翔 on 16/7/22.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import "QYXLunBoTuView.h"
#import "UIImageView+WebCache.h"
@interface QYXLunBoTuView ()<UIScrollViewDelegate>

{
    BOOL _timerIsBegin;
}
/**
 *  当前展示的view(中间的view)
 */
@property (nonatomic,strong) UIImageView *currentView;
/**
 *  左边的view
 */
@property (nonatomic,strong) UIImageView *leftView;
/**
 *  右边的view
 */
@property (nonatomic,strong) UIImageView *rightView;
/**
 *  间隔计时器(当手滑动时取消主定时器作用)
 */
@property (nonatomic,strong) NSTimer *dragTimer;
@end

@implementation QYXLunBoTuView

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpThings];
    }
    return self;
}

#pragma mark 基本配置
- (void)setUpThings {
    _currentIndex = 0;
    _timerIsBegin = NO;
    _realCount = NSIntegerMax;
    [self addObserver:self forKeyPath:@"imageDataArr" options:(NSKeyValueObservingOptionNew) context:nil];
    [self addSubview:self.scroll];
    [self addSubview:self.pageVC];
    [self.scroll addSubview:self.currentView];
    [self.scroll addSubview:self.leftView];
    [self.scroll addSubview:self.rightView];
    
}

#pragma mark 关键方法必须触发(开启定时器可以直接触发)
- (void)ViewShouldBeginScroll {
    [UIView animateWithDuration:0.4 animations:^{
        [self.scroll setContentOffset:CGPointMake(self.scroll.contentOffset.x + self.frame.size.width, 0) animated:NO];
    } completion:^(BOOL finished) {
        [self scrollViewDidEndDecelerating:self.scroll];
    }];
}

#pragma  mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!self.imageDataArr) {
        return;
    }
    if (0 == self.scroll.contentOffset.x) {
        _currentIndex --;
    } else if (self.frame.size.width * 2 == self.scroll.contentOffset.x) {
        _currentIndex ++;
    }
    
    NSInteger leftIndex,rightIndex;
    
    if (_currentIndex == -1 ) {
        _currentIndex = self.imageDataArr.count - 1;
    };
    
    if (_currentIndex == self.imageDataArr.count) {
        _currentIndex = 0;
    }
    
    //适应两张的情况
    if (_currentIndex >= _realCount) {
        _currentIndex = _currentIndex % _imageDataArr.count;
    }
    
    rightIndex = _currentIndex + 1;
    leftIndex = _currentIndex - 1;
    if (rightIndex == self.imageDataArr.count) {
        rightIndex = 0;
    };
    if (leftIndex == -1) {
        leftIndex = self.imageDataArr.count - 1;
    };
    
    [self setUpValueForImageViewWith:leftIndex rightIndex:rightIndex];
    [self.scroll setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
}

#pragma mark 优化拖拽时的主定时器还在滑动视图问题
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_dragTimer invalidate];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_timer) {
        self.dragTimer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(timerShouldBegin) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_dragTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerShouldBegin {
    [_timer setFireDate:[NSDate distantPast]];
}

#pragma mark 切换视图赋值
- (void)setUpValueForImageViewWith:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {
    [self.leftView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArr[leftIndex]] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    [self.currentView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArr[_currentIndex]] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    [self.rightView sd_setImageWithURL:[NSURL URLWithString:self.imageDataArr[rightIndex]] placeholderImage:[UIImage imageNamed:@"placeholderimage"]];
    NSInteger index = _currentIndex;
    if (_currentIndex >= _realCount) {
        index = _currentIndex % _realCount;
    }
    self.pageVC.currentPage = index;
}

#pragma  mark - SelfDelegate -
- (void)tellDelegateShouldAction:(UITapGestureRecognizer *)tap {
    NSInteger index = _currentIndex;
    if (_currentIndex >= _realCount) {
        index = _currentIndex % _realCount;
    }
    //获得此时下标
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapImageView:)]) {
        [self.delegate tapImageView:index];
    }
}

#pragma mark - 监听 -(用来判断当前数据源中的个数，从而适配1张和2张的情况)
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"imageDataArr"]) {
        if (_imageDataArr.count == 1) {
            self.scroll.scrollEnabled = NO;
            _realCount = 1;
        }
        if (_imageDataArr.count == 2) {
            _realCount = 2;
            self.imageDataArr = @[_imageDataArr[0],_imageDataArr[1],_imageDataArr[0],_imageDataArr[1]];
        }
    }
}

#pragma mark SetterAndGetter
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3.0f target:self selector:@selector(ViewShouldBeginScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (UIScrollView *)scroll {
    if (!_scroll) {
        _scroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scroll.pagingEnabled = YES;
        _scroll.bounces = NO;
        _scroll.showsVerticalScrollIndicator = NO;
        _scroll.showsHorizontalScrollIndicator = NO;
        _scroll.delegate = self;
        [_scroll setContentOffset:CGPointMake(0, 0)];
        _scroll.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    }
    return _scroll;
}

- (UIPageControl *)pageVC {
    if (!_pageVC) {
        _pageVC = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        _pageVC.center = CGPointMake(self.frame.size.width/2, self.frame.size.height - 20) ;
        _pageVC.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.4];
        _pageVC.numberOfPages = _imageDataArr.count;
        if (_realCount == 1 || _realCount == 2) {
            _pageVC.numberOfPages = _realCount;
        }
        if (_realCount == 1) {
            _pageVC.hidden = YES;
        }
    }
    return _pageVC;
}

- (UIImageView *)currentView {
    if (!_currentView) {
        _currentView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        _currentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(tellDelegateShouldAction:)];
        [_currentView addGestureRecognizer:tap];
    }
    return _currentView;
}

- (UIImageView *)leftView {
    if (!_leftView) {
        _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _leftView;
}

- (UIImageView *)rightView {
    if (!_rightView) {
        _rightView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _rightView;
}

#pragma mark 销毁
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"imageDataArr"];
}


@end
