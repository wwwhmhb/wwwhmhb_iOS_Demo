//
//  WWWBottomPickerView.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/18.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WWWBottomPickerView : UIView

/**
 展示的数据
 */
@property (nonatomic,strong)NSArray *data;

@property (nonatomic,copy) void (^refreshUserInterface)(NSString *);

@property (nonatomic,copy) void (^dropEditPickerView)(void);

@end
