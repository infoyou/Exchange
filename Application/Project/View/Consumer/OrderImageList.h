//
//  OrderImageList.h
//  Project
//
//  Created by Yfeng__ on 13-12-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class OrderDetailList;

@interface OrderImageList : NSManagedObject

@property (nonatomic, retain) NSString * imageId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) OrderDetailList *orderDetailList;

- (void)updateData:(NSDictionary *)dic;

@end
