//
//  hvGateway.h
//  appMaker
//
//  Created by leo on 13-11-11.
//  Copyright (c) 2013年 heimavista.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define WifiGateWay						@"gateway"
#define WifiIP						    @"ip"
#define WifiBroadcastAddress			@"broadcast"
#define WifiNetMast						@"netmast"
#define WifiInterface					@"interface"
#define WifiSSID                        @"SSID"

@protocol YORWifiInfoManagerDelegate <NSObject>
@optional
- (void)realtimeNetCardMonitoringInternetRate:(NSString *)internetRate;
@end

@interface WWWWifiInfoManager: NSObject
{
	NSString * _wifiGateWay; //网关
	NSString * _wifiIP;   //IP
	NSString * _wifiBroadcastAddress;   //广播地址
	NSString * _wifiNetMast;    //子网掩码
	NSString * _wifiInterface;  //en0端口
    NSString * _wifiSSID;       //wifi名称
}

@property (nonatomic,assign) BOOL isRealtimeNetCardMonitoring;//实时监听网关信息，主要是获取网速
@property (nonatomic,weak) id<YORWifiInfoManagerDelegate> delegate;
@property (nonatomic,copy,readonly) NSString * wifiGateWay;
@property (nonatomic,copy,readonly) NSString * wifiIP;
@property (nonatomic,copy,readonly) NSString * wifiBroadcastAddress;
@property (nonatomic,copy,readonly) NSString * wifiNetMast;
@property (nonatomic,copy,readonly) NSString * wifiInterface;
@property (nonatomic,copy,readonly) NSString * wifiSSID;

- (NSMutableDictionary *) getWifiInformation;

@end
