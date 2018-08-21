//
//  WWWNetworkingManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/31.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWNetworkingManager.h"

@implementation WWWNetworkingManager

//单例实现
singleton_implementation(WWWNetworkingManager)

//初始化网络请求信息
- (void)initNetworkingManager {
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",nil];
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 45.f;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.HTTPShouldHandleCookies = YES;
    [self.requestSerializer setValue:@"YOYO" forHTTPHeaderField:@"Robot-Role"];
}

//网络请求
- (void)networkingRequestWithType:(RequestType)type andUrlStr:(NSString *)urlStr andParameters:(NSDictionary *)parameters andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    
    parameters = [self resetDictionary:parameters];
    
    //配置URL地址????????
    NSString *urlString = [NSString stringWithFormat:@"%@",urlStr];
    if (![urlString hasPrefix:@"http"]) {
        //        urlString = [YB_HTTP stringByAppendingString:urlString];
    }
    
    switch (type) {
        case GET:
        {
            [self GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //成功回调
                finishBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //失败回调
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                [self showErrorContent:error withURL:urlString];
                NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
                finishBlock(nil,error);
            }];
        }
            break;
        case POST:
        {
            [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //成功回调
                finishBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //失败回调
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                [self showErrorContent:error withURL:urlString];
                NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
                finishBlock(nil,error);
            }];
        }
            break;
        case PUT:
        {
            [self PUT:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //成功回调
                finishBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //失败回调
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                [self showErrorContent:error withURL:urlString];
                NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
                finishBlock(nil,error);
            }];
        }
            break;
        case DELETE:
        {
            
            [self DELETE:urlString parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //成功回调
                finishBlock(responseObject,nil);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //失败回调
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                [self showErrorContent:error withURL:urlString];
                NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
                finishBlock(nil,error);
            }];
            
        }
    }
}

//上传文件
- (void)uploadFileToUrlStr:(NSString *)urlStr andFilePath:(NSString *)filePath andParameters:(NSDictionary *)parameters andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    
    NSString *fileName = parameters[@"file_name"];
    NSString *fileType = parameters[@"file_type"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    parameters = [self resetDictionary:parameters];
    
    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:fileType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finishBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        finishBlock(nil,error);
    }];
}


//网络请求参数扩展
- (NSDictionary*)resetDictionary:(NSDictionary*)dict{
    // 系统参数
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    // 软件版本号
    NSString *version = [NSString stringWithFormat:@"%@",[infoDict objectForKey:@"CFBundleShortVersionString"]];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
    mdict[@"app_version"] = version;
    
    return [mdict copy];
}

//展示网络请求错误
- (void)showErrorContent:(NSError *)error withURL:(NSString *)urlStr {
    
    NSData *data = [error userInfo][@"com.alamofire.serialization.response.error.data"];
    if (data) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"错误接口:%@,<<<<>>>错误error = %@,错误reason = %@",urlStr,error,jsonDict[@"reason"]);
    } else {
        NSLog(@"错误接口:%@,<<<<>>>错误error = %@",urlStr,error);
    }
}

@end
