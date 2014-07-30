//
//  NSDateFormatter+JITIOSLib.m
//  JITIOSLib
//
//  Created by user on 13-3-18.
//
//

#import "NSDateFormatter+JITIOSLib.h"
static NSDateFormatter *_DATETIME_FMT = nil;
static NSDateFormatter *_DATE_FMT = nil;
static NSDateFormatter *_TIME_FMT = nil;
static NSDateFormatter *_TIMESTAMP_FMT = nil;

@implementation NSDateFormatter (JITIOSLib)
+ (NSDateFormatter *) defaultDateTimeFormatter
{
	if(!_DATETIME_FMT) {
		_DATETIME_FMT = [[NSDateFormatter alloc] init];
		_DATETIME_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
		_DATETIME_FMT.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
	}
	return _DATETIME_FMT;
}

+ (NSDateFormatter *) defaultDateFormatter
{
	if(!_DATE_FMT) {
		_DATE_FMT = [[NSDateFormatter alloc] init];
		_DATE_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
		_DATE_FMT.dateFormat = @"yyyy-MM-dd";
	}
	return _DATE_FMT;
}

+ (NSDateFormatter *) defaultTimeFormatter
{
	if(!_TIME_FMT) {
		_TIME_FMT = [[NSDateFormatter alloc] init];
		_TIME_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
		_TIME_FMT.dateFormat = @"HH:mm";
	}
	return _TIME_FMT;
}

+ (NSDateFormatter *) timestampFormatter
{
	if(!_TIMESTAMP_FMT) {
		_TIMESTAMP_FMT = [[NSDateFormatter alloc] init];
		_TIMESTAMP_FMT.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"Asia/Shanghai"];
		_TIMESTAMP_FMT.dateFormat = @"yyyyMMddHHmmssSSS";
	}
	return _TIMESTAMP_FMT;
}
@end
