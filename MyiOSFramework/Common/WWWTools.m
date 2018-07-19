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



@end
