//
//  WXWConstants.h
//  Project
//
//  Created by XXX on 12-5-30.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

#pragma mark - system info
#define IOS5    5.000000f
#define IOS4    4.000000f
#define IOS6    6.000000f
#define IOS7    7.000000f
#define IOS4_2  4.2f

#define IPHONE_SIMULATOR			@"iPhone Simulator"

#pragma mark - app properties

#if APP_TYPE == APP_TYPE_FOSUN
    #define VERSION                     @"1.1.8"
#else
    #define VERSION                     @"1.1.0"
#endif

#define PLATFORM                    @"iPhone"
#define LOG                         @"log"
#define APP_DELEGATE                [UIApplication sharedApplication].delegate
#define APP_WINDOW                  ((UIWindow *)([[UIApplication sharedApplication].windows objectAtIndex:0]))
#define WINDOW                      (APP_DELEGATE).window
#define SCREEN_WIDTH            WINDOW.frame.size.width
#define SCREEN_HEIGHT           WINDOW.frame.size.height

typedef enum {
    OTA_TYPE = 1,
    APP_STORE_TYPE = 2,
} PublishChannelType;

#pragma mark - files
#define LOG_DATE_SEPARATOR          @"_"
#define LOG_DEBUG_SEPARATOR         @"#"
#define EMAIL_SEPARATOR             @"，"
#define ERROR_LOG_PREFIX            @"ERROR"
#define CRASH_LOG_PREFIX            @"CRASH"
#define ZIP_SUFFIX                  @".zip"
#define LOG_SUFFIX                  @".log"
#define CRASH_SUFFIX                @".crash"

#pragma mark - DB
#define DBFile                           @"Project.sqlite"
#define DB_NAME                     @"ProjectDB"

#pragma mark - system message
typedef enum {
	SUCCESS_TY,
    INFO_TY,
	WARNING_TY,
	ERROR_TY,
} MessageType;

#pragma mark - core data
#define SAVE_MOC(_MOC)              [WXWCoreDataUtils saveMOCChange:_MOC]
#define DELETE_OBJS_FROM_MOC(_MOC, _NAME, _PREDICATE) [WXWCoreDataUtils deleteEntitiesFromMOC:_MOC entityName:_NAME predicate:_PREDICATE]

#pragma mark - draw UI elements
#define COLOR(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define TITLESTYLE_COLOR          COLOR(180,18,21)
#define BASE_INFO_COLOR           COLOR(130, 130, 140)
//#define BACKGROUND_COLOR          COLOR(239, 239, 239)

#define BACKGROUND_COLOR  COLOR(0xe1, 0xe5, 0xe7)

#define TRANSPARENT_COLOR         [UIColor clearColor]
#define SAFECOLOR(color)          MIN(255,MAX(0,color))
#define MARGIN                    5.0f
#define FADE_IN_DURATION          0.5f
#define NAVIGATION_BAR_COLOR      COLOR(54, 120, 181)

#define DEFAULT_BACKGROUND_COLOR COLOR(0xed, 0xed, 0xed)

#define ACTIVITY_BACKGROUND_WIDTH   120.0f
#define ACTIVITY_BACKGROUND_HEIGHT	120.0f
#define LOADING_LABEL_WIDTH         100.0f
#define LOADING_LABEL_HEIGHT        40.0f
#define	ACTIVITY_DURA_TIME          0.3f

#define ZERO_EDGE                       UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

#define BAR_IMG_BUTTON(IMG, STYLE, TARGET, SELECTOR) [[[UIBarButtonItem alloc] initWithImage:IMG style:STYLE target:TARGET action:SELECTOR] autorelease]


#define CURRENT_OS_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]


#define DEFAULT_NAVIGATION_BAR_FONT_NAME @"MicrosoftYaHei"
#define DEFAULT_NAVIGATION_BAR_FONT_SIZE 18

#define BOLD_FONT(aSize)            [WXWCommonUtils boldFontWithSize:aSize]
#define FONT(aSize)                 [WXWCommonUtils fontWithSize:aSize]
#define LIGHT_FONT(aSize)           [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:aSize]
#define SYS_FONT_NAME               [WXWCommonUtils systemFontName]

#define BOLD_ITALIC_FONT(aSize)     [UIFont fontWithName:@"Arial-BoldItalicMT" size:aSize]
#define ITALIC_FONT(aSize)          [UIFont fontWithName:@"Arial-ItalicMT" size:aSize]
#define Arial_FONT(aSize)           [UIFont fontWithName:@"Arial" size:aSize]
#define TIMESNEWROM_ITALIC(aSize)   [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:aSize]
#define TIMESNEWROM_BOLD_ITALIC(aSize)   [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:aSize]

#define ShowAlert(Delegate,TITLE,MSG,But) [[[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:Delegate \
cancelButtonTitle:But \
otherButtonTitles:nil] autorelease] show]

#define ShowAlertWithTwoButton(Delegate,TITLE,MSG,But1,But2) [[[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:Delegate \
cancelButtonTitle:But1 \
otherButtonTitles:But2, nil] autorelease] show]

