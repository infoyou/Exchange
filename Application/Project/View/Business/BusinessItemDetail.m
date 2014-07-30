//
//  BusinessItemDetail.m
//  Project
//
//  Created by XXX on 13-11-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemDetail.h"

@implementation BusinessItemDetail

-(id) getValue:(id)val
{
    if ([val isEqual:[NSNull null]]) {
        return @"";
    }
    return val;
}

- (void)parserData:(NSDictionary *)dic  timestamp:(NSString *)timestamp categoryID:(int)categoryID parentID:(int)parentID isDelete:(int)isDelete {
    self.param1 =[self getValue: [dic objectForKey:@"param1"]];
    self.param2 = [self getValue: [dic objectForKey:@"param2"]];
    self.param3 = [self getValue: [dic objectForKey:@"param3"]];
    self.param4 = [self getValue: [dic objectForKey:@"param4"]];
    self.param5 =[self getValue:  [dic objectForKey:@"param5"]];
    self.param6 =[self getValue:  [dic objectForKey:@"param6"]];
    self.param7 = [self getValue: [dic objectForKey:@"param7"]];
    self.param8 = [self getValue: [dic objectForKey:@"param8"]];
    self.param9 = [self getValue: [dic objectForKey:@"param9"]];
    self.param10 = [self getValue: [dic objectForKey:@"param10"]];
    
    self.timestamp = timestamp;
    self.categoryID = categoryID;
    self.parentID = parentID;
    self.isDelete = isDelete;
}

@end
