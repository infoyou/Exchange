//
//  BookCommendViewController.h
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

@interface BookCommendViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)VC
           bookID:(int)bookID;

@end
