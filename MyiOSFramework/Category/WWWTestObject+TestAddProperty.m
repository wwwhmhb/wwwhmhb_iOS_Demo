//
//  WWWTestObject+TestAddProperty.m
//  MyiOSFramework
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestObject+TestAddProperty.h"
#import <objc/runtime.h>

static const void *ageKey = &ageKey;

@implementation WWWTestObject (TestAddProperty)
NSString *temp;
- (void)test {
    //可以使用WWWTestObject中的属性方法,但是不能使用其实例变量 _name
    self.name = @"wwwhmhb";
    //公开的实例变量
    _sex = @"man";
}

//将 age 绑定到对象 ageKey 上
- (NSString *)age {
//    return objc_getAssociatedObject(self, ageKey);
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(temp));
}
- (void)setAge:(NSString *)age {
//    objc_setAssociatedObject(self, ageKey, age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(temp), age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
