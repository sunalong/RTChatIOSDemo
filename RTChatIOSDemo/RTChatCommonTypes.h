//
//  RTChatCommonTypes.h
//  RTChat
//
//  Created by wang3140@hotmail.com on 14-8-7.
//  Copyright (c) 2014年 RTChatTeam. All rights reserved.
//

#ifndef RTChat_RTChatCommonTypes_h
#define RTChat_RTChatCommonTypes_h

#include <string.h>
#include <stdint.h>

namespace rtchatsdk {
    
    enum enRoomType
    {
        ROOM_TYPE_MIN = 0,
        ROOM_TYPE_QUEUE = 1, /// 单人队列排麦模式(只能一个人拿麦)
        ROOM_TYPE_FREE = 2,  /// 自由模式(最多4个人)
        ROOM_TYPE_TWO = 3,   /// 二人模式
        ROOM_TYPE_ONLY = 4,   /// 抢麦模式
        ROOM_TYPE_MAX = 5
    };
    
    /// 创建房间的理由
    enum enRoomReason
    {
        ROOM_REASON_MIN = 0,
        ROOM_REASON_NORMAL = 1,
        ROOM_REASON_RANDCHAT = 2,
        ROOM_REASON_MAX = 3
    };
    
    enum enVideoSource
    {
        kVideoSourceNull,
        kVideoSourceFrontCamera,
        kVideoSourceBackCamera,
        kVideoSourceScreen,
        kVideoSourceMediaFile
    };
    
    enum enMediaType
    {
        kVoiceOnly = 0x01,
        kVideoOnly = 0x02,
        kVoiceAndVideo = 0x03,
        kLookLiveBC = 0x10,
    };
    
    enum enMediaProperty
    {
        kVideo_normalDefinition = 0x00,
        kVideo_highDefinition = 0x04,
        kVideo_veryHighDefinition = 0x08,
        
        kVoiceLowMark = 0x00,
        kVoiceMediumMark = 0x20,
        kVoiceHighMark = 0x40,
        kMusicLowMark = 0x60,
        kMusicMediumMark = 0x80,
        kMusicHighMark = 0xA0,
    };
    
    enum enConferenceProperty
    {
        kConferenceNormal = 0x00,
        kConferenceNeedForward = 0x100,
        kConferenceNeedMix = 0x200,
    };
    
    /// 房间权限类型
    enum enPowerType
    {
        POWER_TYPE_NORMAL = 1, /// 普通的人
        POWER_TYPE_MASTER = 2, /// 房主
        POWER_TYPE_ADMIN = 3 /// 管理员(房主分配的)
    };
    
    enum enAssignResult
    {
        ASSIGN_RESULT_NOPOWER,
        ASSIGN_RESULT_TYPEERR,
        ASSIGN_RESULT_NOUSER,
        ASSIGN_RESULT_SYSERR
    };
    
    
    enum SdkOpState {
        SdkUnInit = 0,
        SdkInited,
        SdkUserConnectingPlatform,  //平台通信状态
        SdkUserjoiningRoom,
        SdkUserJoinedRoom,
        SdkUserWaitingToken,
        SdkUserSpeaking,
        SdkUserRecording,   //录音状态
        SdkUserPlaying      //播放状态
    };
    
    enum SdkResponseCmd {
        enNone = 0,
        
        enInitSDK,
        
        /// 加入房间
        enRequestEnterRoom = 7,
        
        /// 离开房间
        enRequestLeaveRoom = 16,
        
        /// 通知房间内用户视频位置信息
        enNotifyUserVideoLayout = 17,

        // user join room add wlf
        enNotifyUserJoinRoom = 18,

        enNotifyUserLeaveRoom = 19,
        
        /// 请求录音
        enRequestRec = 25,
        
        /// 请求播放
        enRequestPlay = 26,
        
        /// 设置头像回调
        enReqSetAvaterResult = 32,
        
        /// 设置头像回调
        enReqGetAvaterResult = 33,
        
        /// 通知即时录音音量
        enNotifyRecordPower = 34,
        
        /// 通知播放停止
        enNotifyPlayOver = 35,
        
        /// 通知视频回调
        enNotifyRecordVideoOver = 36,
        
        ///通知语音识别文本结果回调
        enNotifyVoiceTextResult = 37,
        
        ///通知经纬度定位回调
        enNotifyCoodinateInfo = 38,
        
        /// 通知发送语音的结果
        enNotifySendVoice = 41,
        
        /// 通知发送视频或屏幕分享的结果
        enNotifySendVideo = 42,
        
        /// 通知发送视频或屏幕分享的结果
        enNotifySendScreen = 43,
        
        /// 播放测检测到声音
        enVoiceDetected = 44,
        
        /// 渲染帧对象尺寸变化
        enFrameSizeChanged = 45,
        
        ///录制实时会议
        enRecordConference = 46,

		enMediaPlayStopped = 47
    };
    
    enum SdkErrorCode {
        OPERATION_FAILED = 0,   //通用失败消息
        OPERATION_OK = 1,   //通用成功消息
        OPERATION_VERSION_LOW,  //操作系统版本号低
        
        /* 异步回调消息错误码开始 */
        LOGIC_RESULT_APPID_NOEXITS,
        LOGIC_RESULT_KEY_ERROR,
        LOGIC_RESULT_SYS_ERROR,
        LOGIC_RESULT_OK,
        
        LOGIN_RESULT_TOKEN_ERROR,
        LOGIN_RESULT_OK,
        
        ENTER_RESULT_NOEXITS,
        ENTER_RESULT_FULL,
        ENTER_RESULT_OK,
        ENTER_RESULT_ERROR
        /* 异步回调消息错误码结束 */
        
    };
    
    enum EnVideoDifinition {
        kNormalDifinition,    //普通
        kHighDifinition,      //高清
        kSuperHighDifinition  //超高清
    };

	enum EnDevieType {
		kCameraType,    //camera 
		kMicrophoneType,      //Microphone
		kSpeakerType  //speaker
	};
    
    enum EnFileSourceUsefulType {
        kFileSourceAsInput = 0x01,
        kFileSourceAsOutput = 0x02,
        kFileSourceReplaceInput = 0x04,
    };
    
    typedef void (*MsgCallBackFunc)(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize);
}

#endif
