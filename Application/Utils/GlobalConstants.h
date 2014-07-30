//
//  GlobalConstants.h
//  ProductFramework
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConstants.h"

#define APP_DELEGATE                [UIApplication sharedApplication].delegate
#define APP_WINDOW                  ((UIWindow *)([[UIApplication sharedApplication].windows objectAtIndex:0]))
#define WINDOW                      (APP_DELEGATE).window
#define SCREEN_WIDTH            WINDOW.frame.size.width
#define SCREEN_HEIGHT           WINDOW.frame.size.height

// Style
#define STYLE_NAVIGATIONBAR_COLOR   @"0x1e70e0"
#define STYLE_BLUE_COLOR             @"0x3678b5"
#define STYLE_RED_COLOR               @"0xe64125"

typedef enum {
    WECHAT_OK_CODE = 0,
    WECHAT_BACK_CODE = -2,
} WeChatReturnCodeType;

#pragma mark - app type

#define     APP_TYPE_BASE                   1 //基础
#define     APP_TYPE_O2O                     3 //O2O云商户
#define     APP_TYPE_CIO                      4 //精英小舞台 (CIO地址)
#define     APP_TYPE_IALUMNIUSA       5 //美国校友会
#define     APP_TYPE_INEARBY             6 //微邻客
#define     APP_TYPE_YIMA                    7 //逸马商学院
#define     APP_TYPE_FOSUN                8 //复星

#define APP_TYPE    APP_TYPE_FOSUN

#if APP_TYPE == APP_TYPE_BASE
#define FORGET_PASSWORD_LINK                     @"http://112.124.68.147:5000/Mobile/RetrievePasswordList.aspx"
#elif APP_TYPE == APP_TYPE_O2O
#define FORGET_PASSWORD_LINK                     @""
#else
#define FORGET_PASSWORD_LINK                     @"http://112.124.68.147:5010/Mobile/RetrievePasswordList.aspx"
#endif

//1:default 2:gohigh 3:CIO
#if APP_TYPE == APP_TYPE_BASE //GoHigh-AppKey
#define APP_KEY                     @"6450fd2c-57ce-11e3-a1a7-00163e0028ea"
#elif APP_TYPE == APP_TYPE_CIO //CIO 联盟- AppKey
#define APP_KEY                     @"352e736a-4120-11e3-8165-ab3a22f97e8b"
#elif APP_TYPE == APP_TYPE_IALUMNIUSA //iAlumniUSA- AppKey
#define APP_KEY                     @"bf682be6-62d6-11e3-a1a7-00163e0028ea"
#elif APP_TYPE == APP_TYPE_INEARBY
#define APP_KEY                     @"3539fb18-6925-11e3-a1a7-00163e0028ea"
#elif APP_TYPE == APP_TYPE_YIMA
#define APP_KEY                     @"3539fb18-6925-11e3-a1a7-00163e0028ea"
#elif APP_TYPE == APP_TYPE_FOSUN
//#define APP_KEY                     @"8e7e0eed-74e5-11e3-a1a7-00163e0028ea" // Publish
#define APP_KEY                     @"bfb8e761-9d3c-11e3-b795-238c5812515f"     //Exchange
#else //测试服务器
#define APP_KEY                     @"1141CF99-EACE-4368-8048-D86059698E78"
#endif

#define HAS_CAMERA        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]

#define STATUS_BAR_HEIGHT               20.0f
#define NAVIGATION_BAR_HEIGHT           44.0f
#define TOOLBAR_HEIGHT              44.0f

#pragma mark - take photo
#define EFFECT_PHOTO_SAMPLE_VIEW_HEIGHT     70.0f

#define     KEYBOARD_ANIMATION_DURATION   0.3f

typedef enum {
    TAG_TY,
    SHARING_FILTER_TY,
} ItemPropertyType;

typedef enum {
    SHARE_TY = 100,
    THING_TY = 200,
    PLACE_TY = 300,
} TagType;

typedef enum {
    ONE_TY = 1,
    TWO_TY = 2,
}TagShowType;

typedef enum {
    TAG_FILTER_TY,
    FAVORITE_FILTER_TY,
    DISTANTCE_FILTER_TY,
} SharingFilterType;

typedef enum {
    NONE_SELECTED_TY = 0,
    ALL_CATEGORY_TY = 1,
    FAVORITED_CATEGORY_TY = 2,
}ItemFavoriteCategory;

#if APP_TYPE == APP_TYPE_BASE

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY     @"266e26e26a06a36d3111913daeae69b3"

#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY || APP_TYPE == APP_TYPE_YIMA || APP_TYPE == APP_TYPE_FOSUN

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY     @"266e26e26a06a36d3111913daeae69b3"

#elif APP_TYPE == APP_TYPE_O2O

#define WEIXIN_APP_ID       @"wxaf2414de75f47280"
#define WEIXIN_APP_KEY     @"266e26e26a06a36d3111913daeae69b3"

#endif

#define UMENG_ANALYS_APP_KEY        @"531577df56240b9940002bd0"


#pragma mark -- notification

#define COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP @"CommunicationViewControllerDeleteGroup"

