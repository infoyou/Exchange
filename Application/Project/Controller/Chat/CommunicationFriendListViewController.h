//
//  CommunicationFriendListViewController.h
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseListViewController.h"
#import "QPlusMessage.h"

@protocol CommunicationFriendListViewControllerDelegate;
@interface CommunicationFriendListViewController : BaseListViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;

- (void)onReceiveMessage:(QPlusMessage *)message;

-(void)onDeleteGroupMesssage:(QPlusMessage *)message;
@end

@protocol CommunicationFriendListViewControllerDelegate <NSObject>

- (void)deleteFriendList:(int)userId;

@end