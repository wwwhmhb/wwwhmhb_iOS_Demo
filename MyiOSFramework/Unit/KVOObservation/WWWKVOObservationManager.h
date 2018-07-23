//
//  WWWKVOObservationManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/20.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWKVOObservationManager : NSObject


/**
 添加KVO监听，注意不能监听self本身，因为在移除监听的时候，导致内存泄漏

 @param observerObject 被监听者
 @param keyPath 监听属性的路径
 @param context 上下文
 @param resultBlock 监听结果回调
 */
- (void)addObserveObject:(id)observerObject andKeyPath:(NSString *)keyPath andContext:(NSString *)context andResultBlock:(void(^)(NSDictionary *dict))resultBlock;

- (void)removeAllKVOManagerObserver;
- (void)removeKVOManagerObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeKVOManagerObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(NSString *)context;
@end
