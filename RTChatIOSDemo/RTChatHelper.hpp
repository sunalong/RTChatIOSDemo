//
//  RTChatHelper.hpp
//  RTChat
//
//  Created by wangxin on 16/7/5.
//  Copyright © 2016年 RTChatTeam. All rights reserved.
//

#ifndef RTChatHelper_hpp
#define RTChatHelper_hpp

#include <iostream>
#include "RTChatSdk.h"

using namespace rtchatsdk;

class RTChatHelper {
public:
    RTChatHelper() {};
    virtual ~RTChatHelper() {};
    
    static RTChatHelper& instance();
    
    void init(const char* username);
    
    void joinRoom(const char* roomid, void* ptrWindow);
    
    void leaveRoom();
    
    void adjustVolume(float value);
    
    void setLouderSpeaker(bool enable);
    
    void observerLocalVideoWindow(void* ptrWindow);
    
    void voiceCallBack(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize);
    
    const std::string& lastRecordUrl() {
        return _lastRecordUrl;
    };
    
    const std::string& currentUser() {
        return _currentUser;
    };

    
private:
    std::string _lastRecordUrl;
    std::string _currentUser;
};

#endif /* RTChatHelper_hpp */