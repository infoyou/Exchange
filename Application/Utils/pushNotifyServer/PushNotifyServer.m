//
//  PushNotifyServer.m
//  Project
//
//  Created by XXX on 13-12-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "PushNotifyServer.h"
#import "CommonUtils.h"
#import "WXWSyncConnectorFacade.h"
#import "AppManager.h"
#import "JSONKit.h"

@interface PushNotifyServer()
@end

@implementation PushNotifyServer

#pragma mark - lifecycle methods
- (id)init {
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc {

    [super dealloc];
}

#pragma mark - entrance point
- (void)triggerNotify {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // if no need to continue, the auto release pool will be drained
    [self notifyServer];
    
    RELEASE_OBJ(pool);
}

- (void)notifyServer {
    
    if (![AppManager instance].deviceToken || [AppManager instance].deviceToken.length < 5)
        return;
    
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc] init];
    
    [specialDict setObject:[AppManager instance].deviceToken forKey:@"DeviceToken"];
    [specialDict setObject:[AppManager instance].userId forKey:@"AppUserID"];
    
    NSString *url = [NSString stringWithFormat:@"http://mo.fosun.com:8045/DynamicInterface/data/DataService.asmx/submitUserToken?ReqContent=%@", [specialDict JSONString]];
    [specialDict release];
    
    WXWSyncConnectorFacade *syncConn = [[[WXWSyncConnectorFacade alloc] init] autorelease];    
    [syncConn fetchGets:url];
}

@end

