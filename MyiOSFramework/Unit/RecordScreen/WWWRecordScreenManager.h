//
//  WWWRecordScreenManager.h
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/16.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWWRecordScreenManager : NSObject

@property (nonatomic,assign) BOOL isRecordAudio;
@property (nonatomic,strong) UIView *recordView;

- (void)startRecord;
- (void)stopRecord;
@end
