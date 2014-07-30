//
//  TrainingViewController.h
//  Project
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseListViewController.h"
#import "ImageWallScrollView.h"

@class SquareBlockView;

@interface TrainingViewController : BaseListViewController {
    
    ImageWallScrollView *_imageWallScrollView;
    SquareBlockView *_projectInformation;
    SquareBlockView *_tradeKnowledge;
    SquareBlockView *_tradeInformation;
    SquareBlockView *_marketingInformation;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;
@end
