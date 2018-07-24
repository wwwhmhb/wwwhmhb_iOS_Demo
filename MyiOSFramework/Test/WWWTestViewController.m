//
//  WWWTestViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestViewController.h"

#import "WWWMulti_lineTextAlertViewManager.h"
#import "WWWBottomPickerViewManager.h"

#import "BlazeiceDooleView.h"

@interface WWWTestViewController () {
    BlazeiceDooleView *doodleView;
}

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TestViewController";
    
    CGRect frame = CGRectMake(0, 100, kMainScreenWidth,kMainScreenHeight-80);
    doodleView = [[BlazeiceDooleView alloc] initWithFrame:frame];
    doodleView.drawView.formPush = YES;//标志他是从教师端推送过来的。
    [self.view addSubview:doodleView];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor orangeColor]];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
    
}

- (void)testButtonAction:(UIButton *)button {
    NSLog(@"testButtonAction:");
    [WWWMulti_lineTextAlertViewManager showMulti_lineTextAlertViewWithRequestDataBlock:^(NSString *text) {
        NSLog(@"text = %@",text);
    }];
    
//    [WWWBottomPickerViewManager showEditPickerViewWithData:@[@"早晨",@"中午",@"下午"] andBlock:^(NSString *temp) {
//        NSLog(@"%@",temp);
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
