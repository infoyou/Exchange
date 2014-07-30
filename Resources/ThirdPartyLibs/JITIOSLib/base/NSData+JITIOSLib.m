//
//  NSData+JITIOSLib.m
//  JITIOSLib
//
//  Created by user on 13-3-12.
//
//

#import "NSData+JITIOSLib.h"

@implementation NSData (JITIOSLib)
- (NSString *) UTF8String
{
	return [[[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding] autorelease];
}
@end
