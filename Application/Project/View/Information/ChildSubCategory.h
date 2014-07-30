//
//  ChildSubCategory.h
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWStatement.h"

@interface ChildSubCategory : NSObject

@property (nonatomic, retain) NSMutableArray *list1;
@property (nonatomic, copy) NSString *param1;
@property (nonatomic, copy) NSString *param2;
@property (nonatomic, copy) NSString *param3;
@property (nonatomic, copy) NSString *param4;
@property (nonatomic, copy) NSString *param5;
@property (nonatomic, copy) NSString *param6;
@property (nonatomic, copy) NSString *param7;
@property (nonatomic, copy) NSString *param8;
@property (nonatomic, copy) NSString *param9;
@property (nonatomic, copy) NSString *param10;
@property (nonatomic, copy) NSString *param11;
@property (nonatomic, copy) NSString *param12;
@property (nonatomic, copy) NSString *param13;
@property (nonatomic, copy) NSString *param14;
@property (nonatomic, copy) NSString *param15;
@property (nonatomic, copy) NSString *param16;
@property (nonatomic, copy) NSString *param17;
@property (nonatomic, copy) NSString *param18;
@property (nonatomic, copy) NSString *param19;
@property (nonatomic, copy) NSString *param20;
@property (nonatomic, copy) NSString *parentId;


- (void)parserData:(NSDictionary *)dic;
- (void)parserDataWithData:(WXWStatement *)stmt;

@end