#define BAR_BUTTON(TITLE, STYLE, TARGET, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:STYLE target:TARGET action:SELECTOR] autorelease]

#define BAR_SYS_BUTTON(ButtonSystemItem, TARGET, SELECTOR)  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:ButtonSystemItem target:TARGET action:SELECTOR] autorelease]

#define BAR_IMG_BUTTON(IMG, STYLE, TARGET, SELECTOR) [[[UIBarButtonItem alloc] initWithImage:IMG style:STYLE target:TARGET action:SELECTOR] autorelease]

#define TAB_BAR_IMG_BUTTON(TITLE, IMG, TAG) [[[UITabBarItem alloc] initWithTitle:TITLE image:IMG tag:TAG] autorelease]

typedef enum {
    LinePositionTop = 0,
    LinePositionBottom,
} LinePosition;

typedef enum {
    SMALL_SIZE_TY,
    MEDIUM_SIZE_TY,
    LARGE_SIZE_TY,
} FontSizeType;

typedef enum {
    SOLID_LINE_TY,
    ANGLE_LINE_TY,
    DASH_LINE_TY,
} SeparatorType;

#pragma mark - Picker View
#define TopViewHeight           44.0f
#define PickViewHeight          260.f
#define PopViewWidth            SCREEN_WIDTH
#define PopViewHeight           (TopViewHeight + PickViewHeight + 15)
#define PopViewX                0
#define PopViewY                (SCREEN_HEIGHT - PopViewHeight)
#define iOriginalSelIndexVal    -1

typedef enum {
    RECORD_ID_IDX = 0,
    RECORD_NAME_IDX,
    RECORD_TYPE_IDX,
    RECORD_SELECTION_IDX,
} RecordDataIndexType;

#pragma mark - table list
#define HEADER_TRIGGER_OFFSET           65.0f
#define FOOTER_TRIGGER_35_OFFSET_MAX  390//370.0f
#define FOOTER_TRIGGER_40_OFFSET_MAX  490.0f
typedef enum{
    PULL_HEADER_PULLING = 0,
    PULL_HEADER_NORMAL,
    PULL_HEADER_LOADING,
} PullHeaderRefreshState;

typedef enum{
    PULL_FOOTER_PULLING = 0,
    PULL_FOOTER_NORMAL,
    PULL_FOOTER_LOADING,
    PULL_FOOTER_NO_RESULT,
} PullFooterRefreshState;

typedef enum {
	TRIGGERED_BY_SCROLL,
    TRIGGERED_BY_AUTOLOAD,
	TRIGGERED_BY_SORT,
} LoadTriggerType;

#pragma mark - datetime
#define kDEFAULT_DATE_TIME_FORMAT   (@"yyyy-MM-dd HH:mm:ss")

#pragma mark - image
#define IMAGE_WITH_NAME(__NAME__)   [UIImage imageNamed:__NAME__]

#define PHOTO_LONG_LEN_IPHONE   180//280
#define PHOTO_SHORT_LEN_IPHONE	135//210
#define	PHOTO_LONG_LEN_1G3G     600
#define PHOTO_SHORT_LEN_1G3G    450
#define	PHOTO_LONG_LEN_3GS      640
#define PHOTO_SHORT_LEN_3GS     480
#define	PHOTO_LONG_LEN_4G       680
#define PHOTO_SHORT_LEN_4G      510
#define FRONT_PHOTO_LONG_LEN    640.0f
#define FRONT_PHOTO_SHORT_LEN   480.0f
#define	PHOTO_LONG_LEN_5G       800
#define PHOTO_SHORT_LEN_5G      450
#define LOAD_IMAGE_TY           1111

typedef enum {
    IMG_ZERO_TY,
    IMG_LANDSCAPE_TY,
    IMG_PORTRAIT_TY,
    IMG_SQUARE_TY,
} ImageOrientationType;

typedef enum {
    NORMAL_PHOTO_TY,
    INKWELL_PHOTO_TY,
    CLASSIC_PHOTO_TY,
} PhotoEffectType;

typedef enum {
    LOCATE_SUCCESS_TY,
    LOCATE_FAILED_TY,
} LocationResultType;

#pragma mark - language
#define LANG_CN_TY  @"zh"   //zh-Hans
#define LANG_EN_TY  @"en"

typedef enum {
    NO_TY = 0,
    EN_TY = 1,
    ZH_HANS_TY = 2,
} LanguageType;

#pragma mark - network
#define HTTP_RESP_OK                200
#define NETWORK_TIMEOUT             30.0
#define POST                        @"POST"
#define GET                         @"GET"
#define FORM_AUTH_VALUE             @"application/json"
//@"application/x-www-form-urlencoded"
#define HTTP_HEADER_FIELD           @"Content-Type"
#define HTTP_HEADER_LEN             @"Content-Length"
#define PHONE_CONTROLLER            @"/phone_controller"
#define HTTP_PRIFIX                 @"http"
#define HTTPS_PRIFIX                @"https"
#define TEL_PRIFIX                  @"tel"
#define ITEM_LOAD_COUNT         @"20"
#define WXW_FORM_BOUNDARY       @"WXW_FORM_BOUNDARY_iOS"
#define POST_METHOD_URL         @"/FileUploadServlet"
#define CHART_SUBMIT_URL        @"/phone_controller?action=submit_pr"
#define ERROR_LOG_UPLOAD_URL    @"http://www.weixun.co/error_upload.php?type=Fosun&plat=i"

