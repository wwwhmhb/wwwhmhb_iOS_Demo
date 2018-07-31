//
//  WWWStreamOperationManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/30.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,StreamOperationType) {
    NoneType,
    FileType,
    DataType,
    SocketType,
    BufferType
};

@protocol WWWStreamOperationManagerDelegate <NSObject>

-(void)receiveFromTcpSocketMessage:(NSString *)message andError:(NSError *)error;

@end

@interface WWWStreamOperationManager : NSObject

@property (nonatomic,weak) id<WWWStreamOperationManagerDelegate> delegate;
////调用startTcpSocket时就会发送contentString
//@property (nonatomic,copy) NSString *contentString;

//初始化，通过网关和端口进行连接
- (instancetype)initWithGateWayId:(NSString *)gateWayId andPort:(int)port;
//开始发送或接受流信息
- (void)startTcpSocketWithSendMessage:(NSString *)contentString;
//关掉发送或接受流信息
-(void)closeTcpSocket;

@end
