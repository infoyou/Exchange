//
//  NSDate+CPOS.h
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JITIOSLib)
+ (NSString *) currentDateTimeString;
+ (NSString *) currentDateString;
+ (NSString *) currentTimeString;
+ (NSDate *) dateFromDateTimeString:(NSString *) string;
+ (NSDate *) dateFromDateString:(NSString *) string;
+ (NSDate *) dateFromTimeString:(NSString *) string;
- (NSDate *) beginingOfDay;
- (NSString *) dateTimeString;
- (NSString *) timeString;
- (NSString *) dateString;
- (NSString *) longDateString;
- (NSString *) timestampString;
- (NSDateComponents *) calendarComponents;
@end
