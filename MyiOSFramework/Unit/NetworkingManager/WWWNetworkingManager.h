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

//单例申明
singleton_interface(WWWNetworkingManager);


/**
 初始化网络请求信息
 */
- (void)initNetworkingManager;


//设置请求头



/**
 网络请求

 @param type 请求类型
 @param urlStr 请求url字符串
 @param parameters 请求参数
 @param finishBlock 请求结果回调block
 */
- (void)networkingRequestWithType:(RequestType)type andUrlStr:(NSString *)urlStr andParameters:(NSDictionary *)parameters andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock;


/**
 上传文件

 @param urlStr 文件上传地址
 @param filePath 文件来源路径
 @param parameters 上传参数
 @param extDict 文件类型参数
 @param progressBlock 上传速度回调block
 @param finishBlock 上传结果回调block
 */
- (void)uploadFileToUrlStr:(NSString *)urlStr andFilePath:(NSString *)filePath andParameters:(NSDictionary *)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock;




@end
