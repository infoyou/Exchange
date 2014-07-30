//
//  CommonMethod.h
//  Project
//
//  Created by XXX on 13-7-16.
//  Copyright (c) 2013年 kid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListHeader.h"
#import "UserHeader.h"
#import "ASIHTTPRequest.h"
#import "FTPHelper.h"
#import "ChapterList.h"


#define KEY_FTP_USERNAME @"username"
#define KEY_FTP_PASSWORD @"password"
#define KEY_FTP_PREURL   @"prefix_url"


@class UserProfile;
@interface CommonMethod : NSObject

@property (nonatomic, assign) UIViewController * navigationRootViewController;
@property (nonatomic, assign) UIViewController * lastViewController;
@property (nonatomic, assign) UINavigationController *navigationController;
@property (nonatomic, assign) NSManagedObjectContext *MOC;

- (UINavigationController *)getNavigationController;

+ (CommonMethod *)getInstance;
+ (void)sortArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo;
+ (NSString *)GetUUID;
+ (NSString*)deviceString;

+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)createImageWithColor:(UIColor *)color withRect:(CGRect )rect;
+ (UIButton *)addButton:(id)target withRect:(CGRect)rect withTitle:(NSString *)title withTarget:(SEL)sel;
+ (UITextField *)addTextField:(id)target withRect:(CGRect)rect withEdgeMakeRect:(UIEdgeInsets)edgeRect withPlaceHolderText:(NSString *)placeholder;
+ (UILabel *)addLabel:(CGRect)rect withTitle:(NSString *)title withFont:(UIFont *)font;

+ (UIImage *)drawImageToRect:(UIImage *)image withRegionRect:(CGRect)regionRect;
+ (UIImage *)drawImageToRect:(UIImage *)image withImageRect:(CGRect )imageRect withRegionRect:(CGRect)regionRect;
+ (UIImage *)drawImageToRect:(UIImage *)image withImageRect:(CGRect )imageRect withMaskImage:(UIImage *)image withMaskImageRect:(CGRect )imageMaskRect withRegionRect:(CGRect)regionRect;
+ (UIImage*)regionImage:(UIImage*) image withRect:(CGRect ) rect;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;


+ (NSString *)getAppIcon;

+ (BOOL)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath;
+ (void)writeImage:(UIImage *)image toLocalPath:(NSString *)localPath completion:(void(^)(BOOL completion))completion;

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font;


+ (void)pushViewController:(UIViewController *)viewController withAnimated:(BOOL)animated;
+ (void)popViewController:(UIViewController *)viewController;


+ (double)getCurrentTimeSince1970;
+ (NSString *)getDateFromNow:(int)distDay;
+ (NSString *)getShortTime1:(NSTimeInterval)interval;

+ (NSString *)convertLongTimeToString:(NSTimeInterval)timestamp;
+(NSString *)convertLongTimeToCircleMarketingString:(NSTimeInterval)timestamp;
+ (NSString *)getFormatedTime:(NSTimeInterval)timestamp;
+ (NSString *)getChatFormatedTime:(NSTimeInterval)timestamp;

+ (NSString *)stringForNow;

+ (NSString *)convertURLToLocal:(NSString *)url;
+ (NSString *)convertURLToLocal:(NSString *)url withId:(NSString *)itemId;
+ (NSString *)getLocalDownloadFileName:(NSString *)imageURL  withId:(NSString *)itemId;
+ (NSString *)getLocalImageFolder;
+ (NSString *)getLocalDownloadFolder;
+ (NSString *)getLocalTrainingDownloadFolder;
+ (NSString *)getLocalDownloadFileName:(NSString *)fileURL;

+ (void)loadImageWithURL:(NSString *)imageURL
             delegateFor:(id)delegateFor
               localName:(NSString *)name
                finished:(void (^)(void))finished;

+ (BOOL)isExist:(NSString *)fileName;

+ (void)viewAddGuestureRecognizer:(UIView *)view withTarget:(id)target withSEL:(SEL)sel;

+ (NSString*)hashStringAsMD5:(NSString*)str;

+ (NSString *)encodeURLWithURL:(NSString *)url;
+ (NSString *)decodeURLWithURL:(NSString *)url;

+ (NSString *)JSONStringFromURL:(NSString *)url;
+ (NSDictionary *)dictionaryFromURL:(NSString *)url;
+ (NSDictionary *)dictionaryFromJSONString:(NSString *)jsonString;

//-----------------------userProfile-------------------

+ (NSArray *)userProfilesFromUserList:(NSArray *)array;
+ (NSArray *)userProfilesFromUserListWithUserInfo:(NSArray *)array;

+ (UserProfile *)userProfileWithUserID:(int)userID;
+ (UserProfile *)userProfileFromMemberList:(NSArray *)memberList WithUerID:(int)userID;
+ (UserProfile *)formatUserProfileWithParam:(NSDictionary *)dict;

+ (UserBaseInfo *)userBaseInfoWithUserProfile:(UserProfile *)userProfile;
+ (UserBaseInfo *)userBaseInfoWithUserID:(int)userID;
+ (UserBaseInfo *)userBaseInfoWithDictUserProfile:(UserProfile *)userProfile;

+ (NSMutableDictionary *)encapsulationReqContentWithParam:(NSDictionary *)dict;
+ (NSMutableDictionary *)encapsulationReqContentWithParam:(NSDictionary *)dict withInvokeType:(int)type;

+ (BOOL)uploadUserProfileImageWithImage:(UIImage *)image;

//-----------------------list--------------------------

+ (List *)listWithParam:(NSMutableDictionary *)dict;
+ (List *)listWithParam:(NSMutableDictionary *)dict keyword:(NSString *)keyword;

//-----------------------SileImage---------------------

+ (NSMutableArray *)imageList;

+ (BOOL)is7System;
+ (BOOL)is6System;

//------------show alter
+ (void)showAlert:(id)delegate  title:(NSString *)title tip:(NSString *)tip;
+ (void)preferenceFTPSettings:(NSDictionary *)dic;

//--------------------------study-----
+ (NSString *)getChapterFilePath:(ChapterList *)chapter;
+ (NSString *)getChapterZipFilePath:(ChapterList *)chapter;

//--------------o2o  orderList--------------

+ (NSString *)messageIdFromUUID;
+ (double)timestampOfCurrent;

+ (NSString *)URLForGetOrderList:(NSString *)customerId
                            page:(int)page
                        pageSize:(int)pageSize
                       timestamp:(long long int)timestamp
                          status:(int)status;

+ (NSString *)URLForGetUserMessageList:(NSString *)customerId
                                unitId:(NSString *)unitId
                                userId:(NSString *)userId
                             timestamp:(long long)timestamp
                              pageSize:(int)pageSize
                      displayIndexLast:(int)displayIndexLast;

+ (NSString *)URLForSubmitUserMessage:(NSString *)customerId
                               unitId:(NSString *)unitId
                               userId:(NSString *)userId;

+ (NSString *)URLForServiceWithAction:(NSString *)action
                         specialParam:(NSDictionary *)specparam;

+ (NSString *)URLForO2OLogin:(NSString *)customerName
                    userName:(NSString *)userName
                    password:(NSString *)password;

//--------------send method

+ (void)sendWithPostMethod:(NSString *)url
               requestData:(NSDictionary *)data
                   success:(void (^)(void))success
                    failed:(void (^)(void))failed;

//--------------tables-----------

+ (NSArray *)tableNames;


//---------update
+ (void)update:(NSString *)url;

//---------commit deviceToken

+ (void)commitDeviceToken;

@end