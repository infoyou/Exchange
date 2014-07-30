//
//  EventApplyMemberList.m
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventApplyMemberList.h"


@implementation EventApplyMemberList

@dynamic displayIndex;
@dynamic eventId;
@dynamic userId;
@dynamic userImageURL;
@dynamic userName;



- (void)updateData:(NSDictionary *)dic
{
    self.displayIndex =  [NSNumber numberWithInteger:[[[dic objectForKey:@"displayIndex"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"displayIndex"] integerValue]];
    self.eventId =  [NSNumber numberWithInteger:[[[dic objectForKey:@"eventId"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"eventId"] integerValue]];
    self.userId =  [NSNumber numberWithInteger:[[[dic objectForKey:@"userId"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userId"] integerValue]];
        self.userImageURL = [[dic objectForKey:@"userImageUrl"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userImageUrl"];
        self.userName = [[dic objectForKey:@"userName"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userName"];
}
@end
