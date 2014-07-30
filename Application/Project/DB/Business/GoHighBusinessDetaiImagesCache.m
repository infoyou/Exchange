//
//  GoHighBusinessDetaiImagesCache.m
//  Project
//
//  Created by XXX on 13-11-17.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GoHighBusinessDetaiImagesCache.h"
#import "BusinessImageList.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

@implementation GoHighBusinessDetaiImagesCache


/*
 
 imageID integer,
 projectId integer,
 timestamp double, 
 imageURL TEXT,
 sortOrder integer, 
 target TEXT, 
 title TEXT,
 isDelete int
 
 */
-(void)upinsertBusinessDetailImages:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO businessDetailImages VALUES(?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        BusinessImageList *imageInfo = (BusinessImageList *) [array objectAtIndex:i];
        
        /*
         @property (nonatomic, retain) NSNumber * imageID;
         @property (nonatomic, retain) NSString * imageURL;
         @property (nonatomic, retain) NSNumber * sortOrder;
         @property (nonatomic, retain) NSString * target;
         @property (nonatomic, retain) NSString * title;
         @property (nonatomic, retain) NSNumber * projectId;
         */
        
        [inserStmt bindInt32:[imageInfo.imageID integerValue] forIndex:1];
        [inserStmt bindInt32:[imageInfo.projectId integerValue] forIndex:2];
        [inserStmt bindDouble:[timestamp doubleValue] forIndex:3];
        [inserStmt bindString:imageInfo.imageURL forIndex:4];
        [inserStmt bindInt32:[imageInfo.sortOrder integerValue] forIndex:5];
        [inserStmt bindString:imageInfo.target forIndex:6];
        [inserStmt bindString:imageInfo.title forIndex:7];
        [inserStmt bindInt32:0 forIndex:8];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
        
    }

    
    [inserStmt release];
}


-(double)getLatestBusinessDetailImageTime:(int)projectId
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from businessDetailImages where projectID = ? GROUP BY timestamp limit 1"];
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

-(NSMutableArray *)getAllImagesInfoByProjectId:(int)projectId
{
    
}

@end
