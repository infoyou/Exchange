//
//  MyInfoViewController.h
//  Project
//
//  Created by user on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"

@interface MyInfoViewController : WXWRootViewController
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
       viewHeight:(int)viewHeight;
@end
