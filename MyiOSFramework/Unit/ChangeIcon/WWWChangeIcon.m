//
//  WWWChangeIcon.m
//  MyiOSFramework
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWChangeIcon.h"
#import <objc/runtime.h>

@implementation WWWChangeIcon

- (instancetype)init {
    self = [super init];
    if (self) {
        [self runtimeReplaceAlert];
    }
    return self;
}

//获取当前 icon 名称
- (NSString *)currentAlternateIconName {
    
    if (@available(iOS 10.3, *)) {
        return [UIApplication sharedApplication].alternateIconName;
    } else {
        return nil;
    }
}

//设置 icon
- (void)setAlternateIconName:(NSString *)alternateIconName finshBlock:(void (^)(NSError *error))finshBlock {
    
    if (@available(iOS 10.3, *)) {
        if ([UIApplication sharedApplication].supportsAlternateIcons) {
            [[UIApplication sharedApplication] setAlternateIconName:alternateIconName completionHandler:^(NSError *_Nullable error) {
                
                finshBlock(error);
            }];
        }
    } else {
        NSError *error = [NSError errorWithDomain:@"系统版本低于10.3" code:404 userInfo:@{NSLocalizedDescriptionKey : @"系统版本低于10.3"}];
        finshBlock(error);
    }
}

// 利用runtime来替换展现弹出框的方法
- (void)runtimeReplaceAlert
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
        NSLog(@"title : %@",alertController.title);
        NSLog(@"message : %@",alertController.message);
        
        // 换图标时的提示框的title和message都是nil，由此可特殊处理
        if (alertController.title == nil && alertController.message == nil) { // 是换图标的提示
            return;
        } else {// 其他提示还是正常处理
            [self my_presentViewController:viewControllerToPresent animated:flag completion:completion];
            return;
        }
    }
    
    [self my_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
