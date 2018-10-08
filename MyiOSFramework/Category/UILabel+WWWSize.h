//
//  UILabel+WWWSize.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/10/8.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UILabel (WWWSize)

- (CGSize)getLabelSize;

- (CGFloat)getLabelHeightWithWidth:(CGFloat)width;

- (CGFloat)getLabelWidthWithHeight:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
