//
//  ChatAddGroupViewController.h
//  Project
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "ChatGroupDataModal.h"
#import "BaseListViewController.h"

enum CHAT_GROUP_TYPE_INFO {
    CHAT_GROUP_TYPE_INFO_CREATE = 1,//创建群组
    CHAT_GROUP_TYPE_INFO_MODIFY = 2,//加入群组
    CHAT_GROUP_TYPE_FRIEND_LIST = 3,//好友列表
    };

enum CHAT_GROUP_TYPE {
    CHAT_GROUP_TYPE_UN_OPEN = 0,//非公开群
    CHAT_GROUP_TYPE_OPEN = 1,//公开群
    CHAT_GROUP_TYPE_PUBLIC = 2,//公众群
    };


@protocol CommunicatAddGroupViewControllerDelegate;

@interface ChatAddGroupViewController : BaseListViewController

@property (nonatomic, assign) id<CommunicatAddGroupViewControllerDelegate> delegate;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
             type:(enum CHAT_GROUP_TYPE_INFO)type;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
         userList:(NSArray *)userList
        groupInfo:(ChatGroupDataModal *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
        groupInfo:(ChatGroupDataModal *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type;

- (void)updateSelectedUserList:(NSArray *)userList;
@end

@protocol CommunicatAddGroupViewControllerDelegate <NSObject>

@optional
- (void)userListChanged:(BOOL)changed;

-(void)refreshGroupList;

@end
