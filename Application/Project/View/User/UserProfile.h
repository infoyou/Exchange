//
//  UserProfile.h
//  Project
//
//  Created by user on 13-9-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileKeyDefines.h"

/*
 userId integer ,
 groupId integer,
 displayIndex integer,
 propName TEXT,
 propValue TEXT,
 isFriend integer,
 isDelete integer,
 */
@interface UserDBProperty : NSObject

@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int groupId;
@property (nonatomic, assign) int displayIndex;

@property (nonatomic, copy) NSString *propName;
@property (nonatomic, copy) NSString *propValue;
@property (nonatomic, assign) int isFriend;
@property (nonatomic, assign) int isDelete;

@end

//-----------------UserProfile----------------------
@interface UserProfile : NSObject

@property (nonatomic, assign) int userID;
@property (nonatomic, assign) int isFriend;
@property (nonatomic, assign) int isDelete;
@property (nonatomic, assign) int isActivation;
@property (nonatomic, copy) NSString *firstChar;

@property (nonatomic, retain) NSMutableArray *propertyGroups;

@end


//-----------------PropertyGroup----------------------
@interface PropertyGroup : NSObject

@property (nonatomic) NSInteger displayIndex;
@property (nonatomic) NSInteger propertyGroupID;
@property (nonatomic, retain) NSMutableArray *propertyLists;

@end


//-----------------PropertyList----------------------
@interface PropertyList : NSObject

@property (nonatomic) NSInteger childUserPropertyClientID;
@property (nonatomic) NSInteger controlType;
@property (nonatomic, copy) NSString *defaultValue;//缺省值
@property (nonatomic) NSInteger displayIndex;//显示序列
@property (nonatomic) BOOL isRequired;
@property (nonatomic) NSInteger maxLength;
@property (nonatomic) NSInteger minLength;
@property (nonatomic, retain) NSMutableArray *optionLists;
@property (nonatomic, copy) NSString *propertyName; //字段名 比如 用户名
@property (nonatomic, copy) NSString *propertyValue;//字段值 比如 周恩来
@property (nonatomic, copy) NSString *regularExpression;//正则相关
@property (nonatomic) NSInteger userPropertyClientID; //字段id 比如 公司，职位等等 1 3 5

@end

@interface OptionList : NSObject

@property (nonatomic, retain) NSArray *optionList;
@property (nonatomic) int optionLookupID;
@property (nonatomic, copy) NSString *optionValue;

@end