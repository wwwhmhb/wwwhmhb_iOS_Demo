//
//  WWWMulti_lineTextAlertView.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/19.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWMulti_lineTextAlertView.h"

@interface WWWMulti_lineTextAlertView () <UITextViewDelegate>

@property (nonatomic,strong)UITextView *textView;

@end

@implementation WWWMulti_lineTextAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        //设置两个控件之间的间距
        CGFloat space=10.0;
        //设置与边框的间距
        CGFloat margin=15.0;
        
        //设置圆角
        self.layer.cornerRadius=5;
        [self.layer setMasksToBounds:YES];
        //设置背景色
        self.backgroundColor=[UIColor whiteColor];
        
        //提示框的title
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake((frame.size.width-2 * margin)/3+ margin,  margin,(frame.size.width-2* margin)/3, (frame.size.height- margin*2- space)/7)];
        [self addSubview:titleLabel];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [titleLabel setText:@"提交内容"];
        
        //输入框
        UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake( margin, CGRectGetMaxY(titleLabel.frame)+ space, frame.size.width-2* margin, CGRectGetHeight(titleLabel.frame)*4)];
        textView.backgroundColor=[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.74];
        self.textView=textView;
        textView.font=[UIFont systemFontOfSize:15];
        NSString *str=@"请您输入您对处理结果的评价，最多128个字";
        textView.textColor=[UIColor whiteColor];
        textView.text=str;
        textView.returnKeyType=UIReturnKeyDone;
        textView.delegate=self;
        [self addSubview:textView];
        
        //水平分割线
        UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textView.frame)+ margin, frame.size.width, 1)];
        lineView.backgroundColor=[UIColor grayColor];
        [self addSubview:lineView];
        
        //取消按钮
        UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame=CGRectMake(0, CGRectGetMaxY(lineView.frame), frame.size.width/2, CGRectGetHeight(titleLabel.frame)*2);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        
        //按钮分隔线
        UIView *seperateLine=[[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMinY(cancelBtn.frame), 1, CGRectGetHeight(cancelBtn.frame))];
        seperateLine.backgroundColor=[UIColor grayColor];
        [self addSubview:seperateLine];
        
        //确定按钮
        UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.frame=CGRectMake(CGRectGetMaxX(seperateLine.frame), CGRectGetMinY(cancelBtn.frame), CGRectGetWidth(cancelBtn.frame), CGRectGetHeight(cancelBtn.frame));
        [sureBtn setTitle:@"提交" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(clickSubmit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        
        //监听自身的hidden值的变化
        [self addObserver:self
               forKeyPath:@"hidden"
                  options:NSKeyValueObservingOptionNew
                  context:@"Multi_lineTextAlertView.hidden"];
        
    }
    return self;
}

//移除观察者
- (void)dealloc {
    
    /*
     当对同一个keypath进行两次removeObserver时会导致程序crash
     我们可以分别在父类以及本类中定义各自的context字符串，比如在本类中定义context为@"Multi_lineTextAlertView.hidden";然后在dealloc中remove observer时指定移除的自身添加的observer。这样iOS就能知道移除的是自己的kvo，而不是父类中的kvo，避免二次remove造成crash。
     */
    NSLog(@"WWWMulti_lineTextAlertView - dealloc");
    [self removeObserver:self forKeyPath:@"hidden" context:@"Multi_lineTextAlertView.hidden"];
}

//观察者接受器,如果被观察者的属性通过 setter 发生变化,就会自动调用该方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:@"hidden"]) {//必须对触发回调函数的来源进行判断
        NSLog(@"context = %@;change = %@",context,change);
        NSNumber *num = change[@"new"];
        BOOL value = [num boolValue];
        if (value) {
            [_textView resignFirstResponder];
        }
    } else {//判断父类是否添加了响应的相应的观察方法
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

//处理确定点击事件
-(void)clickSubmit:(id)sender{
    if(self.textView.editable){
        [self.textView resignFirstResponder];
    }
    if(self.textView.text.length>0){
        if([self.textView.textColor isEqual:[UIColor redColor]]||[self.textView.textColor isEqual:[UIColor whiteColor]]){
            //当前状态为空，通过字体颜色进行的判断，不是很好
            [self.textView becomeFirstResponder];
        }else{
            //提交内容
            if(self.submitBlock){
                self.submitBlock(self.textView.text);
            }
            //关闭窗口
            [self clickCancel];
        }
    }else{
        self.textView.textColor=[UIColor redColor];
        self.textView.text=@"您输入的内容不能为空，请您输入内容";
    }
}

//处理取消点击事件
-(void)clickCancel {
    //注销第一响应链
    [_textView resignFirstResponder];
    
    if(self.closeBlock){
        self.closeBlock();
    }
}

#pragma mark -UITextViewDelegate
//开始编辑时
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.textColor=[UIColor blackColor];
    textView.text=@"";
}

/**
 * 通过代理方法去设置不能超过128个字，但是可编辑
 */
-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length>=128){
        textView.text=[textView.text substringToIndex:127];
    }
}

#pragma mark -return键弹回键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //点击键盘的完成按钮之后，text = @“\n”
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
    
}

@end
