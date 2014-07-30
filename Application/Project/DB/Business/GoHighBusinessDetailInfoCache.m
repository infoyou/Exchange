//
//  GoHighBusinessDetailInfoCache.m
//  Project
//
//  Created by XXX on 13-11-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GoHighBusinessDetailInfoCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

#import "GlobalConstants.h"
#import "BusinessItemDetail.h"

@implementation GoHighBusinessDetailInfoCache

/*
 categoryID integer,
 parentID integer,
 timestamp double, 
 param1 TEXT, 
 param2 TEXT, 
 param3 TEXT, 
 param4 TEXT, 
 param5 TEXT, 
 param6 TEXT, 
 param7 TEXT, 
 param8 TEXT, 
 param9 TEXT, 
 param10 TEXT,
 isDelete int
 */
-(void)upinsertBusinessDetails:(NSDictionary *)contentDic timestamp:(NSString *)timestamp categoryID:(int)categoryID MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO businessDetailInfo VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    
#pragma mark ----
    __block void (^blocks)(NSDictionary*,NSMutableArray *,NSString *,int,int,  int);
    blocks = ^(NSDictionary *dict, NSMutableArray *afterArray,NSString *timestamp, int category, int parentId, int isDelete){
        NSArray *array =[dict objectForKey:@"list1"];
        
        BusinessItemDetail *cc = [[[BusinessItemDetail alloc] init] autorelease];
        cc.list1 = [[[NSMutableArray alloc] init] autorelease];
        [cc parserData:dict timestamp:timestamp categoryID:category parentID:parentId isDelete:0];
        
        [afterArray addObject:cc];
        if([array count]){
            for (int i = 0; i < [array count]; ++i) {
                blocks([array objectAtIndex:i],afterArray, cc.timestamp, cc.categoryID, [cc.param1 isEqual:[NSNull null]] ? parentId: [cc.param1 integerValue], cc.isDelete);
            }
        }
    };
    
    NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
    blocks(contentDic,arr, timestamp, categoryID, -1,0 );
    
#pragma mark -- save to db
    
    __block void (^blocksSaveToDB)(NSMutableArray *);
    
    blocksSaveToDB = ^(NSMutableArray *printArray){
        for (int i = 0; i < [printArray count]; ++i) {
            BusinessItemDetail *cc = (BusinessItemDetail *)[printArray objectAtIndex:i];

            DLog(@"%@", cc.param3);
            [inserStmt bindInt32:cc.categoryID forIndex:1];
            [inserStmt bindInt32:cc.parentID forIndex:2];
            [inserStmt bindDouble:[cc.timestamp doubleValue] forIndex:3];
            [inserStmt bindString:cc.param1 forIndex:4];
            [inserStmt bindString:cc.param2 forIndex:5];
            [inserStmt bindString:cc.param3 forIndex:6];
            [inserStmt bindString:cc.param4 forIndex:7];
            [inserStmt bindString:cc.param5 forIndex:8];
            [inserStmt bindString:cc.param6 forIndex:9];
            [inserStmt bindString:cc.param7 forIndex:10];
            [inserStmt bindString:cc.param8 forIndex:11];
            [inserStmt bindString:cc.param9 forIndex:12];
            [inserStmt bindString:cc.param10 forIndex:13];
            [inserStmt bindInt32:cc.isDelete forIndex:14];
            
            [inserStmt step];
            [inserStmt reset];
            
            blocksSaveToDB(cc.list1);
        }
    };
    
    blocksSaveToDB(arr);
    
    [inserStmt release];
}


-(double)getLatestBusinessDetailInfoTime:(int)projectId
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from businessDetailInfo where categoryID = ? GROUP BY timestamp limit 1"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:projectId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
    }
    
    [queryStmt reset];
    [queryStmt release];
    return count;

}


@end
