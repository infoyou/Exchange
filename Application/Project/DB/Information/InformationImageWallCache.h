//
//  InformationImageWallCache.h
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"

@interface InformationImageWallCache : NSObject<WXWConnectorDelegate>

- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestInfoImageWallTime;

@end
