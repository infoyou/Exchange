//
//  QPlusSingleChatDelegate.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-27.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPlusRecordError.h"

@class QPlusMessage;

@protocol QPlusSingleChatDelegate <NSObject>

@optional
/**
 * 成功开始语音消息时的回调。成功的前提是录音时间大于1秒
 * @param voiceMessage 将要开始发送的语音消息的引用
 */
- (void)onStartVoice:(QPlusMessage *)voiceMessage;

/**
 * 在录音过程中，每次从缓冲区读出数据时的回调
 * @param voiceMessage 正在录制的语音消息的引用
 * @param dataSize 已经读取到的语音数据的总大小，单位byte
 * @param duration 已经读取到的语音数据的总长度，单位毫秒
 */
- (void)onRecording:(QPlusMessage *)voiceMessage size:(int)dataSize duration:(long)duration;

/**
 * 录音过程中出现错误的回调
 * @param error 错误类型的枚举值
 * <p>
 * @see RecordError
 */
- (void)onRecordError:(QPlusRecordError)error;

/**
 * 结束语音消息的回调
 * @param voiceMessage 正在发送的语音消息的引用
 */
- (void)onStopVoice:(QPlusMessage *)voiceMessage;

/**
 * 发送消息的回调
 * @param isSuccessful 发送消息的结果。YES为成功，NO为失败（超时、出现异常或者该用户不存在）
 * @param message 发送的消息的引用
 */
- (void)onSendMessage:(QPlusMessage *)message result:(BOOL)isSuccessful;

/**
 * 收到消息时的回调
 * @param message 收到的消息的引用
 */
- (void)onReceiveMessage:(QPlusMessage *)message;

@end
