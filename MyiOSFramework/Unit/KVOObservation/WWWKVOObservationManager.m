//
//  WWWKVOObservationManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/20.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWKVOObservationManager.h"

typedef void(^KVOObservationManagerResultBlock)(NSDictionary *dict);

@interface WWWKVOObservationManager () {
    NSMutableDictionary * _observerInfoDict;
}

@property (nonatomic,copy) void(^resultBlock)(NSDictionary *);

@end

@implementation WWWKVOObservationManager

//初始化创建可变字典
- (instancetype)init {
    self = [super init];
    if (self) {
        _observerInfoDict = [NSMutableDictionary dictionary];
    }
    return self;
}
//反初始化，清空所有的监听
- (void)dealloc {
    NSLog(@"WWWKVOObservationManager_delloc");
    [self removeAllKVOManagerObserver];
}

//添加kvo监听
- (void)addObserveObject:(id)observerObject andKeyPath:(NSString *)keyPath andContext:(NSString *)context andResultBlock:(void(^)(NSDictionary *dict))resultBlock {
    
    if (!context) {//如果没有上下文，需要进行合成
        //将对象的类名转化为字符串
        NSString *classStr = [NSString stringWithUTF8String:object_getClassName(observerObject)];
        context = [NSString stringWithFormat:@"%@_%@",classStr,keyPath];
    }
    
    //将该监听的信息保存到字典中
    NSDictionary *dict = @{
                           @"object" : observerObject,
                           @"keyPath" : keyPath,
                           @"block" : resultBlock
                           };
    [_observerInfoDict setValue:dict forKey:context];
    
    //添加监听
    [observerObject addObserver:self
             forKeyPath:keyPath
                options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                        context:(__bridge void *)(context)];
    
}

//观察者接受器,如果被观察者的属性通过 setter 发生变化,就会自动调用该方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //根据上下文合成key值
    id objectContext = (__bridge id)context;
    NSString *contextKey = [NSString stringWithFormat:@"%@",objectContext];
    //根据key取出监听的信息
    NSDictionary *dict = (NSDictionary *)_observerInfoDict[contextKey];
    id dictObject = dict[@"object"];
    NSString *dictKeyPath = (NSString *)dict[@"keyPath"];
    KVOObservationManagerResultBlock dictResultBlock = (KVOObservationManagerResultBlock)dict[@"block"];
    
    //监听结果回调
    if (dictObject == object && [dictKeyPath isEqualToString:keyPath]) {
        //必须对触发回调函数的来源进行判断
        dictResultBlock(change);
    }
    
//     else {//判断父类是否添加了响应的相应的观察方法
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//
//    }
}

//移除所有的监听
- (void)removeAllKVOManagerObserver {
    //监听移除
    for (NSString *key in _observerInfoDict) {
        NSDictionary *dict = _observerInfoDict[key];
        id dictObject = dict[@"object"];
        NSString *dictKeyPath = (NSString *)dict[@"keyPath"];
        [dictObject removeObserver:self forKeyPath:dictKeyPath];
    }
    //字典清空
    [_observerInfoDict removeAllObjects];
}

//移除指定的监听
- (void)removeKVOManagerObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    
    [self removeObserver:observer forKeyPath:keyPath context:nil];
}

//移除带有context的指定的监听
- (void)removeKVOManagerObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(NSString *)context {
    /*
     当对同一个keypath进行两次removeObserver时会导致程序crash
     我们可以分别在父类以及本类中定义各自的context字符串，比如在本类中定义context为@"Multi_lineTextAlertView.hidden";然后在dealloc中remove observer时指定移除的自身添加的observer。这样iOS就能知道移除的是自己的kvo，而不是父类中的kvo，避免二次remove造成crash。
     */
    
    //目标key值
    NSString *targetKey = nil;
    //移除指定监听
    for (NSString *key in _observerInfoDict) {
        NSDictionary *dict = _observerInfoDict[key];
        id dictObject = dict[@"object"];
        NSString *dictKeyPath = (NSString *)dict[@"keyPath"];
        if (dictObject == observer && [dictKeyPath isEqualToString:keyPath]) {
            //必须对触发回调函数的来源进行判断
            targetKey = key;
            if (context && ![context isEqualToString:@""]) {
                [dictObject removeObserver:self forKeyPath:dictKeyPath context:(__bridge void *)(context)];
            } else {
                [dictObject removeObserver:self forKeyPath:dictKeyPath];
            }
            break;
        }
    }
    
    //字典移除相应的键值对
    if (!targetKey) {
        [_observerInfoDict removeObjectForKey:targetKey];
    }
}

@end
