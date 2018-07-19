//
//  UIButton+AddSelectorForClick.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/17.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "UIButton+AddSelectorForClick.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIButton (AddSelectorForClick)

SequentialOrder _sequentialOrder;
SelectorType _selectorType;

//为原有button的点击方法添加新的响应方法,原有方法即- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
- (void)addSelectorForClickActionSequentialOrder:(SequentialOrder)sequentialOrder andSelectorType:(SelectorType)selectorType {
    
    _sequentialOrder = sequentialOrder;
    _selectorType = selectorType;
    
    /* 运行时创建类 */
    //类名创建
    NSString *className = [NSString stringWithFormat:@"CameraPermission_%@",self.class];
    //类的创建
    Class kclass = objc_getClass([className UTF8String]);
    if (!kclass)
    {
        //为"class pair"分配空间
        kclass = objc_allocateClassPair([self class], [className UTF8String], 0);
    }
    //方法创建，- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
    SEL setterSelector = NSSelectorFromString(@"sendAction:to:forEvent:");
    //得到该类的实例方法；class_getClassMethod 得到类的类方法
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    //将一个self对象设置为kclass类的类型，返回原来的Class
    object_setClass(self, kclass);
    //获取方法的 Type 类型
    const char *types = method_getTypeEncoding(setterMethod);
    
    
    //为 kclass 类添加方法
    /*
     kclass : 被添加方法的类;
     setterSelector : 可以理解为所添加的方法名
     camerapermission_AddSelector : 实现这个方法的函数
     types : 一个定义该函数返回值类型和参数类型的字符串
     */
    /*
     接下来说一下types参数，
     比如我们要添加一个这样的方法：-(int)say:(NSString *)str;
     相应的实现函数如下：
     int say(id self, SEL _cmd, NSString *str)
     {
     NSLog(@"%@", str);
     return 100;//随便返回个值
     }
     class_addMethod这句就应该这么写：
     class_addMethod([EmptyClass class], @selector(say:), (IMP)say, "i@:@");
     其中types参数为"i@:@“，按顺序分别表示：
     i：返回值类型int，若是v则表示void
     @：参数id(self)
     :：SEL(_cmd)
     @：id(str)
     这些表示方法都是定义好的(Type Encodings)
     */
    class_addMethod(kclass, setterSelector, (IMP)camerapermission_AddSelector, types);
    //注册创建的类
    objc_registerClassPair(kclass);
}

//创建的方法的实现时，必须包含 id： self 和 SEL： _cmd 这两个参数，他们是每个方法的两个隐藏参数
static void camerapermission_AddSelector(id self, SEL _cmd, SEL action, id target, UIEvent *event) {
    
    //构建objc_super结构体
    struct objc_super superclass = {
        .receiver = self,//self
        .super_class = class_getSuperclass(object_getClass(self))//父类
    };
    void (*objc_msgSendSuperCasted)(const void *, SEL, SEL, id, UIEvent*) = (void *)objc_msgSendSuper;//调用父类方法，保证能够调用原button的点击事件
    
    //需要添加的方法
    SEL addSelector = NULL;
    switch (_selectorType) {
            
        case ZoomAnimationSelector: {
            addSelector = @selector(zoomAnimation);
            break;
        }
        case NetworkPermissionRequestSelector:
            {
                addSelector = @selector(requestNetwork);
            }
            break;
        case PhotoLibraryPermissionRequestSelector:
            {
                addSelector = @selector(requestPhotoLibrary);
            }
            break;
        case CameraPermissionRequestSelector: {
            {
                addSelector = @selector(requestCamera);
            }
            break;
        }
        case MicrophonePermissionRequestSelector: {
            {
                addSelector = @selector(requestMicrophone);
            }
            break;
        }
    }
    
    //新添加的方法调用顺序
    switch (_sequentialOrder) {
            
        case ClickActionFront:
            {
                [self executeSelector:addSelector];
                objc_msgSendSuperCasted(&superclass, _cmd,action,target,event);
            }
            break;
        case ClickActionBack:
            {
                objc_msgSendSuperCasted(&superclass, _cmd,action,target,event);
                [self executeSelector:addSelector];
            }
            break;
    }
}

//执行指定的方法
- (void)executeSelector:(SEL)aSelector {
    /*
     这一堆代码在做的事情其实是，向 self 请求那个方法对应的 C 函数指针。
     所有的NSObject都能响应methodForSelector:这个方法，不过也可以用 Objective-C runtime 里的class_getMethodImplementation（只在 protocol 的情况下有用，id<SomeProto>这样的）。这种函数指针叫做IMP，就是typedef过的函数指针（id (*IMP)(id, SEL, ...)）。它跟方法签名(signature)比较像，虽然可能不是完全一样。
     得到IMP之后，还需要进行转换，转换后的函数指针包含 ARC 所需的那些细节（比如每个 OC 方法调用都有的两个隐藏参数self和_cmd）。这就是代码第 4 行干的事（右边的那个(void *)只是告诉编译器，不用报类型强转的 warning）。
     最后一步，调用函数指针。
     */
    if (!self) { return; }
    IMP aImp = [self methodForSelector:aSelector];
    void (*aFunc)(id, SEL) = (void *)aImp;
    aFunc(self, aSelector);
    
    //带参数和返回值的函数调用
    /*
    UIView *someView = [UIView new];
    CGRect someRect = CGRectZero;
    if (!_controller) { return; }
    SEL selector = NSSelectorFromString(@"processRegion:ofView:");
    IMP imp = [_controller methodForSelector:selector];
    CGRect (*func)(id, SEL, CGRect, UIView *) = (void *)imp;
    CGRect result = _controller ? func(_controller, selector, someRect, someView) : CGRectZero;
     */
}

/**
 视图控件的缩放动画
 */
- (void)zoomAnimation {
    NSLog(@"zoomAnimation");
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;// 动画时间
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.layer addAnimation:animation forKey:nil];
}

//根据网络权限，进行网络请求
- (void)requestNetwork {
    NSLog(@"requestNetwork");
    [WWWTools requestNetworkPermission];
}

//根据相册权限，进行相册请求
- (void)requestPhotoLibrary {
    NSLog(@"requestPhotoLibrary");
    [WWWTools requestPhotoLibraryPermission];
}

//根据相机权限，进行相机请求
- (void)requestCamera {
    NSLog(@"requestCamera");
    [WWWTools requestCameraPermission];
}

//根据麦克风权限，进行麦克风请求
- (void)requestMicrophone {
    NSLog(@"requestMicrophone");
    [WWWTools requestMicrophonePermission];
}


@end
