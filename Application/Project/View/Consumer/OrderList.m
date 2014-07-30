//
//  OrderList.m
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "OrderList.h"


@implementation OrderList

@dynamic orderCode;
@dynamic orderDate;
@dynamic orderID;
@dynamic status;
@dynamic statusDesc;
@dynamic totalAmount;
@dynamic totalQty;
@dynamic userName;
@dynamic vipLevel;
@dynamic timestamp;
@dynamic detailList;

- (void)updateData:(NSDictionary *)dic {
    self.orderCode = ([NSNull null] == [dic objectForKey:@"orderCode"]) ? @"" : [dic objectForKey:@"orderCode"];
    self.orderDate = ([NSNull null] == [dic objectForKey:@"orderDate"]) ? @"" : [dic objectForKey:@"orderDate"];
    self.orderID = ([NSNull null] == [dic objectForKey:@"orderId"]) ? @"" : [dic objectForKey:@"orderId"];
    self.status = ([NSNull null] == [dic objectForKey:@"status"]) ? @"" : [dic objectForKey:@"status"];
    self.statusDesc = ([NSNull null] == [dic objectForKey:@"statusDesc"]) ? @"" : [dic objectForKey:@"statusDesc"];
    self.totalAmount = [dic objectForKey:@"totalAmount"];
    self.totalQty = [dic objectForKey:@"totalQty"];
    self.userName = ([NSNull null] == [dic objectForKey:@"username"]) ? @"" : [dic objectForKey:@"username"];
    self.vipLevel = [dic objectForKey:@"vipLevel"];
    self.timestamp = ([NSNull null] == [dic objectForKey:@"timestamp"]) ? @"" : [dic objectForKey:@"timestamp"];
}

@end
