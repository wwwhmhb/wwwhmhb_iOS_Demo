//
//  WWWBottomPickerViewManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/18.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWBottomPickerViewManager : NSObject

+(instancetype)showEditPickerViewWithData:(NSArray *)data;

+(void)showEditPickerViewWithData:(NSArray *)data andBlock:(void (^)(NSString *temp))bottomResultPresent;

@end
