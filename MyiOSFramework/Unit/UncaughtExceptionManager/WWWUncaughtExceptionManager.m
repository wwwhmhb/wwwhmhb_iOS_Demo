//
//  YORUncaughtExceptionHandler.m
//  YOYOMonitoring
//
//  Created by Yonggui Wang on 2018/9/5.
//  Copyright © 2018年 youerobot. All rights reserved.
/*
       我们通常所接触到的崩溃主要涉及到两种：
       一：由EXC_BAD_ACCESS引起的，原因是内存访问错误，重复释放等错误
       二： 未被捕获的Objective-C异常（NSException）
 
       针对NSException这种错误，可以直接调用NSSetUncaughtExceptionHandler函数来捕获;而针对EXC_BAD_ACCESS错误则需通过自定义注册SIGNAL来捕获。一般产生一个NSException异常的时候，同时也会抛出一个SIGNAL的信号(当然这只是一般情况，有时可能只是会单独出现)。
 */

#import "WWWUncaughtExceptionManager.h"
#import <libkern/OSAtomic.h>//OSAtomicIncrement32函数
#include <execinfo.h>//backtrace函数

@interface WWWUncaughtExceptionManager () {
    BOOL _dismissed;
}

@end


@implementation WWWUncaughtExceptionManager

#pragma mark -- self declare （本类声明）
//异常处理指针
static NSUncaughtExceptionHandler *g_vaildUncaughtExceptionHandler;

//重定义异常处理方法指针
static void (*ori_NSSetUncaughtExceptionHandler)(NSUncaughtExceptionHandler *);

//自定义发生异常的数
volatile int32_t UncaughtExceptionCount = 0;

//自定义最大异常数
const int32_t UncaughtExceptionMaximum = 10;

//自定义异常地址的开始位置
const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;

//自定义汇报异常地址的数目
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

//自定义 signal 异常名称
NSString * const UncaughtExceptionHandlerSignalExceptionName = @"UncaughtExceptionHandlerSignalExceptionName";

//自定义 Signal 抛出的错误标志的关键词
NSString * const UncaughtExceptionHandlerSignalKey = @"UncaughtExceptionHandlerSignalKey";

//自定义异常地址信息关键词
NSString * const UncaughtExceptionHandlerAddressesKey = @"UncaughtExceptionHandlerAddressesKey";

//自定义崩溃的类型
NSString * const UncaughtExceptionHandlerTypeKey = @"UncaughtExceptionHandlerTypeKey";


#pragma mark -- initliaze data(初始化数据)

//安装抓取异常信息的管理者
- (void)installYORUncaughtExceptionManager {
    
    //捕捉NSException错误，注册 NSException 错误的异常处理函数
    my_NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);

    //注册SIGNAL信号量，注册 Signal 抛出的异常处理函数
    //6:调用abort函数生成的信号
    signal(SIGABRT, SignalHandler);//abort()
    
    //4:执行了非法指令. 通常是因为可执行文件本身出现错误, 或者试图执行数据段. 堆栈溢出时也有可能产生这个信号。
    signal(SIGILL, SignalHandler);//illegal instruction (not reset when caught)
    
    //11:试图访问未分配给自己的内存, 或试图往没有写权限的内存地址写数据.
    signal(SIGSEGV, SignalHandler);//segmentation violation
    
    //8:在发生致命的算术运算错误时发出. 不仅包括浮点运算错误, 还包括溢出及除数为0等其它所有的算术的错误。
    signal(SIGFPE, SignalHandler);//floating point exception
    
    //7:非法地址, 包括内存地址对齐(alignment)出错。比如访问一个四个字长的整数, 但其地址不是4的倍数。它与SIGSEGV的区别在于后者是由于对合法存储地址的非法访问触发的(如访问不属于自己存储空间或只读存储空间)。
    signal(SIGBUS, SignalHandler);//bus error
    
    //13:管道破裂。这个信号通常在进程间通信产生，比如采用FIFO(管道)通信的两个进程，读管道没打开或者意外终止就往管道写，写进程会收到SIGPIPE信号。此外用Socket通信的两个进程，写进程在写Socket的时候，读进程已经终止。
    signal(SIGPIPE, SignalHandler);//write on a pipe with no one to read it
    
    /*
     当产生上述的signal的时候就会调用我们定义的mySignalHandler来处理异常，
     当产生NSException错误时就会调用系统提供的一个现成的函数NSSetUncaughtExceptionHandler()，这里面的方法名自己随便取。
     */
}

//#pragma mark -- lifecycle（生命周期）
//#pragma mark -- override super （重写父类）
//#pragma mark -- public Methods（公有方法）
//#pragma mark -- config control（布局控件）
//#pragma mark -- actions （点击事件）
//#pragma mark -- IBActions （响应事件）
//#pragma mark -- networkRequest (网络请求)
//#pragma mark -- protocol Methods（代理方法）
//#pragma mark -- setter getter （set和getter方法）
//#pragma mark -- private Methods（私有方法）

