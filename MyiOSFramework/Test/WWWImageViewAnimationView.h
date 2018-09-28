//
//  YORStoryAnimationView.h
//  YOYOBlockly
//
//  Created by Yonggui Wang on 2018/9/27.
//  Copyright © 2018年 youerobot. All rights reserved.
/* 能够监听动画的开始结束*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YORStoryImageViewAnimationViewDelegate <NSObject>

- (void)storyImageViewAnimationStop;

@end

@interface WWWImageViewAnimationView : UIView

@property (nonatomic,weak) id<YORStoryImageViewAnimationViewDelegate> __nullable delegate;

/*
 初始化方法
 */
- (instancetype)initWithImageFileName:(NSString *)imageFileName;
- (instancetype)initWithImageFileName:(NSString *)imageFileName andIsCricle:(BOOL)isCircle;
- (instancetype)initWithImageFileName:(NSString *)imageFileName andImageCount:(NSInteger)imageCount;
- (instancetype)initWithImageFileName:(NSString *)imageFileName andImageCount:(NSInteger)imageCount andIsCricle:(BOOL)isCircle;


/**
 动画开始
 */
- (void)startAnimation;

@end

NS_ASSUME_NONNULL_END
