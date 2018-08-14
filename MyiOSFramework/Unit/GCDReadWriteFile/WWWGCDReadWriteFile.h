//
//  WWWGCDReadFile.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/8/13.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWGCDReadWriteFile : NSObject

/**
 读取指定路径的文件内容

 @param filePath 文件路径
 @param isSerial 读取文件是否串行
 @param finshBlock 读取结果回调
 */
+ (void)readFileWithFilePath:(NSString *)filePath andIsSerial:(BOOL)isSerial andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock;


/**
 写内容到指定路径的文件中

 @param object 写入内容
 @param filePath 写入路径
 @param isCover 是否覆盖源文件
 @param finshBlock 写入结果回调
 */
+ (void)wrideFileWithContent:(id)object toFilePath:(NSString *)filePath isCoverOlderFile:(BOOL)isCover andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock;

@end
