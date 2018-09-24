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
- (NSString *)age {
//    return objc_getAssociatedObject(self, ageKey);
    return objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(temp));
}
- (void)setAge:(NSString *)age {
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
 
 该函数先根据 self 对象地址在 AssociationsHashMap 中查找其对应的 ObjectAssociationMap 对象，如果能找到则进一步根据 key 在 ObjectAssociationMap 对象中查找这个 key 所对应的关联结构 ObjcAssociation ，如果能找到对应的关联结构 ObjcAssociation, 则返回 ObjcAssociation 对象的 value 值，否则返回 nil. 也就是说也就是在和 self 建立了关联引用的所有对象中通过 key 找到某一个特定的对象，如果有返回该对象的 value，否则，返回 nil;
 
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
 
 https://blog.csdn.net/justinjing0612/article/details/46803027
 https://www.jianshu.com/p/51921bdd2239
 */



@end