#define COMMUNICAT_VIEW_CONTROLLER_QUIT_CHAT_GROUP @"CommunicationViewControllerQuiteGroup"

#define COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP   @"CommunicationViewControllerRefreshGroup"

#define TRAINING_VIEW_CONTROLLER_REFRESH_COURSE_LIST    @"TrainingViewControllerRefreshCourseList"

#define COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO @"CommunicatViewControllerDeleteGroupFromAiLiao"

#define FEED_DELETED_NOTIFY             @"FEED_DELETED_NOTIFY"
#define POST_DELETED_NOTIFY             @"POST_DELETED_NOTIFY"
#define CHANGE_USER_NOTIFY              @"CHANGE_USER_NOTIFY"
#define NOTIFY_NETWORK_STATUS           @"notify.network.status"

#pragma mark - font
#define TEXT_SHADOW_COLOR           [UIColor whiteColor]
#define BASE_INFO_COLOR                 COLOR(130, 130, 140)
#define DARK_TEXT_COLOR  COLOR(98, 87, 87)
#define HEADER_CELL_TITLE_FONT    BOLD_FONT(13)

#pragma mark - table cell
#define CELL_TITLE_COLOR COLOR(30.0f, 30.0f, 30.0f)

#define CELL_COLOR                      COLOR(239, 239, 239)

#define COMMON_CELL_SUBTITLE_FONT BOLD_FONT(12)
#define COMMON_CELL_TITLE_FONT    BOLD_FONT(14)
#define COMMON_CELL_CONTENT_FONT  BOLD_FONT(13)

#define CELL_TITLE_IMAGE_SIDE_LENGTH    24.0f

#define CELL_CONTENT_PORTRAIT_WIDTH     280.0f

#define PLAIN_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH     266.0f
#define PLAIN_TABLE_NO_IMAGE_ACCESS_NONE_WIDTH                300.0f
#define GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH   216.0f
#define GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_NONE_WIDTH        270.0f

#define PLAIN_TABLE_WITH_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH   232.0f
#define PLAIN_TABLE_WITH_IMAGE_ACCESS_NONE_WIDTH              246.0f
#define GROUPED_TABLE_WITH_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH 232.0f
#define GROUPED_TABLE_WITH_TITLE_IMAGE_ACCESS_NONE_WIDTH      236.0f

#define GROUP_STYLE_CELL_CORNER_RADIUS  10.0f

#define DEFAULT_CELL_HEIGHT             44.0f
#define DEFAULT_HEADER_CELL_HEIGHT      20.0f

#pragma mark - table list
#define SEPARATOR_LINE_COLOR            COLOR(158,161,168)

#define NUMBER(__OBJ) [NSNumber numberWithInt:__OBJ]

#pragma mark - color
#define RANDOM_COLOR [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1]

#define TAG_COLOR                       [UIColor blueColor]
#define COLOR(r, g, b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define ORANGE_COLOR                    COLOR(233, 80, 55)
#define TRANSPARENT_COLOR         [UIColor clearColor]
#define TITLE_COLOR               COLOR(90.0f, 90.0f, 90.0f)
#define BLUE_TITLE_COLOR          COLOR(36.0f, 107.0f, 195.0f)
#define LIGHT_GRAY_BACKGROUND_COLOR COLOR(252.0f, 252.0f, 252.0f)
#define WHITE_COLOR             [UIColor whiteColor]
#define BLUE_COLOR              [UIColor blueColor]

#define DEFAULT_VIEW_COLOR  COLOR(0xe1, 0xe5, 0xe7)
//#define DEFAULT_VIEW_COLOR [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"background.png")]

#define DEFAULT_BACKGROUND_COLOR COLOR(0xed, 0xed, 0xed)

#define COLOR_WITH_IMAGE_NAME(name)     [UIColor colorWithPatternImage:[UIImage imageNamed:name]]
#define IMAGE_WITH_IMAGE_NAME(name)     [UIImage imageNamed:name]

#pragma mark - common ui elements
#define NUMBER_BADGE_COLOR    COLOR(231,50,47)
#define PHOTO_MARGIN                    3.0f

#pragma mark - table list
#define SEPARATOR_LINE_COLOR            COLOR(158,161,168)

#define APP_DELEGATE                [UIApplication sharedApplication].delegate
#define APP_WINDOW                  ((UIWindow *)([[UIApplication sharedApplication].windows objectAtIndex:0]))
#define WINDOW                      (APP_DELEGATE).window
#define SCREEN_WIDTH            WINDOW.frame.size.width
#define SCREEN_HEIGHT           WINDOW.frame.size.height

#define kDEFAULT_DATE_TIME_FORMAT   (@"yyyy-MM-dd HH:mm:ss")

#pragma mark - core data
#define COREDATA_SQLITE_FILE        @"ECCoreData"
#define SELECTED_PREDICATE          [NSPredicate predicateWithFormat:@"(selected == 1)"]

#define MARGIN                      5.0f


#define HEADER_SCROLL_HEIGHT  240.f


#define CHART_PHOTO_WIDTH               35.f //42.5f
#define CHART_PHOTO_HEIGHT              35.f //50.0f

