//
//  FilterableArray.m
//  JITIPadQudao
//
//  Created by user on 13-4-18.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "FilterableArray.h"

@implementation FilterableArray

+ (FilterableArray *) filterableArrayWithArray:(NSArray *) array
{
	return [ [[FilterableArray alloc] initWithArray:array] autorelease];
}

- (id) initWithArray:(NSArray *) array
{
    self = [super init];
    if (self) {
        self.array = array;
		self.filteredArray = array;
    }
    return self;
}

- (void)dealloc
{
    [_filteredArray release];
	[_array release];
    [super dealloc];
}

- (NSInteger) count
{
	return self.filteredArray.count;
}

- (id) objectAtIndex:(NSInteger) index
{
	return [self.filteredArray objectAtIndex:index];
}

- (void) filterUsingPredicate:(NSPredicate *) predicate
{
	self.filteredArray = [self.array filteredArrayUsingPredicate:predicate];
}

- (void) reset
{
	self.filteredArray = self.array;
}

- (BOOL) isResetted
{
	return self.filteredArray == self.array;
}

- (NSMutableArray *) arrayOfKeysUsingBlock:(id(^)(id obj)) block
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
	[self.array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id key = block(obj);
		if(key && ![array containsObject:key])
			[array addObject:key];
	}];
	return array;
}
@end
