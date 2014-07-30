//
//  UserCache.m
//  Project
//
//  Created by XXX on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "ChatModel.h"
#import "GlobalConstants.h"
#import "FirendUserListDataModal.h"
#import "PYMethod.h"

@implementation UserCache

#pragma mark - life cycle methods
- (id)init {
	self = [super init];
    
    return self;
}

- (void)upinsertUserIntoDB:(UserBaseInfo *)userInfo  timestamp:(double)timestamp
{
     WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO user VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
	[inserStmt bindInt32:userInfo.userID forIndex:1];
	[inserStmt bindString:userInfo.portraitName forIndex:2];
	[inserStmt bindString:userInfo.chName forIndex:3];
	[inserStmt bindString:userInfo.enName forIndex:4];
	[inserStmt bindString:userInfo.company forIndex:5];
	[inserStmt bindString:userInfo.department forIndex:6];
	[inserStmt bindString:userInfo.position forIndex:7];
	[inserStmt bindString:userInfo.city forIndex:8];
	[inserStmt bindString:userInfo.address forIndex:9];
	[inserStmt bindString:userInfo.phone forIndex:10];
	[inserStmt bindString:userInfo.weixin forIndex:11];
	[inserStmt bindString:userInfo.email forIndex:12];
    
//     NSString *firstChar = [[PYMethod firstCharOfNamePinyin:userInfo.chName] substringWithRange:NSMakeRange(0,1)];
    [inserStmt bindString:userInfo.firstChar forIndex:13];
    [inserStmt bindInt32:userInfo.isActivation forIndex:14];
	[inserStmt bindInt32:userInfo.isFriend forIndex:15];
	[inserStmt bindDouble:timestamp forIndex:16];
	[inserStmt bindInt32:userInfo.isDelete forIndex:17];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    [inserStmt release];
}

/*
 userId integer ,
 groupId TEXT,
 displayIndex integer, 
 propName TEXT,
 propValue TEXT,  
 isFriend integer, 
 isDelete integer,
 */
- (void)upinsertUserProfile:(int)userId groupId:(int)groupId displayIndex:(int)displayIndex propName:(NSString *)propName propValue:(NSString *)propValue isFriend:(int)isFriend isDelete:(int)isDelete
{
     WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO userProfile VALUES(?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    DLog(@"displayIndex:%d", displayIndex);
	[inserStmt bindInt32:userId forIndex:1];
	[inserStmt bindInt32:groupId forIndex:2];
	[inserStmt bindInt32:displayIndex forIndex:3];
	[inserStmt bindString:propName forIndex:4];
	[inserStmt bindString:propValue forIndex:5];
	[inserStmt bindInt32:isFriend forIndex:6];
	[inserStmt bindInt32:isDelete forIndex:7];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    [inserStmt release];
}

- (void)upinsertUserProfile:(UserProfile *)userProfile
{
    int userId = userProfile.userID;
    int isFriend = userProfile.isFriend;
    
    for (int i = 0; i < userProfile.propertyGroups.count; ++i) {
        
        PropertyGroup *pg = (PropertyGroup *)userProfile.propertyGroups[i];
            
        int groupId = pg.propertyGroupID;
        
        for (int j = 0; j < pg.propertyLists.count; j++) {
            
            PropertyList *pl = (PropertyList *)pg.propertyLists[j];
            
            NSString *value = @"";
            if (pl.controlType == CONTROLTYPE_DROPLIST) {
                
                for (int ii = 0; ii < pl.optionLists.count; ii++) {
                    
                    OptionList *opl = pl.optionLists[ii];
                    
                    if ([pl.propertyValue isEqualToString:[NSString stringWithFormat:@"%d",opl.optionLookupID]]) {
                        //                        [up.values addObject:opl.optionValue];
                        value = opl.optionValue;
                    }
                }
            } else {
                value = pl.propertyValue;
            }
            DLog(@"name:%@  value:%@", pl.propertyName, value);
            
            [self upinsertUserProfile:userId groupId:groupId displayIndex:pl.displayIndex propName:pl.propertyName propValue:value isFriend:isFriend isDelete:0];
        }
    }
}


/*
 userId integer ,
 groupId integer,
 displayIndex integer,
 propName TEXT,
 propValue TEXT,
 isFriend integer,
 isDelete integer,
 */
- (UserDBProperty *)parseUserProperty:(WXWStatement *)queryStmt
{
    UserDBProperty *userDBprop =  [[[UserDBProperty alloc] init] autorelease];
    
    userDBprop.userId = [NUMBER([queryStmt getInt32:0]) integerValue];
    userDBprop.groupId = [NUMBER([queryStmt getInt32:1]) integerValue];
    userDBprop.displayIndex = [NUMBER([queryStmt getInt32:2]) integerValue];
    userDBprop.propName = [queryStmt getString:3];
    userDBprop.propValue = [queryStmt getString:4];
    userDBprop.isFriend =  [NUMBER([queryStmt getInt32:5]) integerValue];
    userDBprop.isDelete =  [NUMBER([queryStmt getInt32:6]) integerValue];
    
    return userDBprop;
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userPropArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from userProfile where userId=? order by displayIndex"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userPropArray addObject:[self parseUserProperty:queryStmt]];
    }
    [queryStmt release];
    return  userPropArray;
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userPropArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from userProfile where userId=? and groupId = ? order by displayIndex"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
	[queryStmt bindInt32:groupId forIndex:2];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userPropArray addObject:[self parseUserProperty:queryStmt]];
    }
    [queryStmt release];
    return  userPropArray;
}

