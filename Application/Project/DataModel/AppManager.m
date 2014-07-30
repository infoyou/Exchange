//
//  AppManager.m
//  Project
//
//  Created by XXX on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "AppManager.h"
#import "GlobalConstants.h"
#import "ProjectAPI.h"
#import "QPlusAPI.h"
#import "CommonUtils.h"
#import "QPlusAPI.h"

@implementation AppManager {
    
//    GHDatabase *_db;
}

@synthesize hostUrl = _hostUrl;
@synthesize common = _common;
@synthesize sessionId = _sessionId;
@synthesize isAutoLogout;

@synthesize OAUser;
@synthesize OAPswd;

@synthesize clientID = _clientID;
@synthesize isLoginLicall = _isLoginLicall;
@synthesize userId = _userId;
@synthesize userType = _userType;
@synthesize username = _username;
@synthesize updateURL = _updateURL;
@synthesize deviceToken = _deviceToken;
@synthesize isMandatory = _isMandatory;

@synthesize visiblePopTipViews;
@synthesize chartContent;

@synthesize bundleDict = _bundleDict;
@synthesize recommend = _recommend;

@synthesize releaseChannelType;
@synthesize supplyDemandGroupId;

@synthesize feedGroupId;
@synthesize supplyDemandType;
@synthesize supplyDemandMsg;

@synthesize errCode;
@synthesize errDesc;

@synthesize userDefaults;
@synthesize vipID;

@synthesize userPageNoCount;

@synthesize checkInterval;
@synthesize groupVisiable;
@synthesize oaUrl;

static AppManager *shareInstance = nil;

+ (AppManager *)instance {
    @synchronized(self) {
        if (nil == shareInstance) {
            shareInstance = [[self alloc] init];
            
            shareInstance.visiblePopTipViews = [[NSMutableArray alloc] init];
        }
    }
    
    return shareInstance;
}

- (void)prepareData
{
    [self initDatabase];
    [self initCommon];
    [self initUser];
    [self initUserDM];
    [self initBundleIdentifier];
    [self initCommonData];
}


- (void)initUser {
    
    [AppManager instance].sessionId = @"";
    [AppManager instance].userType = @"1";
    [AppManager instance].userId = @"-1";
    [AppManager instance].username = @"我";
    //    [AppManager instance].classGroupId = @"EMBA08SH2";
    //    [AppManager instance].className = @"";
    //    [AppManager instance].classClubType = SELF_CLASS_TYPE;
    //    [AppManager instance].classClubId = @"137";
    
    // init DB
    //    [WXWDBConnection prepareBizDB];
    
    // prepare necessary data
    //    [self prepareForNecessaryData];
    
    //    [self startLocationTimer];
}

- (void)initUserDM {
    _userDM = [UserDataManager defaultManager];
    
//    _userDM.userProfiles = [[[NSMutableArray alloc] init] autorelease];
}

//---------------------------common---

- (void)initCommon
{
    _common = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                   @"2",@"channel",
                   @"zh",@"locale",
                   @"6.1",@"osInfo",
                   @"1", @"clientId",
                   @"iPhone",@"plat",
                   @"0", @"userId",
                   @"",@"sessionId",
                   //[AppManager instance].userId,@"userId",
               VERSION,@"version",
               [AppManager instance].deviceToken,@"deviceToken",
                   nil];
    self.customerID = @"f6a7da3d28f74f2abedfc3ea0cf65c01";
}

- (void)initBundleIdentifier
{
    
    _bundleDict = [[NSBundle mainBundle] infoDictionary];
}

-(void)initCommonData
{
    _recommend = @"我正在使用CIO联盟官方 CIOUnion APP。通过该APP可以查询全体校友信息、摇出身边校友进行私聊以及发布和参与商业合作，推荐给您。点击下载：http://weixun.co/ceibs_download";
}

//---------------------------------special-----------------------------------------

- (NSMutableDictionary *)specialWithInvokeType:(int)type {
    return [[[NSMutableDictionary alloc] initWithObjectsAndKeys:NUMBER(type),@"invokeType", nil] autorelease];
}

- (NSMutableDictionary *)specialWithInvokeType:(int)type specifieduserID:(int)userId {
    NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
    [dic setObject:NUMBER(type) forKey:@"invokeType"];
    [dic setObject:NUMBER(userId) forKey:@"specifieduserID"];
    return dic;
}

