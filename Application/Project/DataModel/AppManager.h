//
//  AppManager.h
//  Project
//
//  Created by XXX on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHeader.h"
#import "ProjectUserDefaults.h"
#import "WXWConstants.h"
#import "GlobalConstants.h"


@interface AppManager : NSObject {
    
    NSMutableArray *visiblePopTipViews;
    NSString *chartContent;
}

@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *clientID;
@property (nonatomic, copy) NSString *customerID;
@property (nonatomic, assign) BOOL isAutoLogout;

@property (nonatomic, copy) NSString *OAUser;
@property (nonatomic, copy) NSString *OAPswd;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *isLoginLicall;
@property (nonatomic, retain) NSMutableDictionary *common;
@property (nonatomic, copy) NSString *passwd;
@property (nonatomic, copy) NSString *hostUrl;
@property (nonatomic, retain) NSString *updateURL;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, assign) int isMandatory;
@property (nonatomic, assign) NSString *recommend;
@property (nonatomic, assign) BOOL isFromLogout;
@property (nonatomic, retain) NSNumber *feedGroupId;

@property (nonatomic, retain) UserDataManager *userDM;

@property (nonatomic, retain) NSMutableArray *visiblePopTipViews;
@property (nonatomic, copy) NSString *chartContent;

@property (nonatomic, assign) NSDictionary *bundleDict;

@property (nonatomic, assign) ProjectUserDefaults *userDefaults;

@property (nonatomic, assign) NetworkConnectionStatus connectionStatus;

// supply and demand
@property (nonatomic, copy) NSString *supplyDemandGroupId;
@property (nonatomic, assign) int supplyDemandType;
@property (nonatomic, copy) NSString *supplyDemandMsg;

@property (nonatomic, assign) PublishChannelType releaseChannelType;

@property (nonatomic, copy) NSString *errCode;
@property (nonatomic, copy) NSString *errDesc;

@property (nonatomic, copy) NSString *vipID;

@property (nonatomic, assign) int userPageNoCount;

@property (nonatomic, assign) int checkInterval;
@property (nonatomic, assign) bool groupVisiable;
@property (nonatomic, copy) NSString *oaUrl;

+ (AppManager *)instance;

- (NSString *)getUserIdFromLocal;
- (void)getAllUserProfiles;

- (void)prepareData;

- (NSMutableDictionary *)specialWithInvokeType:(int)type;
- (NSMutableDictionary *)specialWithInvokeType:(int)type specifieduserID:(int)userId;

- (void) updateLoginSuccess:(NSDictionary *)dict;

- (void)getUserInfoFromLocal;

#pragma mark - OA user info
- (void)saveOAUserInfoIntoLocal;
- (void)getOAUserInfoFromLocal;

@end
