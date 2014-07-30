//
//  EventImageDetailList.m
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventImageDetailList.h"
#import "EventDetailList.h"


@implementation EventImageDetailList

@dynamic imageUrl;
@dynamic eventDetailType;
@dynamic eventDetailList;

- (void)updateData:(NSDictionary *)dic withType:(int)type {
    self.eventDetailType = [NSNumber numberWithInt:type];
    self.imageUrl = [[NSNull null] isEqual:[dic objectForKey:@"imageUrl"]] ? @"" : [dic objectForKey:@"imageUrl"];
}

@end
