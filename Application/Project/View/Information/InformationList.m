//
//  InformationList.m
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "InformationList.h"
#import "GlobalConstants.h"

@implementation InformationList

@dynamic clientID;
@dynamic comment;
@dynamic informationID;
@dynamic informationType;
@dynamic lastUpdateTime;
@dynamic link;
@dynamic linkType;
@dynamic reader;
@dynamic sortOrder;
@dynamic title;
@dynamic zipURL;
@dynamic htmlURL;
@dynamic isDelete;

- (void)updateData:(NSDictionary *)dic
{
    self.informationID = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.informationType = [NSNumber numberWithInteger:[[dic objectForKey:@"param2"] integerValue]];
    self.link = [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.linkType = [NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    self.reader = [NSNumber numberWithInteger:[[dic objectForKey:@"param5"] integerValue]];
    self.comment = [NSNumber numberWithInteger:[[dic objectForKey:@"param6"] integerValue]];
    self.sortOrder = [NSNumber numberWithInteger:[[dic objectForKey:@"param7"] integerValue]];
    self.zipURL = [dic objectForKey:@"param8"];
    self.clientID = [NSNumber numberWithInteger:[[dic objectForKey:@"param9"] integerValue]];
    self.lastUpdateTime = [dic objectForKey:@"param10"];
    self.title = [dic objectForKey:@"param11"];
//    self.htmlURL = [dic objectForKey:@"param12"];
    self.isDelete =  [NSNumber numberWithInteger:[[dic objectForKey:@"param12"] integerValue]];
}

- (void)updateObj:(InformationList *)info
{
    self.informationID = info.informationID;
    self.informationType = info.informationType;
    self.link = info.link;
    self.linkType = info.linkType;
    self.reader =info.reader;
    self.comment =info.comment;
    self.sortOrder = info.sortOrder;
    self.zipURL = info.zipURL;
    self.clientID = info.clientID;
    self.lastUpdateTime =info.lastUpdateTime;
    self.title =info.title;
}

-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    self.informationID = NUMBER( [stmt getInt32:0]);
    self.title = [stmt getString:1];
    
    self.informationID= NUMBER( [stmt getInt32:0]);
    self.title= [stmt getString:1];
    self.lastUpdateTime = [stmt getString:2];
    self.clientID = NUMBER([stmt getInt32:3]);
    self.zipURL = [stmt getString:4];
    self.htmlURL= [stmt getString:5];
    self.sortOrder=NUMBER([stmt getInt32:6]);
    self.comment=NUMBER([stmt getInt32:7]);
    self.reader=NUMBER([stmt getInt32:8]);
    self.linkType=NUMBER([stmt getInt32:9]);
    self.link=[stmt getString:10];
    self.informationType=NUMBER([stmt getInt32:11]);
    self.isDelete=NUMBER([stmt getInt32:13]);
}
@end
