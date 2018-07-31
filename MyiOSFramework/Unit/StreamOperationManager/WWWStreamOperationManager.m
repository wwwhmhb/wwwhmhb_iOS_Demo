//
//  WWWStreamOperationManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/30.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWStreamOperationManager.h"

@interface WWWStreamOperationManager () <NSStreamDelegate> {
    NSString *_gateWayId;
    int _port;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    NSString *_contentString;
}

@end

@implementation WWWStreamOperationManager

//初始化
- (instancetype)initWithGateWayId:(NSString *)gateWayId andPort:(int)port {
    self = [super init];
    if (self) {
        _port = port;
        _gateWayId = gateWayId;
        [self initTcpSocketManager];
    }
    return self;
}

//开始通讯
- (void)startTcpSocketWithSendMessage:(NSString *)contentString {
    //发送信息内容
    _contentString = contentString;
    
    //打开流
    [_inputStream open];
    [_outputStream open];
}

//初始化管理者
- (void)initTcpSocketManager {
    
    /*
     在iOS中，NSStream类不支持连接到远程主机，幸运的是CFStream支持。前面已经说过这两者可以通过toll-free桥接来相互转换。使用CFStream时，我们可以调用CFStreamCreatePairWithSocketToHost函数并传递主机名和端口号，来获取一个CFReadStreamRef和一个CFWriteStreamRef来进行通信，然后我们可以将它们转换为NSInputStream和NSOutputStream对象来处理。
     */
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_gateWayId, _port, &readStream, &writeStream);
    
    /*
     Cocoa中的流对象与Core Foundation中的流对象是对应的。我们可以通过toll-free桥接方法来进行相互转换。NSStream、NSInputStream和NSOutputStream分别对应CFStream、CFReadStream和CFWriteStream。但这两者间不是完全一样的，Core Foundation一般使用回调函数来处理数据；另外我们可以子类化NSStream、NSInputStream和NSOutputStream，来自定义一些属性和行为，而Core Foundation中的流对象则无法进行扩展。
     */
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream
                     *)writeStream;
    
    //添加代理进行监听回调
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    //加入runloop中
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                             forMode:NSDefaultRunLoopMode];
}

//关闭通讯
-(void)closeTcpSocket {
    [self close];
}

//关闭管理者
-(void)close
{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

#pragma mark -- NSStreamDelegate 代理
-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
    switch (streamEvent) {
        case NSStreamEventNone:
        {
            
        }
            break;
        case NSStreamEventOpenCompleted:
        {
            
        }
            break;
        case NSStreamEventHasBytesAvailable:
        {
            if (theStream == _inputStream) {
                //初始化data和buffer
                NSMutableData *input = [[NSMutableData alloc] init];
                uint8_t buffer[1024];
                NSInteger len;
                
                //检查流中是否还有数据。
                BOOL isAvailable = [_inputStream hasBytesAvailable];
                while(isAvailable) {
                    //从流中读取数据到 buffer 中，buffer 的 maxLength 不应少于 1024，该接口返回实际读取的数据长度（该长度最大为 len）。
                    len = [_inputStream read:buffer maxLength:1024];
                    if (len > 0)
                    {
                        //将buffer中数据合并到data中
                        [input appendBytes:buffer length:len];
                    }
                }
                
                //将data转化为NSString
                NSString *resultstring = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
                //代理传递信息
                if (resultstring && _delegate && [_delegate respondsToSelector:@selector(receiveFromTcpSocketMessage:andError:)]) {
                    [_delegate receiveFromTcpSocketMessage:resultstring  andError:nil];
                }
            }
        }
            break;
        case NSStreamEventHasSpaceAvailable:
        {
            if (theStream == _outputStream) {
                // hasSpaceAvailable 检查流中是否还有可供写入的空间
                //初始化buff
                UInt8 buff[1024];
                //开辟一个buff空间
                memcpy(buff, [_contentString cStringUsingEncoding:NSASCIIStringEncoding], 2*[_contentString length]);
                
                //检查流中是否还有空间可写入。
                BOOL isAvailable = [_outputStream hasSpaceAvailable];
                if (isAvailable) {
                    //将 buffer 中的数据写入流中，返回实际写入的字节数。
                    [_outputStream write:buff maxLength:1024];
                }
                
                //必须关闭输出流,否则服务器端一直读取不会停止，
                [_outputStream close];
            }
        }
            break;
        case NSStreamEventErrorOccurred:
        {
            NSError *error = [theStream streamError];
            if (error) {
                if (_delegate && [_delegate respondsToSelector:@selector(receiveFromTcpSocketMessage:andError:)]) {
                    [_delegate receiveFromTcpSocketMessage:nil andError:error];
                }
            }
            [self closeTcpSocket];
        }
            break;
        case NSStreamEventEndEncountered:
        {
            [self closeTcpSocket];
        }
            break;
    }
}

@end
