//
//  CommonTableCache.h
//  Project
//
//  Created by Yfeng__ on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"

@interface CommonTableCache : NSObject<WXWConnectorDelegate>

- (void)upinsertCommon:(NSString *)key value:(NSString *)value;
-(NSString*)getCommon:(NSString *)key;

@end
