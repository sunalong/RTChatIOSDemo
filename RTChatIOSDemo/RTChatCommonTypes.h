//
//  RTChatCommonTypes.h
//  RTChat
//
//  Created by wang3140@hotmail.com on 14-8-7.
//  Copyright (c) 2014年 RTChatTeam. All rights reserved.
//

#ifndef RTChat_RTChatCommonTypes_h
#define RTChat_RTChatCommonTypes_h

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
        kVideoSourceScreen
    };
    
    enum enMediaType
    {
        kVoiceOnly = 1,
        kVideo_normalDefinition = 3,
        kVideo_highDefinition = 7,
        kVideo_veryHighDefinition = 11
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
        
        //	/// 请求逻辑服务器信息
        //	enRequestLogicInfo = 1,
        //
        //	/// 返回需要连接的逻辑服务器信息
        //	enNotifyLogicInfo = 2,
        //
        //	/// 请求登录
        //	enRequestLogin = 3,
        //
        //	/// 返回登录结果
        //	enNotifyLoginResult = 4,
        //
        //	/// 创建房间
        //	enRequestCreateRoom = 5,
        //
        //	/// 创建房间返回
        //	enNotifyCreateResult = 6,
        
        /// 加入房间
        enRequestEnterRoom = 7,
        
        //	/// 加入房间返回
        //	enNotifyEnterResult = 8,
        
        //	// 申请房间列表
        //	enRequestRoomList = 9,
        
        //	/// 返回房间列表
        //	enNotifyRoomList = 10,
        
        //	/// 增加收听通道
        //	enNotifyAddVoiceUser = 11,
        
        //	/// 加入麦序
        //	enJoinMicQueue = 12,
        //
        //	/// 离开麦序
        //	enLeaveMicQueue = 13,
        
        //	/// 返回麦序
        //	enNotifyMicQueue = 14,
        //
        //	/// 到某人聊天了
        //	enNotifyTakeMic = 15,
        
        /// 离开房间
        enRequestLeaveRoom = 16,
        
        //    /// 删除一个通道
        //	enNotifyDelVoiceUser = 17,
        //
        //    /// 通知有人进入房间
        //	enNotifySomeEnterRoom = 18,
        //
        //    /// 有人离开房间
        //	enNotifySomeLeaveRoom = 19,
        //
        //	/// 有人想和你随机聊天
        //	enNotifyRandChat = 21,
        //
        //	/// 返回是否要随机聊天
        //	enReturnRandChat = 22,
        //
        //    /// 更新权限
        //	enRequestUpdatePower = 23,
        
        //	/// 通知更新权限
        //	enNotifyUpdatePower = 24,
        
        /// 请求录音
        enRequestRec = 25,
        
        /// 请求播放
        enRequestPlay = 26,
        
        //    /// 请求漂流瓶
        //	enRequestRandPlay = 27,
        //
        //	/// 通知漂流瓶
        //	enNotifyRandPlay = 28,
        //
        //	/// 分配麦
        //	enRequestAssignMic = 29,
        
        //	/// 分配返回结果
        //	enNotifyAssignResult = 30,
        
        //	/// 更新权限结果
        //	enNotifyUpdatePowerResult = 31,
        
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
        
        //    /// 和此人聊天
        //    enTalkWithSome = 39,
        //
        //    /// 通知进入房间
        //    enEnterTalkRoom = 40,
        
        /// 通知发送语音的结果
        enNotifySendVoice = 41,
        
        /// 通知发送视频或屏幕分享的结果
        enNotifySendVideo = 42,
        
        /// 通知发送视频或屏幕分享的结果
        enNotifySendScreen = 43,
        
        /// 播放测检测到声音
        enVoiceDetected = 44
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
    
    typedef void (*MsgCallBackFunc)(SdkResponseCmd cmdType, SdkErrorCode error, const char* dataPtr, uint64_t dataSize);
}

#endif
