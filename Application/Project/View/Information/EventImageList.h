//
//  EventImageList.h
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EventDetailList, EventList;

@interface EventImageList : NSManagedObject

@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * imageType;
@property (nonatomic, retain) EventList *eventList;
@property (nonatomic, retain) EventDetailList *eventDetailList;

- (void)updateData:(NSDictionary *)dic withType:(NSInteger)type;

@end