//底部高度
#define ITEM_BASE_TOP_VIEW_HEIGHT    0
#define ITEM_BASE_BOTTOM_VIEW_HEIGHT    40

#define ALONE_MARKETING_TAB_HEIGHT 44

#pragma mark - network


#pragma mark - we chat
#define WX_API_KEY @"test"


#pragma mark - homepage
#if APP_TYPE != APP_TYPE_FOSUN
#define HOMEPAGE_TAB_HEIGHT             40.0f
#else
#define HOMEPAGE_TAB_HEIGHT             48.0f
#endif

#define NO_IMAGE_FLAG                 @"no_image_url_"


#pragma mark - WeChat integration
#define MAX_WECHAT_ATTACHED_IMG_SIZE    30 * 1024
#define MAX_WECHAT_MAX_DESC_CHAR_COUNT  32
#define MAX_WECHAT_MAX_TITLE_CHAR_COUNT 60

typedef enum {
    NO_ROUNDED,
    HAS_ROUNDED,
    OVAL_ROUNDED,
} ButtonRoundedType;

#pragma mark - UI constants
//#define FONT_SYSTEM_SIZE(aSize) [UIFont fontWithName:@"MicrosoftYaHei" size:aSize]
//#define FONT_BOLD_SYSTEM_SIZE(aSize) [UIFont fontWithName:@"MicrosoftYaHei-Bold" size:aSize]
#define FONT_SYSTEM_SIZE(size) [UIFont systemFontOfSize:(size + 1)]
#define FONT_BOLD_SYSTEM_SIZE(size) [UIFont boldSystemFontOfSize:(size + 1)]
#define ARIAL_FONT(aSize)                [UIFont fontWithName:@"Arial" size:aSize]
#define ARIAL_BOLD_ITALIC_FONT(aSize)     [UIFont fontWithName:@"Arial-BoldItalicMT" size:aSize];
#define ITALIC_FONT(aSize)          [UIFont fontWithName:@"Arial-ItalicMT" size:aSize]
//#define Arial_FONT(aSize)           [UIFont fontWithName:@"Arial" size:aSize]
#define TIMESNEWROM_ITALIC(aSize)   [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:aSize]
#define TIMESNEWROM_BOLD_ITALIC(aSize)   [UIFont fontWithName:@"TimesNewRomanPS-BoldItalicMT" size:aSize]
#define BOLD_HK_FONT(aSize)         [UIFont fontWithName:@"HiraKakuProN-W6" size:aSize]
#define HK_FONT(aSize)              [UIFont fontWithName:@"HiraKakuProN-W3" size:aSize]

#define FONT_HEITI_SIZE(aSize)       [UIFont fontWithName:@"STHeitiSC" size:aSize]
#define FONT_HEITI_MEDUIM_SIZE(aSize)       [UIFont fontWithName:@"STHeitiSC-Medium" size:aSize]

#pragma mark - date formatter type
typedef enum {
    FormatType_Default = 0,
    FormatType_Han
}FormatType;

typedef enum {
    TAB_BAR_FIRST_TAG,
    TAB_BAR_SECOND_TAG,
    TAB_BAR_THIRD_TAG,
    TAB_BAR_FOURTH_TAG,
    TAB_BAR_FIFTH_TAG,
} HomeEntranceItemTagType;

#pragma mark - training

typedef enum {
    MY_COURSE_TY,
    ALL_COURSE_TY,
}TrainingCourseType;

#pragma mark - alumnus
typedef enum {
    OTHER_CLASS_ALUMNUS_TY,
    SAME_CLASS_ALUMNUS_TY,
} KnownAlumnusType;

typedef enum {
	CHAT_SHEET_IDX,
	DETAIL_SHEET_IDX,
    CANCEL_SHEET_IDX,
} UserListActionSheetType;

typedef enum {
    NetworkConnectionStatusOff,
    NetworkConnectionStatusOn,
    NetworkConnectionStatusDoing,
    NetworkConnectionStatusDone,
    NetworkConnectionStatusLoading,
} NetworkConnectionStatus;

/*!
 @enum
 @abstract Cell Margin Type
 @constant left left的Tag
 @constant right right的Tag
 @constant top top的Tag
 @constant bottom bottom的Tag
 */
typedef struct {
    CGFloat left;
    CGFloat right;
    CGFloat top;
    CGFloat bottom;
}CellMargin;

UIKIT_STATIC_INLINE CellMargin NSCellMarginMake(CGFloat left,
                                                CGFloat right,
                                                CGFloat top,
                                                CGFloat bottom) {
    CellMargin cm = {left, right, top, bottom};
    return cm;
}

typedef struct {
    CGFloat x;
    CGFloat y;
}CellDist;

UIKIT_STATIC_INLINE CellDist NSCellDistanceMake(CGFloat x,
                                                CGFloat y) {
    CellDist cd = {x, y};
    return cd;
}

enum GROUP_PROPERTY_TYPE {
    GROUP_PROPERTY_TYPE_NAME = 1,
    GROUP_PROPERTY_BRIEF,
    GROUP_PROPERTY_PHONE,
    GROUP_PROPERTY_EMAIL,
    GROUP_PROPERTY_WEBSITE,
};


