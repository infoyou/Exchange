//
//  CommunicationGroupHeaderViewController.h
//  Project
//
//  Created by XXX on 13-12-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWRootViewController.h"
#import "ChatGroupDataModal.h"

@interface CommunicationGroupHeaderViewController : WXWRootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withDataModal:(ChatGroupDataModal *)dataModal;
@end
