//
//  NSString+CPOS.m
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import <CommonCrypto/CommonDigest.h>
#import "NSString+JITIOSLib.h"
#import "NSData+JITIOSLib.h"
#import "NSNumber+JITIOSLib.h"

static NSCharacterSet *_NON_DIGITS = nil;

@implementation NSString (JITIOSLib)
+ (NSString *) UUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	NSString *s = [(NSString *)string lowercaseString];
	CFRelease(theUUID);
	[(NSString *) string release];
	return s;
}

+ (NSString *) stringFromInt:(int) value
{
	return [[NSNumber numberWithInt:value] stringValue];
}

- (NSString *) MD5String
{
	const char *cStr = [self UTF8String];
	unsigned char digest[16];
	CC_MD5( cStr, strlen(cStr), digest );
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	return  output;
}

- (BOOL) isNumber
{
	if(!_NON_DIGITS) {
		_NON_DIGITS = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet] retain];
	}
	NSRange r = [self rangeOfCharacterFromSet:_NON_DIGITS];
	return r.location == NSNotFound;
}

- (NSString *) formattedNumberString
{
	return [[NSDecimalNumber decimalNumberWithString:self] stringValueFormatted];
}

- (NSString *) encodedURLString
{
	NSString* result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    [result autorelease];
    return result;
}

@end
