//
//  BookImageList.m
//  Project
//
//  Created by Yfeng__ on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookImageList.h"


@implementation BookImageList

@dynamic bookID;
@dynamic bookTitle;
@dynamic bookImage;
@dynamic target;
@dynamic sortOrder;

- (void)updateData:(NSDictionary *)dic {
    self.bookID = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.bookImage = [[dic objectForKey:@"param2"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param2"];
    self.bookTitle = [[dic objectForKey:@"param3"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param3"];
    self.sortOrder = [NSNumber numberWithInteger:[[dic objectForKey:@"param4"] integerValue]];
    self.target = [[dic objectForKey:@"param5"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"param5"];;
}

@end