- (int)getGroupCountByUserId:(int)userId
{
    WXWStatement *queryStmt = nil;
    
    int count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select count(distinct groupId) from userProfile	 where  userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return count;
}


- (int)isFriend:(int)userId
{
    WXWStatement *queryStmt = nil;
    
    int isFriend=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select isFriend from user where userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        isFriend = [NUMBER([queryStmt getInt32:0]) integerValue];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return isFriend;
}


-(void)updateIsFriend:(NSArray *)array
{
    
    
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update user set  isFriend = 1 where userId = ?"];
		[queryStmt retain];
	}
    
    for (int i = 0; i < array.count; ++i) {
        FirendUserListDataModal *model = [array objectAtIndex:i];
        
        [queryStmt bindInt32:[model.userId integerValue] forIndex:1];
        if ([queryStmt step] == SQLITE_ROW) {
        }
        
        [queryStmt reset];
    }
    
    [queryStmt release];
}


-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend
{
    WXWStatement *queryStmt = nil;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"update user set  isFriend = ? where userId = ?"];
		[queryStmt retain];
	}
    
    [queryStmt bindInt32:isFriend forIndex:1 ];
        [queryStmt bindInt32:[userId integerValue] forIndex:2];
        if ([queryStmt step] == SQLITE_ROW) {
        }
        
        [queryStmt reset];
    [queryStmt release];
}

/*
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
 */

- (UserBaseInfo *)getUserInfoFromDB:(int)userId
{
     WXWStatement *queryStmt = nil;
    
    UserBaseInfo * baseInfo = nil;
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where  userId = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:userId forIndex:1];
    if ([queryStmt step] == SQLITE_ROW) {
        
        baseInfo =  [[self parseUserBaseInfo:queryStmt] retain];
	}
    
	[queryStmt reset];
    
    [queryStmt release];
    return baseInfo;
}

- (UserBaseInfo *)parseUserBaseInfo:(WXWStatement *)queryStmt
{
    UserBaseInfo * baseInfo = [[[UserBaseInfo alloc] init] autorelease];
    
    baseInfo.userID = [NUMBER([queryStmt getInt32:0]) integerValue];
    baseInfo.portraitName = [queryStmt getString:1];
    baseInfo.chName = [queryStmt getString:2];
    baseInfo.enName = [queryStmt getString:3];
    baseInfo.company = [queryStmt getString:4];
    baseInfo.department = [queryStmt getString:5];
    baseInfo.position = [queryStmt getString:6];
    baseInfo.city = [queryStmt getString:7];
    baseInfo.address = [queryStmt getString:8];
    baseInfo.phone = [queryStmt getString:9];
    baseInfo.weixin = [queryStmt getString:10];
    baseInfo.email = [queryStmt getString:11];
    baseInfo.firstChar = [queryStmt getString:12];
    baseInfo.isActivation = [NUMBER([queryStmt getInt32:13]) integerValue];
    
    return baseInfo;
}

- (NSMutableArray *)getAllUserInfoFromDB
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *userarray = [NSMutableArray array];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where isdelete == 0"];
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userarray addObject:[self parseUserBaseInfo:queryStmt]];
    }
    
    [queryStmt release];
    return  userarray;
}

- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword {
    WXWStatement *queryStmt = nil;
    NSMutableArray *userarray = [NSMutableArray array];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from user where chName like '%?%'"];
		[queryStmt retain];
	}
    
    [queryStmt bindString:keyword forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [userarray addObject:[self parseUserBaseInfo:queryStmt]];
    }
    
    [queryStmt release];
    return  userarray;
}

-(double)getLatestUserTimestamp
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from user order by timestamp desc limit 1"];
		[queryStmt retain];
	}
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    
    return count;
}

#pragma mark - WXWConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
}

@end