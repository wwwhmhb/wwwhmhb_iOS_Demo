//
//  WWWInnerShadowLayer.m
//  MyiOSFramework
//
//  Created by 王威威 on 2021/2/19.
//  Copyright © 2021 Weiwei Wang. All rights reserved.
//

#import "WWWInnerShadowLayer.h"

@implementation WWWInnerShadowLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.drawsAsynchronously = YES;
        self.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)layoutSublayers {
    [super layoutSublayers];
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)context {
    NSLog(@"drawInContext:");
    CGRect rect = self.bounds;
    if (self.borderWidth != 0) rect = CGRectInset(rect, self.borderWidth, self.borderWidth);
    
    CGContextSaveGState(context);//保存当前的绘图状态
    CGContextAddPath(context, self.innerShadowLayerPath.CGPath);//将路径添加到上下文
    CGContextClip(context);//裁剪上下文的显示区域
    
    CGMutablePathRef outer = CGPathCreateMutable();//创建绘图路径
    CGPathAddRect(outer, NULL, CGRectInset(rect, -1 * rect.size.width, -1 * rect.size.height));//添加矩形
    CGPathAddPath(outer, NULL, self.innerShadowLayerPath.CGPath);//合并多个CGPath组成一条路径,形成环形，这样就可以添加内阴影了
    CGPathCloseSubpath(outer);//将路径闭合
    CGContextAddPath(context, outer);//将路径添加到上下文
    CGPathRelease(outer);//此功能等效于CFRelease，不同之处在于，如果path参数为NULL，则不会导致错误。
    
    
    // 阴影颜色
    UIColor *color = [self.innerShadowLayerColor colorWithAlphaComponent:self.innerShadowLayerOpacity];
    CGContextSetShadowWithColor(context, self.innerShadowLayerOffset, self.innerShadowLayerRadius, color.CGColor);//设置上下文中路径的阴影，偏移，大小，颜色

    /* 填充方式,枚举类型
     kCGPathFill:只有填充（非零缠绕数填充），不绘制边框
     kCGPathEOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
     kCGPathStroke:只有边框
     kCGPathFillStroke：既有边框又有填充
     kCGPathEOFillStroke：奇偶填充并绘制边框
    */
    CGContextDrawPath(context, kCGPathEOFill);//绘制上下文中的路径
    CGContextRestoreGState(context);//恢复旧的绘图上下文
}

- (void)setInnerShadowLayerPath:(UIBezierPath *)innerShadowLayerPath {
    _innerShadowLayerPath = innerShadowLayerPath;
    [self setNeedsDisplay];
}
- (void)setInnerShadowLayerColor:(UIColor *)innerShadowLayerColor {
    _innerShadowLayerColor = innerShadowLayerColor;
    [self setNeedsDisplay];
}
- (void)setInnerShadowLayerOffset:(CGSize)innerShadowLayerOffset {
    _innerShadowLayerOffset = innerShadowLayerOffset;
    [self setNeedsDisplay];
}
- (void)setInnerShadowLayerRadius:(CGFloat)innerShadowLayerRadius {
    _innerShadowLayerRadius = innerShadowLayerRadius;
    [self setNeedsDisplay];
}
- (void)setInnerShadowLayerOpacity:(CGFloat)innerShadowLayerOpacity {
    _innerShadowLayerOpacity = innerShadowLayerOpacity;
    [self setNeedsDisplay];
}
@end
