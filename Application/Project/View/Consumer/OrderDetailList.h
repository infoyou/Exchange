//
//  OrderDetailList.h
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderList;

@interface OrderDetailList : NSManagedObject

@property (nonatomic, retain) NSString * skuID;
@property (nonatomic, retain) NSString * itemID;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * normas;
@property (nonatomic, retain) NSNumber * salesPrice;
@property (nonatomic, retain) NSNumber * stdPrice;
@property (nonatomic, retain) NSNumber * discountRate;
@property (nonatomic, retain) NSNumber * qty;
@property (nonatomic, retain) NSString * itemCategoryName;
@property (nonatomic, retain) NSString * beginDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSNumber * dayCount;
@property (nonatomic, retain) OrderList *orderList;
@property (nonatomic, retain) NSSet *images;

- (void)updateData:(NSDictionary *)dic;

@end

@interface OrderDetailList (CoreDataGeneratedAccessors)

- (void)addImagesObject:(NSManagedObject *)value;
- (void)removeImagesObject:(NSManagedObject *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
