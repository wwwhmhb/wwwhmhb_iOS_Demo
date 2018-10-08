//
//  UILabel+WWWSize.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/10/8.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "UILabel+WWWSize.h"

@implementation UILabel (WWWSize)

- (CGSize)getLabelSize {
    NSDictionary *attrDict = @{
                               NSFontAttributeName : self.font
                               };
    CGSize size = [self.text sizeWithAttributes:attrDict];
    return size;
}

//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGFloat)getLabelHeightWithWidth:(CGFloat)width {
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    return rect.size.height;
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
- (CGFloat)getLabelWidthWithHeight:(CGFloat)height {
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)                                        options:NSStringDrawingUsesLineFragmentOrigin                                     attributes:@{NSFontAttributeName:self.font}                                        context:nil];
    return rect.size.width;
}



@end
