//
//  NSDate+Utils.h
//  cpos
//
//  Created by Jang on 13-9-2.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@interface NSDate (Utils)

+ (NSDate *)today;
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateTimeFromString:(NSString *)string;
+ (NSDate *)dateTimeByEndMiniuteFromString:(NSString *)string;

- (NSString *)defaultDateTimeEndByMiniuteStringWithType:(FormatType)type;
- (NSString *)defaultDateStringWithType:(FormatType)type;
- (NSString *)defaultDateWipeYearWithType:(FormatType)type;

@end
