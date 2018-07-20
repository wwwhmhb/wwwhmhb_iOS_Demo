//
//  WWWBottomPickerView.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/18.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWBottomPickerView.h"

@interface WWWBottomPickerView () <UIPickerViewDelegate,UIPickerViewDataSource> {
    NSString *_result;//选中结果
    UIPickerView *_pickerView;//弹框中的PickView
}

@end


@implementation WWWBottomPickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //主背景图
        UIView *mainBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mainBgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mainBgView];
        
        //ToolBar
        UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/6)];
        [toolbar setBarTintColor:[UIColor blueColor]];
        //        toolbar.backgroundColor=[UIColor redColor];
        //        [toolbar setBackgroundImage:[UIImage imageNamed:@"backgroundImage"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];//设置图片
        [mainBgView addSubview:toolbar];
        [toolbar layoutIfNeeded];//iOS11之后防止ToolBar中的按钮功能失效
        
        
        //取消，确定按钮
        CGFloat btnWidth=100.0;
        UIButton *cancelbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelbtn.frame=CGRectMake(0, 0, btnWidth, CGRectGetHeight(toolbar.frame));
        [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(onclickCancel:) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:cancelbtn];
        
        
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(frame.size.width- btnWidth, 0, btnWidth, CGRectGetHeight(toolbar.frame));
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(onclickSure:) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:sureBtn];
        
        
        //UIPickerView
        _pickerView =[[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(toolbar.frame), frame.size.width, (frame.size.height/6)*5)];
        _pickerView.showsSelectionIndicator=YES;
        _pickerView.delegate=self;
        _pickerView.dataSource=self;
        [mainBgView addSubview:_pickerView];
        
    }
    return self;
}

-(void)dealloc {
    NSLog(@"WWWBottomPickerView-dealloc");
}

//设置data并且设设置_result的初始值
-(void)setData:(NSArray *)data{
    if(_data!=data){
        _data=data;
        _result=data[0];
    }
    //刷新所有元素
    [_pickerView reloadAllComponents];
}

#pragma mark -ButtonClick
-(void)onclickCancel:(id)sender{
    if(self.dropEditPickerView){
        self.dropEditPickerView();
    }
}

//确定按钮,block传值
-(void)onclickSure:(id)sender{
    if(self.refreshUserInterface){
        self.refreshUserInterface(_result);
    }
    if(self.dropEditPickerView){
        self.dropEditPickerView();
    }
}

#pragma mark -PickerViewDelegate
//有多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.data.count;
}
//有多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//设置每一行的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.data[row];
}

//设置选中结果
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _result=self.data[row];
}

@end
