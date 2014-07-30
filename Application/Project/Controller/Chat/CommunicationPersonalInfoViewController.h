//
//  CommunicationPersonalInfoViewController.h
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "UserProfile.h"


@protocol CommunicationPersonalInfoViewControllerDelegate;

@interface CommunicationPersonalInfoViewController : WXWRootViewController

@property (nonatomic) int index;
@property (nonatomic, assign) UIButton *leftButton;
@property (nonatomic, assign) UIButton *rightButton;
@property (nonatomic, assign) id<CommunicationPersonalInfoViewControllerDelegate> delegate;

- (id) initWithUserId:(int )userId withDelegate:(id)delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)VC
           userId:(int)userId
     withDelegate:(id)delegate
     isFromChatVC:(BOOL)chatVC;


@end


@protocol CommunicationPersonalInfoViewControllerDelegate <NSObject>

- (void)getMemberInfo;

@optional
- (void)deleteFriendUser:(int)userId;

@end