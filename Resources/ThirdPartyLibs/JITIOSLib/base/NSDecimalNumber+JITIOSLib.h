//
//  NSDecimalNumber+CPOS.h
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (JITIOSLib)
+ (NSDecimalNumber *) decimalResultOfAdding:(NSNumber *) lhs to:(NSNumber *) rhs;
+ (NSDecimalNumber *) decimalResultOfSubstracting:(NSNumber *) lhs by:(NSNumber *) rhs;
+ (NSDecimalNumber *) decimalResultOfMultiplying:(NSNumber *) lhs by:(NSNumber *) rhs;
- (NSDecimalNumber *) decimalNumberByFlooring;
- (NSDecimalNumber *) decimalNumberByAddingOne;
- (NSDecimalNumber *) decimalNumberByTurningNegative;
@end
