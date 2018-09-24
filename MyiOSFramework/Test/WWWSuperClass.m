//
//  WWWSuperClass.m
//  MyiOSFramework
//
//  Created by mac on 2018/9/13.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWSuperClass.h"

@implementation WWWSuperClass

+ (void)initialize {
    NSLog(@"开始");
    NSLog(@"%@ : %s", [self class], __FUNCTION__);
    NSLog(@"结束");
}

+ (void)load {
    NSLog(@"开始");
    NSLog(@"%@ : %s", [self class], __FUNCTION__);
    NSLog(@"结束");
}

@end
