//
//  NSNumber+CPOS.m
//  cpos
//
//  Created by user on 13-2-7.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSNumber+JITIOSLib.h"
#import "NSNumberFormatter+JITIOSLib.h"

@implementation NSNumber (JITIOSLib)
- (NSDecimalNumber *) decimalNumber
{
	return [NSDecimalNumber decimalNumberWithDecimal:[self decimalValue]];
}

- (NSString *) stringValueFormatted0
{
	return [[NSNumberFormatter round0NumberFormatter] stringFromNumber:self];
}

- (NSString *) stringValueFormatted
{
	return [[NSNumberFormatter round2NumberFormatter] stringFromNumber:self];
}

- (NSString *) stringValueFormatted3
{
	return [[NSNumberFormatter round3NumberFormatter] stringFromNumber:self];
}

- (BOOL) isGTEQ:(NSNumber *) number
{
	assert(number);
	return [self compare:number] != NSOrderedAscending;
}
@end
