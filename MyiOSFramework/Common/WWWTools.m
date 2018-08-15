//
//  WWWTools.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/16.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTools.h"
#import <CoreTelephony/CTCellularData.h>//网络权限
#import <AVFoundation/AVCaptureDevice.h>//摄像头权限
#import <Photos/Photos.h>//相册权限
#import <CoreLocation/CoreLocation.h>//位置权限
#import <CoreBluetooth/CoreBluetooth.h>//蓝牙权限
#import "ZipArchive.h"//压缩与解压文件

@implementation WWWTools

//主目录路径
+ (NSString *)getHomePath {
    return NSHomeDirectory();
}

//APP程序包路径，这是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动
+ (NSString *)getAppPath {
    //    //例如获取程序包中一个图片资源（apple.png）路径的方法：
    //    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"png"];
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//获取 Document 目录路径，您应该将所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
+ (NSString *)getDocumentPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//获取 Library 目录路径，这个目录下有两个子目录：Caches 和 Preferences
+ (NSString *)getLibraryPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

//获取 Library 目录中 Preference 的路径，包含应用程序的偏好设置文件。您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
+ (NSString *)getLibraryPreferencePath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preferences"];
}

//获取 Library 目录中 Cache 的路径，用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
+ (NSString *)getLibraryCachePath {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
//    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
//    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

//获取 tmp 目录路径，这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
+ (NSString *)getTmpPath {
    
    return NSTemporaryDirectory();
//    return [NSHomeDirectory() stringByAppendingFormat:@"/tmp"];
}

//获取自定义目录路径
+ (NSString*)getCustomPathByFilePathType:(FilePathType)filePathType andFilePathName:(NSString *)filePathName andFilePathExtension:(NSString *)filePathExtension {
    
    //根路径
    NSString *rootPath;
    switch (filePathType) {
        case HomePath:
            {
                rootPath = [self getHomePath];
            }
            break;
        case AppPath:
            {
                rootPath = [self getAppPath];
            }
            break;
        case DocumentPath:
            {
                rootPath = [self getDocumentPath];
            }
            break;
        case LibraryPath:
            {
                rootPath = [self getLibraryPath];
            }
            break;
        case LibraryPreferencePath:
            {
                rootPath = [self getLibraryPreferencePath];
            }
            break;
        case LibraryCachePath:
            {
                rootPath = [self getLibraryCachePath];
            }
            break;
        case TmpPath:
            {
                rootPath = [self getTmpPath];
            }
            break;
    }
    
    //合成自定义路径
    NSString *filePath;
    if (filePathName && filePathExtension) {
        filePath = [[rootPath stringByAppendingPathComponent:filePathName] stringByAppendingPathExtension:filePathExtension];
    } else if (filePathName) {
        filePath = [rootPath stringByAppendingPathComponent:filePathName];
    } else if (filePathExtension) {
        filePath = [rootPath stringByAppendingPathExtension:filePathExtension];
    } else {
        filePath = rootPath;
    }
    return filePath;
}


//判断文件是否存在
+ (BOOL)fileExists:(NSString *)path {
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//判断是不是文件目录
+ (BOOL)isDirectory:(NSString *)filePath {
//    BOOL isDirectory = NO;
//    [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
//    return isDirectory;
    
    NSNumber *isDirectory;
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    [fileUrl getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:nil];
    return isDirectory.boolValue;
    
}

//获取文件目录中的内容，浅遍历文件目录
+ (NSArray *)getContentsOfDirectoryWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    return fileList;
}


//获取文件目录中文件，深度遍历文件目录
+ (NSArray *)getSubpathsOfDirectoryWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    NSArray *fileList = [fileManager subpathsOfDirectoryAtPath:path error:&error];
    return fileList;
}

//创建文件夹
+ (BOOL)createDirectoryWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![self fileExists:path]) {
        return [fileManager createDirectoryAtPath:path
                      withIntermediateDirectories:YES
                                       attributes:nil
                                            error:NULL];
    }
    
    return YES;
}

//创建文件
+ (BOOL)createFileWithPath:(NSString *)path andContentsData:(NSData *)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [self deleteFile:path];
    return [fileManager createFileAtPath:path contents:data attributes:nil];
}

//删除文件
+ (BOOL)deleteFile:(NSString *)path {
    if ([self fileExists:path]) {
        NSError *error = nil;
        NSFileManager* fileManager=[NSFileManager defaultManager];
        BOOL isSuccess =  [fileManager removeItemAtPath:path error:&error];
        return isSuccess;
    }
    return YES;
}

