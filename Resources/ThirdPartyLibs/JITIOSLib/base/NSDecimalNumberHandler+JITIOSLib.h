//
//  NSDecimalNumberHandler+JITIOSLib.h
//  JITIOSLib
//
//  Created by user on 13-3-19.
//
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumberHandler (JITIOSLib)
+ (NSDecimalNumberHandler *) decFloorHandler;
+ (NSDecimalNumberHandler *) scale4RoundHandler;
@end
