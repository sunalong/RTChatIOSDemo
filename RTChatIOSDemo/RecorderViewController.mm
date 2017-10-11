//
//  RecorderViewController.m
//  RTChat
//
//  Created by raymon_wang on 17/1/22.
//  Copyright © 2017年 RTChatTeam. All rights reserved.
//

#import "RecorderViewController.h"
#import "RTChatSdk.h"
#import "RTChatHelper.hpp"
#import "MusicPlayTool.h"

@interface RecorderViewController ()

@end

@implementation RecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)BeginRecord
{
    rtchatsdk::RTChatSDKMain::sharedInstance().startRecordVoice(false, true);
}

-(IBAction)StopRecord
{
    rtchatsdk::RTChatSDKMain::sharedInstance().stopRecordVoice();
}

-(IBAction)BeginPlay
{
    std::string str = RTChatHelper::instance().lastRecordUrl();
    NSData* jsonData = [NSData dataWithBytes:str.c_str() length:str.length()];
    NSDictionary* dicParam = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    if (dicParam.count == 3) {
        rtchatsdk::RTChatSDKMain::sharedInstance().startPlayLocalVoice([[dicParam valueForKey:@"url"] UTF8String]);
    }
//    rtchatsdk::RTChatSDKMain::sharedInstance().startPlayLocalVoice("http://giant.audio.mztgame.com/upload/2017012414/28022f4f03b6");
}

-(IBAction)StopPlay
{
    rtchatsdk::RTChatSDKMain::sharedInstance().stopPlayLocalVoice();
}

-(IBAction)CancelRecord
{
    rtchatsdk::RTChatSDKMain::sharedInstance().cancelRecordedVoice();
}

-(IBAction)ReturnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)switchBgMusic:(UISwitch*)sender
{
    NSString* file_path = [[NSBundle mainBundle] pathForResource:@"lucky" ofType:@"mp4"];
    if (sender.on) {
        [MusicPlayTool.tool playMusicWithFileName:file_path];
    }
    else {
        [MusicPlayTool.tool stopMusic];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
