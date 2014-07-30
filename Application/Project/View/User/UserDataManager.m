//
//  UserDataManager.m
//  Project
//
//  Created by user on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserDataManager.h"
#import "UserProfile.h"

static UserDataManager *_instance = nil;

@implementation UserDataManager

+ (UserDataManager *)defaultManager {
    @synchronized(self) {
        if (!_instance) {
            _instance = [[super allocWithZone:NULL] init];
        }
    }
    
    
    return _instance;
}


@end
