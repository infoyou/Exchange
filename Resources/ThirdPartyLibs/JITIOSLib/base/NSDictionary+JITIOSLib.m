//
//  NSDictionary+JITIOSLib.m
//  JITIPadQudao
//
//  Created by user on 13-4-10.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSDictionary+JITIOSLib.h"

@implementation NSDictionary (JITIOSLib)

- (id) objectForKey:(NSString *) key onNull:(id) nullValue
{
	id v = [self objectForKey:key];
	return v == nil || v == [NSNull null] ? nullValue : v;
}

- (Pair *) entry:(NSString *) key
{
	id v = [self objectForKey:key];
	return v == nil ? nil : [Pair cons:key and:v];
}

- (Pair *) entry:(NSString *) key onNull:(id) nullValue;
{
	return [Pair cons:key and:[self objectForKey:key]];
}

- (NSString *) string:(NSString *) key
{
	return [self objectForKey:key onNull:nil];
}

- (NSString *) string:(NSString *) key onNull:(NSString *) nullValue
{
	return [self objectForKey:key onNull:nullValue];
}

- (NSNumber *) number:(NSString *) key
{
	return [self objectForKey:key onNull:nil];
}

- (NSNumber *) number:(NSString *) key onNull:(NSNumber *) nullValue
{
	return [self objectForKey:key onNull:nullValue];
}

- (int) integer:(NSString *) key
{
	return [self integer:key onNull:-1];
}

- (int) integer:(NSString *) key onNull:(int) nullValue
{
	id v = [self objectForKey:key];
	return (v == nil || v == [NSNull null]) ? nullValue : [v intValue];
}

- (BOOL) boolean:(NSString *) key
{
	return [self boolean:key onNull:NO];
}

- (BOOL) boolean:(NSString *) key onNull:(BOOL) nullValue
{
	id v = [self objectForKey:key];
	return (v == nil || v == [NSNull null]) ? nullValue : [v boolValue];
}

- (BOOL) hasString:(NSString *) value atKey:(NSString *) key
{
	NSString *v = [self objectForKey:key];
	return v == nil ? NO : [v isEqualToString:value];
}

- (BOOL) hasValue:(id) value atKey:(NSString *) key
{
	id v = [self objectForKey:key];
	return v == nil ? NO : [v isEqual:value];
}

- (BOOL) nullAtKey:(NSString *) key
{
	id v = [self objectForKey:key];
	return v == nil || v == [NSNull null];
}

- (BOOL) notNullAtKey:(NSString *) key
{
	return ![self nullAtKey:key];
}

- (NSArray *) stringsForKeys:(NSArray *) keys
{
	NSMutableArray *results = [NSMutableArray arrayWithCapacity:keys.count];
	for(NSString *key in keys) {
		[results addObject:[self string:key onNull:@""]];
	}
	return results;
}
@end
