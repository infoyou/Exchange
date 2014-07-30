//
//  AloneMarketingCache.m
//  Project
//
//  Created by XXX on 13-11-20.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "AloneMarketingCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"
#import "ChildSubCategory.h"

@implementation AloneMarketingCache
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO aloneMarketing VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}

    __block void (^blocksPrint)(NSArray *);
    
    blocksPrint = ^(NSArray *printArray){
        for (int i = 0; i < [printArray count]; ++i) {
            ChildSubCategory *cc = (ChildSubCategory *)[printArray objectAtIndex:i];
            
            [inserStmt bindString:[cc.param1 isEqual:[NSNull null]] ? @"-1" : cc.param1 forIndex:1];
            [inserStmt bindString:cc.param2 forIndex:2];
            [inserStmt bindString:cc.param3 forIndex:3];
            [inserStmt bindString:cc.param4 forIndex:4];
            [inserStmt bindString:cc.param5 forIndex:5];
            [inserStmt bindString:cc.param6 forIndex:6];
            [inserStmt bindString:cc.param7 forIndex:7];
            [inserStmt bindString:cc.param8 forIndex:8];
            [inserStmt bindString:cc.param9 forIndex:9];
            [inserStmt bindString:cc.param10 forIndex:10];
            [inserStmt bindString:cc.param11 forIndex:11];
            [inserStmt bindString:cc.param12 forIndex:12];
            [inserStmt bindString:cc.param13 forIndex:13];
            [inserStmt bindString:cc.param14 forIndex:14];
            [inserStmt bindString:cc.param15 forIndex:15];
            [inserStmt bindString:cc.param16 forIndex:16];
            [inserStmt bindString:cc.param17 forIndex:17];
            [inserStmt bindString:cc.param18 forIndex:18];
            [inserStmt bindString:cc.param19 forIndex:19];
            [inserStmt bindString:cc.param20 forIndex:20];
            [inserStmt bindString:[cc.parentId isEqual:[NSNull null]] ? @"-1" : cc.parentId forIndex:21];
            [inserStmt bindDouble:timestamp forIndex:22];
            [inserStmt bindInt32:0 forIndex:23];
            
            //ignore error
            [inserStmt step];
            [inserStmt reset];
            
            
            blocksPrint(cc.list1);
        }
    };
    
    blocksPrint(array);
    
    
    
    [inserStmt release];

}

-(double)getLatestAloneMarketingTime
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from aloneMarketing where isDelete = 0  order by timestamp desc limit 1"];
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
