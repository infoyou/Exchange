//
//  CommunicatGroupMemberListViewController.h
//  Project
//
//  Created by XXX on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "ChatGroupDataModal.h"

@protocol CommunicatGroupMemberListViewControllerDelegate;
@interface CommunicatGroupMemberListViewController : WXWRootViewController

@property (nonatomic, assign) id<CommunicatGroupMemberListViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withDataModal:(ChatGroupDataModal *)dataModal;

- (id)initWithDataModal:(ChatGroupDataModal *)dataModal;
@end


@protocol CommunicatGroupMemberListViewControllerDelegate <NSObject>

@optional
-(void)deleteSuccessfulGroup:(int)groupId;

-(void)removeUserFromGroup:(ChatGroupDataModal *)dataModal userId:(int)userId;

-(void)refreshGroupList;

@end