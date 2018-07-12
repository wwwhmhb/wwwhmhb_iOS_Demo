//
//  WWWTestViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestViewController.h"

#import "WWWWifiInfoManager.h"
#import "GCDAsyncSocket.h"

@interface WWWTestViewController () <GCDAsyncSocketDelegate>

// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (assign, nonatomic) BOOL connected;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TestViewController";
    
    WWWWifiInfoManager *wifiInfoManager = [[WWWWifiInfoManager alloc] init];
    NSDictionary *dict = [wifiInfoManager getWifiInformation];
    
    NSLog(@"dict = %@",dict);
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
