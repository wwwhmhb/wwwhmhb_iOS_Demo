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
#import "WWWGCDReadWriteFile.h"
@interface WWWTestViewController () {
    dispatch_queue_t queue;
}

@property (nonatomic,strong) NSData *myData;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TestViewController";
    
    
    
    NSString *testStr = @"mobile/80224c1717d39a0f341560f01bb36af8d923e372/addRobotFriend";
    NSString *png = [testStr pathExtension];
    NSString *name = [testStr stringByDeletingPathExtension];
    NSArray *array = testStr.pathComponents;
    NSLog(@"array = %@",array);
    NSLog(@"png = %@;name = %@;lastPathComponent = %@",png,name,testStr.lastPathComponent);
    
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:WWWRGBColor(160.0, 176.0, 213.0)];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];

    
    //视图或者文字转化为图片
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, 40, 40)];
    imgview.backgroundColor = [UIColor colorWithRed:160.0/255.0 green:176.0/255.0 blue:213.0/255.0 alpha:1.0];
    imgview.layer.cornerRadius = 20;
    [self.view addSubview:imgview];

    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *hostname = processInfo.hostName;
    NSLog(@"hostname = %@",processInfo.environment);
}



- (void)testButtonAction:(UIButton *)button {


    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    const char *queueName = dispatch_queue_get_label(queue);
    NSLog(@"queueName = %s",queueName);
    
}

//3D Touch 预览该视图控制器时,生成快捷功能菜单
- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
    
    UIPreviewAction *previewAction0 = [UIPreviewAction actionWithTitle:@"取消" style:UIPreviewActionStyleDestructive handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"取消");
    }];
    
    UIPreviewAction *previewAction1 = [UIPreviewAction actionWithTitle:@"替换该元素" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"替换该元素");
    }];
    UIPreviewAction *previewAction2 = [UIPreviewAction actionWithTitle:@"随意" style:UIPreviewActionStyleSelected handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        
        NSLog(@"随意");
    }];
  
  return @[previewAction0 ,previewAction1,previewAction2];
}


#pragma mark - 希尔排序(升序)
- (void)shellAscendingOrderSort:(NSMutableArray *)ascendingArr {
    for (NSInteger gap = ascendingArr.count / 2; gap > 0; gap /= 2) {
        
    }
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
