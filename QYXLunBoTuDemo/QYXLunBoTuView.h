//
//  QYXLunBoTuView.h
//  QYXLunBoTuDemo
//
//  Created by 邱云翔 on 16/7/22.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QYXLunBoTuDelegate <NSObject>
@optional
/**
 *  点击了图片
 *
 *  @param index 第几张图片
 */
- (void)tapImageView:(NSInteger)index;

@end

@interface QYXLunBoTuView : UIView
/**
 *  主ScrollView
 */
@property (nonatomic,strong) UIScrollView *scroll;
/**
 *  小白点可手动隐藏
 */
@property (nonatomic,strong) UIPageControl *pageVC;
//@property (nonatomic,strong) UIView *view;
/**
 *  定时器（默认不触发）
 */
@property (nonatomic,strong) NSTimer *timer;
/**
 *  装图片地址的数组
 */
@property (nonatomic,strong) NSArray <NSString *>*imageDataArr;
//@property (nonatomic,strong) NSArray *dataArray; //数据源<特殊情况使用>
/**
 *  当前展示的图片下标
 */
@property (nonatomic,assign) NSUInteger currentIndex;
/**
 *  实际图片个数（为了适应1张不轮播和2张得情况）
 */
@property (nonatomic,assign) NSUInteger realCount;
/**
 *  代理
 */
@property (nonatomic,weak) id <QYXLunBoTuDelegate> delegate;

/**
 *  手动触发一次（开启定时器可忽略）
 */
- (void)ViewShouldBeginScroll;
@end
