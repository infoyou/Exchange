//
//  BusinessItemModel.h
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"


@interface BusinessItemModel : NSManagedObject

@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) id detailList;
@property (nonatomic, retain) NSNumber * businessId;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * salePrice;
@property (nonatomic, retain) NSString * saleTime;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * volume;

- (void)updateData:(NSDictionary *)dic;
-(void)updateDataByData:(WXWStatement *)stmt;

@end
