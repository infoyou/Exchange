//
//  InformationImageWallCache.m
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "InformationImageWallCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "ImageList.h"
#import "GlobalConstants.h"

@implementation InformationImageWallCache


/*
 imageID integer,
 imageURL TEXT, 
 sortOrder integer,
 target TEXT, 
 title TEXT,
 timestamp double,
 isDelete int
 */
- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO infoScrollWallImages VALUES(?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        ImageList *imageInfo = (ImageList *) [array objectAtIndex:i];
        
        [inserStmt bindInt32:[imageInfo.imageID integerValue] forIndex:1];
        [inserStmt bindString:imageInfo.imageURL forIndex:2];
        [inserStmt bindInt32:[imageInfo.sortOrder integerValue] forIndex:3];
        [inserStmt bindString:imageInfo.target forIndex:4];
        [inserStmt bindString:imageInfo.title forIndex:5];
        [inserStmt bindDouble:timestamp forIndex:6];
        [inserStmt bindInt32:[imageInfo.isDelete integerValue] forIndex:7];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    
    [inserStmt release];
}


-(double)getLatestInfoImageWallTime
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from infoScrollWallImages where isDelete = 0  order by timestamp desc limit 1"];
        [queryStmt retain];
    }
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;

}
@end
