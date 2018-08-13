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

//改变一个 viewController 的 present 另一个 viewController 的方法
- (void)changePresentViewController {
    [self runtimeReplaceAlert];
}

//运行时交换方法
- (void)runtimeReplaceAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{//方法只能交换一次
        //获取实例方法
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(my_presentViewController:animated:completion:));
//        //获取类方法
//        Method classM = class_getClassMethod(self.class, @selector(load));
        
        // 交换方法实现
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

// 自己的替换展示弹出框的方法
- (void)my_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {//判断是 AlertController
        
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        
        //更换换图标时的 alertController 的 title 和 message 都是 nil,由此可特殊处理,如果 alertController 的 title 和 message 都是 nil 也就没有必须要显示 alertController
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
