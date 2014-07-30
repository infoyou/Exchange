//
//  QPlusRoomDelegate.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-27.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPlusSingleChatDelegate.h"

@class QPlusMessage;

@protocol QPlusRoomDelegate <QPlusSingleChatDelegate>

@optional
/**
 * 进入聊天室的回调
 * @param roomID 进入的聊天室的ID
 * @param isSuccessful 进入成功为YES，失败为NO（超时或者有异常）
 */
- (void)onEnterRoom:(long)roomID result:(BOOL)isSuccessful;

/**
 * 退出聊天室的回调
 * @param roomID 退出的聊天室的ID
 * @param isSuccessful 退出成功为YES，失败为NO（超时或者有异常）
 */
- (void)onLeaveRoom:(long)roomID result:(BOOL)isSuccessful;

@end
