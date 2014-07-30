//
//  EventVoteList.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventOptionList;

@interface EventVoteList : NSManagedObject

@property (nonatomic, retain) NSString * voteTitle;
@property (nonatomic, retain) NSNumber * voteFlag;
@property (nonatomic, retain) NSNumber * voteId;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSSet *displayIndex;

- (void)updateData:(NSDictionary *)dic;

@end

@interface EventVoteList (CoreDataGeneratedAccessors)

- (void)addDisplayIndexObject:(EventOptionList *)value;
- (void)removeDisplayIndexObject:(EventOptionList *)value;
- (void)addDisplayIndex:(NSSet *)values;
- (void)removeDisplayIndex:(NSSet *)values;

@end
