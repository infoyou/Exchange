//
//  UserDataManager.h
//  Project
//
//  Created by user on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

@property (nonatomic, retain) NSMutableArray *userProfiles;

+ (UserDataManager *)defaultManager;


@end
