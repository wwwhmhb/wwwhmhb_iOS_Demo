//
//  WWWTools.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/16.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//文件路径类型
typedef NS_ENUM(NSInteger,FilePathType) {
    HomePath = 0,
    AppPath,
    DocumentPath,
    LibraryPath,
    LibraryPreferencePath,
    LibraryCachePath,
    TmpPath
};

@interface WWWTools : NSObject

/*=============== 文件操作部分 =================*/
/**
 获取主目录路径

 @return 主目录路径
 */
+ (NSString *)getHomePath;

/**
 获取APP程序包路径
 该路径是应用程序的程序包目录，包含应用程序的本身。由于应用程序必须经过签名，所以您在运行时不能对这个目录中的内容进行修改，否则可能会使应用程序无法启动
 @return APP程序包路径
 */
+ (NSString *)getAppPath;


/**
 获取 Document 目录路径
 您应该将所有的应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
 @return Document 目录路径
 */
+ (NSString *)getDocumentPath;


/**
 获取 Library 目录路径
 该目录下有两个子目录：Caches 和 Preferences
 @return Library 目录路径
 */
+ (NSString *)getLibraryPath;

/**
 获取 Library 目录中 Preference 的路径
 该目录包含应用程序的偏好设置文件。但您不应该直接创建偏好设置文件，而是应该使用NSUserDefaults类来取得和设置应用程序的偏好.
 @return Library 目录中 Preference 的路径
 */
+ (NSString *)getLibraryPreferencePath;

/**
 获取 Library 目录中 Cache 的路径
 该目录用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息
 @return Library 目录中 Cache 的路径
 */
+ (NSString *)getLibraryCachePath;

/**
 获取 tmp 目录路径
 该目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息
 @return tmp 目录路径
 */
+ (NSString *)getTmpPath;


/**
 获取自定义目录路径

 @param filePathType 文件路径类型
 @param filePathName 文件路径名称
 @param filePathExtension 文件路径格式
 @return 自定义路径
 */
+ (NSString*)getCustomPathByFilePathType:(FilePathType)filePathType andFilePathName:(NSString *)filePathName andFilePathExtension:(NSString *)filePathExtension;



/*=============== 隐私权限请求操作部分 =================*/
/**
 获取网络权限
 */
+ (void)requestNetworkPermission;

/**
 获取相册权限
 */
+ (void)requestPhotoLibraryPermission;

/**
 获取摄像头权限
 */
+ (void)requestCameraPermission;

/**
 获取麦克风权限
 */
+ (void)requestMicrophonePermission;




/**
 获取当前的视图控制器

 @param rootViewController <#rootViewController description#>
 @return <#return value description#>
 */
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

@end
