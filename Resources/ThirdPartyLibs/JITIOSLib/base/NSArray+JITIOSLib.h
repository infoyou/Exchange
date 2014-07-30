//
//  NSArray+JITIOSLib.h
//  JITIPadQudao
//
//  Created by user on 13-4-27.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (JITIOSLib)
- (void) fillViewCollectionWithTexts:(NSArray *) values;
- (void) localizeViewCollection;
- (void) localizeUILabels;
- (void) localizeUILabelsWithKeys:(NSArray *) keys;
- (NSMutableArray *) mappedArrayUsingBlock:(id(^)(id)) block;
@end
