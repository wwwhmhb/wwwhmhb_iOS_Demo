//
//  WWWTestObject.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/9/10.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWTestObject : NSObject {
    
    NSString *_sex;
}
//没有生成 set 方法,但是其相应的实例变量依然是可以赋值改变的
@property (nonatomic,strong,readonly) NSArray *colorArray;

//在.m 文件的延展中,可以从新定义colorArray属性,使其在.m 文件中可读可写
@property (nonatomic,copy,readonly) NSString *identityCard;

@property (nonatomic,copy) NSString *name;

@end
