//
//  NSDate+CPOS.m
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSDate+JITIOSLib.h"
#import "NSDateFormatter+JITIOSLib.h"

@implementation NSDate (JITIOSLib)
+ (NSString *) currentDateTimeString
{
	return [[NSDate date] dateTimeString];
}

+ (NSString *) currentDateString
{
	return [[NSDate date] dateString];
}

+ (NSString *) currentTimeString
{
	return [[NSDate date] timeString];
}

+ (NSDate *) dateFromDateTimeString:(NSString *) string
{
	return [[NSDateFormatter defaultDateTimeFormatter] dateFromString:string];
}

+ (NSDate *) dateFromDateString:(NSString *) string
{
	return [[NSDateFormatter defaultDateFormatter] dateFromString:string];
}

+ (NSDate *) dateFromTimeString:(NSString *) string
{
	return [[NSDateFormatter defaultTimeFormatter] dateFromString:string];
}

- (NSString *) dateTimeString
{
	return [[NSDateFormatter defaultDateTimeFormatter] stringFromDate:self];
}

- (NSString *) dateString
{
	return [[NSDateFormatter defaultDateFormatter] stringFromDate:self];
}

- (NSString *) longDateString
{
	return [NSString stringWithFormat:@"%@ 00:00:00.000", [self dateString]];
}

- (NSString *) timeString
{
	return [[NSDateFormatter defaultTimeFormatter] stringFromDate:self];
}

- (NSString *) timestampString
{
	return [[NSDateFormatter timestampFormatter] stringFromDate:self];
}

- (NSDateComponents *) calendarComponents
{
	return [[NSCalendar currentCalendar]
			components:NSYearCalendarUnit |
			NSMonthCalendarUnit |
			NSDayCalendarUnit |
			NSWeekCalendarUnit |
			NSWeekdayCalendarUnit
			fromDate:self];
}

- (NSDate *) beginingOfDay
{
	NSCalendar *cal = [NSCalendar currentCalendar];
	NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
	
    return [cal dateFromComponents:components];
}
@end
