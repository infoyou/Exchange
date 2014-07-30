//
//  ChatGroupDataModal.h
//  Project
//
//  Created by XXX on 13-12-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"

enum USER_STATUS{
    USER_STATUS_NO_AUDIT = 0,
    USER_STATUS_AUDIT,
    USER_STATUS_REFUSED,
    USER_STATUS_ADMIN,
};


@interface ChatGroupDataModal : NSManagedObject

@property (nonatomic, retain) NSNumber * auditNeededLevel;
@property (nonatomic, retain) NSNumber * canChat;
@property (nonatomic, retain) NSNumber * canDelete;
@property (nonatomic, retain) NSNumber * canInvite;
@property (nonatomic, retain) NSNumber * canQuit;
@property (nonatomic, retain) NSNumber * canViewLog;
@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSString * groupDescription;
@property (nonatomic, retain) NSString * groupEmail;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSString * groupImage;
@property (nonatomic, retain) NSString * groupName;
@property (nonatomic, retain) NSString * groupPhone;
@property (nonatomic, retain) NSNumber * groupType;
@property (nonatomic, retain) NSString * groupWebsite;
@property (nonatomic, retain) NSNumber * invitationPublicLevel;
@property (nonatomic, retain) NSNumber * userCount;
@property (nonatomic, retain) NSNumber * userStatus;
@property (nonatomic, retain) NSNumber * lastMessageTime;
@property (nonatomic, retain) NSString *groupUserImageArray;
@property (nonatomic, retain) NSString *groupUserIdArray;
@property (nonatomic, retain) NSString *groupUserNameArray;

- (void)updateData:(NSDictionary *)dict;
- (void)updateDataWithStmt:(WXWStatement *)stmt;

- (BOOL)isInGroup;
- (BOOL)isAdmin;

@end
