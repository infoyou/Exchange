//
//  NSDecimalNumberHandler+JITIOSLib.m
//  JITIOSLib
//
//  Created by user on 13-3-19.
//
//

#import "NSDecimalNumberHandler+JITIOSLib.h"

static NSDecimalNumberHandler *_DEC_FLOOR_HANDLER = nil;
static NSDecimalNumberHandler *_SCALE4_ROUND_HANDLER = nil;

@implementation NSDecimalNumberHandler (JITIOSLib)
+ (NSDecimalNumberHandler *) decFloorHandler
{
	if(!_DEC_FLOOR_HANDLER) {
		_DEC_FLOOR_HANDLER = [[NSDecimalNumberHandler alloc]
							  initWithRoundingMode: NSRoundDown
							  scale:0
							  raiseOnExactness:NO
							  raiseOnOverflow:NO
							  raiseOnUnderflow:NO
							  raiseOnDivideByZero:NO];
	}
	return _DEC_FLOOR_HANDLER;
}

+ (NSDecimalNumberHandler *) scale4RoundHandler
{
	if(!_SCALE4_ROUND_HANDLER) {
		_SCALE4_ROUND_HANDLER = [[NSDecimalNumberHandler alloc]
								 initWithRoundingMode: NSRoundPlain
								 scale:4
								 raiseOnExactness:NO
								 raiseOnOverflow:NO
								 raiseOnUnderflow:NO
								 raiseOnDivideByZero:NO];
	}
	return _SCALE4_ROUND_HANDLER;
}
@end
