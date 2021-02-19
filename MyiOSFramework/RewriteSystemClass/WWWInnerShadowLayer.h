//
//  WWWInnerShadowLayer.h
//  MyiOSFramework
//
//  Created by 王威威 on 2021/2/19.
//  Copyright © 2021 Weiwei Wang. All rights reserved.
//
/*
 为视图添加内阴影
 基础使用如下：
 WWWInnerShadowLayer *innerShadowLayer = [[WWWInnerShadowLayer alloc] initWithFrame:CGRectMake(0, 0, 100.0, 60.0)];
 innerShadowLayer.innerShadowLayerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 100.0, 60.0) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(30.0, 30.0)];
 innerShadowLayer.innerShadowLayerOpacity = 0.24;
 innerShadowLayer.innerShadowLayerRadius = 16.0;
 innerShadowLayer.innerShadowLayerOffset = CGSizeMake(0.0, 0.0);
 innerShadowLayer.innerShadowLayerColor = UIColor.blackColor;
 [view.layer addSublayer:innerShadowLayer];
 */

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface WWWInnerShadowLayer : CALayer

/* 路径 */
@property (nonatomic, strong) UIBezierPath *innerShadowLayerPath;
/* 颜色 */
@property (nonatomic, strong) UIColor *innerShadowLayerColor;
/* 透明度 */
@property (nonatomic, assign) CGFloat innerShadowLayerOpacity;
/* 半径（大小）*/
@property (nonatomic, assign) CGFloat innerShadowLayerRadius;
/* 偏移 */
@property (nonatomic, assign) CGSize innerShadowLayerOffset;

- (instancetype)initWithFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
