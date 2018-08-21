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
#import "GCDAsyncSocket.h"
#import "WWWWifiInfoManager.h"

#include <stdio.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>

@interface WWWTestViewController () <GCDAsyncSocketDelegate> {
    dispatch_queue_t queue;
    NSString *toPath;
    WWWNetworkingManager *_networkingManager;
}

@property (nonatomic,strong) NSData *myData;
// 客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;
@property (assign, nonatomic) BOOL connected;

@end

@implementation WWWTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"TestViewController";
    
    
    
    WWWWifiInfoManager *wifiManager = [[WWWWifiInfoManager alloc]init];
    NSDictionary *wifiDic =  [wifiManager getWifiInformation];
    NSString *wifiName = wifiDic[WifiSSID];
    NSString *wifiGateway = wifiDic[WifiGateWay];
    if ([wifiName isEqualToString:@"YoYoRobot"]) {

    }
    
    _networkingManager = [WWWNetworkingManager shared];
    [_networkingManager initNetworkingManager];
    
//    struct sockaddr_in server_addr;
//    server_addr.sin_len = sizeof(struct sockaddr_in);
//    server_addr.sin_family = AF_INET;
//    server_addr.sin_port = htons(9054);
//    server_addr.sin_addr.s_addr = inet_addr([wifiGateway UTF8String]);
//    bzero(&(server_addr.sin_zero),8);
//
//    int server_socket = socket(AF_INET, SOCK_STREAM, 0);
//    if (server_socket == -1) {
//        perror("socket error");
//    }
//    char recv_msg[1024];
//    char reply_msg[1024];
//
//    if (connect(server_socket, (struct sockaddr *)&server_addr, sizeof(struct sockaddr_in))==0)  {
//        //connect 成功之后，其实系统将你创建的socket绑定到一个系统分配的端口上，且其为全相关，包含服务器端的信息，可以用来和服务器端进行通信。
//
//        perror("connect success");
//
////        while (1) {
////            bzero(recv_msg, 1024);
////            bzero(reply_msg, 1024);
////            long byte_num = recv(server_socket,recv_msg,1024,0);
////            recv_msg[byte_num] = '\0';
////            printf("server said:%s\n",recv_msg);
////
////            printf("reply:");
////            scanf("%s",reply_msg);
////            if (send(server_socket, reply_msg, 1024, 0) == -1) {
////                perror("send error");
////            }
////        }
//    }
    
    
    //创建socket并指定代理对象为self,代理队列必须为主队列.
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//    self.clientSocket.IPv4PreferredOverIPv6 = YES;
    NSError *error = nil;
    [self.clientSocket connectToHost:wifiGateway onPort:9054 error:&error];
    NSLog(@"error = %@",error);
    
//    NSString *documentPath = [WWWTools getDocumentPath];
//    toPath = [documentPath stringByAppendingPathComponent:@"Light.json"];
//    BOOL isExist = [WWWTools isFileExists:toPath];
//    if (!isExist) {
//        NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"Light" ofType:@"json"];
//        BOOL isCopy = [WWWTools copyFileFromPath:fromPath toPath:toPath isKeepOldFile:YES];
//        if (isCopy) {
//            NSLog(@"复制成功");
//        } else {
//            NSLog(@"复制失败");
//        }
//    }
    
    
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



- (void)testButtonAction:(UIButton *)button {


    // 全局并发队列的获取方法
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
//    const char *queueName = dispatch_queue_get_label(queue);
//    NSLog(@"queueName = %s",queueName);
    
    
//    NSData *contentData = [WWWTools readAllFilePath:toPath];
//
//    [WWWGCDReadWriteFile wrideFileWithContent:contentData toFilePath:toPath isCoverOlderFile:YES andFinishBlock:^(NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"error = %@",error);
//        } else {
//            NSLog(@"写入成功");
//        }
//    }];
////    [WWWTools addContent:contentData toPath:toPath];
//    NSData *data = [WWWTools readAllFilePath:toPath];
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"string = %@",string);
    
    NSDictionary *dict = @{
                           @"robot_id" : @"201807061138"
                           };
    [_networkingManager networkingRequestWithType:POST andUrlStr:@"http://yoby-dispatch.test.youerobot.com/business/get_friends/" andParameters:dict andFinishBlock:^(id responseObject, NSError *error) {
        NSLog(@"responseObject= %@",responseObject);
    }];
    
    
