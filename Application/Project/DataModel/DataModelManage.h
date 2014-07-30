//
//  DataModelManage.h
//  Project
//
//  Created by XXX on 13-9-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BusinessItemModel.h"

@interface DataModelManage : NSObject
+ (DataModelManage *)getInstance;

- (void)saveContext;
- (NSManagedObjectContext *)getContext;


- (void)addBusinessItemModelCoreData:(BusinessItemModel *)item;
- (NSArray *) getBusinessItemModelCoreData;

@end
