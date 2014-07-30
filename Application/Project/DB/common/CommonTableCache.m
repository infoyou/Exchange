//
//  CommonTableCache.m
//  Project
//
//  Created by Yfeng__ on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommonTableCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"


@implementation CommonTableCache

- (void)upinsertCommon:(NSString *)key value:(NSString *)value {
    WXWStatement *insertStmt = nil;
    
    if (insertStmt == nil) {
        insertStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO commonTable(commonKey, commonValue) VALUES(?,?)"];
        [insertStmt retain];
    }
    
    [insertStmt bindString:key forIndex:1];
    [insertStmt bindString:value forIndex:2];
    
    //ignore error
	[insertStmt step];
	[insertStmt reset];
    
    [insertStmt release];
}


-(NSString*)getCommon:(NSString *)key
{
    WXWStatement *queryStmt = nil;
    
    NSString *value = nil;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select commonValue from commonTable where  commonKey = ?"];
        [queryStmt retain];
    }
    
    [queryStmt bindString:key forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        value = [queryStmt getString:0];
    }
    
    [queryStmt reset];
    [queryStmt release];
    
    return value;

}

@end