enum FRIEND_TYPE {
    FRIEND_TYPE_UPDATE = 0,
    FRIEND_TYPE_DELETE = 2,
    FRIEND_TYPE_ADD = 1,
    FRIEND_TYPE_PRIVATE_DELETE=3,
};

#pragma mark - event
#define FAKE_EVENT_INTERVAL_DAY   -1

typedef enum {
    OTHER_CATEGORY_EVENT = 0,
    TODAY_CATEGORY_EVENT = 1,
    THIS_MONTH_CATEGORY_EVENT,
} EventDateCategory;

#pragma mark - download status

typedef enum {
    DownloadStatus_unDownload = 1 << 5,
    DownloadStatus_Downloaded,
    DownloadStatus_Paused,
    DownloadStatus_Downloading
}DownloadStatus;

typedef enum {
    ChapterStatue_Learned = 1 << 2,
    ChapterStatus_Unlearn,
}ChapterStatus;

typedef struct {
    DownloadStatus downloadStatus;
    ChapterStatus chapterStatus;
}ManageStatus;

UIKIT_STATIC_INLINE ManageStatus NSManageStatusSet(DownloadStatus ds,
                                                   ChapterStatus cs) {
    ManageStatus nmss = {ds, cs};
    return nmss;
}

#define SEND_POST_SUPPLY         @"2"
#define SEND_POST_DEMAND         @"1"

#define PHOTO_SIDE_LENGTH               40.0f
#define IMAGE_SIDE_LENGTH               70.0f

#define POST_DETAIL_PHOTO_WIDTH         43.0f
#define POST_DETAIL_PHOTO_HEIGHT        51.0f

#define COLOR(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGB_SEPARATOR   @"-"
#define RGB_COMPONENT_COUNT 3
#define COLOR_ALPHA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define COLOR_HSB(h, s, b, fact) [UIColor colorWithHue:(h/360.0) saturation:(s/100.0) brightness:((b/100.0)*fact) alpha:1.0]
#define SAFECOLOR(color) MIN(255,MAX(0,color))

#define SEPARATOR_LINE_COLOR            COLOR(158,161,168)

#define TITLESTYLE_COLOR                COLOR(180,18,21)
#define SUBTITLESTYLE_COLOR             COLOR(161,167,170)
#define BACKGROUND_COLOR                COLOR(239, 239, 239)//COLOR(229,229,231)

#define RED_BTN_BORDER_COLOR            COLOR(205,50,6)
#define RED_BTN_TITLE_COLOR             COLOR(238,92,66)
#define RED_BTN_TITLE_SHADOW_COLOR      [UIColor whiteColor]
#define RED_BTN_TOP_COLOR               COLOR(255,250,205)
#define RED_BTN_BOTTOM_COLOR            COLOR(255,193,37)

#define ORANGE_BTN_BORDER_COLOR         COLOR(205,50,6)
#define ORANGE_BTN_TITLE_COLOR          [UIColor whiteColor]
#define ORANGE_BTN_TITLE_SHADOW_COLOR   [UIColor blackColor]
#define ORANGE_BTN_TOP_COLOR            COLOR(255,250,205)
#define ORANGE_BTN_BOTTOM_COLOR         COLOR(255,193,37)

#define BLUE_BTN_BORDER_COLOR           COLOR(16,78,139)
#define BLUE_BTN_TITLE_COLOR            [UIColor whiteColor]
#define BLUE_BTN_TITLE_SHADOW_COLOR     [UIColor blackColor]
#define BLUE_BTN_TOP_COLOR              COLOR(209,238,238)
#define BLUE_BTN_BOTTOM_COLOR           COLOR(79,148,205)

#define GRAY_BTN_BORDER_COLOR           [UIColor darkGrayColor]
#define GRAY_BTN_TITLE_COLOR            [UIColor darkGrayColor]
#define GRAY_BTN_TITLE_SHADOW_COLOR     [UIColor whiteColor]
#define GRAY_BTN_TOP_COLOR              [UIColor whiteColor]
#define GRAY_BTN_BOTTOM_COLOR           [UIColor lightGrayColor]

#define DARK_GRAY_BTN_TOP_COLOR         COLOR(77, 78, 80)
#define DARK_GRAY_BTN_BOTTOM_COLOR      COLOR(25, 25, 25)

#define DEEP_GRAY_BTN_BORDER_COLOR            COLOR(213,213,213)

#define LIGHT_GRAY_BTN_BORDER_COLOR           COLOR(186,186,186)
#define LIGHT_GRAY_BTN_TITLE_COLOR            COLOR(106,106,106)
#define LIGHT_GRAY_BTN_TITLE_SHADOW_COLOR     COLOR(255,255,255)
#define LIGHT_GRAY_BTN_TOP_COLOR              COLOR(240,240,240)
#define LIGHT_GRAY_BTN_BOTTOM_COLOR           COLOR(211,211,212)

#define BLACK_BTN_BORDER_COLOR                COLOR(116,116,116)
#define BLACK_BTN_TITLE_COLOR                 [UIColor whiteColor]
#define BLACK_BTN_TITLE_SHADOW_COLOR          [UIColor blackColor]

