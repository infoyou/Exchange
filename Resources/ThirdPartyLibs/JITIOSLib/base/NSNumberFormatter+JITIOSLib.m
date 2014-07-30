//
//  NSNumberFormatter+JITIOSLib.m
//  JITIOSLib
//
//  Created by user on 13-3-19.
//
//

#import "NSNumberFormatter+JITIOSLib.h"

static NSNumberFormatter *_ROUND0_FORMATTER = nil;
static NSNumberFormatter *_ROUND2_FORMATTER = nil;
static NSNumberFormatter *_ROUND3_FORMATTER = nil;

@implementation NSNumberFormatter (JITIOSLib)

+ (NSNumberFormatter *) round0NumberFormatter
{
	if(!_ROUND0_FORMATTER) {
        _ROUND0_FORMATTER = [[NSNumberFormatter alloc] init];
		[_ROUND0_FORMATTER setNumberStyle:NSNumberFormatterDecimalStyle];
		_ROUND0_FORMATTER.maximumFractionDigits = 0;
		_ROUND0_FORMATTER.minimumFractionDigits = 0;
		[_ROUND0_FORMATTER setRoundingMode: NSNumberFormatterRoundDown];
	}
	return _ROUND0_FORMATTER;
}

+ (NSNumberFormatter *) round2NumberFormatter
{
	if(!_ROUND2_FORMATTER) {
	_ROUND2_FORMATTER = [[NSNumberFormatter alloc] init];
		[_ROUND2_FORMATTER setNumberStyle:NSNumberFormatterDecimalStyle];
		_ROUND2_FORMATTER.maximumFractionDigits = 2;
		_ROUND2_FORMATTER.minimumFractionDigits = 2;
		[_ROUND2_FORMATTER setRoundingMode: NSNumberFormatterRoundDown];
	}
	return _ROUND2_FORMATTER;
}

+ (NSNumberFormatter *) round3NumberFormatter
{
	if(!_ROUND3_FORMATTER) {
		_ROUND3_FORMATTER = [[NSNumberFormatter alloc] init];
		[_ROUND3_FORMATTER setNumberStyle:NSNumberFormatterDecimalStyle];
		[_ROUND3_FORMATTER setMaximumFractionDigits:3];
		[_ROUND3_FORMATTER setRoundingMode: NSNumberFormatterRoundDown];
	}
	return _ROUND2_FORMATTER;
}
@end
