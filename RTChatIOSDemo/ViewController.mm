//
//  ViewController.m
//  RTChatDemo
//
//  Created by wangxin on 16/6/23.
//  Copyright © 2016年 RTChatTeam. All rights reserved.
//

#import "ViewController.h"
#import "RTChatHelper.hpp"
#include "RTChatSdk.h"

@interface ViewController ()

@property IBOutlet UILabel* stateLabel;
@property NSString* roomID;
@property IBOutlet UITextField* roomInputField;

@property UIView* localVideoView;
@property UIView* otherVideoView;
@property UIWebView* shareView;

@property bool sendVideo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _sendVideo = true;
    
    _stateLabel.text = @"点击(开始聊天)按钮进入房间";
    
    //随机产生房间ID
    self.roomID = [NSString stringWithFormat:@"%d", (rand()%5+1)];
    self.roomInputField.text = self.roomID;
    
    //    RTChatHelper::instance()._targetScreenView = (__bridge void*)self.view;
    
    NSLog(@"width=%f, height=%f", self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)roomIDChanged:(UITextField*)sender
{
    self.roomID = [sender text];
}

-(IBAction)setLouderSpeaker:(UISwitch*)sender
{
    //    if (sender.isOn) {
    //        rtchatsdk::RTChatSDKMain::sharedInstance().setVideoDefinition(kSuperHighDifinition);
    //    }
    //    else {
    //        rtchatsdk::RTChatSDKMain::sharedInstance().setVideoDefinition(kNormalDifinition);
    //    }
    RTChatHelper::instance().setLouderSpeaker(sender.isOn);
}

-(IBAction)BeginChat
{
    RTChatHelper::instance().joinRoom([_roomID UTF8String], nil);
    
    _stateLabel.text = @"正在聊天中，点击(停止聊天)按钮退出";
}

-(IBAction)StopChat
{
    RTChatHelper::instance().leaveRoom();
    [self deAllocLocalView];
    
    _stateLabel.text = @"已离开聊天房间，点击(开始聊天)按钮进入";
    
    //2.4版本暂时屏蔽该功能
    return;
    //erase render view for remote stream
    if (_otherVideoView) {
        [_otherVideoView removeFromSuperview];
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_otherVideoView);
        self.otherVideoView = nil;
    }
}

-(IBAction)ObserverRemoteVideo:(UISwitch*)sender
{
    //2.4版本暂时屏蔽该功能
    return;
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        UIView* ovideoView = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
        [ovideoView setFrame:CGRectMake(0, 0, rect.size.width, rect.size.width * 1.222)];
        [ovideoView setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:ovideoView atIndex:1];
        
        self.otherVideoView = ovideoView;
        //associate render view to remote video stream
        rtchatsdk::RTChatSDKMain::sharedInstance().startObserverRemoteVideo((__bridge void*)ovideoView);
    }
    else {
        rtchatsdk::RTChatSDKMain::sharedInstance().stopObserverRemoteVideo();
        
        [_otherVideoView removeFromSuperview];
        // destroy a render view
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_otherVideoView);
        self.otherVideoView = nil;
    }
}

-(IBAction)switchLocalVideoSource:(id)sender
{
    //2.4版本暂时屏蔽该功能
    return;
    NSInteger index = [sender selectedSegmentIndex];
    if (index == 0) {
        //use front camera as video source
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceFrontCamera);
    }
    else if (index == 1) {
        //use back camera as video source
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceBackCamera);
    }
    else if (index == 2) {
        //use a uiview(any view inherit from uiview) as video source
        CGRect rect = [self.view frame];
        _shareView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.width * 1.222)];
        
        //replace url with your a website which can be access
        NSURL* url = [NSURL URLWithString:@"http://192.168.114.6"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [_shareView loadRequest:request];
        
        [self.view addSubview:_shareView];
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceScreen, (__bridge void*)_shareView);
    }
    
    if (index != 2) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
}

-(IBAction)switchRemoteVideoSource:(id)sender
{
    //2.4版本暂时屏蔽该功能
    return;
    NSInteger index = [sender selectedSegmentIndex];
    if (index == 0) {
        //看会议视频
        rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteTarget(nullptr);
    }
    else if (index == 1) {
        //看远端传回的单人视频
        rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteTarget(RTChatHelper::instance().currentUser().c_str());
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteTarget("11");
    }
    else {
        rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteTarget(nullptr);
    }
}

-(IBAction)volumeValueChanged:(UISlider*)sender
{
    float_t value = [sender value];
    RTChatHelper::instance().adjustVolume(value);
}

-(IBAction)sendVideo:(UISwitch*)sender
{
    //2.4版本暂时屏蔽该功能
    return;
    if (sender.isOn) {
        [self allocLocalView];
        if (rtchatsdk::RTChatSDKMain::sharedInstance().startSendVideo() == OPERATION_OK) {
            rtchatsdk::RTChatSDKMain::sharedInstance().observerLocalVideoWindow(true, (__bridge void*)_localVideoView);
        }
        
    }
    else {
        rtchatsdk::RTChatSDKMain::sharedInstance().observerLocalVideoWindow(false);
        rtchatsdk::RTChatSDKMain::sharedInstance().stopSendVideo();
        [self deAllocLocalView];
    }
}

-(void)allocLocalView
{
    //2.4版本暂时屏蔽该功能
    return;
    CGRect rect = [self.view frame];
    self.localVideoView  = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
    CGFloat width = rect.size.width / 3;
    CGFloat height = width * 1.222;
    [_localVideoView setFrame:CGRectMake((rect.size.width - width), (rect.size.width*1.222 - height), width, height)];
    [_localVideoView setBackgroundColor:[UIColor blackColor]];
    
    [self.view insertSubview:_localVideoView atIndex:5];
}

-(void)deAllocLocalView
{
    //2.4版本暂时屏蔽该功能
    return;
    [_localVideoView removeFromSuperview];
    rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_localVideoView);
    _localVideoView = nil;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.roomInputField resignFirstResponder];
}

-(IBAction)ReturnBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end