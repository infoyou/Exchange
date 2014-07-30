//
//  CommunicatGroupPropertyInfoViewController.h
//  Project
//
//  Created by XXX on 13-9-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "ChatGroupDataModal.h"
#import "GlobalConstants.h"

@protocol CommunicatGroupPropertyInfoViewControllerDelegate;

@interface CommunicatGroupPropertyInfoViewController : WXWRootViewController

@property (nonatomic, assign) enum GROUP_PROPERTY_TYPE type;
@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) id<CommunicatGroupPropertyInfoViewControllerDelegate> delegate;

-(void)updateInfo:(ChatGroupDataModal *)groupInfo;

- (id)initWithDataModal:(ChatGroupDataModal *)dataModal;
@end

@protocol CommunicatGroupPropertyInfoViewControllerDelegate <NSObject>

- (void)contentChanged:(BOOL)changed;

@end