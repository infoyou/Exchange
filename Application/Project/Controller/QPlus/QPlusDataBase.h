//
//  QPlusDataBase.h
//  TestQPlusAPI
//
//  Created by ouyang on 13-5-8.
//  Copyright (c) 2013年 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NICKNAME_NOTICE     @"公告"

@class QPlusMessage;

@interface QPlusDataBase : NSObject

+ (void)initialize;

+ (void)clearDatabase;

+(void)setCurrentChatFriend:(NSString*)userID inChat:(BOOL)inChat;

+(BOOL)hasNewMessage:(NSString*)userID;

+ (NSArray *)getGroupMsgList:(NSString*)group;
+ (void)addGroupMsg:(QPlusMessage *)msg inGroup:(NSString*)group;

+ (NSArray *)getFriendMsgList:(NSString *)friendID;
+ (void)addFriendMsg:(QPlusMessage *)msg withFriend:(NSString *)friendID;

//陌生人
+ (NSArray *)getChatList;
+ (void)addToChatList:(NSString *)userID;

//好友
+ (void)initFriendList:(NSArray *)array;
+ (NSArray *)getFriendList;
+ (BOOL)addToFriendList:(NSString *)userID;
+ (void)removeFromFriendList:(NSString *)userID;
+ (BOOL)isFriend:(NSString *)userID;

+ (void)setLoginUserID:(NSString *)loginUserID;
+ (NSString *)loginUserID;

@end
