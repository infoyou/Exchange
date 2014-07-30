//
//  AloneMarketingCache.h
//  Project
//
//  Created by XXX on 13-11-20.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

@interface AloneMarketingCache : NSObject<WXWConnectorDelegate>
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestAloneMarketingTime;
@end
