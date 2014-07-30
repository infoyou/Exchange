//
//  NSDate+Utils.m
//  cpos
//
//  Created by Jang on 13-9-2.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSDate+Utils.h"
#import "NSDateFormatter+Utils.h"

@implementation NSDate (Utils)

+ (NSDate *)today {
    return [self date];
}

+ (NSDate *)dateFromString:(NSString *)string {
    return [[NSDateFormatter defaultsDateFormatter] dateFromString:string];
}

+ (NSDate *)dateTimeFromString:(NSString *)string {
    return [[NSDateFormatter defaultsDateTimeFormatter] dateFromString:string];
}

+ (NSDate *)dateTimeByEndMiniuteFromString:(NSString *)string {
    return [[NSDateFormatter defaultsDateTimeEndByMiniuteFormatter] dateFromString:string];
}

- (NSString *)defaultDateTimeEndByMiniuteStringWithType:(FormatType)type {
    return [[NSDateFormatter defaultsDateTimeEndByMiniuteFormatterWithType:type] stringFromDate:self];
}

- (NSString *)defaultDateStringWithType:(FormatType)type {
    return [[NSDateFormatter defaultsDateFormatterWithType:type] stringFromDate:self];
}

- (NSString *)defaultDateWipeYearWithType:(FormatType)type {
    return [[NSDateFormatter defaultsDateWipeYearFormatterWithType:type] stringFromDate:self];
}

@end