#define ZERO_EDGE                       UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)

#define BASE_INFO_COLOR                 COLOR(130, 130, 140)
#define MAIN_LABEL_COLOR                COLOR(131, 131, 133)
#define PROFILE_TITLE_COLOR             COLOR(123, 124, 126)
#define PROFILE_VALUE_COLOR             COLOR(135, 26, 24)
#define ORANGE_COLOR                    COLOR(233, 80, 55)
#define CELL_BASE_INFO_HEIGHT           16.0f
#define PHOTO_SIDE_LENGTH               40.0f
#define IMAGE_SIDE_LENGTH               70.0f

#define PHOTO_LONG_LEN_IPHONE   180//280
#define PHOTO_SHORT_LEN_IPHONE	135//210
#define	PHOTO_LONG_LEN_1G3G     600
#define PHOTO_SHORT_LEN_1G3G    450
#define	PHOTO_LONG_LEN_3GS      640
#define PHOTO_SHORT_LEN_3GS     480
#define	PHOTO_LONG_LEN_4G       680
#define PHOTO_SHORT_LEN_4G      510
#define	PHOTO_LONG_LEN_5G       800
#define PHOTO_SHORT_LEN_5G      450

#define LIST_WIDTH                  320.0f//477

#define TOOLBAR_HEIGHT              44.0f
#define VIEW_TITLE_BAR_COLOR        COLOR(185, 19, 26)
#define CELL_TOP_COLOR              COLOR(240, 240, 240)
#define CELL_BOTTOM_COLOR           COLOR(232, 233, 232)
#define CELL_SELECTED_COLOR         COLOR(102, 102, 102)
#define CELL_BACKGROUND_COLOR       COLOR(218, 218, 218)
#define PROFILE_DETAIL_TEXT_COLOR   COLOR(52, 52, 52)
#define TEXT_SHADOW_COLOR           [UIColor whiteColor]
#define GREEN_BLOCK_COLOR           COLOR(163, 200, 37)
#define YELLOW_BLOCK_COLOR          COLOR(246, 195, 55)

#pragma mark - industry
#define INDUSTRY_ALL_ID           @"A:AA"
#define INDUSTRY_ALL_CN_NAME      @"全部"
#define INDUSTRY_ALL_EN_NAME      @"All"

#pragma mark - tag
#define CENTER_ITEM_ID            0ll
#define TAG_ALL_ID                0ll
#define ITEM_TAG_ID_SEPARATOR     @","

#define POST_IMG_LONG_SIDE      80.0f
#define POST_IMG_SHORT_SIDE     60.0f

#define FRONT_PHOTO_LONG_LEN    640.0f
#define FRONT_PHOTO_SHORT_LEN   480.0f

#define ITEM_PROPERTY_CELL_HEIGHT       40.0f

#define IMG_LONG_LEN_IPHONE        180.0f//280
#define IMG_SHORT_LEN_IPHONE       135.0f//210

#define FEED_IMG_LONG_LEN_IPHONE   240.0f
#define FEED_IMG_SHORT_LEN_IPHONE  180.0f

#define KEYBOARD_GAP                    20.0f

#define HOME_PAGE_BTN_WIDTH   105.0f
#define HOME_PAGE_BTN_HEIGHT  110.0f
#define SEPARATOR_THICKNESS   2.0f

#define DARK_TEXT_COLOR  COLOR(98, 87, 87)

#define NUMBER_BADGE_TOP_COLOR    COLOR(231,50,47)
#define NUMBER_BADGE_BOTTOM_COLOR COLOR(231,50,47)
#define NUMBER_BADGE_HEIGHT       20.0f

#define PNG_POSTFIX                   @"png"
#define JPG_POSTFIX                   @"jpg"
#define GIF_POSTFIX                   @"gif"
#define WEBVIEW_IMG_URL               @"//image"
#define LOADING_IMG_HEIGHT            36.0f
#define ADD_PHOTO_BUTTON_SIDE_LENGTH  216.0f
#define APPLE_SCHEME                  @"applewebdata"
#define WEBVIEW_IMG_URL               @"//image"
#define SELECTED_IMG                  [UIImage imageNamed:@"selected.png"]
#define UNSELECTED_IMG                [UIImage imageNamed:@"unselected.png"]
#define RADIO_IMG                     [UIImage imageNamed:@"radioButton.png"]
#define RADIO_BUTTON_IMG              [UIImage imageNamed:@"radioButton.png"]
#define NO_IMAGE_FLAG                 @"no_image_url_"

typedef enum {
    DEMAND_POST_TY = 1,
    SUPPLY_POST_TY = 2,
    DISCUSS_POST_TY = 3,
    SHARE_POST_TY = 5,
    EVENT_DISCUSS_POST_TY = 4,
    BIZ_POST_TY = 6,
    SUPPLY_DEMAND_COMBINE_TY = 7,
} PostType;

typedef enum {
    SUPPLY_ITEM_TY = SUPPLY_POST_TY,
    DEMAND_ITEM_TY = DEMAND_POST_TY
} SupplyDemandItemType;

