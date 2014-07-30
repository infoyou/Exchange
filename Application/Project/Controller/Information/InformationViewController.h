//
//  InformationViewController.h
//  Project
//
//  Created by XXX on 13-9-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"

@interface InformationViewController : BaseListViewController {
@private
    CGFloat _viewHeight;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
       viewHeight:(CGFloat)viewHeight
  homeContainerVC:(WXWRootViewController *)homeContainerVC;

@end
