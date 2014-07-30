//
//  NSDateFormatter+Utils.m
//  cpos
//
//  Created by Jang on 13-9-2.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSDateFormatter+Utils.h"

static NSDateFormatter *DATE_FMT = nil;
static NSDateFormatter *DATETIME_FMT = nil;
static NSDateFormatter *DATETIME_MINIUTE_FMT = nil;
static NSDateFormatter *DATEWIPEYEAR_FMT = nil;

@implementation NSDateFormatter (Utils)

+ (NSDateFormatter *)defaultsDateFormatterWithType:(FormatType)type {
    if (!DATE_FMT) {
        DATE_FMT = [[NSDateFormatter alloc] init];
        DATE_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        if (type == FormatType_Default) {
            DATE_FMT.dateFormat = @"yyyy-MM-dd";
        }else if (type == FormatType_Han) {
            DATE_FMT.dateFormat = @"yyyy年MM月dd日";
        }
        
    }
    return DATE_FMT;
}

+ (NSDateFormatter *)defaultsDateWipeYearFormatterWithType:(FormatType)type {
    if (!DATEWIPEYEAR_FMT) {
        DATEWIPEYEAR_FMT = [[NSDateFormatter alloc] init];
        DATEWIPEYEAR_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        if (type == FormatType_Default) {
            DATEWIPEYEAR_FMT.dateFormat = @"MM-dd";
        }else if (type == FormatType_Han) {
            DATEWIPEYEAR_FMT.dateFormat = @"MM月dd日";
        }
        
    }
    return DATEWIPEYEAR_FMT;
}

+ (NSDateFormatter *)defaultsDateTimeFormatterWithType:(FormatType)type {
    if(!DATETIME_FMT) {
		DATETIME_FMT = [[NSDateFormatter alloc] init];
		DATETIME_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        
        if (type == FormatType_Default) {
            DATETIME_FMT.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        }else if (type == FormatType_Han) {
            DATETIME_FMT.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";

        }
		
	}
	return DATETIME_FMT;
}

+ (NSDateFormatter *)defaultsDateTimeEndByMiniuteFormatterWithType:(FormatType)type {
    if(!DATETIME_MINIUTE_FMT) {
		DATETIME_MINIUTE_FMT = [[NSDateFormatter alloc] init];
		DATETIME_MINIUTE_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        if (type == FormatType_Default) {
            DATETIME_MINIUTE_FMT.dateFormat = @"yyyy-MM-dd HH:mm";
        }else if (type == FormatType_Han) {
            DATETIME_MINIUTE_FMT.dateFormat = @"yyyy年MM月dd日 HH:mm";
        }
	}
	return DATETIME_MINIUTE_FMT;
}

+ (NSDateFormatter *)defaultsDateFormatter {
    if (!DATE_FMT) {
        DATE_FMT = [[NSDateFormatter alloc] init];
        DATE_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        DATE_FMT.dateFormat = @"yyyy-MM-dd";
        
    }
    return DATE_FMT;
}

+ (NSDateFormatter *)defaultsDateTimeFormatter {
    if(!DATETIME_FMT) {
		DATETIME_FMT = [[NSDateFormatter alloc] init];
		DATETIME_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        
        DATETIME_FMT.dateFormat = @"yyyy/MM/dd HH:mm:ss";

		
	}
	return DATETIME_FMT;
}

+ (NSDateFormatter *)defaultsDateTimeEndByMiniuteFormatter {
    if(!DATETIME_MINIUTE_FMT) {
		DATETIME_MINIUTE_FMT = [[NSDateFormatter alloc] init];
		DATETIME_MINIUTE_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        DATETIME_MINIUTE_FMT.dateFormat = @"yyyy-MM-dd HH:mm";

	}
	return DATETIME_MINIUTE_FMT;
}

+ (NSDateFormatter *)defaultsDateWipeYearFormatter {
    if(!DATEWIPEYEAR_FMT) {
		DATEWIPEYEAR_FMT = [[NSDateFormatter alloc] init];
		DATEWIPEYEAR_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
        DATEWIPEYEAR_FMT.dateFormat = @"MM-dd";
        
	}
	return DATEWIPEYEAR_FMT;
}

@end