#pragma mark - notification names
#define LOADING_NOTIFY_LOCAL_KEY    @"LOADING_NOTIFY_LOCAL_KEY"
#define USER_ID_LOCAL_KEY               @"USER_ID_LOCAL_KEY"
#define USER_NAME_LOCAL_KEY             @"USER_NAME_LOCAL_KEY"
#define USER_EMAIL_LOCAL_KEY            @"USER_EMAIL_LOCAL_KEY"
#define USER_ACCESS_TOKEN_LOCAL_KEY     @"USER_ACCESS_TOKEN_LOCAL_KEY"
#define SYSTEM_LANGUAGE_LOCAL_KEY       @"SYSTEM_LANGUAGE_LOCAL_KEY"
#define USER_CITY_ID_LOCAL_KEY          @"USER_CITY_ID_LOCAL_KEY"
#define USER_CITY_NAME_LOCAL_KEY        @"USER_CITY_NAME_LOCAL_KEY"
#define USER_COUNTRY_ID_LOCAL_KEY       @"USER_COUNTRY_ID_LOCAL_KEY"
#define USER_COUNTRY_NAME_LOCAL_KEY     @"USER_COUNTRY_NAME_LOCAL_KEY"
#define FONT_SIZE_LOCAL_KEY             @"FONT_SIZE_LOCAL_KEY"
#define HOST_LOCAL_KEY                  @"HOST_LOCAL_KEY"
#define HOMEPAGE_HANDY_NOTIFY_LOCAL_KEY @"HOMEPAGE_HANDY_NOTIFY_LOCAL_KEY"
#define NEWS_FAV_HANDY_NOTIFY_LOCAL_KEY @"NEWS_FAV_HANDY_NOTIFY_LOCAL_KEY"
#define SWIPE_HANDY_NOTIFY_LOCAL_KEY    @"SWIPE_HANDY_NOTIFY_LOCAL_KEY"
#define REFRESH_NEARBY_NOTIFY           @"REFRESH_NEARBY_NOTIFY"

#define REFRESH_SESSION_NOTIFY          @"REFRESH_SESSION_NOTIFY"
#define REDO_REQUEST_NOTIFY             @"REDO_REQUEST_NOTIFY"
#define SESSION_EXPIRED_URL_KEY         @"SESSION_EXPIRED_URL_KEY"
#define SESSION_EXPIRED_VIEW_KEY        @"SESSION_EXPIRED_VIEW_KEY"
#define SESSION_EXPIRED_TYPE_KEY        @"SESSION_EXPIRED_TYPE_KEY"
#define SESSION_ID_KEY                  @"SESSION_ID_KEY"

#pragma mark - session handler
#define SESSION_PREFIX                  @"<session_id>"
#define SESSION_SUFFIX                  @"</session_id>"
#define ALIPAY_MARK                     @"#Group/Detail"

#pragma mark - data value
#define NULL_PARAM_VALUE            @""
#define INIT_VALUE_TYPE             -1
#define STR_FORMAT(args...)         [NSString stringWithFormat:args]
#define INT_TO_STRING(_INT_VALUE)   STR_FORMAT(@"%d", _INT_VALUE)
#define LLINT_TO_STRING(_LLINT_VALUE)   [NSString stringWithFormat:@"%lld", _LLINT_VALUE]
#define FLOAT_TO_STRING(_FLOAT_VALUE)   [NSString stringWithFormat:@"%f", _FLOAT_VALUE]
#define DOUBLE_TO_STRING(_DOUBLE_VALUE) [NSString stringWithFormat:@"%f", _DOUBLE_VALUE]
#define LOCDATA_TO_STRING(_DOUBLE_VALUE) [NSString stringWithFormat:@"%.8f", _DOUBLE_VALUE]
#define RADIANS( degrees )			( degrees * M_PI / 180 )

#pragma mark - object handle
#define RELEASE_OBJ(__POINTER) { if (__POINTER) { [__POINTER release]; __POINTER = nil; }}
#define AUTO_RELEASED_CTREFOBJ(CTValue)  ((void*)[(id)(CTValue) autorelease])

#pragma mark - WeChat integration
#define MAX_WECHAT_ATTACHED_IMG_SIZE    30 * 1024
#define MAX_WECHAT_MAX_DESC_CHAR_COUNT  32
#define MAX_WECHAT_MAX_TITLE_CHAR_COUNT 60

#pragma mark - system UI element
#define SYS_STATUS_BAR_HEIGHT   [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_BAR_HEIGHT           44.0f


@interface WXWConstants : NSObject {
    
}

@end
