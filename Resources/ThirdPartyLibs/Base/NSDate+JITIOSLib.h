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
- (NSString *) dateTimeString;
- (NSString *) timeString;
- (NSString *) dateString;
- (NSString *) longDateString;
- (NSDateComponents *) calendarComponents;
@end
