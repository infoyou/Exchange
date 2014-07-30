//
//  NSDateFormatter+JITIOSLib.h
//  JITIOSLib
//
//  Created by user on 13-3-18.
//
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (JITIOSLib)
+ (NSDateFormatter *) defaultDateTimeFormatter;
+ (NSDateFormatter *) defaultDateFormatter;
+ (NSDateFormatter *) defaultTimeFormatter;
@end
