//
//  CommunicateGroupListCache.h
//  Project
//
//  Created by XXX on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"
#import "ChatGroupDataModal.h"

@interface CommunicateGroupListCache :  NSObject <WXWConnectorDelegate>

-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;

-(void)updateGroupInfo:(ChatGroupDataModal *)data;
- (int)getGroupIsDeleted:(NSString *)groupId;
-(void)deleteAllGroupListData;

-(void)deleteGroup:(int)groupId;

-(double)getLatestCommunicateGroupListTime;
@end
