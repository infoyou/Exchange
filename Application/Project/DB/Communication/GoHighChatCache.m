//
//  GoHighChatCache.m
//  Project
//
//  Created by XXX on 13-10-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GoHighChatCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "ChatModel.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"

@implementation GoHighChatCache

#pragma mark - life cycle methods
- (id)init {
	self = [super init];
    
    return self;
}

/*
 uuid TEXT PRIMARY KEY, resPath TEXT,resURL TEXT, thumbData blob 
 */

-(void)insertChatImageIntoDB:(QPlusMessage *)message
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO chatsImage VALUES(?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    QPlusImageObject *imageObject= (QPlusImageObject *)message.mediaObject;
    
	[inserStmt bindString:message.uuid forIndex:1];
	[inserStmt bindString:imageObject.resPath forIndex:2];
    [inserStmt bindString:imageObject.resURL forIndex:3];
    [inserStmt bindData:imageObject.thumbData forIndex:4];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}

/*uuid TEXT PRIMARY KEY, resPath TEXT,resID TEXT, duration long*/


-(void)insertChatVoiceIntoDB:(QPlusMessage *)message
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO chatsVoice VALUES(?,?,?,?)"];
		[inserStmt retain];
	}
    
    QPlusVoiceObject *voiceObject= (QPlusVoiceObject *)message.mediaObject;
    
	[inserStmt bindString:message.uuid forIndex:1];
	[inserStmt bindString:voiceObject.resPath forIndex:2];
    [inserStmt bindString:voiceObject.resID forIndex:3];
    [inserStmt bindInt64:voiceObject.duration forIndex:4];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}


/*
 uuid TEXT PRIMARY KEY,
 type integer,
 isRoomMsg BloB,
 data double,
 text TEXT,
 isPrivate Blob,
 senderID TEXT,
 receiverID text,"
 groupID text,
 */

- (void)insertChatIntoDB:(QPlusMessage *)message groupId:(NSString *)groupId isRead:(int)read{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO chats VALUES(?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
	[inserStmt bindString:message.uuid forIndex:1];
	[inserStmt bindInt32:message.type forIndex:2];
    [inserStmt bindInt32:message.isRoomMsg forIndex:3];
    [inserStmt bindDouble:message.date forIndex:4];
    [inserStmt bindString:message.text forIndex:5];
//    [inserStmt bindData:message.mediaObject forIndex:6];
    [inserStmt bindInt32:message.isPrivate forIndex:7];
    [inserStmt bindString:message.senderID forIndex:8];
    [inserStmt bindString:message.receiverID forIndex:9];
    [inserStmt bindString:groupId  forIndex:10];
    [inserStmt bindDouble:[CommonMethod getCurrentTimeSince1970] forIndex:11];
    [inserStmt bindInt32:read forIndex:12];

	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
    
    
    /*
     TEXT,
     //小图片消息
     SMALL_IMAGE,
     //大图片消息
     BIG_IMAGE,
     //语音消息
     VOICE,
     UNKNOWN
     */
    switch (message.type) {
        case SMALL_IMAGE:
        case BIG_IMAGE:
            [self insertChatImageIntoDB:message];
            break;
        case VOICE:
            [self insertChatVoiceIntoDB:message];
            
            break;
            
        default:
            break;
    }
}

/*
 0 uuid TEXT PRIMARY KEY,
 1 type integer,
 2 isRoomMsg BloB,
 3 data double,
 4 text TEXT,
 5 isPrivate Blob,
 6 senderID TEXT,
 7 receiverID text,"
 8 groupID text,
 */
-(ChatModel *)getGroupLastMessage:(NSString *)groupId
{
    WXWStatement *queryStmt = nil;
    
    ChatModel *dataModel = [[[ChatModel alloc] init] autorelease];
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select  * from chats where groupID = ?  and isRoomMsg = 1 order by data desc limit 1"];
		[queryStmt retain];
	}
	
	[queryStmt bindString:groupId forIndex:1];
    if ([queryStmt step] == SQLITE_ROW) {
        dataModel.date = NUMBER_DOUBLE([queryStmt getDouble:3]);
        dataModel.text = [queryStmt getString:4];
        dataModel.senderID = [queryStmt getString:7];
        dataModel.receiverID = [queryStmt getString:8];
        dataModel.groupID = groupId;
        dataModel.type = NUMBER([queryStmt getInt32:1]);
	}
    
	[queryStmt reset];
    [queryStmt release];
    return dataModel;
}


