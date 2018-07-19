//
//  WWWMulti_lineTextAlertViewManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/19.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWMulti_lineTextAlertViewManager : NSObject

@property (nonatomic,weak)UIButton *grayBgView;
@property (nonatomic,copy)void (^requestDataBlock)(NSString *text);


+(void)showMulti_lineTextAlertViewWithRequestDataBlock:(void(^)(NSString *))requestDataBlock;

@end
