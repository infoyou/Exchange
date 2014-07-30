//
//  CommonUtils.h
//  Project
//
//  Created by XXX on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeader.h"
@class Post;
@interface CommonUtils : NSObject


#pragma mark - user default local storage
+ (void)saveIntegerValueToLocal:(NSInteger)value key:(NSString *)key;
+ (void)saveLongLongIntegerValueToLocal:(long long)value key:(NSString *)key;
+ (void)saveStringValueToLocal:(NSString *)value key:(NSString *)key;
+ (long long)fetchLonglongIntegerValueFromLocal:(NSString *)key;
+ (NSString *)fetchStringValueFromLocal:(NSString *)key;
+ (void)removeLocalInfoValueForKey:(NSString *)key;
+ (void)saveBoolValueToLocal:(BOOL)value key:(NSString *)key;
+ (BOOL)fetchBoolValueFromLocal:(NSString *)key;
+ (NSInteger)fetchIntegerValueFromLocal:(NSString *)key;

#pragma mark - date time
+ (NSString *)currentHourTime;
+ (NSString *)currentHourMinSecondTime;
+ (NSDate *)convertDateTimeFromUnixTS:(NSTimeInterval)unixDate;
+ (NSString *)simpleFormatDate:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy;
+ (NSString *)simpleFormatDateWithYear:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy;
+ (NSTimeInterval)convertToUnixTS:(NSDate *)date;
+ (NSString *)getElapsedTime:(NSDate *)timeline;
+ (NSInteger)getElapsedDayCount:(NSDate *)date;
+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset;
+ (NSString *)getQuantumTimeWithDateFormat:(NSString *)timeline;
//+ (NSString *)getQuantumTimeWithTimeStamp:(NSString *)timeline;


#pragma mark - validate json data
+ (id)validateResult:(NSDictionary *)contentDic dicKey:(NSString *)key;

#pragma mark - validate password format
+ (BOOL)passwordFormatIsValidated:(NSString *)passwordStr;

#pragma mark - Share to WeChat
+ (BOOL)shareByWeChat:(NSInteger)scene
                title:(NSString *)title
                image:(NSString *)image
          description:(NSString *)description
                  url:(NSString *)url;

+ (BOOL)sharePostByWeChat:(Post *)post
                    scene:(NSInteger)scene
                      url:(NSString *)url
                    image:(UIImage *)image;


+ (NSString *)deviceModel;
+ (NSString *)documentsDirectory;
+ (CGFloat)currentOSVersion;

+ (NSString *)datetimeWithFormat:(NSString *)format datetime:(NSDate *)datetime;

#pragma mark - Gene Url
+ (NSString *)geneJSON:(NSDictionary *)specialDict;
+ (NSString *)geneJSONUrl:(NSDictionary *)param itemType:(WebItemType)itemType;

+ (NSString *)decodeAndReplacePlusForText:(NSString *)text;

+ (BOOL)screenHeightIs4Inch;

#pragma mark - image handle
+ (UIImage *)effectedImageWithType:(PhotoEffectType)type
                     originalImage:(UIImage *)originalImage;

+ (UIImage *)cutMiddlePartImage:(UIImage *)image
                          width:(CGFloat)width
                         height:(CGFloat)height;
+ (UIImage *)cutPartImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

+ (UIInterfaceOrientation)currentOrientation;
+ (BOOL)currentOrientationIsLandscape;

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

#pragma mark - combine image
+ (UIImage *)combineImage:(NSMutableArray *)imageArray;

@end
