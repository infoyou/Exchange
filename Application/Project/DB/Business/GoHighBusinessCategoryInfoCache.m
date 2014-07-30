//
//  GoHighBusinessCategoryInfoCache.m
//  Project
//
//  Created by XXX on 13-11-20.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GoHighBusinessCategoryInfoCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

#import "GlobalConstants.h"

@implementation GoHighBusinessCategoryInfoCache


-(void)upinsertBusinessCategories:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO businessCategoryInfo VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count ; ++i) {
        NSDictionary *cc = (NSDictionary *)[array objectAtIndex:i];
        
        [inserStmt bindInt32:[[cc objectForKey:@"param1"] integerValue ] forIndex:1];
        
        for (int j = 2; j <=20 ; j ++) {
            [inserStmt bindString:[cc objectForKey:[NSString stringWithFormat:@"param%d", j] ] forIndex:j];
        }
        
        [inserStmt bindDouble:[timestamp doubleValue] forIndex:21];
        [inserStmt bindInt32:0 forIndex:22];
        [inserStmt step];
        [inserStmt reset];
    }
    
    [inserStmt release];
}

-(double)getLatestBusinessCategoryTime
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from businessCategoryInfo  GROUP BY timestamp limit 1"];
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
