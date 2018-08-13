//
//  WWWChangeIcon.h
//  MyiOSFramework
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWChangeIconManager : NSObject

// 如果alternateIconName为nil，则代表当前使用的是主图标.
@property (nonatomic, readonly, copy) NSString *currentAlternateIconName;

//根据视图控制器进行初始化，不显示 alertController
- (instancetype)initWithViewController:(UIViewController *)viewController;

// 传入nil代表使用主图标. 完成后的操作将会在任意的后台队列中异步执行; 如果需要更改UI，请确保在主队列中执行.
- (void)setAlternateIconName:(NSString *)alternateIconName finshBlock:(void (^)(NSError *error))finshBlock;
@end
