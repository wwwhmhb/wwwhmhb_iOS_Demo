//
//  WWWFileManager.m
//  MyiOSFramework
//
//  Created by 王威威 on 2021/2/20.
//  Copyright © 2021 Weiwei Wang. All rights reserved.
//

#import "WWWFileManager.h"
#import <mach/mach.h>

static NSTimeInterval _lastTimestamp;
static NSInteger _frameCount;
static CADisplayLink *_link;
static FrameValueBlock _valueBlock;

@implementation WWWFileManager
// 获取沙盒中 Document 的目录文件路径
+ (NSString *)getDocumentItemPathWithSubDirectoryPath:(NSString *)subItemPath {
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [documentDirectory stringByAppendingPathComponent:subItemPath];
    return path;
}

// 创建文件目录
+ (BOOL)createDirectoryPath:(NSString *)path {
    if (![self checkItemExistsStatusPath:path]) {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error;
        NSURL *fileUrl = [NSURL fileURLWithPath:path];
        //文件不备份iCloud
        [fileUrl setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
        [manager createDirectoryAtURL:fileUrl withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return false;
        }else{
            return true;
        }
    } else {
        return true;
    }
}

// 创建文件
+ (BOOL)createFilePath:(NSString *)path withData:(nullable NSData *)data {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![self checkItemExistsStatusPath:path]) {
        NSString *pathDeletingLastPathComponent = [path stringByDeletingLastPathComponent];
        if (![self createDirectoryPath:pathDeletingLastPathComponent]) {
            return false;
        }
    }
    return [manager createFileAtPath:path contents:data attributes:nil];
}

//删除目录文件
+ (BOOL)removeItemWithPath:(NSString *)path {
    BOOL isSuccess = true;
    if ([self checkItemExistsStatusPath:path]) {
        isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return isSuccess;
}

// 查询目录或文件是否存在
+ (BOOL)checkItemExistsStatusPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isExists = [manager fileExistsAtPath:path];
    return isExists;
}

// 查询系统磁盘未使用的存储空间
+ (CGFloat)checkVolumeStorageCapacity {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    CGFloat freesize = 0.0;
    NSError *error = nil;
    if (@available(iOS 11.0, *)) {
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:paths.firstObject];
        NSDictionary *dictionary = [fileURL resourceValuesForKeys:@[NSURLVolumeAvailableCapacityForImportantUsageKey] error:&error];
        if (dictionary) {
            NSNumber *_free = dictionary[NSURLVolumeAvailableCapacityForImportantUsageKey];
            freesize = [_free unsignedLongLongValue]*1.0/1000/1000;
        } else {
            printf("Error Check Volume Storage Capacity Info: Domain = %s, Code = %ld", [[error domain] UTF8String], (long)[error code]);
            freesize = 0.0;
        }
    } else {
        NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
        if (dictionary) {
            NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
            freesize = [_free unsignedLongLongValue]*1.0/1000/1000;
        } else {
            printf("Error Check Volume Storage Capacity Info: Domain = %s, Code = %ld", [[error domain] UTF8String], (long)[error code]);
            freesize = 0.0;
        }
    }
    return freesize;
}


//停止计算帧率
+ (void)stopCalculationFrame {
    if (_link) {
        [_link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _link = nil;
    }
}
//开始计算帧率
+ (void)startCalculationFrameWithValueBlock:(FrameValueBlock)valueBlock {
    _valueBlock = valueBlock;
    _lastTimestamp = -1;
    _frameCount = 0;
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(calFPS:)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}
+ (void)calFPS:(CADisplayLink *)displayLink {
    if(_lastTimestamp == -1){
        _lastTimestamp = displayLink.timestamp;
        return;
    }
    
    _frameCount++;
    
    NSTimeInterval interval = displayLink.timestamp - _lastTimestamp;
    if(interval < 1){
        return;
    }
    
    _lastTimestamp = displayLink.timestamp;
    CGFloat fps = _frameCount / interval;
    _frameCount = 0;
    
    if (_valueBlock) {
        _valueBlock(fps);
    }
}

//CPU使用率
+ (float)usedCPU {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++) {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    return tot_cpu;
}
//获取当前设备可用内存
+ (double)availableMemory {
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size * vmStats.free_count)/1024.0)/1024.0;
}

//获取当前任务所占用内存
+ (double)usedMemory {
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size/1024.0/1024.0;
}

//APP占用内存
+ (double)usedMemory_app {
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return vmInfo.phys_footprint / 1024.0 / 1024.0;;
}
@end