//计算文件大小
+ (long long)fileSizeForPath:(NSString *)path {
    long long fileSize = 0;
    if([self fileExists:path]){//文件存在
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {//属性存在
            if ([fileDict.fileType isEqualToString:NSFileTypeDirectory]) {//是文件夹
                //获取文件夹下的文件子路径，同 getSubpathsOfDirectoryWithPath 方法一样
                NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:path];
                if (enumerator) {//存在子文件路径
                    for (NSString *subpath in enumerator) {
                        // 合成全路径
                        NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
                        // 累加文件大小
                        fileSize += [fileManager attributesOfItemAtPath:fullSubpath error:nil].fileSize;
                    }
                }
            } else {//是文件
                fileSize = fileDict.fileSize;
//                NSString *sizeText;
//                if (fileSize >= pow(10, 9)) { // size >= 1GB
//                    sizeText = [NSString stringWithFormat:@"%.2fGB", fileSize / pow(10, 9)];
//                } else if (fileSize >= pow(10, 6)) { // 1GB > size >= 1MB
//                    sizeText = [NSString stringWithFormat:@"%.2fMB", fileSize / pow(10, 6)];
//                } else if (fileSize >= pow(10, 3)) { // 1MB > size >= 1KB
//                    sizeText = [NSString stringWithFormat:@"%.2fKB", fileSize / pow(10, 3)];
//                } else { // 1KB > size
//                    sizeText = [NSString stringWithFormat:@"%zdB", fileSize];
//                }
            }
        }
    }
    return fileSize;
}

//计算系统磁盘中空闲空间
+ (long long)freeSpaceWithPath:(NSString *)path {
    
    NSFileManager* fileManager = [[NSFileManager alloc ] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    return [freeSpace longLongValue];
}

//计算系统磁盘中总共空间
+ (long long)totalSpaceWithPath:(NSString *)path {
    
    NSFileManager* fileManager = [[NSFileManager alloc ] init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    return [totalSpace longLongValue];
}

//将多个文件压缩
+ (BOOL)zipFileFromSourceFilePaths:(NSArray *)paths toZipFilePath:(NSString *)zipFilePath {

    //创建不带密码zip压缩包
    BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:paths];
    //创建带密码zip压缩包
    //BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withFilesAtPaths:paths withPassword:@"SSZipArchive.zip"];
    return isSuccess;
    
}

//文件夹压缩
+ (BOOL)zipFileFromSourceFileDirectoryPath:(NSString *)directoryPath toZipFilePath:(NSString *)zipFilePath {

    //创建不带密码zip压缩包
    BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:directoryPath];
    //创建带密码zip压缩包
    //BOOL isSuccess = [SSZipArchive createZipFileAtPath:zipFilePath withContentsOfDirectory:directoryPath withPassword:@"SSZipArchive.zip"];
    return isSuccess;
    
}

//获取网络权限
+ (void)requestNetworkPermission {
    if (@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState state = cellularData.restrictedState;
        if (state == kCTCellularDataRestrictedStateUnknown) {
            [self simpleNetworkRequest];
        }
    } else {
        [self simpleNetworkRequest];
    }
}
//简单的网络请求，获取网络权限
+ (void)simpleNetworkRequest {
    
    //1. 创建一个网络请求地址，如果使用http，info.plist中需要创建App Transport Security Settings中Allow Arbitrary Loads，并设置为YES，建议使用https，请求的速度会快点，因为请求的内容比较少
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    //2.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session=[NSURLSession sharedSession];
    //4.获取网络请求任务
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result = %@",result);
    }];
    //5.开始任务
    [dataTask resume];
}


//获取相册权限
+ (void)requestPhotoLibraryPermission {
    
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        }];
    }
}

//获取摄像头权限
+ (void)requestCameraPermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType: AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        }];
    }
}

//获取麦克风权限
+ (void)requestMicrophonePermission {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        }];
    }
}

//将字符串存到 Userdefaults 中指定的 key 值名下
+ (NSString *)getUserdefaultsValueFromKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *context = @"";
    if ([userDefaults valueForKey:key]) {
        context = [NSString stringWithFormat:@"%@",[userDefaults valueForKey:key]];
        if (!context) {
            context = @"";
        }
    }
    return context;
}

//获取 Userdefaults 中指定的 key 值名下的字符串
+ (BOOL)setUserdefaultsValue:(NSString *)value toKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (!value) {
        value = @"";
    }
    [userDefaults setValue:value forKey:key];
    BOOL isSuccess = [userDefaults synchronize];
    return isSuccess;
}

//获取当前日期
+ (NSString *)getCurrentDateWithFormat:(NSString *)format {
    if (!format || [format isEqualToString:@""]) {
        format = @"YYYY-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}

//获取当前的视图控制器
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
        
    } else if (rootViewController.presentedViewController) {
        
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        
        return [self topViewControllerWithRootViewController: presentedViewController];
        
    } else {
        
        return rootViewController;

    }
}

@end
