//
//  BusinessImageList.m
//  Project
//
//  Created by Yfeng__ on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessImageList.h"
#import "GlobalConstants.h"


@implementation BusinessImageList

@dynamic imageID;
@dynamic imageURL;
@dynamic sortOrder;
@dynamic target;
@dynamic title;
@dynamic projectId;

- (void)updateData:(NSDictionary *)dic projectId:(int)pid {
    self.imageID = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.sortOrder = [NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    //    self.target =  [[dic objectForKey:@"param5"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param5"];
    self.title =  [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.imageURL =  [[dic objectForKey:@"param2"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param2"];
    self.projectId = [NSNumber numberWithInt:pid];
    DLog(@"%d",self.projectId.intValue);
}


-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    
    self.imageID = NUMBER( [stmt getInt32:0]);
    self.projectId = NUMBER( [stmt getInt32:1]);
    self.imageURL = [stmt getString:3];
    self.sortOrder =NUMBER([stmt getInt32:4]);
    self.target = [stmt getString:5];
    self.title = [stmt getString:6];
}

@end
