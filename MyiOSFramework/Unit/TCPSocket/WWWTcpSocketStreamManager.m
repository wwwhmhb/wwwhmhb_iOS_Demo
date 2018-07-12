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
    
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)_gateWayId, _port, &readStream, &writeStream);
    NSLog(@"_gateWayId = %@",_gateWayId);
    _inputStream = (__bridge_transfer NSInputStream *)readStream;
    _outputStream = (__bridge_transfer NSOutputStream
                     *)writeStream;
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                            forMode:NSDefaultRunLoopMode];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                             forMode:NSDefaultRunLoopMode];
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
                while([_inputStream hasBytesAvailable])
                {
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
                //输出
                UInt8 buff[1024];
                memcpy(buff, [_contentString cStringUsingEncoding:NSASCIIStringEncoding], 2*[_contentString length]);
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
