//
//  CircleMarketingCahce.m
//  Project
//
//  Created by XXX on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingCahce.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"
#import "EventList.h"
#import "EventImageList.h"
#import "EventApplyList.h"

@implementation CircleMarketingCahce

/*
 eventId integer,
 imageIndex integer,
 imageType integer, 
 url TEXT,
 isDelete integer
 */
-(void)upinsertEventImageList:(EventList *)eventList
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO circleMarketingImage VALUES(?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    int index = 0;
    for (EventImageList *imageInfo in eventList.eventImageList) {
        
        [inserStmt bindInt32:[eventList.eventId integerValue] forIndex:1];
        [inserStmt bindInt32:++index forIndex:2];
        [inserStmt bindInt32:-1 forIndex:3];
        [inserStmt bindString:imageInfo.imageUrl forIndex:4];
        [inserStmt bindInt32:0 forIndex:5];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    [inserStmt release];
}


/*
 eventId integer,
 applyId integer,
 applyResult TEXT,
 applyTitle TEXT,
 isDelete integer
 */
-(void)upinsertEventApplyList:(EventList *)eventList
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO circleMarketingApply VALUES(?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (EventApplyList *apply in eventList.eventApplyList) {
        
        [inserStmt bindInt32:[eventList.eventId integerValue] forIndex:1];
        [inserStmt bindInt32:[apply.applyId integerValue] forIndex:2];
        [inserStmt bindString:apply.applyResult forIndex:3];
        [inserStmt bindString:apply.applyTitle forIndex:4];
        [inserStmt bindInt32:0 forIndex:5];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    [inserStmt release];
}

/*
 eventId integer,
 applyCount integer,
 displayIndex integer,
 endTime double,
 endTimeStr TEXT,
 eventAddress TEXT,
 eventDescription TEXT,
 eventTitle TEXT,
 param1 TEXT,
 param2 TEXT,
 param3 TEXT,
 startTime double,
 startTimeStr TEXT,
 timestamp double,
 isDelete integer
 */
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO circleMarketingInfo VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        EventList *info = (EventList *) [array objectAtIndex:i];
        
        [self upinsertEventImageList:info];
        [self upinsertEventApplyList:info];

        [inserStmt bindInt32:[info.eventId integerValue] forIndex:1];
        [inserStmt bindInt32:[info.applyCount integerValue] forIndex:2];
        [inserStmt bindInt32:[info.displayIndex integerValue] forIndex:3];
        [inserStmt bindDouble:[info.endTime doubleValue] forIndex:4];
        [inserStmt bindString:info.endTimeStr forIndex:5];
        [inserStmt bindString:info.eventAddress forIndex:6];
        [inserStmt bindString:info.eventDescription forIndex:7];
        [inserStmt bindString:info.eventTitle forIndex:8];
        [inserStmt bindString:info.eventTheme forIndex:9];
        [inserStmt bindString:info.eventPurpose forIndex:10];
        [inserStmt bindString:info.partakes forIndex:11];
        [inserStmt bindDouble:[info.startTime doubleValue] forIndex:12];
        [inserStmt bindString:info.startTimeStr forIndex:13];
        [inserStmt bindString:info.eventUrl forIndex:14];
        [inserStmt bindInt32:[info.eventType integerValue] forIndex:15];
        [inserStmt bindInt32:[info.applyCheck integerValue] forIndex:16];
        [inserStmt bindString:info.zipUrl forIndex:17];
        [inserStmt bindInt32:[info.applyStatus integerValue] forIndex:18];
        [inserStmt bindDouble:timestamp forIndex:19];
        [inserStmt bindInt32:[info.isDelete integerValue] forIndex:20];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    
    [inserStmt release];

}

-(double)getLatestCircleMarketingTime:(int)type
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from circleMarketingInfo where isDelete = 0 and eventType = ? order by timestamp desc limit 1"];
        [queryStmt retain];
    }
        
    [queryStmt bindInt32:type forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return count;
}
@end
