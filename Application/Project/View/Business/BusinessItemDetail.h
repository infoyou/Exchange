//
//  BusinessItemDetail.h
//  Project
//
//  Created by XXX on 13-11-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BusinessItemDetail : NSObject
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

@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, assign) int parentID;
@property (nonatomic, assign) int categoryID;
@property (nonatomic, assign) int isDelete;



- (void)parserData:(NSDictionary *)dic timestamp:(NSString *)timestamp categoryID:(int)categoryID parentID:(int)parentID isDelete:(int)isDelete;
@end
