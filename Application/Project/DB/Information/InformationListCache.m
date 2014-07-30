//
//  InformationListCache.m
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "InformationListCache.h"
#import "InformationList.h"
#import "GlobalConstants.h"

@implementation InformationListCache


/*
 informationID integer,
 title TEXT, 
 lastUpdateTime TEXT,
 clientID integer,
 zipURL TEXT,
 htmlURL TEXT, 
 sortOrder integer,
 comment integer , 
 reader integer , 
 linkType integer, 
 link TEXT,
 informationType integer,
 isDelete integer
 */
- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO infoList VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        InformationList *info = (InformationList *) [array objectAtIndex:i];
        [inserStmt bindInt32:[info.informationID integerValue] forIndex:1];
        [inserStmt bindString:info.title forIndex:2];
        [inserStmt bindString:info.lastUpdateTime forIndex:3];
        [inserStmt bindInt32:[info.clientID integerValue] forIndex:4];
        [inserStmt bindString:info.zipURL forIndex:5];
        [inserStmt bindString:info.htmlURL forIndex:6];
        [inserStmt bindInt32:[info.sortOrder integerValue] forIndex:7];
        [inserStmt bindInt32:[info.comment integerValue] forIndex:8];
        [inserStmt bindInt32:[info.reader integerValue] forIndex:9];
        [inserStmt bindInt32:[info.linkType integerValue] forIndex:10];
        [inserStmt bindString:info.link forIndex:11];
        [inserStmt bindInt32:[info.informationType integerValue] forIndex:12];
        [inserStmt bindDouble:timestamp forIndex:13];
        [inserStmt bindInt32:[info.isDelete integerValue] forIndex:14];

        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    
    [inserStmt release];
}


-(double)getLatestInfomationTimestamp
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select lastUpdateTime from infoList where isDelete = 0  order by lastUpdateTime desc limit 1"];
        [queryStmt retain];
    }
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;
    
}



-(double)getOldestInfomationTimestamp
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select lastUpdateTime from infoList where isDelete = 0  order by lastUpdateTime asc limit 1"];
        [queryStmt retain];
    }
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;
    
}


-(void)deleteOldInfomationFromTimestamp:(NSString *)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update infoList set isDelete = 1 where lastUpdateTime < ?"];
		[inserStmt retain];
	}
    
	[inserStmt bindString:timestamp forIndex:1];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}


- (void)updateInformationCommentCount:(int)infoId count:(int)count
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update infoList set comment = ? where informationID = ?"];
		[inserStmt retain];
	}
    
    [inserStmt bindInt32:count forIndex:1];
    [inserStmt bindInt32:infoId forIndex:2];

    [inserStmt step];
    [inserStmt reset];
    [inserStmt release];

}

-(void)updateInformationCommentReader:(int)infoId count:(int)count
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update infoList set reader = ? where informationID = ?"];
		[inserStmt retain];
	}
    
    [inserStmt bindInt32:count forIndex:1];
    [inserStmt bindInt32:infoId forIndex:2];
    
    [inserStmt step];
    [inserStmt reset];
    [inserStmt release];
}


- (int)getInformationCommentCount:(int)infoId
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select comment from infoList where informationID = ?"];
        [queryStmt retain];
    }

    [queryStmt bindInt32:infoId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;

}
-(int)getInformationCommentReader:(int)infoId
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select reader from infoList where informationID = 2"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:infoId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;
}

@end
