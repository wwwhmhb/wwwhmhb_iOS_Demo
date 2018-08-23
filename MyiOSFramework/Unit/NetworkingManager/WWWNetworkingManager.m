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
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];// 设置接收数据为 JSON 数据
    self.requestSerializer = [AFJSONRequestSerializer serializer];// 设置请求数据为 JSON 数据
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/json",@"text/plain",nil];
    
    [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.timeoutInterval = 45.f;
    [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    self.requestSerializer.HTTPShouldHandleCookies = YES;
    
    //根据项目需要添加
    [self setHTTPHeaderValue:@"YOYO" forField:@"Robot-Role"];
}

//设置请求头
- (void)setHTTPHeaderValue:(NSString *)value forField:(NSString *)field {
    
    [self.requestSerializer setValue:value forHTTPHeaderField:field];
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
                NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
                [self showErrorContent:error withURL:urlString];
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

//上传视频
- (void)uploadVideoToUrlStr:(NSString*)urlStr andVideoPath:(NSString*)videoPath andParameters:(NSDictionary*)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    //文件类型参数
    if (!extDict) {
        extDict = @{
                    @"name" : @"video",
                    @"fileName" : videoPath.lastPathComponent,
                    @"mimeType" : [NSString stringWithFormat:@"video/%@",videoPath.pathExtension]
                    };
    }
    
    //视频数据
    NSData *videoData = [NSData dataWithContentsOfFile:videoPath];
    
    //上传视频数据
    [self uploadFileToUrlStr:urlStr andFileData:videoData andParameters:parameters andExtDict:extDict andProgress:progressBlock andFinishBlock:finishBlock];
}

//上传单张图片
- (void)uploadImageToUrlStr:(NSString*)urlStr andImage:(UIImage*)image andParameters:(NSDictionary*)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    
    NSArray *imageArray = @[image];
    [self uploadImageArrayToUrlStr:urlStr andImageArray:imageArray andParameters:parameters andExtDict:extDict andProgress:progressBlock andFinishBlock:finishBlock];
}

//上传图片数组
- (void)uploadImageArrayToUrlStr:(NSString*)urlStr andImageArray:(NSArray*)imageArray  andParameters:(NSDictionary*)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    //文件类型参数
    if (!extDict) {
        extDict = @{
                    @"name" : @"image",
                    @"fileName" : @"myImage.png",
                    @"mimeType" : @"image/png"
                    };
    }
    NSString *name = extDict[@"name"];
    NSString *fileName = extDict[@"fileName"];
    NSString *mimeType = extDict[@"mimeType"];
    NSString *imageExtension = [fileName pathExtension];
    NSString *deletingImageExtension = [fileName stringByDeletingPathExtension];
    
    //合并上传参数
    parameters = [self resetDictionary:parameters];
    
    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (int i = 0; i < imageArray.count; i++) {
            NSString *type = [NSString stringWithFormat:@"%@%d",name,i];
            NSString *imageName = [NSString stringWithFormat:@"%@%d",deletingImageExtension,i];
            
            UIImage *image = [imageArray objectAtIndex:i];
            NSData *imageData;
            if ([imageExtension isEqualToString:@"png"]) {
                imageData = UIImagePNGRepresentation(image);//png
            } else {
                imageData = UIImageJPEGRepresentation(image, 0.8);//jpeg,其他格式
            }
            //拼接数据
            [formData appendPartWithFileData:imageData name:type fileName:imageName mimeType:mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        finishBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
        [self showErrorContent:error withURL:urlStr];
        finishBlock(nil,error);
    }];
}

//上传文件
- (void)uploadFileToUrlStr:(NSString *)urlStr andFilePath:(NSString *)filePath andParameters:(NSDictionary *)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    
    //文件数据
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    //上传数据
    [self uploadFileToUrlStr:urlStr andFileData:fileData andParameters:parameters andExtDict:extDict andProgress:progressBlock andFinishBlock:finishBlock];
}

//上传文件基础api
- (void)uploadFileToUrlStr:(NSString *)urlStr andFileData:(NSData *)fileData andParameters:(NSDictionary *)parameters andExtDict:(NSDictionary *)extDict andProgress:(void (^)(NSProgress *uploadProgress))progressBlock andFinishBlock:(void (^)(id responseObject , NSError *error))finishBlock {
    
    //文件数据参数
    if (!extDict) {
        extDict = @{
                    @"name" : @"file",
                    @"fileName" : @"myFile.zip",
                    @"mimeType" : @"file/zip"
                    };
    }
    NSString *name = extDict[@"name"];
    NSString *fileName = extDict[@"fileName"];
    NSString *mimeType = extDict[@"mimeType"];
    
    //合并上传参数
    parameters = [self resetDictionary:parameters];
    
    //上传文件数据
    [self POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progressBlock) {
            progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        finishBlock(responseObject,nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSLog(@"responses.statusCode = %ld",(long)responses.statusCode);
        [self showErrorContent:error withURL:urlStr];
        finishBlock(nil,error);
    }];
}

//文件下载
- (void)downloadFileFromUrlStr:(NSString *)urlStr toFilePath:(NSString *)filePath andProgress:(void (^)(NSProgress *downloadProgress))progressBlock andFinishBlock:(void (^)(NSURLResponse *responseObject , NSError *error))finishBlock {
    //下载url地址
    NSURL *url = [NSURL URLWithString:urlStr];
    //请求头
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //创建下载任务
    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progressBlock) {
            progressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /*
         服务器的文件名:[response suggestedFilename]
         */
        /* 设定下载到的位置 */
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (finishBlock) {
            finishBlock(response,error);
        }
    }];
    
    //开始请求下载
    [downloadTask resume];
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
