//
//  PrivateUserListDataModal.m
//  Project
//
//  Created by XXX on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "PrivateUserListDataModal.h"
#import "GlobalConstants.h"


@implementation PrivateUserListDataModal

@dynamic displayIndex;
@dynamic userId;
@dynamic userImageUrl;
@dynamic userName;



- (void)updateData:(NSDictionary *)dic
{
    self.displayIndex = [NSNumber numberWithInteger:[[dic objectForKey:@"displayIndex"] integerValue]];
    self.userId = [NSNumber numberWithInteger:[[dic objectForKey:@"userId"] integerValue]];
    self.userImageUrl =  [[dic objectForKey:@"userImageUrl"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userImageUrl"];
    
    self.userName = [dic objectForKey:@"userName"];
}


-(void)updateDataByData:(UserBaseInfo *)userInfo;
{
    self.displayIndex = NUMBER(0);
    self.userId =NUMBER(userInfo.userID);
    self.userImageUrl =userInfo.portraitName;
    self.userName = userInfo.chName;    
}


@end
