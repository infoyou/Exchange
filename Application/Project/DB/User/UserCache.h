//
//  UserCache.h
//  Project
//
//  Created by XXX on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWImageFetcherDelegate.h"
#import "WXWConnectorDelegate.h"
#import "QPlusAPI.h"
#import "UserBaseInfo.h"
#import "UserProfile.h"

@interface UserCache  : NSObject <WXWConnectorDelegate>

- (void)upinsertUserIntoDB:(UserBaseInfo *)userInfo timestamp:(double)timestamp;
- (void)upinsertUserProfile:(UserProfile *)userProfile;
- (UserBaseInfo *)getUserInfoFromDB:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId;
- (int)getGroupCountByUserId:(int)userId;
- (int)isFriend:(int)userId;
-(void)updateIsFriend:(NSArray *)array;
-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend;

- (NSMutableArray *)getAllUserInfoFromDB;
- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword;

-(double)getLatestUserTimestamp;

@end
