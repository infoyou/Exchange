//
//  ListDataManager.m
//  Project
//
//  Created by user on 13-10-10.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ListDataManager.h"

static ListDataManager *_instance = nil;

@implementation ListDataManager

+ (ListDataManager *)defaultManager {
    @synchronized(self) {
        if (!_instance) {
            _instance = [[super allocWithZone:NULL] init];
        }
    }
    return _instance;
}

@end
