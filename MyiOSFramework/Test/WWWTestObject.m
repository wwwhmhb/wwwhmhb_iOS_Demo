//
//  WWWTestObject.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/9/10.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestObject.h"

@implementation WWWTestObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorArray = @[@"white",@"red",@"orange",@"yellow",@"green",@"cyan",@"blue",@"purple",@"flashing",@"marquee"];
    }
    return self;
}
@end
