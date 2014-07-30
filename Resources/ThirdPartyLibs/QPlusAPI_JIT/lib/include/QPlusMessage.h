//
//  QPlusMessage.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-23.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    //普通文本消息
    TEXT,
    //小图片消息
    SMALL_IMAGE,
    //大图片消息
    BIG_IMAGE,
    //语音消息
    VOICE,
    UNKNOWN
}QPlusMessageType;

@interface QPlusMessage : NSObject

//自动创建
@property (nonatomic, readonly) NSString *uuid;

@property (nonatomic, assign) QPlusMessageType type;
@property (nonatomic, assign) BOOL isRoomMsg;
@property (nonatomic, assign) long date;
@property (nonatomic, assign) int msgid;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) id mediaObject;
@property (nonatomic, assign, setter = setPrivate:) BOOL isPrivate;
@property (nonatomic, copy) NSString *senderID;
@property (nonatomic, copy) NSString *receiverID;

@end
