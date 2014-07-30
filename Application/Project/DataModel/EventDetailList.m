//
//  EventDetailList.m
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventDetailList.h"
#import "EventApplyList.h"
#import "EventImageDetailList.h"


@implementation EventDetailList

@dynamic applyCount;
@dynamic applyStatus;
@dynamic endTimeStr;
@dynamic eventAddress;
@dynamic eventDescription;
@dynamic eventId;
@dynamic eventPurpose;
@dynamic eventsType;
@dynamic eventTheme;
@dynamic eventTitle;
@dynamic needVerfiy;
@dynamic partakes;
@dynamic startTimeStr;
@dynamic zipURL;
@dynamic eventApplyList;
@dynamic eventImageDetailList;

- (void)updateData:(NSDictionary *)dic {
    self.applyCount = [dic objectForKey:@"applyCount"];
    self.applyStatus = [dic objectForKey:@"applyStatus"];
    self.eventId = [dic objectForKey:@"eventId"];
    
    self.startTimeStr = [[dic objectForKey:@"startTimeStr"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"startTimeStr"];
    self.endTimeStr = [[dic objectForKey:@"endTimeStr"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"endTimeStr"];
    self.eventTitle = [[dic objectForKey:@"eventTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventTitle"];
    self.eventTheme = [[dic objectForKey:@"param1"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param1"];
    self.eventsType = [[dic objectForKey:@"eventsType"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventsType"];
    self.eventPurpose = [[dic objectForKey:@"param2"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param2"];
    self.partakes = [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.zipURL = [[dic objectForKey:@"param5"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param5"];
    self.needVerfiy = [[dic objectForKey:@"param4"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param4"];
    self.eventDescription = [[dic objectForKey:@"eventDescription"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventDescription"];
    self.eventAddress = [[dic objectForKey:@"eventAddress"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventAddress"];
}

@end
