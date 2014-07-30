//
//  CircleMarketingMemberListViewController.h
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"

@interface CircleMarketingMemberListViewController : WXWRootViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
          eventId:(int)eventId;

@end
