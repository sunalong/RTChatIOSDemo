//
//  MusicPlayTool.m
//  song
//
//  Created by tl on 2017/7/18.
//  Copyright © 2017年 tl. All rights reserved.
//

#import "MusicPlayTool.h"

@interface MusicPlayTool()<AVAudioPlayerDelegate>

//当前播放器对象
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;

@end

@implementation MusicPlayTool

- (instancetype)init
{
    if (self = [super init]) {
//        [self backPlay];
    }
    return self;
}


- (void)backPlay
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
//    AVAudioSessionCategoryOptions options = [session categoryOptions];
//    
//    [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:options error:nil];
    [session setMode:AVAudioSessionModeDefault error:nil];
    [session setMode:AVAudioSessionModeVoiceChat error:nil];
}

+ (instancetype)tool
{
    static MusicPlayTool *tool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tool = [[MusicPlayTool alloc]init];
    });
    return tool;
}

- (AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName
{
    NSURL *fileURL = [NSURL  fileURLWithPath:fileName ];
    if (fileURL == nil) {
        return nil;
    }
    //如果播放的是当前正在播放的歌曲, 不需要重新创建播放器对象, 直接开始播放就行
    if ([self.currentPlayer.url.absoluteString isEqualToString:fileURL.absoluteString]) {
        [self.currentPlayer play];
        return self.currentPlayer;
    }
    
    self.currentPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    self.currentPlayer.delegate = self;
    
    [self.currentPlayer prepareToPlay];
    [self.currentPlayer play];
    
    [self backPlay];
    
    return self.currentPlayer;
}

// 暂停
- (void)pauseMusic
{
    [self.currentPlayer pause];
}

//恢复播放音乐
-(void)resume
{
    [self.currentPlayer  play];
}

// 停止
- (void)stopMusic
{
    [self.currentPlayer stop];
    self.currentPlayer = nil;
}

// 设置当前播放器的播放进度
- (void)seekToTimeInterval:(NSTimeInterval)currentTime
{
    self.currentPlayer.currentTime = currentTime;
//    [self.currentPlayer playAtTime:currentTime];
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"musicPlayFinish" object:self.currentPlayer];
    }
}

-(double)getCurTime{
    return self.currentPlayer.currentTime;
}

-(void)setCurVol:(float)vol{
    self.currentPlayer.volume = vol;
}

-(float)getCurVol{
    return self.currentPlayer.volume;
}

//获取当前音乐的总长度
-(double)getDuration{
    return self.currentPlayer.duration;
}


@end
