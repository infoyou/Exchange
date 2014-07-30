//
//  WXWSystemInfoManager.h
//  WXLib
//
//  Created by XXX on 13-1-2.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConstants.h"

@interface WXWSystemInfoManager : NSObject {
  
}

// system info
@property (nonatomic, assign) PublishChannelType releaseChannelType;


// user info
@property (nonatomic, assign) long long userId;
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger userType;

// location info
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) long long cityId;
@property (nonatomic, assign) BOOL locationFetched;

// system device
@property (nonatomic, copy) NSString *device;
@property (nonatomic, copy) NSString *system;
@property (nonatomic, copy) NSString *softName;
@property (nonatomic, copy) NSString *version;

// language
@property (nonatomic, assign) LanguageType currentLanguageCode;
@property (nonatomic, copy) NSString *currentLanguageDesc;

// network
@property (nonatomic, copy) NSString *sessionId;
@property (nonatomic, copy) NSString *hostUrl;
@property (nonatomic, assign) BOOL networkStable;
@property (nonatomic, assign) BOOL sessionExpired;

// ui
@property (nonatomic, assign) BOOL navigationBarHidden;

// temp
@property (nonatomic, retain) NSMutableArray *pickerSel0IndexList;
@property (nonatomic, retain) NSMutableArray *pickerSel1IndexList;


+ (WXWSystemInfoManager *)instance;

#pragma mark - language set
- (void)setLanguageWithType:(LanguageType)type;

#pragma mark - view controller navigation
- (void)backToHomepage;

@end
