//
//  ListDataManager.h
//  Project
//
//  Created by user on 13-10-10.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListDataManager : NSObject

+ (ListDataManager *)defaultManager;

@property (nonatomic, retain) NSArray *informationLists;
@property (nonatomic, retain) NSArray *informationResultLists;

@end
