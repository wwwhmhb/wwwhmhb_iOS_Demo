//
//  WWWGCDReadFile.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/8/13.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWGCDReadWriteFile.h"

@implementation WWWGCDReadWriteFile

dispatch_semaphore_t _semaphore;

+ (void)readFileWithFilePath:(NSString *)filePath andIsSerial:(BOOL)isSerial andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock {
    
    if (isSerial) {
        [self serialReadFileWithFielPath:filePath andFinishBlock:finshBlock];
    } else {
        [self concurrentReadFileWithFielPath:filePath andFinishBlock:finshBlock];
    }
}

//串行读取文件
+ (void)serialReadFileWithFielPath:(NSString *)filePath andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock {
    //队列创建
    dispatch_queue_t queue =dispatch_queue_create("queue",NULL);//当设置为并行队列时在读取文件时实际还是串行
    //创建文件描述，以只读方式打开文件
    dispatch_fd_t fd = open(filePath.UTF8String,O_RDONLY, 0);
    //创建一个调度I / O通道
    dispatch_io_t io =dispatch_io_create(DISPATCH_IO_STREAM, fd, queue, ^(int error) {
        close(fd);
    });
    
    //每次文件读取的大小
    size_t water = 1024;
    //设置一次读取的最小字节
    dispatch_io_set_low_water(io, water);
    //设置一次读取的最大字节
    dispatch_io_set_high_water(io, water);
    //目标文件的大小
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    //创建可变data，用于存放读取的文件内容，可以进行 appendData:，因为此拼接前没有数据
    NSMutableData *totalData = [[NSMutableData alloc] init];
    
    __block NSError *myError = nil;
    
    //在队列中，读取整体文件内容
    dispatch_io_read(io,0, fileSize, queue, ^(bool done,dispatch_data_t  _Nullable data, int error) {
        if (error == 0) {//没有错误
            size_t len = dispatch_data_get_size(data);
            if (len >0) {
                [totalData appendData:(NSData *)data];
            }
        } else {//制定错误信息
            myError = [NSError errorWithDomain:@"读取信息错" code:error userInfo:@{NSLocalizedDescriptionKey : @"读取信息错"}];
        }
        
        if (done) {//每次读取内容完成后调用
            finshBlock(totalData,myError);
        }
    });
}

//并发读取文件
+ (void)concurrentReadFileWithFielPath:(NSString *)filePath andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock {
    //队列创建
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    //创建文件描述，以只读方式打开文件
    dispatch_fd_t fd = open(filePath.UTF8String, O_RDONLY);
    //创建一个并发的调度I / O通道
    dispatch_io_t io = dispatch_io_create(DISPATCH_IO_RANDOM, fd, queue, ^(int error) {
        close(fd);
    });
    //目标文件的大小
    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    //已读取文件大小
    off_t currentSize = 0;
    //每次文件读取的大小
    size_t offset = 1024*1024;
    //创建分组
    dispatch_group_t group = dispatch_group_create();
    //创建可变data，用于存放读取的文件内容,不要进行 appendData:，因为此拼接前有 fileSize 个0数据.
    NSMutableData *totalData = [[NSMutableData alloc] initWithLength:fileSize];
    
    __block NSError *myError = nil;
    
    //一次一次的读取文件，之至目标文件读取完
    for (; currentSize <= fileSize ; currentSize += offset) {
        //队列添加到分组中
        dispatch_group_enter(group);
        //在队列中从指定点开始，读取一定的内容的文件
        dispatch_io_read(io, currentSize, offset, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
            
            if (error == 0) {//没有错误
                //读取内容的长度
                size_t len = dispatch_data_get_size(data);
                
                if (len > 0) {//如果有内容
                    
                    const void *bytes = NULL;
                    //内容转化为bytes
                    (void)dispatch_data_create_map(data, (const void **)&bytes, &len);
                    //data拼接bytes
                    [totalData replaceBytesInRange:NSMakeRange(currentSize, len) withBytes:bytes length:len];
                }
            } else { //出现错误
                myError = [NSError errorWithDomain:@"读取信息错" code:error userInfo:@{NSLocalizedDescriptionKey : @"读取信息错"}];
            }
            if (done) {//每次读取内容完成后调用
                dispatch_group_leave(group);
            }
        });
    }
    //目标文件读取完成之后调用
    dispatch_group_notify(group, queue, ^{
        finshBlock(totalData,myError);
    });
}

//写入文件
+ (void)wrideFileWithContent:(id)object toFilePath:(NSString *)filePath isCoverOlderFile:(BOOL)isCover andFinishBlock:(void(^)(NSData *data,NSError *error))finshBlock {
    
    if(!_semaphore){
        // 初始化信号量，
        _semaphore = dispatch_semaphore_create(1);
    }
    // 等待信号量
    dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);

    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);//队列
    size_t offSize = 0;//文件偏移大小
    dispatch_fd_t fd;//文件描述
    dispatch_io_t pipe_chanel;//调度I / O通道
    
    if (!isCover) {//是否覆盖原文件
        //文件写入的偏移位置
        offSize = [WWWTools fileSizeForPath:filePath];
        //从尾部开始进行写入
        fd = open(filePath.UTF8String, O_RDWR | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO | O_APPEND);
        pipe_chanel = dispatch_io_create_with_path(DISPATCH_IO_STREAM,[filePath UTF8String], O_RDWR | O_APPEND, 0,queue , ^(int error) {
            close(fd);
        });
    } else {
        //从头开始进行写入
        fd = open(filePath.UTF8String, O_RDWR | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
        pipe_chanel = dispatch_io_create_with_path(DISPATCH_IO_STREAM,[filePath UTF8String], O_RDWR, 0,queue , ^(int error) {
            close(fd);
        });
    }
    
    const void *contentChar;//写入内容指针
    size_t size = 0;//内容大小
    if ([object isKindOfClass:[NSString class]]) {//内容为字符串
        NSString *string = (NSString *)object;
        contentChar = [string UTF8String];
        size = strlen(contentChar);
    }
    if ([object isKindOfClass:[NSData class]]) {//内容为NSData
        NSData *data = (NSData *)object;
        contentChar = [data bytes];
        size = data.length;
    }
    
    //内容数据转换为 dispatch_data_t
    dispatch_data_t dataT = dispatch_data_create(contentChar, size, queue, NULL);
//    dispatch_data_t dataT = dispatch_data_create(contentChar, size, queue, ^{
//
//    });
    //内容写入文件
    dispatch_io_write(pipe_chanel, offSize, dataT, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
        if (error == 0) {//写入成功
            NSData *resultData = (NSData *)data;
            finshBlock(resultData,nil);
        } else {//写入失败
            NSError *myError = [NSError errorWithDomain:@"写入信息错" code:error userInfo:@{NSLocalizedDescriptionKey : @"写入信息错"}];
            finshBlock(nil,myError);
        }
        dispatch_semaphore_signal(_semaphore);
    });
}
@end
