//
//  EventOptionList.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EventOptionList.h"


@implementation EventOptionList

@dynamic optionTitle;
@dynamic optionId;

- (void)updateData:(NSDictionary *)dic {
    self.optionId = [dic objectForKey:@"optionId"];
    self.optionTitle = [[dic objectForKey:@"optionTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"optionTitle"];
}

@end
