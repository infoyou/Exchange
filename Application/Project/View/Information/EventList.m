//
//  EventList.m
//  Project
//
//  Created by XXX on 13-12-13.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventList.h"
#import "EventApplyList.h"
#import "EventImageList.h"
#import "GlobalConstants.h"


@implementation EventList

@dynamic applyCheck;
@dynamic applyCount;
@dynamic applyStatus;
@dynamic displayIndex;
@dynamic endTime;
@dynamic endTimeStr;
@dynamic eventAddress;
@dynamic eventDescription;
@dynamic eventId;
@dynamic eventPurpose;
@dynamic eventTheme;
@dynamic eventTitle;
@dynamic eventType;
@dynamic eventUrl;
@dynamic partakes;
@dynamic startTime;
@dynamic startTimeStr;
@dynamic zipUrl;
@dynamic isDelete;
@dynamic eventApplyList;
@dynamic eventImageList;

- (void)updateData:(NSDictionary *)dic withType:(NSInteger)type {
    
    self.eventType =  [NSNumber numberWithInteger:[[dic objectForKey:@"eventsType"] integerValue]];
    self.applyCount = [NSNumber numberWithInteger:[[dic objectForKey:@"applyCount"] integerValue]];
    self.endTime = [dic objectForKey:@"endTime"];
    self.startTime = [dic objectForKey:@"startTime"];
    self.startTimeStr = [[dic objectForKey:@"startTimeStr"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"startTimeStr"];
    self.endTimeStr = [[dic objectForKey:@"endTimeStr"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"endTimeStr"];
    self.displayIndex = [NSNumber numberWithInteger:[[dic objectForKey:@"displayIndex"] integerValue]];
    self.eventId = [NSNumber numberWithInteger:[[dic objectForKey:@"eventId"] integerValue]];
    self.eventTheme = [[dic objectForKey:@"param1"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param1"];
    self.eventPurpose = [[dic objectForKey:@"param2"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param2"];
    self.partakes = [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.applyCheck =[NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    self.zipUrl =[[dic objectForKey:@"param5"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param5"];
    self.applyStatus =[NSNumber numberWithInteger:[[dic objectForKey:@"applyStatus"] integerValue]];
    self.eventDescription = [[dic objectForKey:@"eventDescription"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventDescription"];
    self.eventAddress = [[dic objectForKey:@"eventAddress"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventAddress"];
    self.eventTitle = [[dic objectForKey:@"eventTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventTitle"];
    self.eventUrl =[[dic objectForKey:@"eventUrl"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventUrl"];
    self.isDelete = [NSNumber numberWithInteger:[[dic objectForKey:@"isDelete"] integerValue]];
}


-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    self.eventId = NUMBER([stmt getInt32:0]);
    self.applyCount = NUMBER([stmt getInt32:1]);
    self.displayIndex = NUMBER([stmt getInt32:2]);
    self.endTime = NUMBER_DOUBLE([stmt getDouble:3]);
    self.endTimeStr = [stmt getString:4];
    self.eventAddress = [stmt getString:5];
    self.eventDescription  = [stmt getString:6];
    self.eventTitle = [stmt getString:7];
    self.eventTheme = [stmt getString:8];
    self.eventPurpose = [stmt getString:9];
    self.partakes = [stmt getString:10];
    self.startTime = NUMBER_DOUBLE([stmt getDouble:11]);
    self.startTimeStr = [stmt getString:12];
    self.eventUrl = [stmt getString:13];
    self.eventType = NUMBER([stmt getInt32:14]);
    self.isDelete = NUMBER([stmt getInt32:19]);
    
}


@end