typedef enum {
	PHOTO_BTN,
	CLOSE_BTN,
	CALL_BTN,
    BIRTHDATE_BTN,
} ActionSheetOwnerType;

typedef enum {
    TRANSPARENT_BTN_COLOR_TY = 1,
    RED_BTN_COLOR_TY,
    ORANGE_BTN_COLOR_TY,
    GRAY_BTN_COLOR_TY,
    LIGHT_GRAY_BTN_COLOR_TY,
    TINY_GRAY_BTN_COLOR_TY,
    DEEP_GRAY_BTN_COLOR_TY,
    BLUE_BTN_COLOR_TY,
    BLACK_BTN_COLOR_TY,
    WHITE_BTN_COLOR_TY,
} ButtonColorType;

#define IPHONE_SIMULATOR                        @"iPhone Simulator"
#define SIMULATION_LATITUDE                    @"31.2887"
#define SIMULATION_LONGITUDE                @"121.517"

#define GET_DEVICE_TOKEN                        @"GetDeviceToken"

#pragma mark - load item type
typedef enum {
    REGIST_TY,
    LOGIN_TY,
    LOGIN_OA_TY,
    LOAD_LATEST_VIDEO_TY,
    EVENTLIST_TY,
    LOAD_KNOWN_ALUMNUS_TY,
    SUBMIT_FEEDBACK_TY,
    
    //common
    LOAD_IMAGE_LIST_TY,//获取 图片墙图片信息
    LOAD_BUSINESS_IMAGE_LIST_TY,
    LOAD_UPDATE_VERSION_TY,
    
    GET_USER_PROFILES,//登录前获取所有用户信息
    REGIST_PUSH_NOTIFY_TY,//注册推送接口
    
    //资讯
    SEARCH_INFORMATION_LIST_TY,//获取资讯列表
    GET_APPLY_MEMBER_LIST_TY,//获取报名成员列表
    LOAD_INFORMATION_LIST_TY,//获取资讯列表
    LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY,
    LOAD_CATEGORY_TY,//不打扰营销列表
    LOAD_EVENT_PRE_TY,//获取活动预告
    LOAD_EVENT_REV_TY,//获取活动回顾
    LOAD_EVENT_DETAIL_PRE_TY,//获取活动预告详情
    LOAD_EVENT_DETAIL_REV_TY,//获取活动回顾详情
    SUBMIT_APPLY_TY,
    UPDATE_READER_TY, //更新读者数
    LOAD_INFORMATION_COMMENT_TY,
    SUBMIT_INFORMATION_COMMENT_TY,
    
    // 发现
    // 附近
    LOAD_USER_LIST_TY,
    // 供需
    LOAD_BIZ_POST_TY,
    CLUB_POST_LIST_TY,
    SEND_POST_TY,
    SEND_COMMENT_TY,
    DELETE_POST_COMMENTS_TY,
    // supply demand
    LOAD_SUPPLY_DEMAND_ITEM_TY,
    SEND_SUPPLY_DEMAND_TY,
    SUPPLY_DEMAND_TAG_TY,
    SEND_SERVICE_ITEM_COMMENT_TY,
    
    POST_FAVORITE_ACTION_TY,
    POST_UNFAVORITE_ACTION_TY,
    POST_FAVORITE_USERS_TY,
    SUPPLYDEMAND_SHARE_POST_TY,
    COMMENT_LIST_TY,
    ALUMNI_QUERY_DETAIL_TY,
    DELETE_POST_TY,
    
    //企信
    LOAD_ORDER_LIST_TY,
    LOAD_MESSAGE_LIST_TY,
    SEND_MESSAGE_TEXT_TY,
    SEND_MESSAGE_IMAGE_TY,
    SEND_MESSAGE_VIDEO_TY,
    SEND_MESSAGE_VOICE_TY,
    
    
    //业务
    LOAD_EVENT_VOTE_LIST,
    GET_BUSINESS_CATEGORY,
    LOAD_EVENT_COMMENT_TY,
    SUBMIT_EVENT_COMMENT_TY,
    
    GET_DETAIL_PAGE_1_TY,
    //培训
    GET_TRAINING_LIST_TY,
    GET_COURSE_CHAPTER_TY,
    SUBMIT_CHAPTER_COMPLETION_TY,
    GET_BOOK_IMAGE_LIST,
    GET_BOOK_LIST_TY,
    
    //交流
    SET_USER_LOGIN_LICALL,//设置爱聊
    
    GET_GROUP_USER_LIST,//获取群组用户列表
    GET_USER_SEARCH_TY,//获取用户搜索
    SUBMIT_VOTE_TY,//提交投票
    
    GET_CHAT_GROUP_LIST_TY,//获取群组好友列表
    LOAD_COMMUNICATE_GROUP_LIST_TY,//获取交流群组列表
    
    SUBMIT_JOING_CHAT_GROUP_TY,//加入群组
    SUBMIT_QUIT_CHAT_GROUP_TY,//退出群组
    SUBMIT_DELETE_CHAT_GROUP_TY,//删除群组
    SUBMIT_CREAT_CHAT_GROUP_TY,//创建群组
    SUBMIT_UPDATE_CHAT_GROUP_TY,//更新群组信息
    SUBMIT_PRIVETE_LETTER_TY,//提交私信，	向某人发送私信，但不能自己向自己发
    
    GET_CHAT_GROUP_JOINED_TY,//获取某会员加入的群组列表
    GET_PRIVATE_LETTER_USER_LIST_TY,//私信人员列表
    GET_FRIEND_LETTER_USER_LIST_TY,//好友列表
    
    //更多
    UPLOAD_IMAGE_TY,//上传头像
    SUBMIT_NEW_PWD_TY,
    SAVE_INFO_TO_SERVER,
} WebItemType;

