//
//  RTChatHelper.cpp
//  RTChat
//
//  Created by wangxin on 16/7/5.
//  Copyright © 2016年 RTChatTeam. All rights reserved.
//

#include "RTChatHelper.hpp"
#include <string>
#include <iostream>
#import <UIKit/UIKit.h>

using namespace rtchatsdk;
using namespace std::placeholders;

static RTChatHelper* s_rTChatHelper;

static void sdkCallBack(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize){
    RTChatHelper::instance().voiceCallBack(cmdType, error, dataPtr, dataSize);
}

RTChatHelper& RTChatHelper::instance()
{
    if (!s_rTChatHelper) {
        s_rTChatHelper = new RTChatHelper();
    }
    return *s_rTChatHelper;
}

void RTChatHelper::init(const char* username, const char* appid, const char* appkey, const char* platfrom_addr, const char* cheat_src, const char* lice_server_ip)
{
    srand( time( 0 ) );
    RTChatSDKMain::sharedInstance().registerMsgCallback(sdkCallBack);

    NSDictionary* dic_data = [NSDictionary dictionaryWithObjectsAndKeys:@"http://giant.audio.mztgame.com/wangpan.php", @"VoiceUploadUrl", @"5853625c", @"XunfeiAppID", [NSString stringWithUTF8String:platfrom_addr], @"RoomServerAddr", [NSString stringWithUTF8String:lice_server_ip], @"LiveServerAddr", [NSString stringWithUTF8String:cheat_src], @"CheatingIP", NSTemporaryDirectory(), @"DebugLogPath",nil];
    if ([NSJSONSerialization isValidJSONObject:dic_data]) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:dic_data options:NSJSONWritingPrettyPrinted error:nil];
        NSString* data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        RTChatSDKMain::sharedInstance().SetSdkParams([data_str UTF8String]);
    }
    
    RTChatSDKMain::sharedInstance().initSDK(appid, appkey);
    
    //测试服
//    RTChatSDKMain::sharedInstance().customRoomServerAddr("roomv2.audio.mztgame.com:8080");
    //正式服
//    RTChatSDKMain::sharedInstance().customRoomServerAddr("room.audio.mztgame.com:8080");
    
//    if (1) { //内网
//        //内网appid
//        RTChatSDKMain::sharedInstance().initSDK("1fcfaa5cdc01502e", "7324e82e18d9d16ca4783aa5f872adf54d17a0175f48fa7c1af0d80211dfff82");
//        RTChatSDKMain::sharedInstance().customRoomServerAddr("192.168.114.4:18888");
//    }
//    else {
//        //外网appid
//        RTChatSDKMain::sharedInstance().initSDK("3768c59536565afb", "df191ec457951c35b8796697c204382d0e12d4e8cb56f54df6a54394be74c5fe");
//        RTChatSDKMain::sharedInstance().customRoomServerAddr("115.159.251.79:8081");
//        //    RTChatSDKMain::sharedInstance().customRoomServerAddr("room.audio.mztgame.com:8080");
//    }

//    RTChatSDKMain::sharedInstance().setParams("http://giant.audio.mztgame.com/wangpan.php", "5853625c");
    RTChatSDKMain::sharedInstance().setUserInfo(username, "32261be4ed6fd0d90976da1f7a85237d");
    
    _currentUser = username;
}

void RTChatHelper::joinRoom(const char* roomid, void *ptrWindow)
{
    RTChatSDKMain::sharedInstance().requestJoinPlatformRoom(roomid, kVoiceOnly|kMusicLowMark|kConferenceNeedMix, 4);
}

void RTChatHelper::leaveRoom()
{
    RTChatSDKMain::sharedInstance().requestLeavePlatformRoom();
}

void RTChatHelper::adjustVolume(float value)
{
    RTChatSDKMain::sharedInstance().adjustSpeakerVolume(value);
}

void RTChatHelper::setLouderSpeaker(bool enable)
{
//    if (enable) {
//        RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(2);
//    }
//    else {
//        RTChatSDKMain::sharedInstance().switchRemoteVideoShowStyle(1);
//    }
    RTChatSDKMain::sharedInstance().setLoudSpeaker(enable);
}

void RTChatHelper::observerLocalVideoWindow(void* ptrWindow)
{
    RTChatSDKMain::sharedInstance().observerLocalVideoWindow(true, ptrWindow);
}

void RTChatHelper::voiceCallBack(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize)
{
//    std::cout << cmdType << "---" << error << "---" << dataPtr << std::endl;
    if (cmdType == enRequestEnterRoom) {
        NSLog(@"%s", dataPtr);
    }
    else if (cmdType == enInitSDK) {
        if (error == OPERATION_OK) {
            NSLog(@"初始化sdk成功");
        }
        else {
            NSLog(@"初始化sdk失败");
        }
    }
    else if (cmdType == enRequestRec && error == OPERATION_OK) {
        NSLog(@"录音回调结果：%s\n", dataPtr);
        _lastRecordUrl = dataPtr;
    }
    else if (cmdType == enFrameSizeChanged && error == OPERATION_OK) {
        NSData* json_data = [[NSString stringWithUTF8String:dataPtr] dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic_data = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableLeaves error:nil];
        NSNumber* ns_width = [dic_data objectForKey:@"width"];
        NSNumber* ns_height = [dic_data objectForKey:@"height"];
        NSLog(@"ns_width=%@, ns_height=%@", ns_width, ns_height);
        w_h_rate_ =  ns_width.floatValue / ns_height.floatValue;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ON_FRMAE_SIZE_CHANGED" object:nil];
    }
    else if (cmdType == enNotifyUserJoinRoom) {
        NSLog(@"新进用户：%s", dataPtr);
    }
    else if (cmdType == enNotifyUserLeaveRoom) {
        NSLog(@"离开用户：%s", dataPtr);
    }
}



