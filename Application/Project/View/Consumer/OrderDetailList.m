//
//  OrderDetailList.m
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "OrderDetailList.h"
#import "OrderList.h"


@implementation OrderDetailList

@dynamic skuID;
@dynamic itemID;
@dynamic itemName;
@dynamic normas;
@dynamic salesPrice;
@dynamic stdPrice;
@dynamic discountRate;
@dynamic qty;
@dynamic itemCategoryName;
@dynamic beginDate;
@dynamic endDate;
@dynamic dayCount;
@dynamic orderList;
@dynamic images;

- (void)updateData:(NSDictionary *)dic {
    self.skuID = (nil == [dic objectForKey:@"skuId"]) ? @"" : [dic objectForKey:@"skuId"];
    self.itemID = (nil == [dic objectForKey:@"itemId"]) ? @"" : [dic objectForKey:@"itemId"];
    self.itemName = (nil == [dic objectForKey:@"itemName"]) ? @"" : [dic objectForKey:@"itemName"];
    self.normas = (nil == [dic objectForKey:@"GG"]) ? @"" : [dic objectForKey:@"GG"];
    self.salesPrice = [dic objectForKey:@"salesPrice"];
    self.stdPrice = [dic objectForKey:@"stdPrice"];
    self.discountRate = [dic objectForKey:@"discountRate"];
    self.qty = [dic objectForKey:@"qty"];
    self.itemCategoryName = (nil == [dic objectForKey:@"itemCategoryName"]) ? @"" : [dic objectForKey:@"itemCategoryName"];
    self.beginDate = (nil == [dic objectForKey:@"beginDate"]) ? @"" : [dic objectForKey:@"beginDate"];
    self.endDate = (nil == [dic objectForKey:@"endDate"]) ? @"" : [dic objectForKey:@"endDate"];
    self.dayCount = [dic objectForKey:@"dayCount"];
}

@end
