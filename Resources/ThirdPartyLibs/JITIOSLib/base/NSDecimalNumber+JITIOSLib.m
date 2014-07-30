//
//  NSDecimalNumber+CPOS.m
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import "NSDecimalNumber+JITIOSLib.h"
#import "NSDecimalNumberHandler+JITIOSLib.h"

@implementation NSDecimalNumber (JITIOSLib)
+ (NSDecimalNumber *) decimalResultOfAdding:(NSNumber *) lhs to:(NSNumber *) rhs
{
	return [[NSDecimalNumber decimalNumberWithDecimal:[lhs decimalValue]]
			decimalNumberByAdding:[NSDecimalNumber decimalNumberWithDecimal:[rhs decimalValue]]];
}

+ (NSDecimalNumber *) decimalResultOfSubstracting:(NSNumber *) lhs by:(NSNumber *) rhs
{
	return [[NSDecimalNumber decimalNumberWithDecimal:[lhs decimalValue]]
			decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithDecimal:[rhs decimalValue]]];
}

+ (NSDecimalNumber *) decimalResultOfMultiplying:(NSNumber *) lhs by:(NSNumber *) rhs
{
	return [[NSDecimalNumber decimalNumberWithDecimal:[lhs decimalValue]]
			decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[rhs decimalValue]]];
}

- (NSDecimalNumber *) decimalNumberByFlooring
{
	return [self decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumberHandler decFloorHandler]];
}

- (NSDecimalNumber *) decimalNumberByAddingOne
{
	return [self decimalNumberByAdding:[NSDecimalNumber one]];
}

- (NSDecimalNumber *) decimalNumberByTurningNegative
{
	return [self decimalNumberByMultiplyingBy:
			[NSDecimalNumber decimalNumberWithMantissa: 1
											  exponent: 0
											isNegative: YES]];
}
@end
