//
//  NSArray+LXDExtension.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/30.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
/*
 为 NSArray 添加链式响应，数据元素筛选和转换
 */

#import <Foundation/Foundation.h>

//数组中元素的转变
typedef id(^WWWItemChange)(id item);
typedef NSArray *(^WWWArrayChange)(WWWItemChange itemChange);

//数组中元素筛选
typedef BOOL(^WWWItemFilter)(id item);
typedef NSArray *(^WWWArrayFilter)(WWWItemFilter itemFilter);

@interface NSArray (LXDExtension)

@property (nonatomic,readonly,copy) WWWArrayChange arrayChange;
@property (nonatomic,readonly,copy) WWWArrayFilter arrayFileter;

@end
