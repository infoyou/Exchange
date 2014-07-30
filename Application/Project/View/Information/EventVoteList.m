//
//  EventVoteList.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventVoteList.h"
#import "EventOptionList.h"


@implementation EventVoteList

@dynamic voteTitle;
@dynamic voteFlag;
@dynamic voteId;
@dynamic eventId;
@dynamic displayIndex;

- (void)updateData:(NSDictionary *)dic {
    self.voteId = [dic objectForKey:@"voteId"];
    self.voteFlag = [dic objectForKey:@"voteFlag"];
    self.eventId = [dic objectForKey:@"eventId"];
    self.voteTitle = [[dic objectForKey:@"voteTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"voteTitle"];
}

- (void)addDisplayIndex:(NSSet *)values {
    self.displayIndex = values;
}

@end