//----------------------------------------Database---------------------------------------
- (void)initDatabase
{
//    _db = [[GHDatabase alloc]
//           initWithPath:[FileUtils pathForDocumentFiles:GH_DB_NAME]];
//    
//    @try {
//        
//        [_db open];
//        if(_db.isNewDB) {
////            [GHDatabase loadDefaultData:_db];
//        }
////        FMResultSet *r = [_db executeQuery:@"SELECT unit_id FROM T_Unit"];
////        if(r.next) {
////            [self.defaults saveUnitID:[r stringForColumnIndex:0]];
////        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"openDatabase -%@", exception.description);
//        
//    }
//    @finally {
//    }
    
}

//----------------------------------userProfile---------------------------------------

- (void)getAllUserProfiles {
//    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc] init];
    
#if USE_ASIHTTP
#else 
//    [specialDict setObject:NUMBER(INVOKETYPE_ALLUSERINFO) forKey:KEY_API_INVOKETYPE];
//    
//    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
//    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
//    
//    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
//    [specialDict release];
    
#endif
}

//----------------------------------local------------------------------------------------
- (NSString *)getUserIdFromLocal {
    return @"5e1fd55bffb04008b74fb4f273c33021";
	return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (NSString*)getHostUrlFromLocal {
    NSString *url = [[NSUserDefaults standardUserDefaults] objectForKey:HOST_LOCAL_KEY];
    if(url == nil || [@"" isEqualToString:url]) {
        url = HOST_URL;
    }
    return url;
}

- (void) saveHostUrlToLocal:(NSString*) url {
    
    [CommonUtils saveStringValueToLocal:url key:HOST_LOCAL_KEY];
}

//- (void)getHostUrl
//{
//    [AppManager instance].hostUrl = [self getHostUrlFromLocal];
//    // asy update hostUrl
//    NSString *url = [NSString stringWithFormat:@"http://www.weixun.co/host_get.php?host_type=%d", HOST_TYPE];
//    
//    NSString * urlResult = [APIInfo getHostURL:url];
//    if (urlResult)
//        [self saveHostUrlToLocal:urlResult];
//    
//}

- (void)updateLoginSuccess:(NSDictionary *)dict
{
    self.userId = [dict objectForKey:@"userId"];
    self.clientID = [dict objectForKey:@"clientID"];
    self.isLoginLicall = [dict objectForKey:@"isLoginLicall"];
    self.username = [dict objectForKey:@"loginName"];
    
    _common = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
               @"2",@"channel",
               @"zh",@"locale",
               @"6.1",@"osInfo",
               self.clientID, @"clientId",
               @"iPhone",@"plat",
               self.userId, @"userId",
               @"",@"sessionId",
               //[AppManager instance].userId,@"userId",
               VERSION,@"version",
              [AppManager instance].deviceToken,@"deviceToken",
               nil];
    
    [[ProjectAPI getInstance] setCommon:[AppManager instance].common];
    
    if ([AppManager instance].deviceToken != nil) {
//        [CommonMethod commitDeviceToken];
    }
    
    [self saveUserInfoIntoLocal];
}

- (void)saveUserInfoIntoLocal {
    [[NSUserDefaults standardUserDefaults] setObject:self.username forKey:@"loginName"];
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"userId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.passwd forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:self.clientID forKey:@"clientID"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.isLoginLicall forKey:@"isLoginLicall"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getUserInfoFromLocal {
    self.username = [[NSUserDefaults standardUserDefaults] stringForKey:@"loginName"];
	self.userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    self.passwd  =  [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    self.clientID  =  [[NSUserDefaults standardUserDefaults] stringForKey:@"clientID"];
//    self.isLoginLicall =   [[NSUserDefaults standardUserDefaults] stringForKey:@"isLoginLicall"];
}

#pragma mark - OA user info
- (void)saveOAUserInfoIntoLocal {
    [[NSUserDefaults standardUserDefaults] setObject:self.OAUser forKey:@"OAUser"];
    [[NSUserDefaults standardUserDefaults] setObject:self.OAPswd forKey:@"OAPswd"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getOAUserInfoFromLocal {
    self.OAUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"OAUser"];
    self.OAPswd  =  [[NSUserDefaults standardUserDefaults] stringForKey:@"OAPswd"];
}

@end
