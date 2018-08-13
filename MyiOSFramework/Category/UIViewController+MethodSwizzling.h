//
//  UIViewController+MethodSwizzling.h
//  MyiOSFramework
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (MethodSwizzling)


/**
 改变一个 viewController 的 present 另一个 viewController 的方法
 */
- (void)changePresentViewController;

@end
