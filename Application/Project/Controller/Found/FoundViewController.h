//
//  FoundViewController.h
//  IPhoneCIO
//
//  Created by XXX on 13-11-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

@interface FoundViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;
@end
