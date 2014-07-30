//
//  GoHighBusinessDetailInfoCache.h
//  Project
//
//  Created by XXX on 13-11-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"

@interface GoHighBusinessDetailInfoCache :  NSObject <WXWConnectorDelegate>


-(void)upinsertBusinessDetails:(NSDictionary *)contentDic timestamp:(NSString *)timestamp categoryID:(int)categoryID MOC:(NSManagedObjectContext *)MOC;


-(double)getLatestBusinessDetailInfoTime:(int)projectId;
@end
