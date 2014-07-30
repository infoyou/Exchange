//
//  CirleMarketingVoteViewController.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

@interface CirleMarketingVoteViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
          eventID:(int)eid;;

@end
