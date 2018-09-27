//
//  WWWTestObject+TestAddProperty.m
//  MyiOSFramework
//
//  Created by mac on 2018/9/12.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWTestObject+TestAddProperty.h"
#import <objc/runtime.h>

static const void *ageKey = &ageKey;

@implementation WWWTestObject (TestAddProperty)
NSString *temp;
- (void)test {
    //可以使用WWWTestObject中的属性方法,但是不能使用其实例变量 _name
    self.name = @"wwwhmhb";
    //公开的实例变量
    _sex = @"man";
}

//将 age 属性关联到对象上,其 key 值为 ageKey
- (NSString *)testString {
//    return objc_getAssociatedObject(self, ageKey);
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(temp));
}
- (void)setTestString:(NSString *)age {
//    objc_setAssociatedObject(self, ageKey, age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(temp), age, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIButton *)button {
    UIButton *button = objc_getAssociatedObject(self, @selector(button));
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor redColor];
        [button setTitle:@"categoryAddProperty" forState:UIControlStateNormal];
        objc_setAssociatedObject(self, @selector(button), button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return button;
}
- (void)setButton:(UIButton *)button {
    objc_setAssociatedObject(self, @selector(button), button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)testNumber {
    NSString *number = objc_getAssociatedObject(self, _cmd);
    return number;
}
- (void)setTestNumber:(NSString *)testNumber {
    objc_setAssociatedObject(self, @selector(testNumber), testNumber, OBJC_ASSOCIATION_ASSIGN);
}

/*
 * Returns the value associated with a given object for a given key.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 *
 * @return The value associated with the key \e key for \e object.
 *
 * @see objc_setAssociatedObject
 
 函数 objc_getAssociatedObject :
 OBJC_EXPORT id _Nullable
 objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)
 OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0, 2.0);
 
 该函数 用于获取关联对象。
 先根据 self 对象地址在 AssociationsHashMap 中查找其对应的 ObjectAssociationMap 对象，如果能找到则进一步根据 key 在 ObjectAssociationMap 对象中查找这个 key 所对应的关联结构 ObjcAssociation ，如果能找到对应的关联结构 ObjcAssociation, 则返回 ObjcAssociation 对象的 value 值，否则返回 nil。也就是说也就是在和 self 建立了关联引用的所有对象中通过 key 找到某一个特定的对象，如果有返回该对象的 value，否则，返回 nil;
 
 objc_getAssociatedObject有两个参数，第一个参数为从该 object 中获取关联对象，第二个参数为想要获取关联对象的key;
 对于第二个参数const void *key,有以下四种推荐的key值：
 声明 static char kAssociatedObjectKey; ，使用 &kAssociatedObjectKey 作为 key 值;
 声明 static void *kAssociatedObjectKey = &kAssociatedObjectKey;，使用 kAssociatedObjectKey 作为key值；
 用 selector ，使用 getter 方法的名称作为key值；
 而使用 _cmd 可以直接使用该 @selector 的名称，即 button，并且能保证改名称不重复。(与上一种方法相同)
 */



/**
 * Sets an associated value for a given object using a given key and association policy.
 *
 * @param object The source object for the association.
 * @param key The key for the association.
 * @param value The value to associate with the key key for object. Pass nil to clear an existing association.
 * @param policy The policy for the association. For possible values, see “Associative Object Behaviors.”
 *
 * @see objc_setAssociatedObject
 * @see objc_removeAssociatedObjects
 
 OBJC_EXPORT void
 objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
 id _Nullable value, objc_AssociationPolicy policy)
 OBJC_AVAILABLE(10.6, 3.1, 9.0, 1.0, 2.0);
 
 该函数用于给对象添加关联对象，传入 nil 则可以移除已有的关联对象。
 
 将对象 value 赋值到 object 对象地址中 AssociationsHashMap 中的 ObjectAssociationMap 对应的 key 值中，policy 为对象的关联策略，等同于给property添加关键字。
 
 参数说明：
 object和key同于objc_getAssociatedObject;
 value：需要和object建立关联引用对象的value；
 policy：关联策略，等同于给property添加关键字，具体说明如下表关联策略
 关联策略
 
 |关联策略 |等价属性|说明|
 |------|------|------|
 |OBJC_ASSOCIATION_ASSIGN| @property (assign) or @property (unsafe_unretained)| 弱引用关联对象|
 |OBJC_ASSOCIATION_RETAIN_NONATOMIC| @property (strong, nonatomic)| 强引用关联对象，且为非原子操作|
 |OBJC_ASSOCIATION_COPY_NONATOMIC| @property (copy, nonatomic)| 复制关联对象，且为非原子操作|
 |OBJC_ASSOCIATION_RETAIN| @property (strong, atomic)| 强引用关联对象，且为原子操作|
 |OBJC_ASSOCIATION_COPY| @property (copy, atomic)| 复制关联对象，且为原子操作|

 https://blog.csdn.net/justinjing0612/article/details/46803027
 */


/**
 objc_removeAssociatedObjects: 用于移除一个对象的所有关联对象
 注：objc_removeAssociatedObjects 函数我们一般是用不上的，因为这个函数会移除一个对象的所有关联对象，将该对象恢复成“原始”状态。这样做就很有可能把别人添加的关联对象也一并移除，这并不是我们所希望的。所以一般的做法是通过给 objc_setAssociatedObject 函数传入 nil 来移除某个已有的关联对象。
 */


@end
