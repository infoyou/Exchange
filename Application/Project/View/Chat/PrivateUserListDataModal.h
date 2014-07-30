//
//  PrivateUserListDataModal.h
//  Project
//
//  Created by XXX on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UserBaseInfo.h"


@interface PrivateUserListDataModal : NSManagedObject

@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userImageUrl;
@property (nonatomic, retain) NSString * userName;

- (void)updateData:(NSDictionary *)dic;
-(void)updateDataByData:(UserBaseInfo *)userInfo;

@end
