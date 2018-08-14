//
//  WWWGCDReadFile.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/8/13.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWGCDReadFile : NSObject

+ (void)readFileWithFilePath:(NSString *)filePath andIsSerial:(BOOL)isSerial andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock;

@end
