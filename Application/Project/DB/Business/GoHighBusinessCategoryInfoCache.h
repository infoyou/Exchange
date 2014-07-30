//
//  GoHighBusinessCategoryInfoCache.h
//  Project
//
//  Created by XXX on 13-11-20.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"
@interface GoHighBusinessCategoryInfoCache : NSObject<WXWConnectorDelegate>

-(void)upinsertBusinessCategories:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;

-(double)getLatestBusinessCategoryTime;
@end
