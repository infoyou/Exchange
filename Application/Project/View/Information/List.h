//
//  List.h
//  Project
//
//  Created by user on 13-10-9.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InformationList.h"

@interface List : NSObject

@property (nonatomic) BOOL isAll;
@property (nonatomic, retain) NSMutableArray *informationLists;

@end
