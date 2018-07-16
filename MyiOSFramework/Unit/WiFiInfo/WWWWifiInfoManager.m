//
//  hvGateway.m
//  appMaker
//
//  Created by leo on 13-11-11.
//  Copyright (c) 2013年 heimavista.com. All rights reserved.
//

#import "WWWWifiInfoManager.h"
#import "getgateway.h"

#import <sys/socket.h>
#import <net/if.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#include <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/CaptiveNetwork.h>



@interface WWWWifiInfoManager () {
    NSTimer *_timer;
}

@property (nonatomic,assign) long long int lastBytes;
@property (nonatomic,assign) BOOL isFirstRate;

@end

@implementation WWWWifiInfoManager

@synthesize wifiBroadcastAddress = _wifiBroadcastAddress;
@synthesize wifiGateWay = _wifiGateWay;
@synthesize wifiInterface = _wifiInterface;
@synthesize wifiIP = _wifiIP;
@synthesize wifiNetMast = _wifiNetMast;
@synthesize wifiSSID = _wifiSSID;

- (NSDictionary *) getWifiInformation
{
	NSMutableDictionary * wifiInformation = [[NSMutableDictionary alloc] init];
	_wifiGateWay = [NSString stringWithFormat:@"%@",[self defaultGateWay]];
	
	if (_wifiGateWay == nil) {
		_wifiGateWay = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiBroadcastAddress == nil) {
		_wifiBroadcastAddress = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiIP == nil) {
		_wifiIP = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiInterface == nil) {
		_wifiInterface = [NSString stringWithFormat:@"%@",@""];
	}
	if (_wifiNetMast == nil) {
		_wifiNetMast = [NSString stringWithFormat:@"%@",@""];
	}
    if (_wifiSSID == nil) {
        _wifiSSID = [self getCurreWiFiSsid];
    }
    
	[wifiInformation setObject:_wifiBroadcastAddress forKey:WifiBroadcastAddress];
	[wifiInformation setObject:_wifiInterface forKey:WifiInterface];
	[wifiInformation setObject:_wifiIP forKey:WifiIP];
	[wifiInformation setObject:_wifiGateWay forKey:WifiGateWay];
	[wifiInformation setObject:_wifiNetMast forKey:WifiNetMast];
    [wifiInformation setObject:_wifiSSID forKey:WifiSSID];
    
	return wifiInformation;
}

- (void)setIsRealtimeNetCardMonitoring:(BOOL)isRealtimeNetCardMonitoring {
    _isRealtimeNetCardMonitoring = isRealtimeNetCardMonitoring;
    if (_isRealtimeNetCardMonitoring) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getByteRate) userInfo:nil repeats:YES];
        
        [_timer fireDate];
    } else {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}
#pragma mark - 
#pragma makr - wifi methods
- (NSString *) defaultGateWay
{
	NSString * vlcGateWay;
	NSString* routerIP= [self routerIp];
	NSLog(@"local device ip address----%@",routerIP);
	
	
	in_addr_t i =inet_addr([routerIP cStringUsingEncoding:NSUTF8StringEncoding]);
	in_addr_t* x =&i;
	char * r= getdefaultgateway(x);
	
	//char*转换为NSString
	vlcGateWay = [[NSString alloc] initWithFormat:@"%s",r];
	NSLog(@"gateway: %@",vlcGateWay);
	return vlcGateWay;
}

//获取WiFi名称
- (nullable NSString *)getCurreWiFiSsid {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSLog(@"%@ => %@", ifnam, info);
        if (info && [info count]) { break; }
    }
    return [(NSDictionary*)info objectForKey:@"SSID"];
}

