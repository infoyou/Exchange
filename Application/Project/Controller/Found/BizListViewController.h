//
//  BizListViewController.h
//  Project
//
//  Created by XXX on 13-12-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"

@interface BizListViewController : BaseListViewController

    - (id)initWithMOC:(NSManagedObjectContext *)MOC
             parentVC:(WXWRootViewController *)pVC;

@end
