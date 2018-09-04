//
//  TodayViewController.m
//  WWWWidget
//
//  Created by mac on 2018/8/26.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor redColor];
    
    //iOS10之后，Widget支持展开及折叠两种展现方式
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }

    //配置Today Extension展示视图的大小
    self.preferredContentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 100);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];

    label.backgroundColor = [UIColor yellowColor];
    label.textColor = [UIColor blueColor];
    label.text = @"Hello,Word!";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *openURLContainingAPP = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openURLContainingAPP)];
    [label addGestureRecognizer:openURLContainingAPP];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

//重写切换展开及折叠布局时的方法（iOS10之后）
- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize API_AVAILABLE(ios(10.0)) {
    NSLog(@"maxWidth %f maxHeight %f",maxSize.width,maxSize.height);
    
    if (activeDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(maxSize.width, 110);
    } else {
        self.preferredContentSize = CGSizeMake(maxSize.width, 200);
    }
}

//iOS10之前，视图原点默认存在一个间距，可以实现以下方法来调整视图间距
- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//通过openURL的方式启动Containing APP
- (void)openURLContainingAPP
{
    //scheme为app的scheme
    [self.extensionContext openURL:[NSURL URLWithString:@"MyiOSFramework://xxxx"]
                 completionHandler:^(BOOL success) {
                     NSLog(@"open url result:%d",success);
                 }];
}

@end
