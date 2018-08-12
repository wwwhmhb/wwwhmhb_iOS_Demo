//
//  UIViewController+MethodSwizzling.m
//  MyiOSFramework
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "UIViewController+MethodSwizzling.h"
#import <objc/runtime.h>

@implementation UIViewController (MethodSwizzling)

- (void)changePresentViewController {
    [self runtimeReplaceAlert];
}

//运行时交换方法
- (void)runtimeReplaceAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//方法只能交换一次
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(my_presentViewController:animated:completion:));
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)my_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        
        //更换换图标时的提示框的title和message都是nil，由此可特殊处理
        if (alertController.title == nil && alertController.message == nil) { // 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self my_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    //其实调用 my_presentViewController:animated:completion: 相当于调用 presentViewController:animated:completion:, 所以不会造成循环调用
    [self my_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
