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

@interface ViewController () {
    bool landspace;
}

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _sendVideo = true;
    
    _stateLabel.text = @"已离开";
    
    //随机产生房间ID
    self.roomID = [NSString stringWithFormat:@"%d", (rand()%5+1)];
    self.roomInputField.text = self.roomID;
    
    //    RTChatHelper::instance()._targetScreenView = (__bridge void*)self.view;
    
    NSLog(@"width=%f, height=%f", self.view.frame.size.width, self.view.frame.size.height);
}

- (void)deviceOrientationDidChange:(NSNotification*)notification
{
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            landspace = true;
            break;
        default:
            landspace = false;
            break;
    }
    
    [self frameSizeChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)roomIDChanged:(UITextField*)sender
{
    self.roomID = [sender text];
}

-(void)frameSizeChanged
{
    float w_h_ratio = RTChatHelper::instance().w_h_rate_;
    if (!landspace && w_h_ratio > 1) {
        w_h_ratio = 1 / w_h_ratio;
    }
    
    CGFloat old_width = _otherVideoView.frame.size.width;
    CGFloat r_new_height = old_width / w_h_ratio;
    [_otherVideoView setFrame:CGRectMake(0, 0, old_width, r_new_height)];
    NSLog(@"new_width=%f, new_height=%f, w_h_ratio=%f", old_width, r_new_height, w_h_ratio);
    
    CGRect rect = _localVideoView.frame;
    old_width = rect.size.width;
    CGFloat l_new_height = old_width / w_h_ratio;
    [_localVideoView setFrame:CGRectMake(self.view.frame.size.width * 0.8, 0, old_width, l_new_height)];
}

-(IBAction)BeginChat
{
    RTChatHelper::instance().joinRoom([_roomID UTF8String], nil);
    
    _stateLabel.text = @"聊天中";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameSizeChanged) name:@"ON_FRMAE_SIZE_CHANGED" object:nil];
}

-(IBAction)StopChat
{
    RTChatHelper::instance().leaveRoom();
    [self deAllocLocalView];
    
    //erase render view for remote stream
    if (_otherVideoView) {
        [_otherVideoView removeFromSuperview];
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_otherVideoView);
        self.otherVideoView = nil;
    }
    
    _stateLabel.text = @"已离开";
}

-(IBAction)ObserverRemoteVideo:(UISwitch*)sender
{
    if (sender.isOn) {
        CGRect rect = [self.view frame];
        // create a render view
        UIView* ovideoView = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
        [ovideoView setFrame:CGRectMake(0, 0, rect.size.width*0.8, rect.size.width * 1.333 * 0.8)];
        [ovideoView setBackgroundColor:[UIColor blackColor]];
        [self.view insertSubview:ovideoView atIndex:1];
        
        self.otherVideoView = ovideoView;
        //associate render view to remote video stream
//        rtchatsdk::RTChatSDKMain::sharedInstance().startObserverRemoteVideo((__bridge void*)ovideoView);
        rtchatsdk::RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", (__bridge void*)ovideoView);
    }
    else {
        rtchatsdk::RTChatSDKMain::sharedInstance().stopObserverRemoteVideo();
        
        [_otherVideoView removeFromSuperview];
        // destroy a render view
        rtchatsdk::RTChatSDKMain::sharedInstance().destroyAVideoRenderWindow((__bridge void*)_otherVideoView);
        rtchatsdk::RTChatSDKMain::sharedInstance().observerRemoteTargetVideo("", nullptr);
        self.otherVideoView = nil;
    }
}

-(IBAction)switchLocalVideoSource:(id)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    if (index == 0) {
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchUserShowPostionIndex("[\"wangxin\",\"lulu\"]");
        //use front camera as video source
        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceFrontCamera);
    }
    else if (index == 1) {
//        rtchatsdk::RTChatSDKMain::sharedInstance().switchUserShowPostionIndex("[\"\",\"\",\"wangxin\",\"lulu\"]");
        //use back camera as video source
        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceBackCamera);
    }
    else if (index == 2) {
        //use a uiview(any view inherit from uiview) as video source
        CGRect rect = [self.view frame];
        _shareView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width * 0.8, rect.size.width * 1.333 * 0.8)];
        
        //replace url with your a website which can be access
        NSURL* url = [NSURL URLWithString:@"http://www.163.com"];
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [_shareView loadRequest:request];
        
        [self.view addSubview:_shareView];
        rtchatsdk::RTChatSDKMain::sharedInstance().switchVideoSource(kVideoSourceScreen, (__bridge void*)_shareView);
    }
    
    if (index != 2) {
        [_shareView removeFromSuperview];
        _shareView = nil;
    }
}

-(IBAction)switchDisplayMode:(id)sender
{
    NSInteger index = [sender selectedSegmentIndex];
    switch (index) {
        case 0:
            rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(2);
            break;
        case 1:
            rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(3);
            break;
        case 2:
            rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(4);
            break;
        case 3:
            rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(5);
            break;
        case 4:
            rtchatsdk::RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(6);
            break;
        default:
            break;
    }
}

-(IBAction)sendVideo:(UISwitch*)sender
{
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

-(IBAction)enableBeauty:(UISwitch*)sender
{
    rtchatsdk::RTChatSDKMain::sharedInstance().enableBeautify(sender.isOn);
}

-(void)allocLocalView
{
    CGRect rect = [self.view frame];
    self.localVideoView  = (__bridge UIView*)rtchatsdk::RTChatSDKMain::sharedInstance().createAVideoWindow();
    CGFloat width = rect.size.width * 0.2;
    CGFloat height = width * 1.333;
    [_localVideoView setFrame:CGRectMake(rect.size.width * 0.8, 0, width, height)];
    [_localVideoView setBackgroundColor:[UIColor blackColor]];
    
    [self.view insertSubview:_localVideoView atIndex:5];
}

-(void)deAllocLocalView
{
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
    [self StopChat];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)switchBgMusic:(UISwitch*)sender
{
    NSString* file_path = [[NSBundle mainBundle] pathForResource:@"music48" ofType:@"wav"];
    if (sender.on) {
        RTChatSDKMain::sharedInstance().startPlayFileAsMic([file_path UTF8String], true);
    }
    else {
        RTChatSDKMain::sharedInstance().stopPlayFileAsMic();
    }
}

@end
