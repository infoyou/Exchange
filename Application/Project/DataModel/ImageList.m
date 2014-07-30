//
//  ImageList.m
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ImageList.h"
#import "GlobalConstants.h"
#import "WXWStatement.h"

@implementation ImageList

@dynamic imageID;
@dynamic imageURL;
@dynamic sortOrder;
@dynamic target;
@dynamic title;
@dynamic isDelete;

- (void)updateData:(NSDictionary *)dic {
    self.imageID = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.sortOrder = [NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    self.target =  [[dic objectForKey:@"param5"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param5"];
    self.title =  [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.imageURL =  [[dic objectForKey:@"param2"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param2"];
    
}

-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    self.imageID = NUMBER( [stmt getInt32:0]);
    self.imageURL = [stmt getString:1];
    self.sortOrder =NUMBER([stmt getInt32:2]);
    self.target = [stmt getString:3];
    self.title = [stmt getString:4];
    self.isDelete =NUMBER ( [stmt getInt32:6]);
}

@end
