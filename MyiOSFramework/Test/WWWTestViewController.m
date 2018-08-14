//
//  WWWTestViewController.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestViewController.h"

#import "NSArray+LXDExtension.h"
#import "BlazeiceDooleView.h"
#import "WWWNetworkingManager.h"
#import "WWWGCDReadWriteFile.h"
@interface WWWTestViewController () {
    dispatch_queue_t queue;
}

@property (nonatomic,strong) NSData *myData;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"TestViewController";
    WeakSelf(self)
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"text"];
    [WWWGCDReadWriteFile readFileWithFilePath:path andIsSerial:NO andFinishBlock:^(NSData *data, NSError *error) {
        StrongSelf(weakSelf)
        strongSelf.myData = (NSData *)data;
        NSString *string = [[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"string = %@",string);
    }];
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Test" forState:UIControlStateNormal];
    [testButton setBackgroundColor:[UIColor orangeColor]];
    [testButton addTarget:self action:@selector(testButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(80);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
}


- (void)testButtonAction:(UIButton *)button {


//    // 全局并发队列的获取方法
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
//    const char *queueName = dispatch_queue_get_label(queue);
//    NSLog(@"queueName = %s",queueName);

    
    NSString *path = [WWWTools getDocumentPath];
    NSString *filePath = [path stringByAppendingPathComponent:@"myTest.text"];
    NSString *string = @"我很好";
    NSData* xmlData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [WWWGCDReadWriteFile wrideFileWithContent:xmlData toFilePath:filePath isCoverOlderFile:NO andFinishBlock:^(NSData *data, NSError *error) {
        if (error) {
            NSLog(@"error = %@",error);
        } else {
            NSLog(@"GCD写入文件成功");
        }
    }];
    
//    dispatch_fd_t fd = open(filePath.UTF8String, O_RDWR | O_CREAT, S_IRWXU | S_IRWXG | S_IRWXO);
//
//    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
//
//    dispatch_io_t pipe_chanel = dispatch_io_create_with_path(DISPATCH_IO_STREAM,[filePath UTF8String], O_RDWR, 0,queue , ^(int error) {
//        close(fd);
//    });
    
//    dispatch_io_write( dispatch_io_t channel, off_t offset, dispatch_data_t data, dispatch_queue_t queue, dispatch_io_handler_t io_handler);
//    size_t water = 1024;
//    dispatch_io_set_low_water(pipe_chanel, water);
//    dispatch_io_set_high_water(pipe_chanel, water);
    
    
//    const char *daxiao;
//    daxiao = [string UTF8String];
//    size_t size = strlen(daxiao);
//
//    dispatch_data_t dataT = dispatch_data_create(daxiao, size, queue, NULL);
//
//    dispatch_io_write(pipe_chanel, 0, dataT, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
//
//        NSLog(@"error = %d",error);
//    });
    
//    NSMutableData *totalData = [[NSMutableData alloc] init];
//    dispatch_io_read(pipe_chanel, 0, SIZE_MAX, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
//        if (error == 0) {
//            size_t len = dispatch_data_get_size(data);
//            if (len > 0) {
//                [totalData appendData:(NSData *)data];
//            }
//        }
//        if (done) {
//            NSString *str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", str);
//        }
//    });
    

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"text"];
//    dispatch_queue_t queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
//    dispatch_io_t pipe_chanel = dispatch_io_create_with_path(DISPATCH_IO_STREAM,[path UTF8String], 0, 0,queue , ^(int error) {
//
//    });
//    size_t water = 1024;
//    dispatch_io_set_low_water(pipe_chanel, water);
//    dispatch_io_set_high_water(pipe_chanel, water);
//    NSMutableData *totalData = [[NSMutableData alloc] init];
//    dispatch_io_read(pipe_chanel, 0, SIZE_MAX, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
//        if (error == 0) {
//            size_t len = dispatch_data_get_size(data);
//            if (len > 0) {
//                [totalData appendData:(NSData *)data];
//            }
//        }
//        if (done) {
//            NSString *str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@", str);
//        }
//    });


//    //文件路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"text"];
//    //队列创建
//    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
//    //创建文件描述
//    dispatch_fd_t fd = open(path.UTF8String, O_RDONLY);
//    //创建一个调度I / O通道
//    dispatch_io_t io = dispatch_io_create(DISPATCH_IO_RANDOM, fd, queue, ^(int error) {
//        close(fd);
//    });
//    //目标文件的大小
//    long long fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
//    //已读取文件大小
//    off_t currentSize = 0;
//    //每次文件读取的大小
//    size_t offset = 1024*1024;
//    //创建分组
//    dispatch_group_t group = dispatch_group_create();
//    //创建可变data，用于存放读取的文件
//    NSMutableData *totalData = [[NSMutableData alloc] initWithLength:fileSize];
//    //一次一次的读取文件，之至目标文件读取完
//    for (; currentSize <= fileSize ; currentSize += offset) {
//        //队列添加到分组中
//        dispatch_group_enter(group);
//        //在队列中从指定点开始，读取一定的内容的文件
//        dispatch_io_read(io, currentSize, offset, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
//
//            if (error == 0) {//没有错误
//                //读取内容的长度
//                size_t len = dispatch_data_get_size(data);
//
//                if (len > 0) {//如果有内容
//
//                    const void *bytes = NULL;
//                    //内容转化为bytes
//                    (void)dispatch_data_create_map(data, (const void **)&bytes, &len);
//                    //data拼接bytes
//                    [totalData replaceBytesInRange:NSMakeRange(currentSize, len) withBytes:bytes length:len];
//                }
//            }
//            if (done) {//每次读取内容完成后调用
//                dispatch_group_leave(group);
//            }
//        });
//    }
//    //目标文件读取完成之后调用
//    dispatch_group_notify(group, queue, ^{
//
//        NSString *str = [[NSString alloc] initWithData:totalData encoding:NSUTF8StringEncoding];
//
//        NSLog(@"%@", str);
//
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
