//
//  WWWMulti_lineTextAlertView.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/19.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWMulti_lineTextAlertView : UIView

@property (nonatomic,weak)UITextView *textView;
@property (nonatomic,weak)UIButton *submitBtn;
@property (nonatomic,weak)UIButton *cancelBtn;

@property (nonatomic,weak)UILabel *titleLabel;

@property (nonatomic,copy) void(^submitBlock)(NSString * text);
@property (nonatomic,copy) void(^closeBlock)(void);

@end
