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

@property (nonatomic,copy) NSString *contentString;

- (instancetype)initWithGateWayId:(NSString *)gateWayId andPort:(int)port;
- (void)startTcpSocket;
-(void)closeTcpSocket;

@end
