//
//  CommunicateGroupListCache.m
//  Project
//
//  Created by XXX on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicateGroupListCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

#import "GlobalConstants.h"
#import "ChatGroupDataModal.h"



@implementation CommunicateGroupListCache


/*
 userId TEXT,
 canChat integer, 
 canDelete integer,
 canInvite integer,
 canQuit integer, 
 canViewLog integer,
 displayIndex integer,
 groupDescription TEXT,
 groupEmail TEXT, 
 groupId integer, 
 groupImage TEXT, 
 groupName TEXT,
 groupPhone TEXT, 
 groupType integer,
 groupWebsite TEXT, 
 invitationPublicLevel integer,
 userCount integer, 
 userStatus integer, 
 auditNeededLevel integer,
 timestamp double,
 isDelete integer
 */
-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO communicateGroupList VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        ChatGroupDataModal *group = (ChatGroupDataModal *) [array objectAtIndex:i];

        /*
         userId TEXT,
         canChat integer,
         canDelete integer,
         canInvite integer,
         canQuit integer,
         canViewLog integer,
         displayIndex integer,
         groupDescription TEXT,
         groupEmail TEXT,
         groupId integer,
         groupImage TEXT,
         groupName TEXT,
         groupPhone TEXT,
         groupType integer,
         groupWebsite TEXT,
         invitationPublicLevel integer,
         userCount integer, 
         userStatus integer, 
         auditNeededLevel integer,
         timestamp double,
         isDelete integer
         */
        [inserStmt bindString:userId forIndex:1];
        [inserStmt bindInt32:[group.canChat integerValue] forIndex:2];
        [inserStmt bindInt32:[group.canDelete integerValue] forIndex:3];
        [inserStmt bindInt32:[group.canInvite integerValue] forIndex:4];
        [inserStmt bindInt32:[group.canQuit integerValue] forIndex:5];
        [inserStmt bindInt32:[group.canViewLog integerValue] forIndex:6];
        [inserStmt bindInt32:[group.displayIndex integerValue] forIndex:7];
        [inserStmt bindString:group.groupDescription forIndex:8];
        [inserStmt bindString:group.groupEmail forIndex:9];
        [inserStmt bindInt32:[group.groupId integerValue] forIndex:10];
        [inserStmt bindString:group.groupImage forIndex:11];
        [inserStmt bindString:group.groupName forIndex:12];
        [inserStmt bindString:group.groupPhone forIndex:13];
        [inserStmt bindInt32:[group.groupType integerValue] forIndex:14];
        [inserStmt bindString:group.groupWebsite forIndex:15];
        
        [inserStmt bindInt32:[group.invitationPublicLevel integerValue] forIndex:15];
        [inserStmt bindInt32:[group.userCount integerValue] forIndex:17];
        [inserStmt bindInt32:[group.userStatus integerValue] forIndex:18];
        [inserStmt bindInt32:[group.auditNeededLevel integerValue] forIndex:19];
        [inserStmt bindString:group.groupUserImageArray forIndex:20];
        [inserStmt bindString:group.groupUserIdArray forIndex:21];
        [inserStmt bindString:group.groupUserNameArray forIndex:22];
        
        [inserStmt bindDouble:[timestamp doubleValue] forIndex:23];
        [inserStmt bindInt32:0 forIndex:24];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    [inserStmt release];

}

-(void)updateGroupInfo:(ChatGroupDataModal *)data
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO communicateGroupList VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
}

- (int)getGroupIsDeleted:(NSString *)groupId
{
    WXWStatement *queryStmt = nil;
    
    int isDeleted=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select isDelete from communicateGroupList where groupId=?"];
		[queryStmt retain];
	}
    
	[queryStmt bindString:groupId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        isDeleted = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    return isDeleted;
}


-(void)deleteAllGroupListData
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"delete from communicateGroupList"];
		[inserStmt retain];
	}
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}
-(void)deleteGroup:(int)groupId
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update communicateGroupList set isDelete = 1 where groupId = ?"];
		[inserStmt retain];
	}
    
	[inserStmt bindInt32:groupId forIndex:1];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}

-(double)getLatestCommunicateGroupListTime
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from communicateGroupList  GROUP BY timestamp limit 1"];
        [queryStmt retain];
    }
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    
    return count;
}
@end
