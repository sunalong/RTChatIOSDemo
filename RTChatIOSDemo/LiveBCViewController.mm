//
//  LiveBCViewController.m
//  RTChat
//
//  Created by raymon_wang on 2017/5/24.
//  Copyright © 2017年 RTChatTeam. All rights reserved.
//

#import "LiveBCViewController.h"
#import "RTChatSdk.h"
#include "RTChatHelper.hpp"

@interface LiveBCViewController ()

@property IBOutlet UITextField* roomInputField;
@property NSString* roomID;
@property (weak)UIView* otherVideoView;

@end

@implementation LiveBCViewController

-(IBAction)roomIDChanged:(UITextField*)sender
{
    _roomID = [sender text];
}

-(IBAction)enterRoom:(id)sender
{
    rtchatsdk::RTChatSDKMain::sharedInstance().requestJoinPlatformRoom(_roomID.UTF8String, rtchatsdk::kLookLiveBC);
}

-(IBAction)leaveRoom:(id)sender
{
    rtchatsdk::RTChatSDKMain::sharedInstance().requestLeavePlatformRoom();
}

-(IBAction)ReturnBack:(id)sender
{
    rtchatsdk::RTChatSDKMain::sharedInstance().requestLeavePlatformRoom();
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)observerRemoteVideo:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        UIView* ovideoView = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
        [ovideoView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.width * 1.222)];
        [ovideoView setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:ovideoView atIndex:1];
        _otherVideoView = ovideoView;
        
        rtchatsdk::RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", (__bridge void*)ovideoView);
//        rtchatsdk::RTChatSDKMain::sharedInstance().startObserverRemoteVideo((__bridge void*)ovideoView);
    }
    else {
        rtchatsdk::RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", nullptr);
//        rtchatsdk::RTChatSDKMain::sharedInstance().stopObserverRemoteVideo();
        
        [_otherVideoView removeFromSuperview];
        // destroy a render view
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_otherVideoView);
        self.otherVideoView = nil;
    }
}

-(IBAction)setLouderSpeaker:(UISwitch*)sender
{
    RTChatHelper::instance().setLouderSpeaker(sender.isOn);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.roomInputField resignFirstResponder];
}

@end
