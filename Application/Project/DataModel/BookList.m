//
//  BookList.m
//  Project
//
//  Created by XXX on 13-11-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookList.h"
#import "GlobalConstants.h"

@implementation BookList

@dynamic bookCategory;
@dynamic bookID;
@dynamic bookImage;
@dynamic bookTitle;
@dynamic clientID;
@dynamic commendReason;
@dynamic comment;
@dynamic informationType;
@dynamic lastUpdateTime;
@dynamic link;
@dynamic linkType;
@dynamic reader;
@dynamic sortOrder;
@dynamic title;
@dynamic zipURL;
@dynamic isDelete;

- (void)updateData:(NSDictionary *)dic {
    
    self.bookID = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.informationType = [NSNumber numberWithInteger:[[dic objectForKey:@"param2"] integerValue]];
    self.bookCategory = [[dic objectForKey:@"param23"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param23"];
    self.bookTitle = [[dic objectForKey:@"param22"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param22"];
    self.bookImage = [[dic objectForKey:@"param21"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param21"];
    self.comment = [NSNumber numberWithInteger:[[dic objectForKey:@"param6"] integerValue]];
    self.lastUpdateTime = [[dic objectForKey:@"param10"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param10"];
    self.clientID = [NSNumber numberWithInteger:[[dic objectForKey:@"param9"] integerValue]];
    self.commendReason = [[dic objectForKey:@"param24"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param24"];
    self.title = [[dic objectForKey:@"param11"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param11"];
    self.zipURL = [[dic objectForKey:@"param8"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param8"];
    self.reader = [NSNumber numberWithInteger:[[dic objectForKey:@"param5"] integerValue]];
    self.link = [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.linkType = [NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    self.sortOrder = [NSNumber numberWithInteger:[[dic objectForKey:@"param7"] integerValue]];
}


-(void)updateDataByData:(WXWStatement *)stmt
{
    self.bookID = NUMBER([stmt getInt32:0]);
    self.bookImage = [stmt getString:1];
    self.bookTitle = [stmt getString:2];
    self.bookCategory = [stmt getString:3];
    self.clientID = NUMBER([stmt getInt32:4]);
    self.informationType = NUMBER([stmt getInt32:5]);
    self.lastUpdateTime = [stmt getString:6];
    self.commendReason = [stmt getString:7];
    self.zipURL = [stmt getString:8];
    self.sortOrder = NUMBER([stmt getInt32:9]);
    self.reader = NUMBER([stmt getInt32:10]);
    self.linkType = NUMBER([stmt getInt32:11]);
    self.link = [stmt getString:12];
    self.comment= NUMBER([stmt getInt32:13]);
    self.title = [stmt getString:14];
    
}

@end
