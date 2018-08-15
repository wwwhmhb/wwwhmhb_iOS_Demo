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

typedef NS_ENUM(NSInteger,FileHandleType) {
    OnlyWritingType = 0,
    OnlyReadingType,
    ReadingAndWritingType
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


/**
 判断文件是否存在

 @param path 文件路径
 @return YES存在，NO不存在
 */
+ (BOOL)isFileExists:(NSString *)path;


/**
 判断是不是文件目录

 @param filePath 文件路径
 @return 是不是文件目录
 */
+ (BOOL)isFileDirectory:(NSString *)filePath;


/**
 获取文件目录中的内容

 @param path 文件路径
 @param isDeep 是否深度遍历文件
 @return 获取目录子路径的列表

 */
+ (NSArray *)getContentsOfDirectoryFromPath:(NSString *)path isDeep:(BOOL)isDeep;


/**
 创建文件夹

 @param path 文件路径
 @return 是否创建成功
 */
+ (BOOL)createDirectoryWithPath:(NSString *)path;


/**
 创建文件

 @param path 文件路径
 @param data 文件数据
 @return 是否创建成功
 */
+ (BOOL)createFileWithPath:(NSString *)path andContentsData:(NSData *)data;


/**
 复制文件/目录从路径A到路径B

 @param fromPath 路径A
 @param toPath 路径B
 @param isKeep 是否保存原文件
 @return 操作是否成功
 */
+ (BOOL)copyFileFromPath:(NSString *)fromPath toPath:(NSString *)toPath isKeepOldFile:(BOOL)isKeep;


/**
 删除文件

 @param path 文件路径
 @return 删除文件是否成功
 */
+ (BOOL)deleteFile:(NSString *)path;


/**
 获取文件属性

 @param path 文件路径
 @return 文件属性
 */
+ (NSDictionary *)getAttributesOfFileFromPath:(NSString *)path;


/**
 计算文件大小

 @param path 文件路径
 @return 文件大小
 */
+ (long long)fileSizeForPath:(NSString *)path;


/**
 计算系统磁盘中空闲空间

 @param path 磁盘路径
 @return 磁盘闲置空间大小
 */
+ (long long)freeSpaceWithPath:(NSString *)path;


/**
 计算系统磁盘中总共空间

 @param path 磁盘路径
 @return 磁盘空间大小
 */
+ (long long)totalSpaceWithPath:(NSString *)path;


/**
 将多个文件压缩

 @param paths 多个文件路径数组
 @param zipFilePath 压缩文件路径
 @return 是否压缩成功
 */
+ (BOOL)zipFileFromSourceFilePaths:(NSArray *)paths toZipFilePath:(NSString *)zipFilePath;


/**
 将多个文件夹压缩

 @param directoryPath 文件夹路径
 @param zipFilePath 压缩文件路径
 @return 是否压缩成功
 */
+ (BOOL)zipFileFromSourceFileDirectoryPath:(NSString *)directoryPath toZipFilePath:(NSString *)zipFilePath;

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
 将字符串存到 Userdefaults 中指定的 key 值名下

 @param value 数据
 @param key key值
 @return 是否成功
 */
+ (BOOL)setUserdefaultsValue:(NSString *)value toKey:(NSString *)key;

/**
 获取 Userdefaults 中指定的 key 值名下的字符串

 @param key key值
 @return 字符串
 */
+ (NSString *)getUserdefaultsValueFromKey:(NSString *)key;


/**
 获取当前日期

 @param format 日期格式，默认为：YYYY-MM-dd HH:mm:ss
 @return 日期字符串
 */
+ (NSString *)getCurrentDateWithFormat:(NSString *)format;


/**
 获取当前的视图控制器

 @param rootViewController 根视图控制器
 @return 当前视图控制器
 */
+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

@end
