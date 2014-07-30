//
//  NSDictionary+JITIOSLib.h
//  JITIPadQudao
//
//  Created by user on 13-4-10.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pair.h"

@interface NSDictionary (JITIOSLib)
- (id) objectForKey:(NSString *) key onNull:(id) nullValue;
- (NSString *) string:(NSString *) key;
- (NSString *) string:(NSString *) key onNull:(NSString *) nullValue;
- (NSNumber *) number:(NSString *) key;
- (NSNumber *) number:(NSString *) key onNull:(NSNumber *) nullValue;
- (int) integer:(NSString *) key;
- (int) integer:(NSString *) key onNull:(int) nullValue;
- (BOOL) boolean:(NSString *) key;
- (BOOL) boolean:(NSString *) key onNull:(BOOL) nullValue;
- (BOOL) hasValue:(id) value atKey:(NSString *) key;
- (BOOL) hasString:(NSString *) value atKey:(NSString *) key;
- (BOOL) nullAtKey:(NSString *) key;
- (BOOL) notNullAtKey:(NSString *) key;
- (NSArray *) stringsForKeys:(NSArray *) keys;
@end
