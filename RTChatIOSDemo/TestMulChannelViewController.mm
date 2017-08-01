//
//  TestMulChannelViewController.m
//  RTChat
//
//  Created by raymon_wang on 2017/7/20.
//  Copyright © 2017年 RTChatTeam. All rights reserved.
//

#import "TestMulChannelViewController.h"
#include "RTChatSdk.h"

using namespace rtchatsdk;

@interface TestMulChannelViewController ()

@property IBOutlet UITextField* RoomInputField;
@property IBOutlet UILabel* UserNameLabel1;
@property IBOutlet UILabel* UserNameLabel2;
@property IBOutlet UILabel* UserNameLabel3;
@property IBOutlet UILabel* UserNameLabel4;
@property UIView* LocalVideoView;
@property UIView* RemoteVideoView1;
@property UIView* RemoteVideoView2;
@property UIView* RemoteVideoView3;
@property UIView* RemoteVideoView4;

@end

@implementation TestMulChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

-(IBAction)SendVideo:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        _LocalVideoView  = (__bridge UIView*)RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = rect.size.width * 0.2;
        CGFloat height = width * 1.333;
        [_LocalVideoView setFrame:CGRectMake(rect.size.width * 0.8, 0, width, height)];
        [_LocalVideoView setBackgroundColor:[UIColor blackColor]];
        
        [self.view insertSubview:_LocalVideoView atIndex:5];
        if (RTChatSDKMain::sharedInstance().startSendVideo() == OPERATION_OK) {
            RTChatSDKMain::sharedInstance().observerLocalVideoWindow(true, (__bridge void*)_LocalVideoView);
        }
    }
    else {
        RTChatSDKMain::sharedInstance().observerLocalVideoWindow(false);
        RTChatSDKMain::sharedInstance().stopSendVideo();
        [_LocalVideoView removeFromSuperview];
        RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_LocalVideoView);
        _LocalVideoView = nil;
    }
}

-(IBAction)RecvVideo1:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        _RemoteVideoView1 = (__bridge UIView*)RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = rect.size.width * 0.3;
        [_RemoteVideoView1 setFrame:CGRectMake(0, 0, width, width * 1.333)];
        [_RemoteVideoView1 setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:_RemoteVideoView1 atIndex:1];
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", (__bridge void*)_RemoteVideoView1);
    }
    else {
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", nullptr);
        RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_RemoteVideoView1);
        [_RemoteVideoView1 removeFromSuperview];
        _RemoteVideoView1 = nil;
    }
}

-(IBAction)RecvVideo2:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        _RemoteVideoView2 = (__bridge UIView*)RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = rect.size.width * 0.3;
        [_RemoteVideoView2 setFrame:CGRectMake(width, 0, width, width * 1.333)];
        [_RemoteVideoView2 setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:_RemoteVideoView2 atIndex:1];
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("wangxin", (__bridge void*)_RemoteVideoView2);
    }
    else {
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("wangxin", nullptr);
        RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_RemoteVideoView2);
        [_RemoteVideoView2 removeFromSuperview];
        _RemoteVideoView2 = nil;
    }
}

-(IBAction)RecvVideo3:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        _RemoteVideoView3 = (__bridge UIView*)RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = rect.size.width * 0.3;
        [_RemoteVideoView3 setFrame:CGRectMake(0, width * 1.333, width, width * 1.333)];
        [_RemoteVideoView3 setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:_RemoteVideoView3 atIndex:1];
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("lulu", (__bridge void*)_RemoteVideoView3);
    }
    else {
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("lulu", nullptr);
        RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_RemoteVideoView3);
        [_RemoteVideoView3 removeFromSuperview];
        _RemoteVideoView3 = nil;
    }
}

-(IBAction)RecvVideo4:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        _RemoteVideoView4 = (__bridge UIView*)RTChatSDKMain::sharedInstance().createAVideoWindow();
        CGFloat width = rect.size.width * 0.3;
        [_RemoteVideoView4 setFrame:CGRectMake(width, width * 1.333, width, width * 1.333)];
        [_RemoteVideoView4 setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:_RemoteVideoView4 atIndex:1];
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("kiwi", (__bridge void*)_RemoteVideoView4);
    }
    else {
        RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("kiwi", nullptr);
        RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_RemoteVideoView4);
        [_RemoteVideoView4 removeFromSuperview];
        _RemoteVideoView4 = nil;
    }
}

-(IBAction)ReturnBack
{
    [self StopChat];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
