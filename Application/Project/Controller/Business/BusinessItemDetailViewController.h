//
//  BusinessItemDetailViewController.h
//  Project
//
//  Created by XXX on 13-9-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import "WXWRootViewController.h"

@interface BusinessItemDetailViewController : WXWRootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
        projectID:(int)pid;

- (void)updateInfo:(NSDictionary *)detailDict;
@end
