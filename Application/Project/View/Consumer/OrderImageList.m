//
//  OrderImageList.m
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "OrderImageList.h"
#import "OrderDetailList.h"


@implementation OrderImageList

@dynamic imageId;
@dynamic imageURL;
@dynamic orderDetailList;

- (void)updateData:(NSDictionary *)dic {
    self.imageId = (nil == [dic objectForKey:@"imageId"]) ? @"" : [dic objectForKey:@"imageId"];
    self.imageURL = (nil == [dic objectForKey:@"imageUrl"]) ? @"" : [dic objectForKey:@"imageUrl"];
}

@end
