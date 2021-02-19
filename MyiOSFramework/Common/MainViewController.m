//
//  ViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/11.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "MainViewController.h"
#import "WWWTestViewController.h"
#import "WWWInnerShadowLayer.h"


@interface MainViewController ()

@end

@implementation MainViewController


#pragma mark -- 本类声明

#pragma mark -- 初始化方法

#pragma mark -- 生命周期方法

#pragma mark -- 重写父类方法

#pragma mark -- 公有方法

#pragma mark -- 布局控件

#pragma mark -- 响应事件

#pragma mark -- 网络请求方法

#pragma mark -- 代理方法

#pragma mark -- set和getter方法

#pragma mark -- 私有方法

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NVLogInfo(@"日志文件地址:\n%@", [[NVLogManager shareInstance] getCurrentLogFilePath])
    DDLogInfo(@"1234567890");
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor orangeColor]];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(200);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    
    //注册3D Touch
    /**
     从iOS9开始，我们可以通过UITraitCollection这个类的UITraitEnvironment协议属性来判断设备是否支持3D Touch。
     UITraitCollection是UIViewController所遵守的其中一个协议，不仅包含了UI界面环境特征，而且包含了3D Touch的特征描述
     通过这个类来判断运行程序对应的设备是否支持3D Touch功能。
     UIForceTouchCapabilityUnknown = 0,     //未知
     UIForceTouchCapabilityUnavailable = 1, //不可用
     UIForceTouchCapabilityAvailable = 2    //可用
     */
    if ([self respondsToSelector:@selector(traitCollection)]) {
        
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                
                [self registerForPreviewingWithDelegate:(id)self sourceView:testButton];
            }
        }
    }

}

- (void)testButtonAction:(UIButton *)button {
    
    WWWTestViewController *testViewController = [[WWWTestViewController alloc] init];
    [self.navigationController pushViewController:testViewController animated:YES];
}

#pragma mark -- UIViewControllerPreviewingDelegate 代理方法
//3D Touch显示预览页
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0) {
    //获取响应 3D Touch 的原视图
    UIButton *button = (UIButton *)[previewingContext sourceView];
    NSLog(@"响应 3D Touch 的原视图 = %@",button);
    
    //指定当前上下文视图的Rect
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    previewingContext.sourceRect = rect;
    
    //创建要预览的控制器
    WWWTestViewController *presentationVC = [[WWWTestViewController alloc] init];
    return presentationVC;
}

//3D Touch从预览页到跳转页
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0) {

    [self showViewController:viewControllerToCommit sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
