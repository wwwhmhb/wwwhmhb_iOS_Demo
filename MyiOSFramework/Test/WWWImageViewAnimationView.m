//
//  YORStoryAnimationView.m
//  YOYOBlockly
//
//  Created by Yonggui Wang on 2018/9/27.
//  Copyright © 2018年 youerobot. All rights reserved.
//

#import "WWWImageViewAnimationView.h"

@interface WWWImageViewAnimationView () <CAAnimationDelegate> {
    NSDictionary *_imageFileInfo;
    UIImageView *_imageView;
    NSString *_imageFileName;
    NSInteger _imageCount;
    BOOL _isCircle;
}
@property (nonatomic,strong) NSDictionary *imageFileInfo;

@end

@implementation WWWImageViewAnimationView

#pragma mark -- 初始化数据
- (instancetype)initWithImageFileName:(NSString *)imageFileName {
    return [self initWithImageFileName:imageFileName andImageCount:0 andIsCricle:NO];
}
- (instancetype)initWithImageFileName:(NSString *)imageFileName andIsCricle:(BOOL)isCircle {
    return [self initWithImageFileName:imageFileName andImageCount:0 andIsCricle:isCircle];
}
- (instancetype)initWithImageFileName:(NSString *)imageFileName andImageCount:(NSInteger)imageCount{
    return [self initWithImageFileName:imageFileName andImageCount:imageCount andIsCricle:NO];
}
- (instancetype)initWithImageFileName:(NSString *)imageFileName andImageCount:(NSInteger)imageCount andIsCricle:(BOOL)isCircle {
    self = [super init];
    if (self) {
        _imageFileName = imageFileName;
        _imageCount = imageCount;
        _isCircle = isCircle;
        [self createAndAddSubview];
    }
    return self;
}

#pragma mark -- 公开方法
- (void)startAnimation {
    [_imageView startAnimating];
}

#pragma mark -- 私有方法
//创建动画 imageView
- (void)createAndAddSubview {
    NSArray *imageArray = [self createImageArray];
    if (imageArray) {
        _imageView = [[UIImageView alloc] init];
        _imageView.animationImages = imageArray;
        _imageView.animationDuration = _imageCount * 0.04;
        _imageView.animationRepeatCount = !_isCircle;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
}

//创建 Image 数组
- (NSArray *)createImageArray {
    //初始化数组个数
    if (_imageCount == 0) {
        if (self.imageFileInfo[_imageFileName]) {
            _imageCount = [self.imageFileInfo[_imageFileName] integerValue];
        } else {
            return nil;
        }
    }
    //创建数组
    NSMutableArray *mImageArray = [NSMutableArray array];
    for (NSInteger i = 0; i < _imageCount; i++) {
        NSString *name = [NSString stringWithFormat:@"%@_%03ld",_imageFileName,i];
        UIImage *image = [UIImage imageNamed:name];
        [mImageArray addObject:image];
    }
    
    return mImageArray.copy;
}

//为 imageview 添加关键帧动画，控制 imageview 动画时间，确定动画结束的响应事件
- (void)addKeyframeAnimationForAnimationEnd {
    //添加关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.duration = _imageView.animationDuration;
    animation.delegate = self;
    [_imageView.layer addAnimation:animation forKey:@"OnceAnimation"];
}

#pragma mark -- CAAnimationDelegate 代理方法
/* Called when the animation begins its active duration. */
//CAAnimationDelegate动画开始的时候调用
- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"动画开始");
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
//CAAnimationDelegate动画结束或者被移除的时候调用，结束动画没有被移除 flag = yes,否则 flag = NO
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        NSLog(@"动画结束");
        //移除动画
        [_imageView.layer removeAnimationForKey:@"OnceAnimation"];
        //代理通知动画结束
        [_delegate storyImageViewAnimationStop];
    } else {
        NSLog(@"动画被移除");
    }
}

#pragma mark -- setter or getter 方法
// imageFileInfo 懒加载方法
- (NSDictionary *)imageFileInfo {
    if (!_imageFileInfo) {
        _imageFileInfo = @{
                           @"storySmallPassImage" : @50,
                           @"storyBigPassBeforeImage" : @50,
                           @"storyBigPassAfterImage" : @20
                           };
    }
    return _imageFileInfo;
}

//代理 setter 方法
- (void)setDelegate:(id<YORStoryImageViewAnimationViewDelegate> __nullable)delegate {
    _delegate = delegate;
    if (_delegate && [_delegate respondsToSelector:@selector(storyImageViewAnimationStop)]) {
        //添加关键帧动画
        [self addKeyframeAnimationForAnimationEnd];
    }
}

@end
