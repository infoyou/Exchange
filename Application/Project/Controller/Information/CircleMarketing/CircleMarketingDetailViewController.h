//
//  CircleMarketingDetailViewController.h
//  Project
//
//  Created by XXX on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "EventList.h"

@interface CircleMarketingDetailViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withEventList:(EventList *)eventList
       detailType:(int)type;
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
      withEventId:(int)eventId
       detailType:(int)type;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
      withEventList:(EventList *)eventList
       detailType:(int)type;
@end
