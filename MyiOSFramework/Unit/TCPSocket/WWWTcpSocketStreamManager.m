//
//  YORTcpSocketManager.m
//  YOYOMonitoring
//
//  Created by Yonggui Wang on 2018/7/4.
//  Copyright © 2018年 youerobot. All rights reserved.
//

#import "WWWTcpSocketStreamManager.h"

@interface WWWTcpSocketStreamManager () <NSStreamDelegate> {
    NSString *_gateWayId;
    int _port;
    NSInputStream *_inputStream;
    NSOutputStream *_outputStream;
    
}

@end

@implementation WWWTcpSocketStreamManager

- (instancetype)initWithGateWayId:(NSString *)gateWayId andPort:(int)port {
    self = [super init];
    if (self) {
        _port = port;
        _gateWayId = gateWayId;
    }
    return self;
}

- (void)startTcpSocket {
   [self initTcpSocketManager];
}

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
    
    //打开流
    [_inputStream open];
    [_outputStream open];
}

-(void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    NSString *event;
    int flag = 0;
    switch (streamEvent) {
        case NSStreamEventNone:
            event = @"NSStreamEventNone";
            break;
        case NSStreamEventOpenCompleted:
            event = @"NSStreamEventOpenCompleted";
            break;
        case NSStreamEventHasBytesAvailable:
            event = @"NSStreamEventHasBytesAvailable";
            if (flag ==0 && theStream == _inputStream) {
                NSMutableData *input = [[NSMutableData alloc] init];
                uint8_t buffer[1024];
                NSInteger len;
                // hasBytesAvailable 检查流中是否还有数据。
                while([_inputStream hasBytesAvailable])
                {
                    //从流中读取数据到 buffer 中，buffer 的 maxLength 不应少于 1024，该接口返回实际读取的数据长度（该长度最大为 len）。
                    len = [_inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        [input appendBytes:buffer length:len];
                    }
                }
                
                NSString *resultstring = [[NSString alloc] initWithData:input encoding:NSUTF8StringEncoding];
                [self close];
                if (resultstring && _delegate && [_delegate respondsToSelector:@selector(receiveFromTcpSocketMessage:andError:)]) {
                    [_delegate receiveFromTcpSocketMessage:resultstring  andError:nil];
                }
            }
            break;
        case NSStreamEventHasSpaceAvailable:
            event = @"NSStreamEventHasSpaceAvailable";
            if (flag ==0 && theStream == _outputStream) {
                
                // hasSpaceAvailable 检查流中是否还有可供写入的空间
                //输出
                UInt8 buff[1024];
                
                //开辟一个buff空间
                memcpy(buff, [_contentString cStringUsingEncoding:NSASCIIStringEncoding], 2*[_contentString length]);
                
                //将 buffer 中的数据写入流中，返回实际写入的字节数。
                [_outputStream write:buff maxLength: strlen((const char*)buff)];
                
                //必须关闭输出流否则，服务器端一直读取不会停止，
                [_outputStream close];
            }
            break;
        case NSStreamEventErrorOccurred:
            event = @"NSStreamEventErrorOccurred";
            [self close];
            if ([theStream streamError]) {
                NSError *error = [theStream streamError];
                if (error && _delegate && [_delegate respondsToSelector:@selector(receiveFromTcpSocketMessage:andError:)]) {
                    [_delegate receiveFromTcpSocketMessage:nil andError:error];
                }
            }
            
            break;
        case NSStreamEventEndEncountered:
            event = @"NSStreamEventEndEncountered";
            [self close];
            break;
        default:
            [self close];
            event = @"Unknown";
            break;
    }
    
    NSLog(@"event------%@",event);
}

-(void)closeTcpSocket {
    [self close];
}

-(void)close
{
    [_outputStream close];
    [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_outputStream setDelegate:nil];
    
    [_inputStream close];
    [_inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [_inputStream setDelegate:nil];
}

@end