//返回广播地址，利用广播地址获取网关
- (NSString *) routerIp {
	
	NSString *address = @"error";
	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	int success = 0;
	
	// retrieve the current interfaces - returns 0 on success
	success = getifaddrs(&interfaces);
	if (success == 0)
	{
		// Loop through linked list of interfaces
		temp_addr = interfaces;
		while(temp_addr != NULL)
		{
			if(temp_addr->ifa_addr->sa_family == AF_INET)
			{
				// Check if interface is en0 which is the wifi connection on the iPhone
				if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
				{
					// Get NSString from C String //ifa_addr
					//ifa->ifa_dstaddr is the broadcast address, which explains the "255's"
					//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
					
					address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					
					//routerIP----192.168.1.255 广播地址
					NSLog(@"broadcast address--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)]);
					_wifiBroadcastAddress = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_dstaddr)->sin_addr)];
					
					//--192.168.1.106 本机地址
					NSLog(@"local device ip--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]);
					_wifiIP = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
					
					//--255.255.255.0 子网掩码地址
					NSLog(@"netmask--%@",[NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)]);
					_wifiNetMast = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_netmask)->sin_addr)];
					
					//--en0 端口地址
					NSLog(@"interface--%@",[NSString stringWithUTF8String:temp_addr->ifa_name]);
					_wifiInterface = [NSString stringWithUTF8String:temp_addr->ifa_name];
				}
			}
			
			temp_addr = temp_addr->ifa_next;
		}
	}
	
	// Free memory
	freeifaddrs(interfaces);
	
	return address;
}


//获取下行速度

- (void)getByteRate {
    
    long long int rate = 0;
    
    long long int currentBytes = [self getInterfaceBytes];
    
    if(self.lastBytes) {
        
        //用上当前的下行总流量减去上一秒的下行流量达到下行速录
        
        rate = currentBytes - self.lastBytes;
        
    }else{
        
        self.isFirstRate=NO;
    }
    //保存上一秒的下行总流量
    self.lastBytes= [self getInterfaceBytes];
    
    //格式化一下
    NSString *rateStr = [self formatNetWork:rate];
    
    NSLog(@"当前网速%@",rateStr);
    if (_delegate && [_delegate respondsToSelector:@selector(realtimeNetCardMonitoringInternetRate:)]) {
        [_delegate realtimeNetCardMonitoringInternetRate:rateStr];
    }
}

//获取数据流量详情

- (long long int)getInterfaceBytes {
    
    struct ifaddrs *ifa_list =0, *ifa;
    
    if(getifaddrs(&ifa_list) == -1) {
        
        return 0;
    }
    
    uint32_t iBytes =0;//下行
    
    uint32_t oBytes =0;//上行
    
    for(ifa = ifa_list; ifa; ifa = ifa->ifa_next) {
        
        if(AF_LINK!= ifa->ifa_addr->sa_family)
            
            continue;
        
        if(!(ifa->ifa_flags & IFF_UP) && !(ifa->ifa_flags & IFF_RUNNING))
            
            continue;
        
        if(ifa->ifa_data==0)
            
            continue;
        
        if(strncmp(ifa->ifa_name,"lo",2)) {
            
            struct if_data *if_data = (struct if_data*)ifa->ifa_data;
            
            iBytes += if_data->ifi_ibytes;
            
            oBytes += if_data->ifi_obytes;
        }
    }
    
    freeifaddrs(ifa_list);
    //返回下行的总流量
    return iBytes;//return iBytes + oBytes;计算总流量
}


//格式化方法
- (NSString*)formatNetWork:(long long int)rate {
    
    if(rate <1024) {
        
        return[NSString stringWithFormat:@"%lldB/秒", rate];
        
    }else if(rate >=1024&& rate <1024*1024) {
        
        return[NSString stringWithFormat:@"%.1fKB/秒", (double)rate /1024];
        
    }else if(rate >=1024*1024&& rate <1024*1024*1024){
        
        return[NSString stringWithFormat:@"%.2fMB/秒", (double)rate / (1024*1024)];
        
    }else{
        return@"10Kb/秒";
    };
}

//取消监控
- (void)dealloc {
    
    [self setIsRealtimeNetCardMonitoring:NO];
}



@end
