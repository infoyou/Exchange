//
//  QPlusDataBase.m
//  TestQPlusAPI
//
//  Created by ouyang on 13-5-8.
//  Copyright (c) 2013年 AiLiao. All rights reserved.
//

#import "QPlusDataBase.h"

@implementation QPlusDataBase

static NSMutableDictionary *_groupMsgDictionary = nil;
static NSMutableDictionary *_friendMsgDictionary = nil;
static NSMutableArray *_chatList = nil;
static NSMutableArray *_friendList = nil;
static NSMutableArray *_messageStatus = nil;
static NSString *_loginUserID = nil;

+ (void)initialize {
    
    NSLog(@"QPlusDataBase initialize ");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _groupMsgDictionary = [[NSMutableDictionary alloc]init];
        _friendMsgDictionary = [[NSMutableDictionary alloc]init];
        _chatList = [[NSMutableArray alloc]init];
        _friendList = [[NSMutableArray alloc]init];
        _messageStatus = [[NSMutableArray alloc]init];
        
        [QPlusDataBase addToFriendList:NICKNAME_NOTICE];
        
        _currentFriend = [[NSString alloc] init];
        _loginUserID = [[NSString alloc] init];
    });
}

+ (void)clearDatabase
{
    [_groupMsgDictionary removeAllObjects];
    [_friendMsgDictionary removeAllObjects];
    [_chatList removeAllObjects];
    [_friendList removeAllObjects];
    [_messageStatus removeAllObjects];
    
    _inChat = NO;
    _currentFriend = nil;
    
    [QPlusDataBase addToFriendList:NICKNAME_NOTICE];
}

+ (NSArray *)getGroupMsgList:(NSString*)group {
    return _groupMsgDictionary[group];
}

+ (void)addGroupMsg:(QPlusMessage *)msg inGroup:(NSString*)group {
    NSMutableArray *array = _groupMsgDictionary[group];
    if (array) {
        [array addObject:msg];
    } else {
        array = [@[msg]mutableCopy];
        [_groupMsgDictionary setObject:array forKey:group];
    }
}

+ (NSArray *)getFriendMsgList:(NSString *)friendID {
    return _friendMsgDictionary[friendID];
}

+(void)markMessageStatus:(NSString*)userID status:(BOOL)inChat
{
    
    NSUInteger idx = [_friendList indexOfObject:userID];
    if(idx != NSNotFound ) {
        NSLog(@"idx is %d", idx);
        _messageStatus[idx] = [NSNumber numberWithBool:inChat];
    }
}

+ (void)addFriendMsg:(QPlusMessage *)msg withFriend:(NSString *)friendID {
    NSMutableArray *array = _friendMsgDictionary[friendID];
    if(!_inChat)
    {
        [QPlusDataBase markMessageStatus:friendID status:TRUE];
    }
    else
    {
        [QPlusDataBase markMessageStatus:friendID status:![friendID isEqualToString:_currentFriend]];
    }
    
    if (array) {
        [array addObject:msg];
    } else {
        array = [@[msg]mutableCopy];
        [_friendMsgDictionary setObject:array forKey:friendID];
    }
}

//陌生人
+ (NSArray *)getChatList {
    NSArray *array = [NSArray arrayWithArray:_chatList];
    return array;
}

+ (void)addToChatList:(NSString *)userID {
    [_chatList addObject:userID];
}

//好友
+ (void)initFriendList:(NSArray *)array {
    for(NSString *fid in array)
    {
        [QPlusDataBase addToFriendList:fid];
    }
}

+ (NSArray *)getFriendList {
    NSArray *array = [NSArray arrayWithArray:_friendList];
    return array;
}

+(BOOL)hasNewMessage:(NSString*)userID
{
    if(![_friendList containsObject:userID])
    {
        return FALSE;
    }
    
    NSUInteger idx = [_friendList indexOfObject:userID];
    return [_messageStatus[idx] boolValue];
}

static BOOL _inChat;
static NSString *_currentFriend;


+(void)setCurrentChatFriend:(NSString*)userID inChat:(BOOL)inChat
{
    _currentFriend = userID;
    _inChat = inChat;
    if(_inChat)
    {
        [QPlusDataBase markMessageStatus:userID status:FALSE];
    }
}

+ (BOOL)addToFriendList:(NSString *)userID
{
    if(![_friendList containsObject:userID])
    {
        [_friendList addObject:userID];
        [QPlusDataBase markMessageStatus:userID status:FALSE];
        
        return TRUE;
    }
    
    return FALSE;
}

+ (void)removeFromFriendList:(NSString *)userID {
    int idx = [_friendList indexOfObject:userID];
    [_friendList removeObject:userID];
    [_messageStatus removeObjectAtIndex:idx];
}

+ (BOOL)isFriend:(NSString *)userID {
    return [_friendList containsObject:userID];
}

+ (void)setLoginUserID:(NSString *)loginUserID {
    _loginUserID = [[NSString alloc]initWithString:loginUserID];
}

+ (NSString *)loginUserID {
    return _loginUserID;
}

@end
