//
//  WWWTestViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestViewController.h"

#import "NSArray+LXDExtension.h"
#import "BlazeiceDooleView.h"
#import "WWWNetworkingManager.h"

@interface WWWTestViewController () {
    UITableView *tableView;
}

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TestViewController";
    
    NSArray *array = @[@"67"];
    NVLogInfo(@"Array = %@",array[3]);
    
    
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}


- (void)testButtonAction:(UIButton *)button {
    
//    NSString *robotid = @"TWYP5TA6LR5LOVRC";
//    NSDictionary *dic = @{
//                          @"robot_id" : robotid,
//                          @"file_name" : @"Test.txt",
//                          @"file_type" : @"file/txt"
//                          };
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"text"];
//    WWWNetworkingManager *manager = [WWWNetworkingManager shared];
//    [manager initNetworkingManager];
//    [manager uploadFileToUrlStr:@"http://yoby-dispatch.test.youerobot.com/business/upload_log_file/" andFilePath:path andParameters:dic andProgress:^(NSProgress *uploadProgress) {
//        
//    } andFinishBlock:^(id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"error = %@",error);
//        } else {
//            NSLog(@"提交成功");
//        }
//    }];
//    NSArray *numbers = @[@10, @15, @99, @66, @25, @28.1, @7.5, @11.2, @66.2];
//
//
//    NSArray *result = numbers.arrayFileter((WWWItemFilter)^(NSNumber * item){return item.floatValue > 20;}).arrayChange((WWWItemChange)^(NSNumber *item){return [NSString stringWithFormat:@"%@",item];});
//
//    NSLog(@"result = %@",result);
    
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
