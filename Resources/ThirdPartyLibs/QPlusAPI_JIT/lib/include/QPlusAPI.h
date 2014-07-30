//
//  QPlusAPI.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-17.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

//#define SUPPORT_GROUP 1

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "QPlusRoom.h"
#import "QPlusMessage.h"
#import "QPlusWhineMode.h"
#import "QPlusImageObject.h"
#import "QPlusVoiceObject.h"
#import "QPlusRoomDelegate.h"
#if SUPPORT_GROUP
    #import "QPlusGroupDelegate.h"
    #import "QPlusChatTargetType.h"
#endif
#import "QPlusGeneralDelegate.h"
#import "QPlusProgressDelegate.h"
#import "QPlusPlaybackDelegate.h"

#define kKeyLoginServer     @"QPlusLoginServer"
#define kKeyLoginPort       @"QPlusLoginPort"

#define kKeyLoginServerValue     @"112.124.68.147"
//#define kKeyLoginServerValue     @"mo.fosun.com" // Exchange
#define kKeyLoginPortValue       8888

@interface QPlusAPI : NSObject

//使用获取到的key初始化SDK，appKey不能为空
+ (void)initWithAppKey:(NSString *)appKey;

//设置自定义的服务器地址和端口
+ (void)setLoginServer:(NSString *)host port:(NSInteger)port;

+ (void)addGeneralListener:(id<QPlusGeneralDelegate>)listener;
+ (void)removeGeneralListener:(id<QPlusGeneralDelegate>)listener;
+ (void)removeGeneralListeners;

+ (void)addSingleChatListener:(id<QPlusSingleChatDelegate>)listener;
+ (void)removeSingleChatListener:(id<QPlusSingleChatDelegate>)listener;
+ (void)removeSingleChatListeners;

#if SUPPORT_GROUP
+ (void)addGroupListener:(id<QPlusGroupDelegate>)listener;
+ (void)removeGroupListener:(id<QPlusGroupDelegate>)listener;
+ (void)removeGroupListeners;
#else
+ (void)addRoomListener:(id<QPlusRoomDelegate>)listener;
+ (void)removeRoomListener:(id<QPlusRoomDelegate>)listener;
+ (void)removeRoomListeners;
#endif

+ (void)removeAllListeners;

/** 登录接口*/

//登录sdk

//设置自动重连
+ (void)setAutoRelogin:(BOOL)flag;

//使用指定的用户昵称登录，参数不能为空
+ (void)loginWithUserID:(NSString *)userID;

//取消当前正在登录的连接
+ (void)cancelLogin;

//登出sdk，并释放资源
+ (void)logout;

//请求公告列表
+ (BOOL)reqNoticeList;

//请求好友列表
+ (BOOL)reqFriendList;

//添加好友
+ (BOOL)reqAddFriendWithID:(NSString *)friendID;

//删除好友
+ (BOOL)reqDeleteFriendWithID:(NSString *)friendID;

//向某个用户发送文字消息
+ (QPlusMessage *)sendText:(NSString *)text toUser:(NSString *)receiverID;

//向某个用户发送图片
//这里压缩图片可能会有点耗时，建议在非UI线程操作
+ (QPlusMessage *)sendPic:(UIImage *)image toUser:(NSString *)receiverID;

//向某个用户发送语音
+ (BOOL)startVoiceToUser:(NSString *)userID whineMode:(QPlusWhineMode)whineMode;

#if SUPPORT_GROUP

//请求指定群或者好友的历史聊天记录
+(int)reqHistoryMessagesByTargetID:(NSString*)tarID targetType:(QplusChatTargetType)type lastMessage:(QPlusMessage*)msg count:(int)count;

//在群里发送文字
+ (QPlusMessage *)sendText:(NSString *)text inGroup:(NSString *)groupID;

//在群里发送图片
+ (QPlusMessage *)sendPic:(UIImage *)image inGroup:(NSString *)groupID;

//在群里发送语音
+ (BOOL)startVoiceInGroup:(NSString *)groupID whineMode:(QPlusWhineMode)whineMode;

#else

//请求聊天室列表。pageIndex表示取第几页的聊天室列表，从0开始。页的大小为16.
+ (BOOL)reqRoomListAtPage:(NSUInteger)pageIndex;

//进入聊天室。roomID为聊天室的ID
+ (BOOL)enterRoomWithID:(long)roomID;

//不再提供
//请求聊天室里的用户列表，roomID为聊天室的ID。
//+ (BOOL)reqUserListInRoom:(long)roomID;

//离开聊天室，roomID为聊天室的ID。
+ (BOOL)leaveRoomWithID:(long)roomID;

//判断是否已经进入了指定房间
+ (BOOL)isRoomEntered:(long)roomID;

//在聊天室里发送文字
+ (QPlusMessage *)sendText:(NSString *)text inRoom:(long)roomID;

//在聊天室里发送图片
+ (QPlusMessage *)sendPic:(UIImage *)image inRoom:(long )roomID;

//在聊天室里发送语音
+ (BOOL)startVoiceInRoom:(long)roomID whineMode:(QPlusWhineMode)whineMode;

//不再提供
//向聊天室里某个用户发送私聊
//+ (QPlusMessage *)sendPrivateMsg:(NSString *)text toUser:(NSString *)receiverID inRoom:(long)roomID;

#endif//end of SUPPORT_GROUP

//停止当前语音
+ (void)stopVoice;

//下载大图或语音文件
+ (BOOL)downloadRes:(QPlusMessage *)message saveTo:(NSString *)savePath progressDelegate:(id)progressDelegate;

//播放指定路径的音频文件
+ (BOOL)startPlayVoice:(NSString *)voiceFilePath playbackDelegate:(id)delegate;

//停止播放音频文件
+ (void)stopPlayVoice;

@end
