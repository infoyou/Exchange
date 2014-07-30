//
//  CircleMarketingEventCommitViewController.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"

typedef enum {
    CommentType_Informtaion = 1,
    CommentType_Event
}CommentType;

@protocol CircleMarketingEventCommentViewControllerDelegate;
@interface CircleMarketingEventCommentViewController : BaseListViewController


@property (nonatomic, assign) id<CircleMarketingEventCommentViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pvc
      commentType:(CommentType)ctype
          paramId:(int)pid;

@end


@protocol CircleMarketingEventCommentViewControllerDelegate <NSObject>

- (void)updateCommentCount:(int)count;

@end