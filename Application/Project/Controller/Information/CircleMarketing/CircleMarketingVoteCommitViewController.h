//
//  CircleMarketingVoteCommitViewController.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "EventVoteList.h"

@interface CircleMarketingVoteCommitViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pvc
    eventVoteList:(EventVoteList *)evList;

@end
