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
    
    //iOS10之后，Widget支持展开及折叠两种展现方式
    if (@available(iOS 10.0, *)) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
//    label.backgroundColor = [UIColor yellowColor];
//    label.textColor = [UIColor blueColor];
//    label.text = @"Hello,Word!";
//    [self.view addSubview:label];
    
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

@end
