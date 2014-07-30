//
//  QPlusGeneralDelegate.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-27.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPlusLoginError.h"
#import "QPlusChatTargetType.h"

@class QPlusMessage;

@protocol QPlusGeneralDelegate <NSObject>

@optional
/**
 * 登录成功时的回调
 */
- (void)onLoginSuccess:(BOOL)isRelogin;

/**
 * 登录失败时的回调调用
 * @param error 失败原因：TIMEOUT、NETWORK_DISCONNECT或者VERIFY_FAILED
 */
- (void)onLoginFailed:(QPlusLoginError)error;

/**
 * 登录取消时的回调
 */
- (void)onLoginCanceled;

/**
 * 用户登出时的回调
 * @param error 登出的原因：FORCE_LOGOUT或者NETWORK_DISCONNECT,
 * 	nil则表示用户正常登出
 */
- (void)onLogout:(QPlusLoginError)error;

/**
 * 添加好友的回调
 * @param friendID 添加的好友的ID
 * @param isSuccessful YES为成功, NO为失败
 */
- (void)onAddFriend:(NSString*)friendID result:(BOOL)isSuccessful;

/**
 * 删除好友的回调
 * @param friendID 删除的好友的ID
 * @param isSuccessful YES为成功, NO为失败
 */
- (void)onDeleteFriend:(NSString*)friendID result:(BOOL)isSuccessful;

/**
 * 获取好友列表的回调
 * @param friendList 获取到的好友列表。nil表示获取失败，空数组表示没有好友
 */
- (void)onGetFriendList:(NSArray *)friendList;

/**
 * 获取群列表的回调
 * @param roomList 获取到的聊天室列表。nil表示获取失败，空数组表示没有聊天室存在
 */
- (void)onGetRoomList:(NSArray *)roomList;

/**
 * 获取资源（语音或者大图片）的回调
 * @param message 对应的消息。如果获取成功， 则message.mediaObject != nil，下载到的语音或者图片保存的路径为QPlusVoiceObject或者QPlusImageObject的resPath。
 * @param isSuccessful YES表示成功，NO表示失败
 */
- (void)onGetRes:(QPlusMessage *)message result:(BOOL)isSuccessful;

/**
 * 获取公告的回调
 * @param noticeList 获取到的公告列表, 数组元素类型：[QPlusMessage*]。nil表示获取失败，空数组表示没有公告
 */
- (void)onGetNoticeList:(NSArray *)noticeList;

#if SUPPORT_GROUP
/**
 * 获取历史聊天消息列表的回调
 * @param type 
 * @param msgList 获取到的历史聊天消息列表, 数组元素类型：[QPlusMessage*]。nil表示获取失败，空数组表示没有消息
 */
- (void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString*)tarID;

#endif

/**
 * 当有新公告发布时的回调。这时候，需要调用reqGetNoticeList去服务器获取新的公告
 *
 */
- (void)onNewNotice;

@end
