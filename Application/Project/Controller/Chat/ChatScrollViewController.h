//
//  ChatScrollViewController.h
//  Project
//
//  Created by XXX on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"

@interface ChatScrollViewController : WXWRootViewController


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
       withImages:(NSArray *)imageArray;

@end
