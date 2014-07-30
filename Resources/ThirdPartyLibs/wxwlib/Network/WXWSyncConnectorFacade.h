//
//  ECSyncConnector.h
//  Project
//
//  Created by XXX on 11-11-3.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnector.h"
#import "WXWConstants.h"

@interface WXWSyncConnectorFacade : WXWConnector {


}

#pragma mark - upload log
- (NSData *)uploadLog:(NSString *)logContent logFileName:(NSString*)logFileName;
- (NSData *)uploadLogData:(NSData *)data logFileName:(NSString*)logFileName;
- (NSData *)uploadLogData:(NSDictionary *)dic data:(NSData *)data logFileName:(NSString*)logFileName;
- (NSData *)uploadLog:(NSString *)logContent;
- (void)fetchGets:(NSString *)url;

@end
