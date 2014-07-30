//
//  EventList.h
//  Project
//
//  Created by XXX on 13-12-13.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"


@class EventApplyList, EventImageList;

@interface EventList : NSManagedObject

@property (nonatomic, retain) NSNumber * applyCheck;
@property (nonatomic, retain) NSNumber * applyCount;
@property (nonatomic, retain) NSNumber * applyStatus;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSNumber * endTime;
@property (nonatomic, retain) NSString * endTimeStr;
@property (nonatomic, retain) NSString * eventAddress;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSString * eventPurpose;
@property (nonatomic, retain) NSString * eventTheme;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSString * eventUrl;
@property (nonatomic, retain) NSString * partakes;
@property (nonatomic, retain) NSNumber * startTime;
@property (nonatomic, retain) NSString * startTimeStr;
@property (nonatomic, retain) NSString * zipUrl;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSSet *eventApplyList;
@property (nonatomic, retain) NSSet *eventImageList;

- (void)updateData:(NSDictionary *)dic withType:(NSInteger)type;
-(void)updateDataWithStmt:(WXWStatement *)stmt;
@end

@interface EventList (CoreDataGeneratedAccessors)

- (void)addEventApplyListObject:(EventApplyList *)value;
- (void)removeEventApplyListObject:(EventApplyList *)value;
- (void)addEventApplyList:(NSSet *)values;
- (void)removeEventApplyList:(NSSet *)values;

- (void)addEventImageListObject:(EventImageList *)value;
- (void)removeEventImageListObject:(EventImageList *)value;
- (void)addEventImageList:(NSSet *)values;
- (void)removeEventImageList:(NSSet *)values;

@end