typedef enum {
    HANDY_PHOTO_TAKER_TY,
    POST_COMPOSER_TY,
    SERVICE_ITEM_PHOTO_TY,
    SERVICE_PROVIDER_PHOTO_TY,
    USER_AVATAR_TY,
    SERVICE_ITEM_AVATAR_TY,
} PhotoTakerType;

enum DOWNLOADED_CELL_MODE {
    DOWNLOADED_CELL_MODE_NORMAL = 1,
    DOWNLOADED_CELL_MODE_EDIT = 2,
};

typedef enum {
    ALL_NEWS_TY,
    FOR_HOMEPAGE_NEWS_TY = 1,
    ALUMNI_NEWS_TY,
    UNION_NEWS_TY,
} NewsType;

typedef enum {
    
    ERR_CODE = -1,
    MOC_SAVE_ERR_CODE = 1,
    NO_DATA_CODE = 1001,
    SUCCESS_CODE = 200,
    RESP_OK = 200,
    
    EMAIL_TEXT_ERR_CODE = 201, // 邮箱输入不正确。
    EMAIL_ACCOUNT_NOT_CODE = 202, //账号不存在。
    EMAIL_SEND_ERR_CODE = 203, //邮件发送失败。
    
    APP_EXPIRED_CODE = 206,
    SOFT_UPDATE_CODE = 220,
    
    
    // system error code
    SESSION_EXPIRED_CODE = 101,
    BACKEND_ERR_CODE = 102,
    DB_ERROR_CODE = 103,
    USER_NO_AUTH_CODE = 104,
    
    // biz error code
    CUSTOMER_NAME_ERR_CODE = 300,
    USERNAME_ERR_CODE = 301,
    PASSWORD_ERR_CODE = 302,
    ACCOUNT_INVALID_CODE = 303,
    MOBILE_OCCUPIED_CODE = 304,
    EMAIL_OCCUPIED_CODE = 305,
    HAS_NEW_VERSION_CODE = 306,
    // join the group
    GROUP_REJECT_JOIN = 307,
    GROUP_NEED_AUDIT_JOIN = 308,
    GROUP_APPLY_JOINED = 309,
    GROUP_EXIT_FAILED = 400,
    
    // object handle
    OBJ_IS_NULL_CODE = 404,
    
    PASSWORD_OLD_ERR_CODE = 425,
    
    GROUP_NOT_EXIST = 1002,
    // coustom jump
    COUSTOM_JUMP_PROFILE = 4001,// 个人名片页面
    COUSTOM_JUMP_CERTIFICATION = 4002,// 提交认证资料页面
    COUSTOM_JUMP_APPROVAL = 4003,// 待认证页面
    
} ConnectionAndParserResultCode;


#define OBJ_FROM_DIC(_DIC_, _KEY_) [CommonUtils validateResult:_DIC_ dicKey:_KEY_]
#define INT_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).intValue
#define FLOAT_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).floatValue
#define DOUBLE_VALUE_FROM_DIC(_DIC_, _KEY_) ((NSString *)OBJ_FROM_DIC(_DIC_, _KEY_)).doubleValue


#pragma mark - UIAlertView
#define ShowAlert(Delegate,TITLE,MSG,But) [[[[UIAlertView alloc] initWithTitle:(TITLE) \
message:(MSG) \
delegate:Delegate \
cancelButtonTitle:But \
otherButtonTitles:nil] autorelease] show]


#define RET_CODE_NAME               @"code"
#define RET_DESC_NAME               @"description"


//-------------------------------------------communication----------------------------------------
#define COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT   78
#define COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK   63.5
#define COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT   0.5


#define SYSTEM_STATUS_BAR_HEIGHT   20


#define COMMUNICATE_PROPERTY_CELL_HEIGHT    45
#define COMMUNICATE_PROPERTY_CELL_FOOTER_HEIGHT    20

#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT 4
#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH   60
#define COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT   (COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH + 20)


#pragma mark - local user default storage
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
#define LOADING_NOTIFY_LOCAL_KEY        @"LOADING_NOTIFY_LOCAL_KEY"

#define KEY_PROPERTY_CONTENT_TYPE_TITLE @"contentTitle"
#define KEY_PROPERTY_CONTENT_TYPE_VALUE @"contentVale"
#define KEY_PROPERTY_CONTENT_TYPE_TYPE  @"contentType"
#define KEY_PROPERTY_CONTENT_TYPE_SEL  @"contentSEL"
#define KEY_PROPERTY_CONTENT_TYPE_TARGET  @"contentTarget"



