//
//  BookListCache.m
//  Project
//
//  Created by XXX on 13-11-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookListCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"

@implementation BookListCache

/*
 bookID integer,
 bookImage TEXT,
 bookTitle TEXT,
 bookCategory TEXT,
 clientID integer, 
 informationType integer, 
 lastUpdateTime TEXT,
 commendReason TEXT,
 zipURL TEXT,
 sortOrder integer,
 reader integer, 
 linkType integer, 
 link TEXT,
 comment integer,
 title TEXT, 
 timestamp double,
 isDelete integer
 */
- (void)upinsertBookListInfo:(NSArray *)array timestamp:(double)timestamp
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO bookList VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        BookList *book = (BookList *) [array objectAtIndex:i];
        /*
         bookID integer,
         bookImage TEXT,
         bookTitle TEXT,
         bookCategory TEXT,
         clientID integer,
         informationType integer,
         lastUpdateTime TEXT,
         commendReason TEXT,
         zipURL TEXT,
         sortOrder integer,
         reader integer,
         linkType integer,
         link TEXT,
         comment integer,
         title TEXT,
         timestamp double,
         isDelete integer
         */
        [inserStmt bindInt32:[book.bookID integerValue] forIndex:1];
        [inserStmt bindString:book.bookImage forIndex:2];
        [inserStmt bindString:book.bookTitle forIndex:3];
        [inserStmt bindString:book.bookCategory forIndex:4];
        [inserStmt bindInt32:[book.clientID integerValue] forIndex:5];
        [inserStmt bindInt32:[book.informationType integerValue] forIndex:6];
        [inserStmt bindString:book.lastUpdateTime forIndex:7];
        [inserStmt bindString:book.commendReason forIndex:8];
        [inserStmt bindString:book.zipURL forIndex:9];
        [inserStmt bindInt32:[book.sortOrder integerValue] forIndex:10];
        [inserStmt bindInt32:[book.reader integerValue] forIndex:11];
        [inserStmt bindInt32:[book.linkType integerValue] forIndex:12];
        [inserStmt bindString:book.link forIndex:13];
        [inserStmt bindInt32:[book.comment integerValue] forIndex:14];
        [inserStmt bindString:book.title forIndex:15];
        [inserStmt bindDouble:timestamp forIndex:16];
        [inserStmt bindInt32:[book.isDelete integerValue] forIndex:17];
        
        //ignore error
        [inserStmt step];
        [inserStmt reset];
    }
    
    
    [inserStmt release];
}
-(double)getLatestBookListTime
{

        WXWStatement *queryStmt = nil;
        
        double count=0;
        
        if (queryStmt == nil) {
            queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from bookList where isDelete = 0  order by timestamp desc limit 1"];
            [queryStmt retain];
        }
        
        if ([queryStmt step] == SQLITE_ROW) {
            count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
        }
        
        [queryStmt reset];
        [queryStmt release];
        
        return count;
        
    
}

- (BookList *)booklistWithBookId:(int)bookId {
    WXWStatement *queryStmt = nil;
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from bookList where bookID = ?"];
        [queryStmt release];
    }
    
    [queryStmt bindInt32:bookId forIndex:1];
    
    
}
@end