//    NSDictionary *dict = @{
//                           @"robot_ids" : @[@"201807061138", @"cc:b8:a8:36:f9:fa"],
//                           @"operation" : @"add",
//                           @"friends_info" : @"xxxxxxxxxxxxx"
//                           };
//    [_networkingManager networkingRequestWithType:POST andUrlStr:@"http://yoby-dispatch.test.youerobot.com/business/update_friends/" andParameters:dict andFinishBlock:^(id responseObject, NSError *error) {
//        NSLog(@"responseObject= %@",responseObject);
//    }];
    
}

#pragma mark -- GCDAsyncSocketDelegate代理方法
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"err = %@",err);
}

//成功连接主机对应端口号.
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"%@",[NSString stringWithFormat:@"链接成功,服务器IP: %@-------端口: %d", host,port]);
    
    // 连接成功开启定时器
//    [self addTimer];
    // 连接后,可读取服务端的数据
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
    self.connected = YES;
}

//读取服务端数据
/**
 读取数据
 
 @param sock 客户端socket
 @param data 读取到的数据
 @param tag 本次读取的标记
 */
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *text = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"text = %@",text);
    
    // 读取到服务端数据值后,能再次读取
    [self.clientSocket readDataWithTimeout:- 1 tag:0];
}

//发送数据给服务端
// 发送数据
- (void)sendMessageAction
{
    if (self.connected) {
        NSDictionary *jsonDic = @{
                    @"state": @"bind",//状态 [connect:配网，bind:只绑定]
                    @"topic": @"mobile/af5dfafed01a492627b9b7b502fe62c12dce1fd6/yoyoSettingNetwork"
                    };
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&error];
        
        // withTimeout -1 : 无穷大,一直等
        // tag : 消息标记
        [self.clientSocket writeData:jsonData withTimeout:- 1 tag:0];
    } else {
        NSLog(@"socket 仍未连接");
    }
}


//@Override public void run() {
//    InetAddress inetAddress = null;
//    try {
//        mSocket = new Socket(serverUrl, serverPort);
//        in = mSocket.getInputStream();
//        out = mSocket.getOutputStream();
//        mHeartTime = System.currentTimeMillis();
//        Log.v(SOCKET_TAG, "client socket create successed");
//
//        // 轮询发送消息列表中的数据
//        while (true) {
//            if (mMsgQueue.size() > 0) {
//                // 判断是否要发送心跳包
//                if (Math.abs(mHeartTime - System.currentTimeMillis()) > HEART_TIME)
//                    sendHeart(new String(mMsgQueue.get(0).getBytes()));
//                Thread.sleep(SEND_TIME);
//            }
//            // 判断client socket 是否连接上Server
//            if (mSocket.isConnected()) {
//                Log.v(SOCKET_TAG, "### client socket connected ###");
//                // 发送数据
//                if (!mSocket.isOutputShutdown() && !isMsgQueueEmpty()) {
//                    out.write(mMsgQueue.get(0).getBytes());
//                    //                        // 将发送过的数据移除消息列表
//                    //                        mMsgQueue.remove(0);
//                    Log.i("socket2222222222", "连接上了！！！");
//                    mHeartTime = System.currentTimeMillis();
//                }
//            } else {
//                // 重建连接
//                Log.v(SOCKET_TAG, "client socket disconnected");
//                if (!mSocket.isClosed()) mSocket.close();
//                //                    inetAddress = InetAddress.getByName(serverUrl);
//                mSocket = new Socket(serverUrl, serverPort);
//            }
//        }
//    } catch (InterruptedException e) {
//        // TODO Auto-generated catch block
//        e.printStackTrace();
//        this.interrupt();
//        //   Log.v(SOCKET_TAG,e.getMessage());
//    } catch (UnknownHostException e) {
//        e.printStackTrace();
//        Log.v(SOCKET_TAG, e.getMessage());
//    } catch (IOException e) {
//        e.printStackTrace();
//        Log.v(SOCKET_TAG, e.getMessage());
//    } finally {
//        if (out != null)
//            try {
//                out.close();
//            } catch (IOException e2) {
//                // TODO Auto-generated catch block
//                e2.printStackTrace();
//            }
//        if (in != null) {
//            try {
//                in.close();
//            } catch (IOException e1) {
//                // TODO Auto-generated catch block
//                e1.printStackTrace();
//            }
//        }
//
//        if (mSocket != null) {
//            try {
//                mSocket.close();
//            } catch (IOException e) {
//                e.printStackTrace();
//                Log.v(SOCKET_TAG, e.getMessage());
//            }
//        }
//        Log.v(SOCKET_TAG, "client socket close");
//    }
//}

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
