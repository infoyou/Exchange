//
//  EventDetailList.h
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventApplyList, EventImageDetailList;

@interface EventDetailList : NSManagedObject

@property (nonatomic, retain) NSNumber * applyCount;
@property (nonatomic, retain) NSNumber * applyStatus;
@property (nonatomic, retain) NSString * endTimeStr;
@property (nonatomic, retain) NSString * eventAddress;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * eventPurpose;
@property (nonatomic, retain) NSString * eventsType;
@property (nonatomic, retain) NSString * eventTheme;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSString * needVerfiy;
@property (nonatomic, retain) NSString * partakes;
@property (nonatomic, retain) NSString * startTimeStr;
@property (nonatomic, retain) NSString * zipURL;
@property (nonatomic, retain) NSSet *eventApplyList;
@property (nonatomic, retain) NSSet *eventImageDetailList;

- (void)updateData:(NSDictionary *)dic;

@end

@interface EventDetailList (CoreDataGeneratedAccessors)

- (void)addEventApplyListObject:(EventApplyList *)value;
- (void)removeEventApplyListObject:(EventApplyList *)value;
- (void)addEventApplyList:(NSSet *)values;
- (void)removeEventApplyList:(NSSet *)values;

- (void)addEventImageDetailListObject:(EventImageDetailList *)value;
- (void)removeEventImageDetailListObject:(EventImageDetailList *)value;
- (void)addEventImageDetailList:(NSSet *)values;
- (void)removeEventImageDetailList:(NSSet *)values;

@end
