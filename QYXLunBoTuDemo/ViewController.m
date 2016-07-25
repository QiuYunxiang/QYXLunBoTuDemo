//
//  ViewController.m
//  QYXLunBoTuDemo
//
//  Created by 邱云翔 on 16/7/22.
//  Copyright © 2016年 邱云翔. All rights reserved.
//

//三张图片无限轮播,只依赖了SD去赋值


#import "ViewController.h"
#import "QYXLunBoTuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark 测试数据
    
    NSArray *imageDataArray = @[@"http://7xrxob.com2.z0.glb.qiniucdn.com/Fs4IB0MldeBzopdlxwmzNrJZciyE",@"http://7xrxob.com2.z0.glb.qiniucdn.com/Fh3frVXyBXFo0IcXrbA9iW9zP5Dx",@"http://7xrxob.com2.z0.glb.qiniucdn.com/FrYoGPiRwtm5s0FLZ7y0ANGvUBD-",@"http://7xrxob.com2.z0.glb.qiniucdn.com/Fl5L8gpVw7O-PRKJxDFWGQqCAPGZ",@"http://cdn.duitang.com/uploads/item/201512/20/20151220155233_X3yhm.jpeg",@"http://cdn.duitang.com/uploads/item/201512/20/20151220124415_8FzL2.jpeg"];
    
    QYXLunBoTuView *lunBoView = [[QYXLunBoTuView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, self.view.bounds.size.width / 16 * 9)];
    [self.view addSubview:lunBoView];
    lunBoView.imageDataArr = imageDataArray;
    
#pragma mark ------要轮播的话计时器和 ViewShouldBeginScroll 触发一个，定时器不手动触发的话默认不自动轮播，需要手动滑动
    
    if (imageDataArray.count > 1) {
        [lunBoView.timer fire];
    } else {
        [lunBoView ViewShouldBeginScroll];
    }
    
//    lunBoView.pageVC.hidden = YES;   --- 可隐藏小白点
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
