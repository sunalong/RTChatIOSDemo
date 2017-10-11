//
//  NativeVoiceEngine.h
//  RTChat
//
//  Created by wang3140@hotmail.com on 14-7-29.
//  Copyright (c) 2014年 RTChatTeam. All rights reserved.
//

#ifndef RTChat_RTChatSdk_h
#define RTChat_RTChatSdk_h

#include "RTChatCommonTypes.h"
#include <functional>

namespace rtchatsdk {

class RTChatSDKMain {
public:
    static RTChatSDKMain& sharedInstance();

    //设置Android虚拟机信息
    SdkErrorCode setAndroidObjects(void* javaVM, void* env, void* context);
    
    //清除Android虚拟机信息
    SdkErrorCode clearAndroidObjects();
    
    //sdk初始化，只能调用一次(主线程)
    SdkErrorCode initSDK(const char* appid, const char* key);
    
    /// 设置自定义参数
    [[deprecated ("use SetSdkParams")]] void setParams(const char* voiceUploadUrl, const char* xunfeiAppID);
    
    /// 设置平台连接地址
    [[deprecated ("use SetSdkParams")]] void customRoomServerAddr(const char* roomServerAddr);
    
    /// 设置sdk参数接口, params为json字符串
    /// {"RoomServerAddr":"room.audio.mztgame.com:8080", "XunfeiAppID":"xxxx",  "VoiceUploadUrl":"http://giant.audio.mztgame.com/wangpan.php", "LiveServerAddr":"livebc.audio.mztgame.com:8000"}
    void SetSdkParams(const char* params);
    
    //改变语音聊天登录用户信息
    SdkErrorCode setUserInfo(const char* username, const char* userkey);
    
    //注册消息回调(主线程)
    void registerMsgCallback(const MsgCallBackFunc& func);
    
    //激活SDK(主线程)
    void activateSDK();
    
    //当应用最小化时需要调用这个，清理数据(主线程)
    void deActivateSDK();
    
    //获取SDK当前操作状态，用户发起操作前可以检测一下状态判断可否继续
    SdkOpState getSdkState();
    
    /// 向平台请求加入房间(主线程)
    /// media_type = (enMediaType|enMediaProperty|enConferenceProperty)
    SdkErrorCode requestJoinPlatformRoom(const char* roomid_p, int meida_type = kVoiceOnly, int layout_mode = 4);
    
    /// 向平台请求退出房间(主线程)
    SdkErrorCode requestLeavePlatformRoom();
    
    /// 调整通道外放音量(主线程)(0.0f-10.0f)
    SdkErrorCode adjustSpeakerVolume(float volume);
    
    /// 设置是否用外放扬声器
    SdkErrorCode setLoudSpeaker(bool enable);
    
    /// 获取或创建一个渲染窗口指针; renderMode: 0: SCALE_SCREEN_FIT, 适配到陪屏幕，屏幕与视频比例不对时，会有黑边; 1: SCALE_SCREEN_FILL,填充到屏幕，
    void* createAVideoWindow(int renderMode = 0);

    //设置指定窗口的渲染模式， renderMode: 0: SCALE_SCREEN_FIT, 适配到陪屏幕，屏幕与视频比例不对时，会有黑边; 1: SCALE_SCREEN_FILL,填充到屏幕，
    SdkErrorCode setWindowRenderMode(int renderMode, void* window);
    
    ///内部销毁一个渲染窗口指针
    void destroyAVideoRenderWindow(void* window);
    
    /// 开始广播本地视频(ptrScreenView为要发送的屏幕窗口指针, ios下为UIView*类型)
    SdkErrorCode startSendVideo();
    
    /// 结束广播本地视频
    SdkErrorCode stopSendVideo();
    
    /// 切换发送视频源，当使用屏幕分享源时，ptrScreenView不能为空时
    SdkErrorCode switchVideoSource(enVideoSource sourceIndex, void* ptrScreenView = nullptr);
    
    /// 注册本地视频渲染窗口
    SdkErrorCode observerLocalVideoWindow(bool enable, void* ptrWindow = nullptr);
    
//    /// 打开或关闭他人视频(主线程)(otherUserID如果为NULL，则表示打开或关闭当前所有人的)
//    SdkErrorCode startObserverRemoteVideo(void* ptrWindow = nullptr);
    
//    /// 关闭远端视频
//    SdkErrorCode stopObserverRemoteVideo();
    
    /// 切换视频源对象(null为看会议视频，否则为目标用户视频)
    SdkErrorCode switchRemoteTarget(const char* userID);
    
