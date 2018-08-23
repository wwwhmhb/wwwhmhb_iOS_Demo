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
    
    NSString *testStr = @"business/upload_log_file/myImage.png";
    NSString *png = [testStr pathExtension];
    NSString *name = [testStr stringByDeletingPathExtension];
    NSArray *array = testStr.pathComponents;
    NSLog(@"array = %@",array);
    NSLog(@"png = %@;name = %@;lastPathComponent = %@",png,name,testStr.lastPathComponent);
    
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

    
    //视图或者文字转化为图片
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 40, 40)];
    imgview.backgroundColor = [UIColor colorWithRed:160/255.0 green:176/255.0 blue:213/255.0 alpha:1.0];
    imgview.layer.cornerRadius = 20;
    [self.view addSubview:imgview];
    
    UILabel *temptext  = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    temptext.text = @"好";
    temptext.textColor = [UIColor whiteColor];
    temptext.textAlignment = NSTextAlignmentCenter;
    UIImage *image  = [self imageForView:temptext];
    imgview.image = image;
    
    /*
     NSString *string = @"字";
     NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
     [paragraphStyle setAlignment:NSTextAlignmentCenter];
     [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
     [paragraphStyle setLineSpacing:15.f];  //行间距
     [paragraphStyle setParagraphSpacing:2.f];//字符间距
     
     NSDictionary *attributes = @{NSFontAttributeName            : [UIFont systemFontOfSize:12],
     NSForegroundColorAttributeName : [UIColor blueColor],
     NSBackgroundColorAttributeName : [UIColor clearColor],
     NSParagraphStyleAttributeName : paragraphStyle, };
     
     
     UIImage *image1  = [self imageFromString:string attributes:attributes size:imgview.bounds.size];
     imgview.image = image1;
     */
}



- (void)testButtonAction:(UIButton *)button {


    // 全局并发队列的获取方法
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    const char *queueName = dispatch_queue_get_label(queue);
    NSLog(@"queueName = %s",queueName);
    
}

//文字转化为图片
- (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [string drawInRect:CGRectMake(0, 0, size.width, size.height) withAttributes:attributes];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//视图转化为图片
- (UIImage *)imageForView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    else
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
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
