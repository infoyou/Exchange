//
//  NSNumber+CPOS.h
//  cpos
//
//  Created by user on 13-2-7.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (JITIOSLib)
- (NSDecimalNumber *) decimalNumber;
- (NSString *) stringValueFormatted0;
- (NSString *) stringValueFormatted;
- (NSString *) stringValueFormatted3;
- (BOOL) isGTEQ:(NSNumber *) number;
@end

#ifndef DEC_MACRO
#define DEC_MACRO

#define DECS(s) [NSDecimalNumber decimalNumberWithString:s]
#define DECI(i) [[NSNumber numberWithInt:i] decimalNumber]
#define DECF(i) [[NSNumber numberWithFloat:i] decimalNumber]
#define DECZERO [NSDecimalNumber zero]
#endif