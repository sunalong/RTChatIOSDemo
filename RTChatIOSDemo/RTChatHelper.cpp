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

void RTChatHelper::init(const char* username)
{
    RTChatSDKMain::sharedInstance().registerMsgCallback(sdkCallBack);
    
    sranddev();
    int userid = rand();
    char buf[128] = {0};
    snprintf(buf, 127, "%d", userid);
    
    //外网appid
    RTChatSDKMain::sharedInstance().initSDK("3768c59536565afb", "df191ec457951c35b8796697c204382d0e12d4e8cb56f54df6a54394be74c5fe");
    RTChatSDKMain::sharedInstance().customRoomServerAddr("room.audio.mztgame.com:8080");
    RTChatSDKMain::sharedInstance().setParams("http://giant.audio.mztgame.com/wangpan.php", "5853625c");
    RTChatSDKMain::sharedInstance().setUserInfo(username, "");
    
    _currentUser = username;
}

void RTChatHelper::joinRoom(const char* roomid, void *ptrWindow)
{
    RTChatSDKMain::sharedInstance().requestJoinPlatformRoom(roomid, kVoiceOnly);
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
    RTChatSDKMain::sharedInstance().setLoudSpeaker(enable);
}

void RTChatHelper::observerLocalVideoWindow(void* ptrWindow)
{
    RTChatSDKMain::sharedInstance().observerLocalVideoWindow(true, ptrWindow);
}

void RTChatHelper::voiceCallBack(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize)
{
    std::cout << cmdType << "-------" << error << std::endl;
    if (cmdType == enRequestEnterRoom && error == OPERATION_OK) {

    }
    else if (cmdType == enRequestRec && error == OPERATION_OK) {
        printf("录音回调结果：%s\n", dataPtr);
        _lastRecordUrl = dataPtr;
    }
}



