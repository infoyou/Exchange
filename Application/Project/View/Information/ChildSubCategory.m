//
//  ChildSubCategory.m
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChildSubCategory.h"

@implementation ChildSubCategory

- (void)parserData:(NSDictionary *)dic {
    self.param1 = [dic objectForKey:@"param1"];
    self.param2 = [dic objectForKey:@"param2"];
    self.param3 = [dic objectForKey:@"param3"];
    self.param4 = [dic objectForKey:@"param4"];
    self.param5 = [dic objectForKey:@"param5"];
    self.param6 = [dic objectForKey:@"param6"];
    self.param7 = [dic objectForKey:@"param7"];
    self.param8 = [dic objectForKey:@"param8"];
    self.param9 = [dic objectForKey:@"param9"];
    self.param10 = [dic objectForKey:@"param10"];
    self.param11 = [dic objectForKey:@"param11"];
    self.param12 = [dic objectForKey:@"param12"];
    self.param13 = [dic objectForKey:@"param13"];
    self.param14 = [dic objectForKey:@"param14"];
    self.param15 = [dic objectForKey:@"param15"];
    self.param16 = [dic objectForKey:@"param16"];
    self.param17 = [dic objectForKey:@"param17"];
    self.param18 = [dic objectForKey:@"param18"];
    self.param19 = [dic objectForKey:@"param19"];
    self.param20 = [dic objectForKey:@"param20"];
}


- (void)parserDataWithData:(WXWStatement *)stmt
{
    self.param1 = [stmt getString:0] ;
    self.param2 = [stmt getString:1] ;
    self.param3 = [stmt getString:2] ;
    self.param4 = [stmt getString:3] ;
    self.param5 = [stmt getString:4] ;
    self.param6 = [stmt getString:5] ;
    self.param7 = [stmt getString:6] ;
    self.param8 = [stmt getString:7] ;
    self.param9 = [stmt getString:8] ;
    self.param10 = [stmt getString:9] ;
    self.param11 = [stmt getString:10] ;
    self.param12 = [stmt getString:11] ;
    self.param13 = [stmt getString:12] ;
    self.param14 = [stmt getString:13] ;
    self.param15 = [stmt getString:14] ;
    self.param16 = [stmt getString:15] ;
    self.param17 = [stmt getString:16] ;
    self.param18 = [stmt getString:17] ;
    self.param19 = [stmt getString:18] ;
    self.param20 = [stmt getString:19] ;
}
@end
