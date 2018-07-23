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

@property (nonatomic,strong) WWWMulti_lineTextAlertView *topTextView;
@property (nonatomic,strong) UIView *grayBgView;

@end

@implementation WWWMulti_lineTextAlertViewManager

WWWMulti_lineTextAlertViewManager *_editTextView;

+(void)showMulti_lineTextAlertViewWithRequestDataBlock:(void(^)(NSString *text))requestDataBlock{
    //初始化全局变量
    _editTextView=[[self alloc] init];

    //topTextView 确定按钮的点击事件
    _editTextView.topTextView.submitBlock = requestDataBlock;

    //topTextView 取消按钮的点击事件
    __weak __typeof__(_editTextView) weakEditTextView = _editTextView;
    _editTextView.topTextView.closeBlock=^(){
        __strong __typeof(_editTextView) strongEditTextView = weakEditTextView;
        [strongEditTextView popAndPushPickerView];
    };
    
    //显示 topTextView 视图
    [_editTextView popAndPushPickerView];
}

-(instancetype)init {
    self=[super init];
    if(self){
        //黑色半透明背景
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        UIView *grayBgView = [[UIView alloc] init];
        grayBgView.frame=[UIScreen mainScreen].bounds;
        grayBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [app.window.rootViewController.view addSubview:grayBgView];
        grayBgView.hidden=YES;
        self.grayBgView=grayBgView;
        [self.grayBgView setUserInteractionEnabled:YES];

        //为_grayBgView添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1; // 设置单击几次才触发方法
        tapGestureRecognizer.delegate=self;
        [tapGestureRecognizer addTarget:self action:@selector(popAndPushPickerView)]; // 添加点击手势的方法
        //当 cancelsTouchesInView 的值为YES的时候，手势识别之后，并取消触摸事件；为NO的时候，手势识别之后，系统接着会触发触摸事件。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_grayBgView addGestureRecognizer:tapGestureRecognizer];
        
        
        self.topTextView = [[WWWMulti_lineTextAlertView alloc]initWithFrame:CGRectMake(15, self.grayBgView.bounds.size.height/3, self.grayBgView.bounds.size.width-30, self.grayBgView.bounds.size.height/3)];
//        self.topTextView=topTextView;
        
        [self.grayBgView addSubview:self.topTextView];
        
    }
    return self;
}


-(void)popAndPushPickerView{
    if(self.grayBgView.hidden){
        [UIView animateWithDuration:0.5 animations:^{
            self.grayBgView.hidden=NO;
            self.topTextView.hidden=NO;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.topTextView.hidden=YES;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.grayBgView.hidden=YES;
                _editTextView = nil;
            }];
        }];
    }
}

//判断是否允许响应手势，YES,手势正常响应；NO，不响应手势，事件继续由系统向下分发，不管cancelsTouchesInView属性的值。
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    [self.grayBgView removeFromSuperview];
    NSLog(@"WWWMulti_lineTextAlertViewManager_dealloc");
}

@end
