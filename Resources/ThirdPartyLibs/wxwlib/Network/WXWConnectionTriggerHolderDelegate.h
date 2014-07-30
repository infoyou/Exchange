//
//  WXWConnectionTriggerHolderDelegate.h
//  Project
//
//  Created by XXX on 11-12-5.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWAsyncConnectorFacade.h"

@protocol WXWConnectionTriggerHolderDelegate <NSObject>

@required
// some kind of views, e.g., table view cells in list, which triggered connection process, when these views being destructed, 
// the connection should be cancelled immediately, and the parent/holder of these views response for cancel action,
// so the connection of these views should be registered in parent/holder firstly, following method be called when
// views trigger connection process, once user navigates back to home or back, these registered connections will be
// cancelled immediately (in WXWRootViewController cancelSubViewConnections method)
- (void)registerRequestUrl:(NSString *)url connFacade:(WXWAsyncConnectorFacade *)connFacade;

@end
