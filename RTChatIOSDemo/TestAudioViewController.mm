//
//  TestAudioViewController.m
//  RTChat
//
//  Created by raymon_wang on 2017/7/24.
//  Copyright © 2017年 RTChatTeam. All rights reserved.
//

#import "TestAudioViewController.h"
#import "MusicPlayTool.h"
#include "RTChatSdk.h"
#include "RTChatHelper.hpp"

using namespace rtchatsdk;

@interface TestAudioViewController ()

@property IBOutlet UITextField* RoomInputField;
@property IBOutlet UITextField* SearchPosInputField;
@property UIView*  MovieView;

@end

@implementation TestAudioViewController

-(void)viewDidLoad
{
    //随机产生房间ID
    _RoomInputField.text = [NSString stringWithFormat:@"%d", (rand()%5+1)];
}

-(IBAction)BeginChat
{
    RTChatSDKMain::sharedInstance().requestJoinPlatformRoom([_RoomInputField.text UTF8String], kVoiceOnly|kMusicLowMark);
}

-(IBAction)StopChat
{
    RTChatSDKMain::sharedInstance().requestLeavePlatformRoom();
}

-(IBAction)ReturnBack
{
    [self StopChat];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)OpenMic:(UISwitch*)sender
{
    const char* user_id = RTChatHelper::instance().currentUser().c_str();
    RTChatSDKMain::sharedInstance().muteAudioStream(user_id, !sender.on);
//    RTChatSDKMain::sharedInstance().setSendVoice(sender.on);
}

-(IBAction)setLouderSpeaker:(UISwitch*)sender
{
    RTChatSDKMain::sharedInstance().setLoudSpeaker(sender.on);
}

-(IBAction)volumeValueChanged:(UISlider*)sender
{
    float_t value = [sender value];
    RTChatSDKMain::sharedInstance().adjustSpeakerVolume(value);
}

-(IBAction)speechValueChanged:(UISlider*)sender
{
    int value = [sender value];
    RTChatSDKMain::sharedInstance().setVoiceChangeParm(value, 0);
}

-(IBAction)ReverbValueChanged:(UISlider*)sender
{
    int value = [sender value];
    RTChatSDKMain::sharedInstance().setVoiceChangeParm(0, value);
}

-(IBAction)MediaVolumnChanged:(UISlider*)sender
{
    int value = [sender value];
    RTChatSDKMain::sharedInstance().adjustMusicVolume(value);
}

-(IBAction)switchBgMusic:(UISwitch*)sender
{
    NSString* file_path = [[NSBundle mainBundle] pathForResource:@"music48" ofType:@"wav"];
    if (sender.on) {
//        RTChatSDKMain::sharedInstance().startPlayFileAsMic([file_path UTF8String], true);
        [MusicPlayTool.tool playMusicWithFileName:file_path];
    }
    else {
        [MusicPlayTool.tool stopMusic];
//        RTChatSDKMain::sharedInstance().stopPlayFileAsMic();
    }
}

-(IBAction)PlatMusicAsMic:(UISwitch*)sender
{
    NSString* file_path = [[NSBundle mainBundle] pathForResource:@"guangdao" ofType:@"mkv"];
    if (sender.on) {
        RTChatSDKMain::sharedInstance().startPlayFileAsSource([file_path UTF8String], kFileSourceAsOutput|kFileSourceAsInput);
        
//        RTChatSDKMain::sharedInstance().startPlayFileAsSource("http://hwpic.ztgame.com.cn/song/stream/aiqingzhuanyi/aiqingzhuanyi.m3u8", kFileSourceAsOutput|kFileSourceAsInput);
        
        
        _MovieView  = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = 360;
        CGFloat height = 240;
        [_MovieView setFrame:CGRectMake(0, 0, width, height)];
        [_MovieView setBackgroundColor:[UIColor blackColor]];
        
        [self.view insertSubview:_MovieView atIndex:5];
        RTChatSDKMain::sharedInstance().observerMovieVideoWindow(true, (__bridge void*)_MovieView);
    }
    else {
        RTChatSDKMain::sharedInstance().observerMovieVideoWindow(false);
        [_MovieView removeFromSuperview];
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_MovieView);
        _MovieView = nil;
        RTChatSDKMain::sharedInstance().stopPlayFileAsSource();
    }
}

-(IBAction)PausePlay:(UISwitch*)sender
{
    RTChatSDKMain::sharedInstance().pausePlayFileAsSource(sender.on);
}

-(IBAction)SearchMediaPos
{
    int file_pos = [_SearchPosInputField.text intValue];
    RTChatSDKMain::sharedInstance().searchToFilePos(file_pos);
}

-(IBAction)SwitchAudioTrack:(UISwitch*)sender
{
    if (sender.on) {
        RTChatSDKMain::sharedInstance().setAudioTrack(2);
    }
    else {
        RTChatSDKMain::sharedInstance().setAudioTrack(1);
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
