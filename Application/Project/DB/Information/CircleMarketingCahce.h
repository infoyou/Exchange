//
//  CircleMarketingCahce.h
//  Project
//
//  Created by XXX on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

@interface CircleMarketingCahce : NSObject<WXWConnectorDelegate>
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestCircleMarketingTime:(int)type;
@end
