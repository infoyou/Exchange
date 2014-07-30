//
//  NSString+CPOS.h
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INTSTRING(n) [NSString stringFromInt:n]
#define SPRINTF(fmt,...) [NSString stringWithFormat:fmt,##__VA_ARGS__]
@interface NSString (JITIOSLib)
+ (NSString *) UUID;
+ (NSString *) stringFromInt:(int) value;
- (NSString *) MD5String;
- (BOOL) isNumber;
- (NSString *) formattedNumberString;
- (NSString *) encodedURLString;
@end
