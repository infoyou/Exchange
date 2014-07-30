
#import <UIKit/UIKit.h>
#import "WXWConstants.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>
#import <AddressBook/AddressBook.h>

@class WXWWebViewController;
@class Alumni;
@class Post;

@interface WXWCommonUtils : NSObject {
	
}

#pragma mark - files
+ (NSString *)documentsDirectory;

#pragma mark - device
+ (void)parserDeviceSystemInfo;
+ (UIInterfaceOrientation)currentOrientation;
+ (BOOL)currentOrientationIsLandscape;
+ (NSString *)deviceModel;
+ (CGFloat)currentOSVersion;
+ (BOOL)screenHeightIs4Inch;

#pragma mark - font
+ (UIFont *)boldFontWithSize:(CGFloat)size;
+ (UIFont *)fontWithSize:(CGFloat)size;
+ (NSString *)systemFontName;

#pragma mark - system language
+ (LanguageType)currentLanguage;
+ (void)getLocalLanguage;
+ (void)getDBLanguage;
+ (void)setLanguage:(NSString *)languageDesc;
+ (void)resetCurrentAppLanguage;
+ (NSBundle *)getBundle;

#pragma mark - object class and selector handler
+ (void)checkAndExecuteSelectorWithName:(NSString *)selectorName byTarget:(id)target;

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
+ (NSDate *)NSStringDateToNSDate:(NSString *)string;
+ (NSString *)datetimeWithFormat:(NSString *)format datetime:(NSDate *)datetime;


#pragma mark - network
+ (NSString *)replaceWithNewSessionId:(NSString *)sessionId url:(NSString *)url;
+ (NSString *)assembleUrl:(NSString *)param;
+ (NSString *)convertParaToHttpBodyStr:(NSDictionary *)dic;
+ (NSString *)assembleRequestUrl:(NSString *)param;
//+ (NSString *)assembleurlWithType:(DomainType)type;
+ (NSDate *)getTodayMidnight;
+ (NSString *)assembleXmlRequestUrl:(NSString *)actionName param:(NSString *)param;

#pragma mark - parser hyper link
+ (NSString *)parsedTextForHyperLink:(NSString *)originalText;
+ (NSString *)parsedTextForHyperLinkNoBold:(NSString *)originalText;

#pragma mark - zip
+ (void)saveToZipFile:(NSString *)logFilePath
        logFolderPath:(NSString *)logFolderPath
  zipNoSuffixFileName:(NSString *)zipNoSuffixFileName;

#pragma mark - image handlers
+ (ImageOrientationType)imageOrientationType:(UIImage *)image;
+ (UIImage*)scaleAndRotateImage:(UIImage*)sourceImage
                     sourceType:(UIImagePickerControllerSourceType)sourceType;

+ (UIImage *)resizeImage:(UIImage *)image
                  length:(float)length
                  square:(BOOL)square;

+ (UIImage *)cutPartImage:(UIImage *)image 
                    width:(CGFloat)width 
                   height:(CGFloat)height
                   square:(BOOL)square;

+ (UIImage *)cutPartImage:(UIImage *)image
                    width:(CGFloat)width
                   height:(CGFloat)height;

+ (UIImage *)cutMiddlePartImage:(UIImage *)image
                          width:(CGFloat)width
                         height:(CGFloat)height;
+ (UIImage *)cutCenterPartImage:(UIImage *)image
                           size:(CGSize)imageSize;

#pragma mark - image effect handler
+ (UIImage *)effectedImageWithType:(PhotoEffectType)type originalImage:(UIImage *)originalImage;

#pragma mark - web view
+ (void)clearWebViewCookies;

+ (void)openWebView:(UINavigationController *)parentNavController
              title:(NSString *)title
                url:(NSString *)url
    needCloseButton:(BOOL)needCloseButton
     needNavigation:(BOOL)needNavigation
     needHomeButton:(BOOL)needHomeButton;

+ (void)openWebView:(UINavigationController *)parentNavController
              title:(NSString *)title
                url:(NSString *)url
    needCloseButton:(BOOL)needCloseButton
     needNavigation:(BOOL)needNavigation
blockViewWhenLoading:(BOOL)blockViewWhenLoading
     needHomeButton:(BOOL)needHomeButton;

+ (void)openLocalWebView:(UINavigationController *)parentNavCintroller
                   title:(NSString *)title
                     url:(NSString *)url
         needCloseButton:(BOOL)needCloseButton
          needNavigation:(BOOL)needNavigation
          needHomeButton:(BOOL)needHomeButton;


+ (void)openLocalWebView:(UINavigationController *)parentNavCintroller
                   title:(NSString *)title
                     url:(NSString *)url
         needCloseButton:(BOOL)needCloseButton
          needNavigation:(BOOL)needNavigation
    blockViewWhenLoading:(BOOL)blockViewWhenLoading
          needHomeButton:(BOOL)needHomeButton;

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
+ (NSString *)cacheNamedDirectory;
+ (NSData*)readLocalFile:(NSString*)fileName;
+ (void)saveLocalFile:(NSData*)objData fileName:(NSString*)fileName;
+ (BOOL)deleteCacheNamedDirectoryWithFileName:(NSString *)fileName;

#pragma mark - string utilies methods
+ (NSString *)decodeForText:(NSString *)text;
+ (NSString *)replacePlusForText:(NSString *)text;
+ (NSString *)replaceSpaceForText:(NSString *)text;
+ (NSString *)decodeAndReplacePlusForText:(NSString *)text;
+ (CGSize)sizeForText:(NSString *)text font:(UIFont *)font attributes:(NSDictionary *)attributes;
+ (CGSize)sizeForText:(NSString *)text
                 font:(UIFont *)font
    constrainedToSize:(CGSize)constrainedToSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
              options:(NSStringDrawingOptions)options
           attributes:(NSDictionary *)attributes;

#pragma mark - remove html tag from string
+ (NSString *)convertingHTMLToPlainTextFromContent:(NSString *)content;

#pragma mark - md5 hash

+ (NSString*)hashStringAsMD5:(NSString*)str;

+ (BOOL)getDeviceAndOSInfo;

#pragma mark - Url encoding
+ (NSString*)stringByURLEncodingStringParameter:(NSString *)originalUrl;
@end
