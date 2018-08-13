//
//  WWWChangeIcon.m
//  MyiOSFramework
//
//  Created by mac on 2018/8/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWChangeIconManager.h"
#import "UIViewController+MethodSwizzling.h"

@implementation WWWChangeIconManager

//根据视图控制器进行初始化，不显示 alertController
- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        [viewController changePresentViewController];
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

@end
