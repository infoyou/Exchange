//
//  OrderList.h
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderList : NSManagedObject

@property (nonatomic, retain) NSString * orderCode;
@property (nonatomic, retain) NSString * orderDate;
@property (nonatomic, retain) NSString * orderID;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * statusDesc;
@property (nonatomic, retain) NSNumber * totalAmount;
@property (nonatomic, retain) NSNumber * totalQty;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * vipLevel;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSSet *detailList;

- (void)updateData:(NSDictionary *)dic;

@end

@interface OrderList (CoreDataGeneratedAccessors)

- (void)addDetailListObject:(NSManagedObject *)value;
- (void)removeDetailListObject:(NSManagedObject *)value;
- (void)addDetailList:(NSSet *)values;
- (void)removeDetailList:(NSSet *)values;

@end
