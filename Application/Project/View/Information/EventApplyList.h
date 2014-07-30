//
//  EventApplyList.h
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventDetailList, EventList;

@interface EventApplyList : NSManagedObject

@property (nonatomic, retain) NSNumber * applyId;
@property (nonatomic, retain) NSString * applyResult;
@property (nonatomic, retain) NSString * applyTitle;
@property (nonatomic, retain) EventDetailList *eventDetailList;
@property (nonatomic, retain) EventList *eventList;

@end
