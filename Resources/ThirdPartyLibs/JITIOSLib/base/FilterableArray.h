//
//  FilterableArray.h
//  JITIPadQudao
//
//  Created by user on 13-4-18.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterableArray : NSObject
@property (retain, nonatomic) NSArray *array;
@property (retain, nonatomic) NSArray *filteredArray;
+ (FilterableArray *) filterableArrayWithArray:(NSArray *) array;
- (id) initWithArray:(NSArray *) array;
- (NSInteger) count;
- (id) objectAtIndex:(NSInteger) index;
- (void) filterUsingPredicate:(NSPredicate *) predicate;
- (NSMutableArray *) arrayOfKeysUsingBlock:(id(^)(id obj)) block;
- (void) reset;
- (BOOL) isResetted;
@end
