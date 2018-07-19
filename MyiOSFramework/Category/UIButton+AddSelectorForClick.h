//
//  UIButton+AddSelectorForClick.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/17.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加方法的响应顺序，即在原有点击事件前或者后进行响应
typedef NS_ENUM(NSInteger,SequentialOrder) {
    ClickActionFront,
    ClickActionBack
};

//所要添加方法的类型
typedef NS_ENUM(NSInteger,SelectorType) {
    ZoomAnimationSelector,
    NetworkPermissionRequestSelector,
    PhotoLibraryPermissionRequestSelector,
    CameraPermissionRequestSelector,
    MicrophonePermissionRequestSelector
    
    
};

@interface UIButton (AddSelectorForClick)

/**
 为原有button的点击方法添加新的响应方法

 @param sequentialOrder 新的方法在原有方法的前或者后执行顺序
 @param selectorType 新增加的方法类型
 */
- (void)addSelectorForClickActionSequentialOrder:(SequentialOrder)sequentialOrder andSelectorType:(SelectorType)selectorType;

@end
