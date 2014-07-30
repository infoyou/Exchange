//
//  EventImageList.m
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventImageList.h"
#import "EventDetailList.h"
#import "EventList.h"

@implementation EventImageList

@dynamic imageUrl;
@dynamic imageType;
@dynamic eventList;
@dynamic eventDetailList;

- (void)updateData:(NSDictionary *)dic withType:(NSInteger)type {
    self.imageUrl = [[NSNull null] isEqual:[dic objectForKey:@"imageUrl"]] ? @"" : [dic objectForKey:@"imageUrl"];
    self.imageType = [NSNumber numberWithInt:type];
}

@end
