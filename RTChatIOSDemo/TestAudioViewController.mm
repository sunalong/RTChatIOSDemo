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

using namespace rtchatsdk;

@interface TestAudioViewController ()

@property IBOutlet UITextField* RoomInputField;

@end

@implementation TestAudioViewController

-(void)viewDidLoad
{
    //随机产生房间ID
    _RoomInputField.text = [NSString stringWithFormat:@"%d", (rand()%5+1)];
}

-(IBAction)BeginChat
{
    RTChatSDKMain::sharedInstance().requestJoinPlatformRoom([_RoomInputField.text UTF8String]);
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
    RTChatSDKMain::sharedInstance().setSendVoice(sender.on);
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

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
