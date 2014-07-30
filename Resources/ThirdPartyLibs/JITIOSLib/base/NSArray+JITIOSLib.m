//
//  NSArray+JITIOSLib.m
//  JITIPadQudao
//
//  Created by user on 13-4-27.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSArray+JITIOSLib.h"

@implementation NSArray (JITIOSLib)
- (void) fillViewCollectionWithTexts:(NSArray *) values
{
	[self enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
		*stop = idx >= values.count;
		if(!*stop && [view respondsToSelector:@selector(setText:)]) {
			[view setText:[values objectAtIndex:idx]];
		}
	}];
}

- (void) localizeViewCollection
{
	[self enumerateObjectsUsingBlock:^(id view, NSUInteger idx, BOOL *stop) {
		if( [view respondsToSelector:@selector(text)]
		   && [view respondsToSelector:@selector(setText:)]) {
			[view setText:NSLocalizedString([view text], nil)];
		}
	}];
}

- (void) localizeUILabels
{
	[self enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
		[label setText:NSLocalizedString([label text], nil)];
	}];
}

- (void) localizeUILabelsWithKeys:(NSArray *) keys
{
	[self enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
		*stop = idx >= keys.count;
		if(!*stop) {
			[label setText:NSLocalizedString([keys objectAtIndex:idx], nil)];
		}
	}];
}

- (NSMutableArray *) mappedArrayUsingBlock:(id(^)(id)) block
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id result = block(obj);
		if(result)
			[array addObject:result];
	}];
	return array;
}
@end
