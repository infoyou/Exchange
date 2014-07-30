//
//  WXWStatement.h
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <sqlite3.h>

@interface WXWStatement : NSObject {
  sqlite3_stmt *stmt;
}

+ (id)statementWithDB:(sqlite3*)db query:(const char*)sql;
- (id)initWithDB:(sqlite3*)db query:(const char*)sql;

// method
- (int)step;
- (void)reset;

// Getter
- (NSString*)getString:(int)index;
- (int)getInt32:(int)index;
- (double)getDouble:(int)index;
- (long long)getInt64:(int)index;
- (NSData*)getData:(int)index;

// Binder
- (void)bindString:(NSString*)value forIndex:(int)index;
- (void)bindInt32:(int)value forIndex:(int)index;
- (void)bindInt64:(long long)value forIndex:(int)index;
- (void)bindData:(NSData*)value forIndex:(int)index;
- (void)bindDouble:(double)value forIndex:(int)index;
@end