//处理异常信息的方法
- (void)handleException:(NSException *)exception {
    //标志和保存异常错误信息
    [self markAndSaveException:exception];

    //异常数量太多就不处理了
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum) {
        return;
    }

    //程序崩溃时的信息提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Unhandled exception", nil) message:[NSString stringWithFormat:NSLocalizedString(@"You can try to continue but the application may be unstable.\n\n" @"Debug details follow:\n%@\n%@", nil),[exception reason],[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]] preferredStyle:UIAlertControllerStyleAlert];
    WeakObject(self)
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Quit", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        StrongObject(self)
        strongself -> _dismissed = YES;
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Continue", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        StrongObject(self)
        strongself -> _dismissed = NO;
    }]];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UINavigationController *navigationController = (UINavigationController *)window.rootViewController;
    UIViewController *viewController = (UIViewController *)[[navigationController viewControllers] firstObject];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
    //在这里我们可以进行延时操作，保证在崩溃前我们能有充分的时间来完成对于崩溃信息的采集
    //获取当前的 RunLoop
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);

    while (!_dismissed) {
        for (NSString *mode in (__bridge NSArray *)allModes) {
            //快速切换Mode
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }

    CFRelease(allModes);


    //将先前的保存的 OCCrash 处理重新注册回去
    ori_NSSetUncaughtExceptionHandler(g_vaildUncaughtExceptionHandler);
    //将 SignalCrash 处理重新注册回去
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);

    //杀死进程
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {//SignalCrash
        //给pid所指的进程发送 signal 信号
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey] intValue]);
    } else {// OCCrash
        // OC 抛出异常
        [exception raise];
    }
}

//标志并保存数据
- (void)markAndSaveException:(NSException *)exception {

    //标志错误异常
    [WWWTools setUserdefaultsValue:@"YES" toKey:@"APPSystemCrash"];

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

    //综合异常错误信息
    NSString *content = [NSString stringWithFormat:@"\n日期：%@  \nuid：%@  \n端口：%@  \nAPP版本：%@  \n系统版本：%@   \n错误名称：%@  \n视图控制器：%@  \n错误原因：%@  \n崩溃所在：%@ ",dateStr,diceuserport[@"uid"],diceuserport[@"port"],appCurVersion,devicetext,name,nowview,reason,[callStack componentsJoinedByString:@"\n"]];

    //保存异常错误信息
    NVLogError(@"错误信息 = %@",content)
}

//获取调用堆栈信息
//上面就是我们自己获取到调用堆栈的方法。backtrace是Linux下用来追踪函数调用堆栈以及定位段错误的函数。
+ (NSArray *)backtrace {

    //指针列表
    void* callstack[128];

    /**
     用来获取当前线程的调用堆栈信息

     param callstack 存放获取信息的指针列表
     param 128 用来指定当前的buffer中可以保存多少个void*元素
     return 实际获取的指针个数
     */
    int frames = backtrace(callstack, 128);

    /**
     将从backtrace函数获取的信息转化为一个字符串数组

     param callstack 存放获取信息的指针列表
     param frames 实际的指针个数
     return 返回一个指向字符串数组的指针，其中每个字符串包含了一个相对于callstack中对应元素的可打印信息，包括函数名、偏移地址、实际返回地址
     */
    char **strs = backtrace_symbols(callstack, frames);

    //收集全部的异常地址
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (int i = 0; i < frames; i++) {

        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }

    //    //收集异常地址，从指定的位置开始并有指定数目
    //    for (int i = UncaughtExceptionHandlerSkipAddressCount; i < UncaughtExceptionHandlerSkipAddressCount + UncaughtExceptionHandlerReportAddressCount; i++) {
    //        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    //    }

    //释放字符串数组的指针
    free(strs);

    //返回收集的异常
    return backtrace;
}


//注册 NSException 错误的异常处理函数，并保证不拦截别人的异常处理 handler
void my_NSSetUncaughtExceptionHandler(NSUncaughtExceptionHandler *handler) {
    //定义的异常处理 handler 进行赋值，并用来保存先前别人注册的 handler
    g_vaildUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
    //定义的函数指针进行赋值，并指向 NSSetUncaughtExceptionHandler 函数
    ori_NSSetUncaughtExceptionHandler = NSSetUncaughtExceptionHandler;
    
    //注册自己的异常处理方法
    ori_NSSetUncaughtExceptionHandler(handler);
}

//NSException 异常处理函数
void UncaughtExceptionHandler(NSException *exception) {
    
    //构建 OC 错误信息
    NSArray *callStack = [WWWUncaughtExceptionManager backtrace];
    NSMutableDictionary *userInfo =
    [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:@"OCCrash" forKey:UncaughtExceptionHandlerTypeKey];
    
    //将错误信息传递给方法 handleException:
    [[[WWWUncaughtExceptionManager alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                                 withObject:[NSException exceptionWithName:[exception name]
                                                                                                    reason:[exception reason]
                                                                                                  userInfo:userInfo]
                                                              waitUntilDone:YES];
}

//注册 Signal 抛出的异常处理函数
void SignalHandler(int signal) {
    //构建 signal 错误信息
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [WWWUncaughtExceptionManager backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    [userInfo setObject:@"SignalCrash" forKey:UncaughtExceptionHandlerTypeKey];
    
    //将错误信息传递给方法 handleException:
    [[[WWWUncaughtExceptionManager alloc] init] performSelectorOnMainThread:@selector(handleException:)
                                                                 withObject: [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName
                                                                                                     reason: [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n", nil),signal]
                                                                                                   userInfo:userInfo]
                                                              waitUntilDone:YES];
}

@end


