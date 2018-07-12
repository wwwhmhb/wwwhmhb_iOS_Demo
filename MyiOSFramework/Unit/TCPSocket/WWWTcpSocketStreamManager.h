//
//  YORTcpSocketManager.h
//  YOYOMonitoring
//
//  Created by Yonggui Wang on 2018/7/4.
//  Copyright © 2018年 youerobot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YORTcpSocketManagerDelegate <NSObject>

-(void)receiveFromTcpSocketMessage:(NSString *)message andError:(NSError *)error;

@end

@interface WWWTcpSocketStreamManager : NSObject

@property (nonatomic,weak) id<YORTcpSocketManagerDelegate> delegate;
//调用startTcpSocket时就会发送contentString
@property (nonatomic,copy) NSString *contentString;
//初始化，通过网关和端口进行连接
- (instancetype)initWithGateWayId:(NSString *)gateWayId andPort:(int)port;
//开始发送或接受流信息
- (void)startTcpSocket;
//关掉发送或接受流信息
-(void)closeTcpSocket;

@end
