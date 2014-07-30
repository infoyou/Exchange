//
//  BusinessItemModel.m
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemModel.h"


@implementation BusinessItemModel

@dynamic area;
@dynamic detailList;
@dynamic businessId;
@dynamic imageURL;
@dynamic itemName;
@dynamic location;
@dynamic salePrice;
@dynamic saleTime;
@dynamic type;
@dynamic volume;

- (void)updateData:(NSDictionary *)dic
{
    self.businessId = [NSNumber numberWithInteger:[[dic objectForKey:@"param1"] integerValue]];
    self.itemName = [dic objectForKey:@"param3"];
    self.location = [dic objectForKey:@"param11"];
    self.type = [dic objectForKey:@"param12"];
    self.volume =[dic objectForKey:@"param13"];
    self.salePrice = [dic objectForKey:@"param14"];
    self.saleTime = [dic objectForKey:@"param15"];
    self.imageURL = [dic objectForKey:@"param16"];
    self.area = [dic objectForKey:@"param11"];
    
}

-(void)updateDataByData:(WXWStatement *)stmt
{
    self.businessId = [NSNumber numberWithInteger:[stmt getInt32:0]];
    self.itemName = [stmt getString:2];
    self.location = [stmt getString:10];
    self.type = [stmt getString:11];
    self.volume =[stmt getString:12];
    self.salePrice = [stmt getString:13];
    self.saleTime = [stmt getString:14];
    self.imageURL = [stmt getString:15];
    self.area = [stmt getString:10];
}
@end
