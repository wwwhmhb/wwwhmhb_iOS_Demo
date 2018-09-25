//
//  WWWTestObject.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/9/10.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestObject.h"
@interface WWWTestObject ()

@property (nonatomic,copy) NSString *identityCard;

@end


@implementation WWWTestObject
//@synthesize identityCard = _identityCard;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self test];
    }
    return self;
}

- (void)test {
    
    _colorArray = @[@"white",@"red",@"orange",@"yellow",@"green",@"cyan",@"blue",@"purple",@"flashing",@"marquee"];
    
    self.identityCard = @"www";
}
@end
