//
//  AppDelegate.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/11.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "AppDelegate.h"

#import "WWWBaseNavigationController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    //启动图片延时: 1秒
    [NSThread sleepForTimeInterval:1];
    
    
    //加载并显示根视图控制器
    MainViewController *mainViewController = [[MainViewController alloc] init];
    WWWBaseNavigationController *baseNavigationController = [[WWWBaseNavigationController alloc]initWithRootViewController:mainViewController];
    //设置窗口的大小和位置，如果不设置，就不显示根视图，界面呈现黑色
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = baseNavigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark    收集异常，上传
void UncaughtExceptionHandler(NSException *exception) {
    //异常信息
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    //日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * dateStr = [formatter stringFromDate:[NSDate date]];
    //获取崩溃界面
    UIViewController *viewNow = [WWWTools topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    //class 转字符串
    NSString * nowview = NSStringFromClass([viewNow class]);
    
    
    // 用户信息
    NSDictionary * diceuserport= [[NSUserDefaults standardUserDefaults]objectForKey:@"useruidport" ];
    //app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //iOS系统
    NSString * devicetext = [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    
    //综合信息
    NSString *content = [NSString stringWithFormat:@"\n日期：%@  \nuid:%@  \n端口：%@  \nAPP版本：%@  \n系统版本：%@   \n错误：%@  \n视图控制器：%@  \n错误原因：%@  \n崩溃所在：%@ ",dateStr,diceuserport[@"uid"],diceuserport[@"port"],appCurVersion,devicetext,name,nowview,reason,[callStack componentsJoinedByString:@"\n"]];
    
    NSLog(@"content = %@",content);
    
//    //同步方法上传服务器 （试了试异步了，还没上传就崩了）
//    // 创建URL对象
//    NSURL *url =[NSURL URLWithString:YJFKPresentUrlStr];
//    NSMutableURLRequest *resuest =[NSMutableURLRequest requestWithURL:url];
//    [resuest setHTTPMethod:@"post"];
//    [resuest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [resuest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"uid":diceuserport[@"uid"],@"type":@"应用崩溃",@"content":content,@"contact_way":@"App-反馈"} options:NSJSONWritingPrettyPrinted error:nil];
//    NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
//    resuest.HTTPBody = tempJsonData;
//    //4 创建响应对象
//    NSURLResponse *response = nil;
//    //5 创建连接对象
//    NSError *error;
//    NSData *data = [NSURLConnection sendSynchronousRequest:resuest returningResponse:&response error:&error];
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    //反馈结果
//    NSLog(@"%@",dict);
}


@end
