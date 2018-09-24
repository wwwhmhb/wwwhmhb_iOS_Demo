//
//  WWWTestObject+TestAddProperty.h
//  MyiOSFramework
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestObject.h"

@interface WWWTestObject (TestAddProperty)

//为分类添加 NSString 属性
@property (nonatomic,copy) NSString *age;

//为分类添加 UIButton 属性
@property (nonatomic, strong) UIButton *button;

@end
