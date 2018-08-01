//
//  WWWNetworkingManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/31.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestType)
{
    GET,
    POST,
    PUT,
    DELETE
};

@interface WWWNetworkingManager : AFHTTPSessionManager

@end
