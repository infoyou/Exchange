//
//  GoHighBusinessDetaiImagesCache.h
//  Project
//
//  Created by XXX on 13-11-17.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"
@interface GoHighBusinessDetaiImagesCache : NSObject<WXWConnectorDelegate>


-(void)upinsertBusinessDetailImages:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;

-(double)getLatestBusinessDetailImageTime:(int)projectId;
@end
