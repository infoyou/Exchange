//
//  ChatGroupDataModal.m
//  Project
//
//  Created by XXX on 13-12-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChatGroupDataModal.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"

@implementation ChatGroupDataModal

@dynamic auditNeededLevel;
@dynamic canChat;
@dynamic canDelete;
@dynamic canInvite;
@dynamic canQuit;
@dynamic canViewLog;
@dynamic displayIndex;
@dynamic groupDescription;
@dynamic groupEmail;
@dynamic groupId;
@dynamic groupImage;
@dynamic groupName;
@dynamic groupPhone;
@dynamic groupType;
@dynamic groupWebsite;
@dynamic invitationPublicLevel;
@dynamic userCount;
@dynamic userStatus;
@dynamic lastMessageTime;
@dynamic groupUserImageArray;
@dynamic groupUserIdArray;
@dynamic groupUserNameArray;

- (void) updateData:(NSDictionary *)dict
{
    self.canChat = [NSNumber numberWithInteger:[[dict objectForKey:@"canChat"] integerValue]];
    self.canDelete = [NSNumber numberWithInteger:[[dict objectForKey:@"canDelete"] integerValue]];
    self.canInvite = [NSNumber numberWithInteger:[[dict objectForKey:@"canInvite"] integerValue]];
    self.canQuit = [NSNumber numberWithInteger:[[dict objectForKey:@"canQuit"] integerValue]];
    self.canViewLog = [NSNumber numberWithInteger:[[dict objectForKey:@"canViewLog"] integerValue]];
    self.displayIndex = [NSNumber numberWithInteger:[[dict objectForKey:@"displayIndex"] integerValue]];
    self.groupId = [NSNumber numberWithInteger:[[dict objectForKey:@"groupId"] integerValue]];
    self.groupType = [NSNumber numberWithInteger:[[dict objectForKey:@"groupType"] integerValue]];
    self.invitationPublicLevel = [NSNumber numberWithInteger:[[dict objectForKey:@"invitationPublicLevel"] integerValue]];
    
    self.groupDescription = [[dict objectForKey:@"groupDescription"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupDescription"] ;
    self.groupImage = [[dict objectForKey:@"groupImage"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupImage"] ;
    self.groupEmail = [[dict objectForKey:@"groupEmail"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupEmail"] ;
    self.groupName = [[dict objectForKey:@"groupName"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupName"] ;
    self.groupPhone = [[dict objectForKey:@"groupPhone"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupPhone"] ;
    self.groupWebsite = [[dict objectForKey:@"groupWebsite"] isEqual:[NSNull null]] ? @"" : [dict objectForKey:@"groupWebsite"] ;
    
    NSArray *otherAvatarDict = OBJ_FROM_DIC(dict, @"showAvatar");
    
    if (otherAvatarDict) {
        self.groupUserImageArray = @"";
        self.groupUserIdArray = @"";
        self.groupUserNameArray = @"";
        
        if (otherAvatarDict.count) {
            int size = otherAvatarDict.count;
            
            for (int index=0; index<size; index++) {
                
                NSDictionary *userInfo = [otherAvatarDict objectAtIndex:index];
                
                // image
                NSString *tempString = [[userInfo objectForKey:@"headerImage"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"headerImage"] ;
                
                if (self.groupUserImageArray && self.groupUserImageArray.length > 2) {
                    self.groupUserImageArray = [NSString stringWithFormat:@"%@#%@", self.groupUserImageArray, tempString];
                } else {
                    self.groupUserImageArray = [NSString stringWithFormat:@"%@", tempString];
                }
                
                // Id
                NSString *userIDString = [[userInfo objectForKey:@"userID"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"userID"] ;
                
                if (self.groupUserIdArray && self.groupUserIdArray.length > 2) {
                    self.groupUserIdArray = [NSString stringWithFormat:@"%@#%@", self.groupUserIdArray, userIDString];
                } else {
                    self.groupUserIdArray = [NSString stringWithFormat:@"%@", userIDString];
                }
                
                // name
                NSString *userNameString = [[userInfo objectForKey:@"userName"] isEqual:[NSNull null]] ? @"" : [userInfo objectForKey:@"userName"] ;
                
                if (self.groupUserNameArray && self.groupUserNameArray.length > 2) {
                    self.groupUserNameArray = [NSString stringWithFormat:@"%@#%@", self.groupUserNameArray, userNameString];
                } else {
                    self.groupUserNameArray = [NSString stringWithFormat:@"%@", userNameString];
                }
                
            }
        }
    } else {
        self.groupUserImageArray = @"";
        self.groupUserIdArray = @"";
        self.groupUserNameArray = @"";
    }
    
    self.userStatus = [NSNumber numberWithInteger:[[dict objectForKey:@"userStatus"] integerValue]];
    self.userCount = [NSNumber numberWithInteger:[[dict objectForKey:@"userCount"] integerValue]];
    
}


/*
 userId TEXT,
 canChat integer,
 canDelete integer,
 canInvite integer,
 canQuit integer,
 canViewLog integer,
 displayIndex integer,
 groupDescription TEXT,
 groupEmail TEXT,
 groupId integer,
 groupImage TEXT,
 groupName TEXT,
 groupPhone TEXT,
 groupType integer,
 groupWebsite TEXT,
 invitationPublicLevel integer,
 userCount integer,
 userStatus integer,
 auditNeededLevel integer,
 timestamp double,
 isDelete integer
 */

-(void)updateDataWithStmt:(WXWStatement *)stmt
{
    self.canChat = NUMBER([stmt getInt32:1]);
    self.canDelete = NUMBER([stmt getInt32:2]);
    self.canInvite = NUMBER([stmt getInt32:3]);
    self.canQuit = NUMBER([stmt getInt32:4]);
    self.canViewLog = NUMBER([stmt getInt32:5]);
    self.displayIndex = NUMBER([stmt getInt32:6]);
    self.groupDescription = [stmt getString:7];
    self.groupEmail = [stmt getString:8];
    self.groupId = NUMBER([stmt getInt32:9]);
    self.groupImage = [stmt getString:10];
    self.groupName = [stmt getString:11];
    self.groupPhone = [stmt getString:12];
    self.groupType = NUMBER([stmt getInt32:13]);
    self.groupWebsite = [stmt getString:14];
    self.invitationPublicLevel = NUMBER([stmt getInt32:15]);
    self.userCount = NUMBER([stmt getInt32:16]);
    self.userStatus = NUMBER([stmt getInt32:17]);
    self.auditNeededLevel = NUMBER([stmt getInt32:18]);
    self.groupUserImageArray = [stmt getString:19];
    self.groupUserIdArray = [stmt getString:20];
    self.groupUserNameArray = [stmt getString:21];
}

- (BOOL)isInGroup
{
    if ([self.userStatus integerValue] == USER_STATUS_ADMIN || [self.userStatus integerValue] == USER_STATUS_AUDIT) {
        return TRUE;
    }
    
    return FALSE;
}

- (BOOL)isAdmin
{
    if ([self.userStatus integerValue] == USER_STATUS_ADMIN) {
        return TRUE;
    }
    
    return FALSE;
}


@end