    /// 打开或关闭一路视频源对象(userID为""看会议视频，否则为目标用户视频, ptrWindow为空则关闭该路视频流)
    SdkErrorCode observerRemoteTargetVideo(const char* userID, void* ptrWindow);

        // 禁音一路发送音频源对象(userID为""表示操作除该用户以外的全部用户，否则操作该用户， mute: ture 为禁音，false 为非禁音)
        SdkErrorCode  muteAudioStream(const char* userID, bool mute);
    
    /// 切换视频显示模式，即多用户在显示区域的布局样式
    SdkErrorCode switchRemoteVideoShowStyle(int styleIndex);
    
    /// 排列远端用户视频在显示区域的显示位置(desc_index为json数组格式表示的字符串)
    /// "[\"aaa\",\"bbb\",\"ccc\",\"ddd\"]"
    SdkErrorCode switchUserShowPostionIndex(const char* desc_index);
    
    /// 设置视频清晰度
    SdkErrorCode setVideoDefinition(EnVideoDifinition difinition);
    
    /// 设置本人Mac静音(主线程)
    [[deprecated ("use muteAudioStream")]] SdkErrorCode setSendVoice(bool isSend);
    
    /**********IM interface begin**********/
    
    /// 开始录制麦克风数据(主线程)
    SdkErrorCode startRecordVoice(bool needConvertWord = false, bool isPersis = false);
    
    /// 停止录制麦克风数据(主线程)
    SdkErrorCode stopRecordVoice();
    
    /// 取消当前录音
    SdkErrorCode cancelRecordedVoice();
    
    /// 开始播放录制数据(主线程)
    SdkErrorCode startPlayLocalVoice(const char* voiceUrl);
    
    /// 停止播放数据(主线程)
    SdkErrorCode stopPlayLocalVoice();
    
    ///开始语音识别
    SdkErrorCode startVoiceToText();
    
    ///停止语音识别
    SdkErrorCode stopVoiceToText();
    
    /**********IM interface end**********/
    
    /// 获取当前地理位置信息
    SdkErrorCode startGetCurrentCoordinate();
    
    /// 设置头像
    SdkErrorCode setAvater(unsigned int uid, int type);
    
    /// 获取头像
    SdkErrorCode getAvater(unsigned int uid, int type, const char* imageUrl);

    //打开美颜
    void enableBeautify(bool enabled);
    
    /**********MediaPlayer interface begin**********/
    
    ///source_type = kFileSourceMixInput|kFileSourceAsOutput
    SdkErrorCode startPlayFileAsSource(const char* fileNameUTF8, int source_type);
    
    ///stop local file or network file stream playing
    SdkErrorCode stopPlayFileAsSource();
    
    /// pause file playing
    /// pause==true(pause play) pause==false(resume play)
    SdkErrorCode pausePlayFileAsSource(bool pause);
    
    /// search to file position and play
    SdkErrorCode searchToFilePos(int file_pos);

	//set play audio track index
	SdkErrorCode setAudioTrack(int index);

	//music音量范围为0~100， 默认100 为原始文件音量；
	SdkErrorCode adjustMusicVolume(int volume);

	//get current player position
	int getFileCurrentPosition();

	//get file total duration;
	int getFileDuration();

	//get current playing audio track
	int getPlayingAudioTrack();

	//get all available audio tracks; 
	const char* getAvailableAudioTracks();
    
    /// 打开或关闭视频文件播放窗口
    SdkErrorCode observerMovieVideoWindow(bool enable, void* ptrWindow = nullptr);
    
    /**********MediaPlayer interface end**********/

	//设置变音参数 pitch = -10 ~ +10
	//            reverbLevel = 0 ~ 9; 0 为原始声音，1到9，混响级别逐渐增强；
	SdkErrorCode setVoiceChangeParm(int pitch, int reverbLevel);

    //启用说话者音量提示;
    //interval 指定音量提示的时间间隔; <10; 禁用音量提示功能; >=10;提示间隔，单位为毫秒，建议设置到大于等于500毫秒；
    SdkErrorCode enableAudioVolumeIndication(int interval);
    
    /// 开始录制会场音视频
    SdkErrorCode startRecordConference(const char* record_name, bool need_record_video = false);
    
    /// 停止录制会场音视频
    SdkErrorCode stopRecordConference();

#ifdef WIN32
    //获取windows下可用媒体设备
	int getAvailableDeviceInfo(char**& deviceNames, int type);
    //设置媒体设备信息
	void setDeviceInfo(const char* deviceName, int type);
#endif
};
    
}

#endif