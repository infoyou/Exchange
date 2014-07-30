//
//  UserBaseInfo.h
//  Project
//
//  Created by user on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PORTRAITNAME_INDEX 0
#define CHNAME_INDEX       1
#define ENNAME_INDEX       2
#define COMPANY_INDEX      3
#define DEPARTMENT_INDEX   4
#define POSITION_INDEX     5
#define CITY_INDEX     6
#define ADDRESS_INDEX     7

#define PHONE_INDEX 0
#define WEIXUN_INDEX 1
#define EMAIL_INDEX 2

#define KEY_USER_NAME   @"name"
#define KEY_USER_VALUE  @"value"

@interface UserBaseInfo : NSObject

@property (nonatomic) int userID; //用户id
@property (nonatomic, copy) NSString *portraitName; //头像
@property (nonatomic, copy) NSString *chName; //中文名
@property (nonatomic, copy) NSString *enName; //英文名
@property (nonatomic, copy) NSString *company; //公司
@property (nonatomic, copy) NSString *department; //部门
@property (nonatomic, copy) NSString *position; //职位
@property (nonatomic, copy) NSString *city; //城市
@property (nonatomic, copy) NSString *address; //地址

@property (nonatomic, copy) NSString *phone; //手机
@property (nonatomic, copy) NSString *weixin; //微讯
@property (nonatomic, copy) NSString *email; //邮箱

@property (nonatomic, assign) int isActivation;
@property (nonatomic, copy) NSString *firstChar;

@property (nonatomic) int isFriend;
@property (nonatomic) int isDelete;

@property (nonatomic, retain) NSMutableArray *groups;

- (void)parseValueProperties;

@end
