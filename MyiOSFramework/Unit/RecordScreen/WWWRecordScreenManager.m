//
//  WWWRecordScreenManager.m
//  MyiOSFramework
//
//  Created by Yonggui Wang on 2018/7/16.
//  Copyright © 2018年 Weiwei Wang. All rights reserved.
//

#import "WWWRecordScreenManager.h"
#import "THCapture.h"
#import "BlazeiceAudioRecordAndTransCoding.h"
#import "THCaptureUtilities.h"

#define VEDIOPATH @"vedioPath"

@interface WWWRecordScreenManager () <THCaptureDelegate,AVAudioRecorderDelegate,BlazeiceAudioRecordAndTransCodingDelegate> {
    
    THCapture *_capture;
    BlazeiceAudioRecordAndTransCoding *_audioRecord;
    NSString *_videoPath;
    NSString *_audioPath;
}
@end

@implementation WWWRecordScreenManager

- (instancetype)init {
    self = [super init];
    if (self) {
        
        _capture=[[THCapture alloc] init];
        _capture.frameRate = 35;
        _capture.delegate = self;
        
        _audioRecord = [[BlazeiceAudioRecordAndTransCoding alloc]init];
        _audioRecord.recorder.delegate=self;
        _audioRecord.delegate=self;
        _audioPath = [WWWTools getCustomPathByFilePathType:DocumentPath andFilePathName:VEDIOPATH andFilePathExtension:@"wav"];
    }
    return self;
}

- (void)dealloc {
    _capture.delegate = nil;
    _audioRecord.recorder.delegate = nil;
    _audioRecord.delegate = nil;
}

//开始录制音视频
- (void)startRecord {
    if (_recordView) {
        _capture.captureLayer = _recordView.layer;
        [_capture startRecording1];
    }
    
    if (_isRecordAudio) {
        [_audioRecord beginRecordByFilePath:_audioPath];
    }
}

//停止录制音视频
- (void)stopRecord {
    [_capture stopRecording];
}

//合成音视频
- (void)mergedidFinish:(NSString *)videoPath WithError:(NSError *)error
{
    //获取当前时间，并确定展示形式
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *currentDateStr=[dateFormatter stringFromDate:[NSDate date]];
    //自定义合成视频路径
    NSString *fileName=[NSString stringWithFormat:@"myVideo_%@",currentDateStr];
    NSString *filePathExtension = @"mov";
    NSString* path = [WWWTools getCustomPathByFilePathType:DocumentPath andFilePathName:fileName andFilePathExtension:filePathExtension];
    //移动资源到指定位置
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        NSError *err=nil;
        [[NSFileManager defaultManager] moveItemAtPath:videoPath toPath:path error:&err];
    }
    //音频与视频合并结束，存入相册中
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
        UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
}

//音视频存入相册结束后，调用此方法
- (void)video: (NSString *)videoPath didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInfo{
    if (error) {
        NSLog(@"---%@",[error localizedDescription]);
    }
}

#pragma mark THCaptureDelegate
//录屏成功结束回调方法，同时结束音频录制
- (void)recordingFinished:(NSString*)outputPath
{
    _videoPath = outputPath;
    if (_isRecordAudio) {
        [_audioRecord endRecord];
    } else {
        [self mergedidFinish:_videoPath WithError:nil];
    }
}
//录屏失败结束回调方法
- (void)recordingFaild:(NSError *)error
{
    NSLog(@"录屏失败");
}

#pragma mark - BlazeiceAudioRecordAndTransCodingDelegate
//音频录制结束合成视频音频
-(void)wavComplete
{
    if (_isRecordAudio) {
        //结合音视频
        [THCaptureUtilities mergeVideo:_videoPath andAudio:_audioPath andTarget:self andAction:@selector(mergedidFinish:WithError:)];
    }
}



@end