-(ChatModel *)getPrivateLastMessage:(NSString *)friendId userId:(NSString *)userId
{
     WXWStatement *queryStmt = nil;
    
    ChatModel *dataModel = [[[ChatModel alloc] init] autorelease];
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select  * from chats where isRoomMsg = 0 and ( (senderID = ? and receiverID = ? )  or (senderID = ? and receiverID = ? ))order by data desc limit 1"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:friendId forIndex:1];
	[queryStmt bindString:userId forIndex:2];
    
	[queryStmt bindString:userId forIndex:3];
	[queryStmt bindString:friendId forIndex:4];
    
    if ([queryStmt step] == SQLITE_ROW) {
        dataModel.type = NUMBER([queryStmt getInt32:1]);
        dataModel.date = NUMBER_DOUBLE([queryStmt getDouble:3]);
        dataModel.text = [queryStmt getString:4];
        dataModel.senderID = [queryStmt getString:7];
        dataModel.receiverID = [queryStmt getString:8];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return dataModel;
}


- (int)getNewMessageCount:(NSString *)id targetID:(NSString *)targetId isRoomMsg:(int)isRoomMsg
{
     WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(*) from chats where isRoomMsg = ? and isRead = 0 and ? = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:isRoomMsg forIndex:1];
	[queryStmt bindString:targetId forIndex:2];
	[queryStmt bindString:id forIndex:3];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return count;
}

-(int)getVoiceMessageListened:(QPlusMessage *)message
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select isRead from chats where type = ? and isRoomMsg = ? and data = ? and isPrivate = ? and senderID = ? and receiverID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:message.type forIndex:1];
	[queryStmt bindInt32:message.isRoomMsg forIndex:2];
	[queryStmt bindDouble:message.date forIndex:3];
	[queryStmt bindInt32:message.isPrivate forIndex:4];
	[queryStmt bindString:message.senderID forIndex:5];
	[queryStmt bindString:message.receiverID forIndex:6];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return count;
}

-(int)getGroupNewMessageCount:(NSString *)groupId userId:(NSString *)userId
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(*) from (select count(*) as cnt from (select * from chats order by data DESC LIMIT 20 ) where isRoomMsg = 1 and isRead = 0 and receiverID = ? and senderID != ? group by data)"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:groupId forIndex:1];
	[queryStmt bindString:userId forIndex:2];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return count;

    
}

-(int)getPrivateNewMessageCount:(NSString *)friendId userId:(NSString *)userId
{WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(*) from chats where isRoomMsg = 0 and isRead = 0 and senderID = ? and receiverID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:friendId forIndex:1];
	[queryStmt bindString:userId forIndex:2];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return count;

}

-(void)setVoiceMessageListened:(QPlusMessage *)messsage
{
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update chats set  isRead = 1 where type = ? and isRoomMsg = ? and data = ? and isPrivate = ? and senderID = ? and receiverID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:messsage.type forIndex:1];
	[queryStmt bindInt32:messsage.isRoomMsg forIndex:2];
	[queryStmt bindDouble:messsage.date forIndex:3];
	[queryStmt bindInt32:messsage.isPrivate forIndex:4];
	[queryStmt bindString:messsage.senderID forIndex:5];
	[queryStmt bindString:messsage.receiverID forIndex:6];
    
    if ([queryStmt step] == SQLITE_ROW) {
	}
    
	[queryStmt reset];
    [queryStmt release];

}

-(void)setGroupMessageReaded:(NSString *)groupId
{
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update chats set  isRead = 1 where isRoomMsg = 1 and receiverID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:groupId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
	}
    
	[queryStmt reset];
    [queryStmt release];
}

-(void)setPrivateMessageReaded:(NSString *)friendId
{
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update chats set  isRead = 1 where isRoomMsg = 0 and senderID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:friendId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
	}
    
	[queryStmt reset];
    [queryStmt release];
}


#pragma mark - WXWConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {

}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {

}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
   }

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
}

@end