#define PROPERTY_TYPE_BUTTON    @"1"
#define PROPERTY_TYPE_TEXT      @"2"

#pragma mark - network
#define HOST_TYPE                   14
#define HOST_URL                    @"http://112.124.68.147:5022/"

//------------------------
#define APP_NAME                    @"GoHigh"
#define SINGLE_LOGIN_APP_NAME       @"GoHigh"
#define PLATFORM                    @"iPhone"
#define APP_ID                      @"GoHigh"

#define POST_MOD_ID           @"POST_MOD"

#define IMAGE_UPLOAD_URL            @"http://180.153.154.21:9001/UploadImage.aspx"

#pragma mark - Post
#define SUBMIT_POST_MESSAGE_URL             @"PostService/submitPost"
#define SUBMIT_POST_COMMENT_URL             @"PostService/submitPostComment"
#define SUBMIT_POST_LIKE_URL                @"PostService/submitPostLike"
#define GROUP_POST_LIST_URL                 @"PostService/GetPosts"
#define GET_POST_DETAIL_URL                 @"PostService/GetPostDetail"
#define GET_POST_COMMENTS_URL               @"PostService/GetPostComments"
#define DELETE_POST_COMMENTS_URL            @"PostService/deletePostComments"
#define LIKE_POST_URL                       @"PostService/submitPostLike"
#define GET_USER_LIST_URL                   @"PostService/getPostLiker"
#define GROUP_SUBUMIT_POST_URL              @"PostService/submitPost"
#define GROUP_SUBMIT_COMMENT_URL            @"PostService/submitPostComment"
#define SUBMIT_POST_ATTENTION               @"PostService/submitPostAttention"
#define DELETE_POST_URL                     @"PostService/deletePost"
#define SUPPLYDEMAND_POST_SHARE_URL         @"PostService/setShareCounts"

#define KEYBOARD_GAP                    20.0f
#define ADD_PHOTO_BUTTON_SIDE_LENGTH  120.f

#pragma mark - invoketype

#define INVOKETYPE_LOOKUSERINFO  1
#define INVOKETYPE_EDITUSERINFO  2
#define INVOKETYPE_SEARCHUSER    3
#define INVOKETYPE_SAVEUSERINFO  4
#define INVOKETYPE_ALLUSERINFO   5

#pragma mark - controlType

#define CONTROLTYPE_TEXT        1
#define CONTROLTYPE_MTEXT       2
#define CONTROLTYPE_DROPLIST    3
#define CONTROLTYPE_IMAGE       4

#pragma mark - imageType

#define IMAGETYPE_INFORMATION       1
#define IMAGETYPE_EVENT             2
#define IMAGETYPE_TRAIN             3
#define IMAGETYPE_PROJECT_THUMBNAIL 4
#define IMAGETYPE_PROJECT_ORIGINAL  5

#pragma mark - informationtype

#define INFORMATION_TYPE_NEWS_INFOTMATION        1
#define INFORMATION_TYPE_ALONE_MARKETING         2
#define INFORMATION_TYPE_BUSINESS                3
#define INFORMATION_TYPE_RECOMMEND_BOOK          4

#define FULL_WIDTH_COMMA          @","
#define HALF_WIDTH_COMMA          @"，"

#pragma mark - eventsType

#define EVENTS_TYPE_PRE  0 //预告
#define EVENTS_TYPE_REV  1 //回顾
#define EVENTS_TYPE_ALL  2 //全部


#define GROUP_PROPERTY_MAX_COUNT_NAME   20
#define GROUP_PROPERTY_MAX_COUNT_BRIEF  200
#define GROUP_PROPERTY_MAX_COUNT_PHONE 15
#define GROUP_PROPERTY_MAX_COUNT_EMAIL  20
#define GROUP_PROPERTY_MAX_COUNT_WEBSITE    20

#pragma MARK - categoryType

#define CATEGORY_TYPE_ALONE_MARKETING   2
#define CATEGORY_TYPE_BUSINESS          3

#define USE_ASIHTTP 0

#define ImageWithName(string) [UIImage imageNamed:string]

#define NUMBER(__OBJ) [NSNumber numberWithInt:__OBJ]
#define NUMBER_LONG(__OBJ) [NSNumber numberWithLong:__OBJ]
#define NUMBER_DOUBLE(__OBJ) [NSNumber numberWithDouble:__OBJ]


#define MESSAGE_CREATE_GROUP(creator)   \
    [NSString stringWithFormat:@"%@创建了此群", creator]

#define MESSAGE_INVITED_GROUP(inviter, invitee)     \
    [NSString stringWithFormat:@"%@被%@邀请加入此群", invitee, inviter]

#define MESSAGE_REMOVE_FROM_GROUP(remover, removee)     \
    [NSString stringWithFormat:@"%@被%@从此群中移除", removee, remover]

#define MESSAGE_QUIT_GROUP(quiter)      \
    [NSString stringWithFormat:@"%@已退出此群", quiter]


@interface GlobalConstants : NSObject {
    
}

@end