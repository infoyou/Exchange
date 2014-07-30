//
//  WXWTextPool.h
//  WXLib
//
//  Created by XXX on 12-12-28.
//  Copyright (c) 2012年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - common
static NSString *const NSLoadingTitle = @"loadingTitle";
static NSString *const NSLoadMoreTitle = @"loadMoreTitle";
static NSString *const NSLoadNoResultTitle = @"loadNoResultTitle";
static NSString *const NSCloseTitle = @"closeTitle";
static NSString *const NSPullDownToRefresh = @"pullDownToRefresh";
static NSString *const NSReleaseToRefresh = @"releaseToRefresh";
static NSString *const NSLastUpdate = @"lastUpdate";
static NSString *const NSOKTitle = @"okTitle";
static NSString *const NSNoteTitle = @"noteTitle";
static NSString *const NSCancelTitle = @"cancelTitle";
static NSString *const NSSureTitle = @"sureTitle";

#pragma mark - network
static NSString *const NSUserAuthFailedMsg  = @"userAuthFailedMsg";
static NSString *const NSConnectionErrorMsg = @"connectionErrorMsg";
static NSString *const NSTimeoutMsg         = @"timeoutMsg";
static NSString *const NSNetworkUnstableMsg = @"networkUnstableMsg";
static NSString *const NSResponseMsg        = @"responseMsg";
static NSString *const NSResponse304Msg     = @"response304Msg";
static NSString *const NSResponse400Msg     = @"response400Msg";
static NSString *const NSResponse403Msg     = @"response403Msg";
static NSString *const NSResponse404Msg     = @"response404Msg";
static NSString *const NSResponse500Msg     = @"response500Msg";
static NSString *const NSResponse501Msg     = @"response501Msg";
static NSString *const NSResponse502Msg     = @"response502Msg";
static NSString *const NSResponse503Msg     = @"response503Msg";
static NSString *const NSResponseCommonErrorMsg = @"responseCommonErrorMsg";
static NSString *const NSWeWillSolveTitle   = @"weWillSolveTitle";
static NSString *const NSNoResponseMsg      = @"noResponseMsg";

#pragma mark - location
static NSString *const NSLocationTimeOutMsg = @"locationTimeOutMsg";
static NSString *const NSLocationSevDisabledMsg = @"locationSevDisabledMsg";
static NSString *const NSKilometerTitle = @"kilometerTitle";
static NSString *const NSLocationInProcessMsg = @"locationInProcessMsg";
static NSString *const NSNearbyPlaceListTitle = @"nearbyPlaceListTitle";
static NSString *const NSLocatingMsg = @"locatingMsg";

#pragma mark - web view
static NSString *const NSPrePageTitle = @"prePageTitle";
static NSString *const NSNextPageTitle = @"nextPageTitle";

#pragma mark - feed
static NSString *const NSHourAgoTitle = @"hourAgoTitle";
static NSString *const NSMinAgoTitle = @"minAgoTitle";
static NSString *const NSSecAgoTitle = @"secAgoTitle";
static NSString *const NSHoursAgoTitle = @"hoursAgoTitle";
static NSString *const NSMinsAgoTitle = @"minsAgoTitle";
static NSString *const NSSecsAgoTitle = @"secsAgoTitle";
static NSString *const NSDaysAgoTitle = @"daysAgoTitle";
static NSString *const NSDayAgoTitle = @"dayAgoTitle";

static NSString *const NSHourLaterTitle = @"hourLaterTitle";
static NSString *const NSHoursLaterTitle = @"hoursLaterTitle";
static NSString *const NSMinLaterTitle = @"minLaterTitle";
static NSString *const NSMinsLaterTitle = @"minsLaterTitle";
static NSString *const NSSecLaterTitle = @"secLaterTitle";
static NSString *const NSSecsLaterTitle = @"secsLaterTitle";
static NSString *const NSDayLaterTitle = @"dayLaterTitle";
static NSString *const NSDaysLaterTitle = @"daysLaterTitle";

#pragma mark - setting

static NSString *const NSPwdFormatIncorrectMsg  = @"pwdFormatIncorrectMsg";



#pragma mark - location
static NSString *const NSNearbyServiceUnavailableMsg = @"nearbyServiceUnavailableMsg";
static NSString *const NSLocationServiceDeniedMsg = @"locationServiceDeniedMsg";

#define LocaleStringForKey(KEY, ALTER)  [WXWTextPool localizedStringForKey:KEY alter:ALTER]

@interface WXWTextPool : NSObject {
}

+ (NSString *)localizedStringForKey:(NSString *)key
                              alter:(NSString *)alternate;
@end
