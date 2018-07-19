//
//  WWWMulti_lineTextAlertViewManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/19.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWMulti_lineTextAlertViewManager.h"
#import "WWWMulti_lineTextAlertView.h"
#import "AppDelegate.h"

@interface WWWMulti_lineTextAlertViewManager ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) WWWMulti_lineTextAlertView *topTextView;
@property (nonatomic,weak)UIViewController *controller;
@end

@implementation WWWMulti_lineTextAlertViewManager

WWWMulti_lineTextAlertViewManager *_editTextView;

-(instancetype)init {
    self=[super init];
    if(self){
        //黑色半透明背景
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *grayBgView=[UIButton buttonWithType:UIButtonTypeCustom];
        grayBgView.frame=[UIScreen mainScreen].bounds;
        grayBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [app.window.rootViewController.view addSubview:grayBgView];
        grayBgView.hidden=YES;
        self.grayBgView=grayBgView;
        [grayBgView addTarget:self action:@selector(popAndPushPickerView) forControlEvents:UIControlEventTouchUpInside];
        
        WWWMulti_lineTextAlertView *topTextView=[[WWWMulti_lineTextAlertView alloc]initWithFrame:CGRectMake(15, self.grayBgView.bounds.size.height/3, self.grayBgView.bounds.size.width-30, self.grayBgView.bounds.size.height/3)];
        self.topTextView=topTextView;
        topTextView.submitBlock=^(NSString *text){
            [self popAndPushPickerView];
            if(self.requestDataBlock){
                self.requestDataBlock(text);
            }
        };
        topTextView.closeBlock=^(){
            [self popAndPushPickerView];
        };
        [self.grayBgView addSubview:topTextView];
        
    }
    return self;
}



+(void)showMulti_lineTextAlertViewWithRequestDataBlock:(void(^)(NSString *text))requestDataBlock{
    _editTextView=[[self alloc] init];
    _editTextView.requestDataBlock=requestDataBlock;
    [_editTextView popAndPushPickerView];
}

-(void)popAndPushPickerView{
    if(self.grayBgView.hidden){
        [UIView animateWithDuration:0.5 animations:^{
            self.grayBgView.hidden=NO;
            self.topTextView.hidden=NO;
        }];
        [self.grayBgView setUserInteractionEnabled:YES];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.topTextView.hidden=YES;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.grayBgView.hidden=YES;
            }];
        }];
        
    }
    
}
@end
