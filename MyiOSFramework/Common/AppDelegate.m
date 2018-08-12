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
#import "WWWNetworkingManager.h"
#import "ZipArchive.h"

@interface AppDelegate () {
    
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //经日志写入文件中
    [[NVLogManager shareInstance] enableFileLogSystem];
    NVLogError(@"错误信息如上所述")
    
    //抓住异常问题
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    //监听设备旋转通知
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    
    //判断上次退出APP是否有异常问题
    NSString *isCrash = [WWWTools getUserdefaultsValueFromKey:@"APPSystemCrash"];
    //异常日志路径
    NSString *crashFilePath = [[NVLogManager shareInstance] getCurrentLogFilePath];
    NSString *cachePath = [WWWTools getLibraryCachePath];
    NSString *zipFilePath = [cachePath stringByAppendingPathComponent:@"ZipCrashLogs"];
    if ([isCrash isEqualToString:@"YES"]) {//有异常问题，进行文件压缩
        //压缩异常日志
        [self zipFileFromSourceFilePaths:@[crashFilePath] toZipFilePath:zipFilePath];
    } else if ([isCrash isEqualToString:@"NO"]) {//没有异常问题，清空日志
        //清空日志
        [[NVLogManager shareInstance] clearFileLog];
        //设置系统崩溃为NO
        [WWWTools setUserdefaultsValue:@"NO" toKey:@"APPSystemCrash"];
    }
    
    //上传异常日志
    [self uploadExceptionLogWithPath:zipFilePath];
//    [self uploadExceptionLogWithPath:@""];
    
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


#pragma mark  --  收集异常，进行标志
void UncaughtExceptionHandler(NSException *exception) {
    //异常信息
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    //日期
    NSString * dateStr = [WWWTools getCurrentDateWithFormat:nil];
    
    //获取崩溃界面
    UIViewController *viewNow = [WWWTools topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
    //class 转字符串
    NSString * nowview = NSStringFromClass([viewNow class]);
    
    // 用户信息
    NSDictionary * diceuserport= [[NSUserDefaults standardUserDefaults] objectForKey:@"useruidport" ];
    //app版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //iOS系统版本
    NSString * devicetext = [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]];
    
    //综合信息
    NSString *content = [NSString stringWithFormat:@"\n日期：%@  \nuid：%@  \n端口：%@  \nAPP版本：%@  \n系统版本：%@   \n错误名称：%@  \n视图控制器：%@  \n错误原因：%@  \n崩溃所在：%@ ",dateStr,diceuserport[@"uid"],diceuserport[@"port"],appCurVersion,devicetext,name,nowview,reason,[callStack componentsJoinedByString:@"\n"]];
    NVLogError(@"错误信息 = %@",content)
    [WWWTools setUserdefaultsValue:@"YES" toKey:@"APPSystemCrash"];
}

#pragma mark  --  上传异常信息
- (void)uploadExceptionLogWithPath:(NSString *)path {
    
    NSArray *fileArray = [WWWTools getContentsOfDirectoryWithPath:path];
    if (fileArray.count > 0) {
        for (NSString *fileName in fileArray) {
            NSString *robotid = @"TWYP5TA6LR5LOVRC";
            NSDictionary *dic = @{
                                  @"robot_id" : robotid,
                                  @"file_name" : @"MyTest.zip",
                                  @"file_type" : @"file/zip"
                                  };
            
            NSString *crashLogFilePath = [path stringByAppendingPathComponent:fileName];
            WWWNetworkingManager *networkingManager = [WWWNetworkingManager shared];
            [networkingManager initNetworkingManager];
            [networkingManager uploadFileToUrlStr:@"http://yoby-dispatch.test.youerobot.com/business/upload_log_file/" andFilePath:crashLogFilePath andParameters:dic andProgress:^(NSProgress *uploadProgress) {

            } andFinishBlock:^(id responseObject, NSError *error) {
                if (error) {
                    NVLogError(@"error = %@",error);
                } else {
                    NVLogInfo(@"上传崩溃日志成功");
                    //删除文件
                    [WWWTools deleteFile:crashLogFilePath];
                }
            }];
        }
    }
}

#pragma mark  --  压缩文件
- (void)zipFileFromSourceFilePaths:(NSArray *)paths toZipFilePath:(NSString *)zipFilePath {
    //创建文件目录
    BOOL isFile = [WWWTools createDirectoryWithPath:zipFilePath];
    if (isFile) {
        //数组里可以放多个源文件，这些文件会被同一打包成压缩包，到 destinationPath 这个路径下,注意目的路径是 zip 格式的后缀。
        NSString *currentDateStr = [WWWTools getCurrentDateWithFormat:@"YYYYMMddHHmmss"];
        NSString *componentPath = [NSString stringWithFormat:@"%@.zip",currentDateStr];
        zipFilePath = [zipFilePath stringByAppendingPathComponent:componentPath];
        BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:paths];
        if (isSuccess) {//压缩成功，清空日志
            NVLogInfo(@"压缩成功");
            //清空日志
            [[NVLogManager shareInstance] clearFileLog];
            //设置系统崩溃为NO
            [WWWTools setUserdefaultsValue:@"NO" toKey:@"APPSystemCrash"];
        } else {//压缩失败再次压缩
            NVLogError(@"压缩失败");
            BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:paths];
            if (isSuccess) {//压缩成功，清空日志
                NVLogInfo(@"压缩成功");
                //清空日志
                [[NVLogManager shareInstance] clearFileLog];
                //设置系统崩溃为NO
                [WWWTools setUserdefaultsValue:@"NO" toKey:@"APPSystemCrash"];
            } else {
                NVLogError(@"压缩失败");
                //设置系统崩溃为YES
                [WWWTools setUserdefaultsValue:@"YES" toKey:@"APPSystemCrash"];
            }
        }
    } else {
        NVLogInfo(@"创建文件失败");
    }
}

@end
