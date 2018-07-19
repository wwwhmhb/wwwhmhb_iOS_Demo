//
//  WWWBottomPickerViewManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/18.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWBottomPickerViewManager.h"
#import "WWWBottomPickerView.h"
#import "AppDelegate.h"

@interface WWWBottomPickerViewManager () <UIGestureRecognizerDelegate> {
    UIView *_grayBgView;
}

@property (nonatomic,copy)   void (^bottomResultPresent)(NSString *);

@property (nonatomic,strong) WWWBottomPickerView *editView;

@end

@implementation WWWBottomPickerViewManager

WWWBottomPickerViewManager *_bottom;

+(instancetype)showEditPickerViewWithData:(NSArray *)data{
    WWWBottomPickerViewManager *bottom=[[self alloc] init];
    bottom.editView.data=data;
    [bottom popAndPushPickerView];//显示 pickView 视图
    return  bottom;
}


+(void)showEditPickerViewWithData:(NSArray *)data andBlock:(void (^)(NSString *temp))bottomResultPresent{
    
    //重新创建全局变量_bottom
    _bottom = [self showEditPickerViewWithData:data];
    
    //editView 确定按钮的点击事件
    _bottom.editView.refreshUserInterface = bottomResultPresent;

    //editView 取消按钮的点击事件
    __weak __typeof__(_bottom) weakBottom = _bottom;
    _bottom.editView.dropEditPickerView=^(){
        __strong __typeof(_bottom) strongBottom = weakBottom;
        [strongBottom popAndPushPickerView];
    };
    
}

-(instancetype)init {
    self=[super init];
    if(self){
        //黑色半透明背景
        AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
        _grayBgView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _grayBgView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [app.window.rootViewController.view addSubview:_grayBgView];//
        _grayBgView.hidden=YES;
        [_grayBgView setUserInteractionEnabled:YES];
        
        //为_grayBgView添加点击手势
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        tapGestureRecognizer.numberOfTapsRequired = 1; // 设置单击几次才触发方法
        tapGestureRecognizer.delegate=self;
        [tapGestureRecognizer addTarget:self action:@selector(popAndPushPickerView)]; // 添加点击手势的方法
        //当 cancelsTouchesInView 的值为YES的时候，手势识别之后，并取消触摸事件；为NO的时候，手势识别之后，系统接着会触发触摸事件。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_grayBgView addGestureRecognizer:tapGestureRecognizer];
        
        
        //创建 editView，其顶部和屏幕底部重合，即看不见
        _editView=[[WWWBottomPickerView alloc]initWithFrame:CGRectMake(0, _grayBgView.bounds.size.height, _grayBgView.bounds.size.width, _grayBgView.bounds.size.height/5*2)];
        
        [_grayBgView addSubview:self.editView];
        
    }
    return self;
}

//显示或者隐藏 PickerView 视图
-(void)popAndPushPickerView{
    
    if(_grayBgView.hidden){//隐藏则显示
        [UIView animateWithDuration:0.5 animations:^{
            self->_grayBgView.hidden = NO;//背景层隐藏
            //editView底部和屏幕底部重合
            self.editView.frame=CGRectMake(0, self->_grayBgView.bounds.size.height/5*3, self->_grayBgView.bounds.size.width, self->_grayBgView.bounds.size.height/5*2);
        }];
    } else {//显示则隐藏
        [UIView animateWithDuration:0.5 animations:^{
            //editView顶部和屏幕底部重合，即消失
            self.editView.frame=CGRectMake(0, self->_grayBgView.bounds.size.height, self->_grayBgView.bounds.size.width, self->_grayBgView.bounds.size.height/5*2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self->_grayBgView.hidden=YES;
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
    //由于TestEdiPickView中的toolView也受到了手势的影响，所以在这里将这这个ToolView屏蔽掉
    if([touch.view isKindOfClass:[UIToolbar class]]){
        return NO;
    }
    
    return YES;
}

@end
