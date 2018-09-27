//
//  WWWTestView.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/9/25.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestView.h"

@interface WWWTestView () {
    UIView *_view;
}

@end


@implementation WWWTestView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createSubviewsAndAdd];
    }
    return self;
}

- (void)createSubviewsAndAdd {
    _view = [[UIView alloc] init];
    _view.backgroundColor = [UIColor redColor];
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(80);
        make.left.mas_equalTo(self).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [_view addGestureRecognizer:pan];

}

#pragma mark - 手势执行的方法
-(void)handlePan:(UIPanGestureRecognizer *)rec{
    //    CGFloat KWidth = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat KHeight = [UIScreen mainScreen].bounds.size.height;
    
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point=[rec translationInView:self];
    
    //    CGFloat centerX = rec.view.center.x+point.x;
    //    CGFloat centerY = rec.view.center.y+point.y;
    //
    //    CGFloat viewHalfH = rec.view.frame.size.height/2;
    //    CGFloat viewhalfW = rec.view.frame.size.width/2;
    //
    //    //确定特殊的centerY
    //    if (centerY - viewHalfH < 0 ) {
    //        centerY = viewHalfH;
    //    }
    //    if (centerY + viewHalfH > KHeight ) {
    //        centerY = KHeight - viewHalfH;
    //    }
    //
    //    //确定特殊的centerX
    //    if (centerX - viewhalfW < 0){
    //        centerX = viewhalfW;
    //
    //    }
    //    if (centerX + viewhalfW > KWidth){
    //        centerX = KWidth - viewhalfW;
    //    }
    
    rec.view.center = CGPointMake(rec.view.center.x+point.x, rec.view.center.y+point.y);
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"FlyElephant---触摸开始");
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _view.center = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

    NSLog(@"FlyElephant---触摸开始");
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    _view.center = point;

    UITouch *touch = [touches anyObject];

    CGPoint currentPoint = [touch locationInView:self];
    // 获取上一个点
    CGPoint prePoint = [touch previousLocationInView:self];
    CGFloat offsetX = currentPoint.x - prePoint.x;
    CGFloat offsetY = currentPoint.y - prePoint.y;

    NSLog(@"FlyElephant----当前位置:%@---之前的位置:%@",NSStringFromCGPoint(currentPoint),NSStringFromCGPoint(prePoint));
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"FlyElephant---触摸结束");
}


@end
