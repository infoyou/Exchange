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

@end
