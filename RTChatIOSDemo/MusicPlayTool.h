//
//  MusicPlayTool.h
//  song
//
//  Created by tl on 2017/7/18.
//  Copyright © 2017年 tl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicPlayTool : NSObject

+ (instancetype)tool;

/** 播放音乐 */
- (AVAudioPlayer *)playMusicWithFileName:(NSString *)fileName;

/** 暂停播放音乐 */
- (void)pauseMusic;

/** 停止播放音乐 */
- (void)stopMusic;

/**  开始音乐**/
- (void)resume;

/** 设置当前播放进度 */
- (void)seekToTimeInterval:(NSTimeInterval)currentTime;

/*获取当前的播放进度*/
-(double)getCurTime;
//获取当前音乐的总长度

-(double)getDuration;
-(float)getCurVol;

-(void)setCurVol:(float)vol;
@end
