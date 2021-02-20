//
//  WWWFileManager.h
//  MyiOSFramework
//
//  Created by 王威威 on 2021/2/20.
//  Copyright © 2021 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FrameValueBlock)(CGFloat frame);

NS_ASSUME_NONNULL_BEGIN

@interface WWWFileManager : NSObject

+ (NSString *)getDocumentItemPathWithSubDirectoryPath:(NSString *)subItemPath;
+ (BOOL)createDirectoryPath:(NSString *)path;
+ (BOOL)createFilePath:(NSString *)path withData:(nullable NSData *)data;
+ (BOOL)removeItemWithPath:(NSString *)path;
+ (BOOL)checkItemExistsStatusPath:(NSString *)path;
+ (CGFloat)checkVolumeStorageCapacity;
+ (void)stopCalculationFrame;
+ (void)startCalculationFrameWithValueBlock:(FrameValueBlock)valueBlock;
+ (float)usedCPU;
+ (double)availableMemory;
+ (double)usedMemory;
+ (double)usedMemory_app;

@end

NS_ASSUME_NONNULL_END
