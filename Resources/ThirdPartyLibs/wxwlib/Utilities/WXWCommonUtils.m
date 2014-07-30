#import "WXWCommonUtils.h"
#import "netinet/in.h"
#import "netdb.h"
#import "arpa/inet.h"
#import "sys/utsname.h"
#import "zlib.h"
#import <execinfo.h>
#import "WXWNavigationController.h"
#import <CommonCrypto/CommonDigest.h>
#import "SystemConfiguration/SCNetworkReachability.h"
#import "GTMNSString+HTML.h"
#import "WXWDebugLogOutput.h"
#import "UIDevice-hardware.h"
#import "WXWTextPool.h"
#import "UnicodeUtils.h"
#import "GPUImagePicture.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageGrayscaleFilter.h"
#import "WXWWebViewController.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"
#import "CommonMethod.h"

#define ACT_VIEW_TAG            181
#define MIN_CELL_HEIGHT         44
#define PORTRAIT_WIDTH          320
#define LANDSCAPE_WIDTH         480
#define RADIANS( degrees )			( degrees * M_PI / 180 )

#define LOADING_LABEL_WIDTH         100.0f
#define LOADING_LABEL_HEIGHT        40.0f

#define INFOLABEL_WIDTH             150.0f
#define INFOLABEL_HEIGHT            150.0f

#define INFOIMG_WIDTH               40.0f
#define INFOIMG_HEIGHT              40.0f

#define	ACTIVITY_DURA_TIME          0.3f

#define SHADOW_HEIGHT               10.0
#define SHADOW_INVERSE_HEIGHT       5.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)

#define BUFFER_SIZE 1024 * 100

@interface WXWCommonUtils(private)
+ (void)fcAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
+ (void)initActivityView;
+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset;
@end

@implementation WXWCommonUtils

static NSBundle *bundle = nil;

#pragma mark - files
+ (NSString *)documentsDirectory {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

#pragma mark - device

+ (void)parserDeviceSystemInfo
{
  //here use sys/utsname.h
  struct utsname systemInfo;
  uname(&systemInfo);
  
  //get the device model and the system version
  [WXWSystemInfoManager instance].device = @(systemInfo.machine);
  [WXWSystemInfoManager instance].system = [[UIDevice currentDevice] systemVersion];
  
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  [WXWSystemInfoManager instance].softName = infoDictionary[@"CFBundleDisplayName"];
  //    NSString *shortVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  [WXWSystemInfoManager instance].version = infoDictionary[@"CFBundleVersion"];
  
//    [WXWSystemInfoManager instance].releaseChannelType = APP_STORE_TYPE;
  [WXWSystemInfoManager instance].releaseChannelType = OTA_TYPE;
}

+ (UIInterfaceOrientation)currentOrientation {
  return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (BOOL)currentOrientationIsLandscape {
  if ([self currentOrientation] == UIDeviceOrientationPortrait
      || [self currentOrientation] == UIDeviceOrientationPortraitUpsideDown) {
    return NO;
  } else {
    return YES;
  }
}

+ (NSString *)deviceModel {
	UIDevice *device = [[[UIDevice alloc] init] autorelease];
	return [device platformString];
}

+ (BOOL)screenHeightIs4Inch {
  if ([[WXWCommonUtils deviceModel] rangeOfString:IPHONE_5_NAMESTRING].length > 0 ||
      [[WXWCommonUtils deviceModel] rangeOfString:IPHONE_5S_NAMESTRING].length > 0 ||
      [[WXWCommonUtils deviceModel] rangeOfString:IPHONE_5C_NAMESTRING].length > 0) {
    return YES;
  } else {
    return NO;
  }
}

+ (CGFloat)currentOSVersion {
  return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - font
+ (UIFont *)boldFontWithSize:(CGFloat)size {
  if (CURRENT_OS_VERSION >= IOS7) {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
  } else {
    return [UIFont fontWithName:@"Arial-BoldMT" size:size];
  }
}

+ (UIFont *)fontWithSize:(CGFloat)size {
  if (CURRENT_OS_VERSION >= IOS7) {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
  } else {
    return [UIFont fontWithName:@"ArialMT" size:size];
  }
}

+ (NSString *)systemFontName {
  if (CURRENT_OS_VERSION >= IOS7) {
    return @"HelveticaNeue";
  } else {
    return @"Arial-BoldMT";
  }
}

#pragma mark - system language
+ (LanguageType)currentLanguage {
  return [WXWSystemInfoManager instance].currentLanguageCode;
}

+ (void)getDBLanguage{
  switch ([WXWSystemInfoManager instance].currentLanguageCode) {
    case EN_TY:
      [[WXWSystemInfoManager instance] setLanguageWithType:EN_TY];
      break;
      
    default:    
      [[WXWSystemInfoManager instance] setLanguageWithType:ZH_HANS_TY];
    
      break;
  }
  
  [self setLanguage:[WXWSystemInfoManager instance].currentLanguageDesc];
}

+ (void)getLocalLanguage {
  NSArray* preferredLangs = [NSLocale preferredLanguages];
  
	if ([((NSString *)preferredLangs[0]) rangeOfString:@"en"].length > 0) {
    [[WXWSystemInfoManager instance] setLanguageWithType:EN_TY];
	} else if ([((NSString *)preferredLangs[0]) rangeOfString:@"zh-Hans"].length > 0) {
    [[WXWSystemInfoManager instance] setLanguageWithType:ZH_HANS_TY];
	} else {
    [[WXWSystemInfoManager instance] setLanguageWithType:ZH_HANS_TY];
	}
  
  // Save
  [self setLanguage:[WXWSystemInfoManager instance].currentLanguageDesc];
}

+ (void)setLanguage:(NSString *)languageDesc {
  
  if ([languageDesc isEqualToString:@"zh"]) {
    languageDesc = @"zh-Hans";
  }
  NSString *path = [[NSBundle mainBundle] pathForResource:languageDesc
                                                   ofType:@"lproj" ];

  bundle = [[NSBundle bundleWithPath:path] retain];
  
  // Save languageCode
  [self saveIntegerValueToLocal:[WXWSystemInfoManager instance].currentLanguageCode
                            key:SYSTEM_LANGUAGE_LOCAL_KEY];
}

+ (BOOL)getDeviceAndOSInfo
{
  if ([[WXWSystemInfoManager instance].system hasPrefix:@"5"]) {
    return NO;
  }else{
    return YES;
  }
}

+ (void)resetCurrentAppLanguage {
  NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
  NSArray* languages = [defs objectForKey:@"AppleLanguages"];
  NSString *current = languages[0];
  [self setLanguage:current];
}

+ (NSBundle *)getBundle {
  return bundle;
}

#pragma mark - object class and selector handler
+ (void)checkAndExecuteSelectorWithName:(NSString *)selectorName byTarget:(id)target {
  
  if (nil == target || selectorName.length <= 0) {
    return;
  }
  
  SEL selector = sel_registerName(selectorName.UTF8String);
  if ([target respondsToSelector:selector]) {
    [target performSelector:selector];
  }
}

#pragma mark - date time
+ (NSString *)currentHourTime {
  NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH"];
	NSString *dateString = [dateFormat stringFromDate:today];
	[dateFormat release];
	dateFormat = nil;
	return dateString;
}

+ (NSString *)currentHourMinSecondTime {
  NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateString = [dateFormat stringFromDate:today];
	[dateFormat release];
	dateFormat = nil;
	return dateString;
}

+ (NSDate *)convertDateTimeFromUnixTS:(NSTimeInterval)unixDate {
	return [NSDate dateWithTimeIntervalSince1970:unixDate];
}

+ (NSTimeInterval)convertToUnixTS:(NSDate *)date {
	return [date timeIntervalSince1970];
}

+ (NSString *)simpleFormatDateWithYear:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	switch ([self currentLanguage]) {
		case ZH_HANS_TY:
		{
			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
      if (secondAccuracy) {
        [formatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm"];
      } else {
        [formatter setDateFormat:@"yyyy年 MM月 dd日"];
      }
			
			break;
		}
		case EN_TY:
		{
      [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
      if (secondAccuracy) {
        [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
      } else {
        [formatter setDateFormat:@"dd MMM yyyy"];
      }
			
			break;
		}
		default:
			break;
	}
	
	NSString *timeline = [formatter stringFromDate:date];
  //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	[formatter release];
	formatter = nil;
	
	//return timelineResult;
  return timeline;
}

+ (NSString *)simpleFormatDate:(NSDate *)date secondAccuracy:(BOOL)secondAccuracy {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	switch ([self currentLanguage]) {
		case ZH_HANS_TY:
		{
			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
      if (secondAccuracy) {
        [formatter setDateFormat:@"MM/dd HH:mm"];
      } else {
        [formatter setDateFormat:@"MM/dd"];
      }
			
			break;
		}
		case EN_TY:
		{
      [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
      if (secondAccuracy) {
        [formatter setDateFormat:@"dd MMM HH:mm"];
      } else {
        [formatter setDateFormat:@"dd MMM"];
      }
			
			break;
		}
		default:
			break;
	}
	
	NSString *timeline = [formatter stringFromDate:date];
  //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	[formatter release];
	formatter = nil;
	
	//return timelineResult;
  return timeline;
}

+ (NSString *)getElapsedTime:(NSDate *)timeline {
  
  if (timeline == nil) {
    return NULL_PARAM_VALUE;
  }
  
  NSUInteger desiredComponents = NSDayCalendarUnit | NSHourCalendarUnit
  | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  
  NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                       fromDate:timeline
                                                                         toDate:[NSDate date]
                                                                        options:0];
  // format to be used to generate string to display
  NSInteger number = 0;
  NSString *elapsedTime = nil;
  
    //---------day
    if ([elapsedTimeUnits day] > 0) {
        //      elapsedTime = [WXWCommonUtils simpleFormatDate:timeline secondAccuracy:NO];
        
        number = [elapsedTimeUnits day];
        
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSDaysAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSDayAgoTitle, nil)];
        }
        
    }else {
        if (number < -1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSDaysLaterTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSDayLaterTitle, nil)];
        }
    }
    
    //------hour
    if ([elapsedTimeUnits hour] > 0) {
        
        number = [elapsedTimeUnits hour];
        
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHoursAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHourAgoTitle, nil)];
        }
    
    } else {
        if (number < -1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHoursLaterTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHourLaterTitle, nil)];
        }
    }
    
    //-------minute
    if ([elapsedTimeUnits minute] > 0) {
        
        number = [elapsedTimeUnits minute];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinAgoTitle, nil)];
        }
        
    } else {
        if (number < -1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinsLaterTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinLaterTitle, nil)];
        }
    }
    
    //------second
    if ([elapsedTimeUnits second] > 0) {
        
        number = [elapsedTimeUnits second];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecAgoTitle, nil)];
        }
        
    } else {
        number = [elapsedTimeUnits second];
        if (number > -1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecsLaterTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecLaterTitle, nil)];
        }
    }
    
    if ([elapsedTimeUnits second] <= 0) {
    
        elapsedTime = [NSString stringWithFormat:@"1 %@", LocaleStringForKey(NSSecAgoTitle, nil)];
    }
  
  return elapsedTime;
}

+ (NSDate *)getOffsetDateTime:(NSDate *)nowDate offset:(NSInteger)offset {
	NSDateComponents *components = [[NSDateComponents alloc] init];
  
	[components setDay:offset];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	
	NSDate *newDate = [gregorian dateByAddingComponents:components
                                               toDate:nowDate
                                              options:0];
	
	[components release];
	components = nil;
	[gregorian release];
	gregorian = nil;
	
	return newDate;
}

+ (NSDate *)getTodayMidnight {
  NSDate *today = [NSDate date];
  
  NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
  
  NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
  components.day = 1;
  NSDate *tomorrow = [gregorian dateByAddingComponents:components toDate:today options:0];
  
  NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
  components = [gregorian components:unitFlags fromDate:tomorrow];
  [components setHour:-16]; // maybe timezone caused the offset, set hour offset to -16
  [components setMinute:0];
  
  NSDate *todayMidnight = [gregorian dateFromComponents:components];
  
  return todayMidnight;
}


+ (NSInteger)getElapsedDayCount:(NSDate *)date {
  
  if (date == nil) {
    return 0;
  }
  
  NSDate *currentDate = [NSDate date];
  
  NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                       fromDate:date
                                                                         toDate:currentDate
                                                                        options:0];
  return [elapsedTimeUnits day];
}

+(NSDate *)NSStringDateToNSDate:(NSString *)string {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CCT"]];
  [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
  NSDate *date = [formatter dateFromString:string];
  [formatter release];
  return date;
}

+ (NSString *)datetimeWithFormat:(NSString *)format datetime:(NSDate *)datetime
{
  NSDateFormatter* dayFormater = [[[NSDateFormatter alloc] init] autorelease];
  [dayFormater setDateFormat:format];
  switch ([WXWCommonUtils currentLanguage]) {
    case EN_TY:
      dayFormater.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"] autorelease];
      break;
      
    default:
      dayFormater.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
      break;
  }
  return [dayFormater stringFromDate:datetime];
}

#pragma mark - network

+ (NSString *)replaceWithNewSessionId:(NSString *)sessionId url:(NSString *)url {
  if (url.length > 0 && [url rangeOfString:SESSION_PREFIX].length > 0 && [url rangeOfString:SESSION_SUFFIX].length > 0) {
    
    NSArray *parts = [url componentsSeparatedByString:SESSION_PREFIX];
    if (parts.count == 2) {
      NSString *lastPart = parts[1];
      
      if ([lastPart rangeOfString:SESSION_SUFFIX].length > 0) {
        NSArray *sessionParts = [lastPart componentsSeparatedByString:SESSION_SUFFIX];
        if (sessionParts.count > 0) {
          return STR_FORMAT(@"%@%@%@%@%@", parts[0], SESSION_PREFIX, sessionId, SESSION_SUFFIX, sessionParts[1]);
        }
      }
    }
  }
  return nil;
}

+ (NSString *)assembleUrl:(NSString *)param {
	
  NSString *url;
	if (param) {
		url = [NSString stringWithFormat:@"%@%@%@", [WXWSystemInfoManager instance].hostUrl, PHONE_CONTROLLER, param];
    
    if ([WXWSystemInfoManager instance].sessionId && [[WXWSystemInfoManager instance].sessionId length] > 0) {
      url = [NSString stringWithFormat:@"%@&session=%@", url, [WXWSystemInfoManager instance].sessionId];
    }
    
    url = [NSString stringWithFormat:@"%@&lang=%@", url, [WXWSystemInfoManager instance].currentLanguageDesc];
	} else {
    // used for "Http POST" method
		url = [NSString stringWithFormat:@"%@%@", [WXWSystemInfoManager instance].hostUrl, PHONE_CONTROLLER];
	}
  
  return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)assembleRequestUrl:(NSString *)param {
  return [NSString stringWithFormat:@"%@%@%@", [WXWSystemInfoManager instance].hostUrl, PHONE_CONTROLLER, param];
}

+ (NSString*)stringByURLEncodingStringParameter:(NSString *)originalUrl
{
  // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
  // some characters that should be escaped in URL parameters, like / and ?;
  // we'll use CFURL to force the encoding of those
  //
  // We'll explicitly leave spaces unescaped now, and replace them with +'s
  //
  // Reference: <a href="\"http://www.ietf.org/rfc/rfc3986.txt\"" target="\"_blank\"" onclick="\"return" checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
  
  NSString *resultStr = originalUrl;
  
  CFStringRef originalString = (CFStringRef) originalUrl;
  CFStringRef leaveUnescaped = CFSTR(" ");
  CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
  
  CFStringRef escapedStr;
  escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                       originalString,
                                                       leaveUnescaped,
                                                       forceEscaped,
                                                       kCFStringEncodingUTF8);
  
  if( escapedStr ) {
    NSMutableString *mutableStr = [NSMutableString stringWithString:(NSString *)escapedStr];
    CFRelease(escapedStr);
    
    // replace spaces with plusses
    [mutableStr replaceOccurrencesOfString:@" "
                                withString:@"%20"
                                   options:0
                                     range:NSMakeRange(0, [mutableStr length])];
    resultStr = mutableStr;
  }
  return resultStr;
}

+ (NSString *)assembleXmlRequestUrl:(NSString *)actionName param:(NSString *)param {
	
  NSString *encodedUrl = [self stringByURLEncodingStringParameter:param];//ENCODE_URL(param);
  
  NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@", [WXWSystemInfoManager instance].hostUrl, PHONE_CONTROLLER, [NSString stringWithFormat:@"?action=%@&strxml=%@", actionName, encodedUrl]];
  
  return requestUrl;
}

/*
+ (NSString *)assembleurlWithType:(DomainType)type {
  
  switch (type) {
    case LINKEDIN_DOMAIN_TY:
      return [NSString stringWithFormat:@"%@/ajax_linkedin?", [WXWSystemInfoManager instance].hostUrl];
      
    default:
      return [self assembleUrl:nil];
  }
}
*/

+ (NSString *) convertParaToHttpBodyStr:(NSDictionary *)dic
{
	NSArray *keys = [dic allKeys];
	NSString *res = [NSString string];
	
	for (int i = 0; i < [keys count]; i++) {
		res = [res stringByAppendingString:
           [@"--" stringByAppendingString:
            [WXW_FORM_BOUNDARY stringByAppendingString:
             [@"\nContent-Disposition: form-data; name=\"" stringByAppendingString:
              [keys[i] stringByAppendingString:
               [@"\"\r\n\r\n" stringByAppendingString:
                [[dic valueForKey: keys[i]] stringByAppendingString:@"\r\n"]]]]]]];
    
	}
	
	return res;
}

#pragma mark - parser hyper link

+ (NSString *)parsedTextForHyperLinkNoBold:(NSString *)originalText {
  return [self parsedTextUrl:originalText needBold:NO];
}

+ (NSString *)parsedTextForHyperLink:(NSString *)originalText {
  return [self parsedTextUrl:originalText needBold:YES];
}

+ (NSString *)parsedTextUrl:(NSString *)originalText needBold:(BOOL)needBold {
  NSArray *expressions = [[[NSArray alloc] initWithObjects:
                           //@"([@#][a-zA-Z0-9]+)", // screen names, temp removed because there is no requirement for @somebody or #topic current
                           @"(((([hH][tT][tT][pP]([sS]?))\\:\\/\\/)?)([-0-9a-zA-Z]+\\.)+[a-zA-Z]{2,6}(\\:[0-9]+)?(\\/[-0-9a-zA-Z_#!:.?+=&%@~*\\';,/$]*)?)",
                           nil] autorelease];
  NSString *res = NULL_PARAM_VALUE;
  NSRange matchRangeInOriginalText, lastRange, midRange;
  
  lastRange.location = 0;
  lastRange.length = 0;
  midRange.location = 0;
  for (NSString *expression in expressions) {
    
		NSEnumerator *enumerator = [originalText matchEnumeratorWithRegex:expression];
    NSString *match = nil;
		while (match = [enumerator nextObject]) {
      
			matchRangeInOriginalText = [originalText rangeOfString:match];
      
      NSString *link = match;
      if ([match rangeOfString:@"http" options:NSCaseInsensitiveSearch].length <= 0) {
        link = [NSString stringWithFormat:@"http://%@", match];
      }
      
      if (matchRangeInOriginalText.location < midRange.location) {
        midRange.length = 0;
      } else {
        midRange.length = matchRangeInOriginalText.location - midRange.location;
      }
      
      NSString *midStr = [originalText substringWithRange:midRange];
      if (midStr) {
        res = [res stringByAppendingString:midStr];
      }
      
      NSString *str = nil;
      if (needBold) {
        str = [NSString stringWithFormat:@"<a href=\"%@\" style=\"color:#7D9EC0;text-decoration:none;text-shadow:1px 1px 1px white;word-break:break-word\"><b>%@</b></a>", link, match];
        
      } else {
        str = [NSString stringWithFormat:@"<a href=\"%@\" style=\"font-family:ArialMT;color:#7D9EC0;text-shadow:1px 1px 1px white;word-break:break-word\">%@</a>", link, match];
      }
			res = [res stringByAppendingString:str];
      
      midRange.location = matchRangeInOriginalText.location + matchRangeInOriginalText.length;
    }
	}
  
  if (midRange.location < [originalText length]) {
    midRange.length = [originalText length] - midRange.location;
    NSString *lastStr = [originalText substringWithRange:midRange];
    res = [res stringByAppendingString:lastStr];
  }
  return res;
}

#pragma mark - web view
+ (void)clearWebViewCookies {
  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in storage.cookies) {
    [storage deleteCookie:cookie];
  }
}

+ (void)presentWebViewController:(WXWWebViewController *)webVC
             parentNavController:(UINavigationController *)parentNavController {
  WXWNavigationController *webViewNav = [[WXWNavigationController alloc] initWithRootViewController:webVC];
  
  [parentNavController presentModalViewController:webViewNav
                                         animated:YES];
  RELEASE_OBJ(webViewNav);
}

+ (void)openWebView:(UINavigationController *)parentNavController
              title:(NSString *)title
                url:(NSString *)url
    needCloseButton:(BOOL)needCloseButton
     needNavigation:(BOOL)needNavigation
     needHomeButton:(BOOL)needHomeButton {
  
  WXWWebViewController *webVC = [[[WXWWebViewController alloc] initWithNeedCloseButton:needCloseButton
                                                                        needNavigation:needNavigation
                                                                        needHomeButton:needHomeButton
                                                                               isLocal:NO] autorelease];
  webVC.urlStr = url;
  webVC.title = title;
  [self presentWebViewController:webVC parentNavController:parentNavController];
}

+ (void)openWebView:(UINavigationController *)parentNavController
              title:(NSString *)title
                url:(NSString *)url
    needCloseButton:(BOOL)needCloseButton
     needNavigation:(BOOL)needNavigation
blockViewWhenLoading:(BOOL)blockViewWhenLoading
     needHomeButton:(BOOL)needHomeButton {
  
  WXWWebViewController *webVC = [[[WXWWebViewController alloc] initWithNeedCloseButton:needCloseButton
                                                                        needNavigation:needNavigation
                                                                  blockViewWhenLoading:blockViewWhenLoading
                                                                        needHomeButton:needHomeButton
                                                                               isLocal:NO] autorelease];
  webVC.urlStr = url;
  webVC.title = title;
  
  [self presentWebViewController:webVC parentNavController:parentNavController];
}

+ (void)openLocalWebView:(UINavigationController *)parentNavCintroller
                   title:(NSString *)title
                     url:(NSString *)url
         needCloseButton:(BOOL)needCloseButton
          needNavigation:(BOOL)needNavigation
          needHomeButton:(BOOL)needHomeButton {
    WXWWebViewController *webVC = [[[WXWWebViewController alloc] initWithNeedCloseButton:needCloseButton
                                                                          needNavigation:needNavigation
                                                                          needHomeButton:needHomeButton
                                                                                 isLocal:YES] autorelease];
    webVC.urlStr = url;
    webVC.title = title;
    
    [self presentWebViewController:webVC parentNavController:parentNavCintroller];
}

+ (void)openLocalWebView:(UINavigationController *)parentNavCintroller
                   title:(NSString *)title
                     url:(NSString *)url
         needCloseButton:(BOOL)needCloseButton
          needNavigation:(BOOL)needNavigation
    blockViewWhenLoading:(BOOL)blockViewWhenLoading
          needHomeButton:(BOOL)needHomeButton {
    WXWWebViewController *webVC = [[[WXWWebViewController alloc] initWithNeedCloseButton:needCloseButton
                                                                          needNavigation:needNavigation
                                                                    blockViewWhenLoading:blockViewWhenLoading
                                                                          needHomeButton:needHomeButton
                                                                                 isLocal:YES] autorelease];
    webVC.urlStr = url;
    webVC.title = title;
    
    [self presentWebViewController:webVC parentNavController:parentNavCintroller];
}

#pragma mark - zip
+ (void)saveToZipFile:(NSString *)logFilePath
        logFolderPath:(NSString *)logFolderPath
  zipNoSuffixFileName:(NSString *)zipNoSuffixFileName {
  
  NSError *error = nil;
  
  NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:logFilePath error:&error];
  NSDate *date = attributes[NSFileCreationDate];
  
  
  NSString *zipFilePath = [NSString stringWithFormat:@"%@/%@%@", logFolderPath, zipNoSuffixFileName, ZIP_SUFFIX];
  NSString *logFileName = [NSString stringWithFormat:@"%@%@", zipNoSuffixFileName, LOG_SUFFIX];
  ZipFile *zipFile = [[[ZipFile alloc] initWithFileName:zipFilePath mode:ZipFileModeCreate] autorelease];
  ZipWriteStream *writeStream = [zipFile writeFileInZipWithName:logFileName
                                                       fileDate:date
                                               compressionLevel:ZipCompressionLevelBest];
  NSData *data = [NSData dataWithContentsOfFile:logFilePath];
  [writeStream writeData:data];
  [writeStream finishedWriting];
  
  [zipFile close];
}

#pragma mark - image effect handler
+ (void)filterClassic:(UInt8 *)pixelBuf offset:(UInt32)offset context:(void *)context {
	int r = offset;
	int g = offset+1;
	int b = offset+2;
	
	int red = pixelBuf[r];
	int green = pixelBuf[g];
	int blue = pixelBuf[b];
	
	pixelBuf[r] = SAFECOLOR((red * 0.393) + (green * 0.769) + (blue * 0.189));
	pixelBuf[g] = SAFECOLOR((red * 0.349) + (green * 0.686) + (blue * 0.168));
	pixelBuf[b] = SAFECOLOR((red * 0.272) + (green * 0.534) + (blue * 0.131));
  
}

+ (UIImage *)effectedImageWithFilterType:(PhotoEffectType)type
                           originalImage:(UIImage *)originalImage {
  
  switch (type) {
    case CLASSIC_PHOTO_TY:
    {
      GPUImageSepiaFilter *sepiaFilter = [[[GPUImageSepiaFilter alloc] init] autorelease];
      return [sepiaFilter imageByFilteringImage:originalImage];
    }
      
    case INKWELL_PHOTO_TY:
    {
      GPUImageGrayscaleFilter *grayscaleFilter = [[[GPUImageGrayscaleFilter alloc] init] autorelease];
      
      return [grayscaleFilter imageByFilteringImage:originalImage];
    }
      
    default:
      return originalImage;
  }
}

+ (UIImage *)effectedImageWithType:(PhotoEffectType)type
                     originalImage:(UIImage *)originalImage {
  
  return [self effectedImageWithFilterType:type
                             originalImage:originalImage];
}


+ (ImageOrientationType)imageOrientationType:(UIImage *)image {
  if (nil == image) {
    return IMG_ZERO_TY;
  }
  if (image.size.width > image.size.height) {
    return IMG_LANDSCAPE_TY;
  } else if (image.size.width < image.size.height) {
    return IMG_PORTRAIT_TY;
  } else {
    return IMG_SQUARE_TY;
  }
}

+ (BOOL)needBeScaledSize:(UIImage *)sourceImage
              targetSize:(CGSize *)targetSize
              sourceType:(UIImagePickerControllerSourceType)sourceType {
	NSString *model = [WXWCommonUtils deviceModel];
	
	if ([model isEqualToString:IPHONE_3G_NAMESTRING] || [model isEqualToString:IPHONE_1G_NAMESTRING]) {
		if ((sourceImage.size.width <= PHOTO_LONG_LEN_1G3G &&
         sourceImage.size.height <= PHOTO_SHORT_LEN_1G3G) ||
        (sourceImage.size.width <= PHOTO_SHORT_LEN_1G3G &&
         sourceImage.size.height <= PHOTO_LONG_LEN_1G3G)) {
          
          return NO;
        } else {
          if (sourceImage.size.width < sourceImage.size.height) {
            *targetSize = CGSizeMake(PHOTO_SHORT_LEN_1G3G, PHOTO_LONG_LEN_1G3G);
          } else {
            *targetSize = CGSizeMake(PHOTO_LONG_LEN_1G3G, PHOTO_SHORT_LEN_1G3G);
          }
        }
		
	} else if ([model isEqualToString:IPHONE_3GS_NAMESTRING]) {
		if ((sourceImage.size.width <= PHOTO_LONG_LEN_3GS && sourceImage.size.height <= PHOTO_SHORT_LEN_3GS)
        || (sourceImage.size.width <= PHOTO_SHORT_LEN_3GS && sourceImage.size.height <= PHOTO_LONG_LEN_3GS)) {
      
			return NO;
		} else {
			if (sourceImage.size.width < sourceImage.size.height) {
				*targetSize = CGSizeMake(PHOTO_SHORT_LEN_3GS, PHOTO_LONG_LEN_3GS);
			} else {
				*targetSize = CGSizeMake(PHOTO_LONG_LEN_3GS, PHOTO_SHORT_LEN_3GS);
			}
		}
	} else if ([model isEqualToString:IPHONE_4_NAMESTRING] || [model isEqualToString:IPOD_4G_NAMESTRING] || [model isEqualToString:IPHONE_4S_NAMESTRING] || [model isEqualToString:IPHONE_5_NAMESTRING] ||[model isEqualToString:IPHONE_5S_NAMESTRING] || [model isEqualToString:IPHONE_5C_NAMESTRING]) {
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera
        && ((sourceImage.size.width == FRONT_PHOTO_LONG_LEN && sourceImage.size.height == FRONT_PHOTO_SHORT_LEN)
            || (sourceImage.size.width == FRONT_PHOTO_SHORT_LEN && sourceImage.size.height == FRONT_PHOTO_LONG_LEN))) {
          /*
           * iphone4 and ipod touch 4 has front facing camera, the photo size taken by front facing camera is 640×480 or 480×640,
           * this kind of photo need be adjusted
           */
          return YES;
        }
    
		if ((sourceImage.size.width <= PHOTO_LONG_LEN_4G && sourceImage.size.height <= PHOTO_SHORT_LEN_4G)
        || (sourceImage.size.width <= PHOTO_SHORT_LEN_4G && sourceImage.size.height <= PHOTO_LONG_LEN_4G)
        /*|| sourceImage.size.width == sourceImage.size.height*/) {
      
			return NO;
		} else {

      if (sourceImage.size.width < sourceImage.size.height) {
        *targetSize = CGSizeMake(PHOTO_SHORT_LEN_4G, PHOTO_LONG_LEN_4G);
      } else {
        *targetSize = CGSizeMake(PHOTO_LONG_LEN_4G, PHOTO_SHORT_LEN_4G);
      }
		}
	}
  
	return YES;
}

+ (UIImage *)scaleImage:(UIImage *)sourceImage
             sourceType:(UIImagePickerControllerSourceType)sourceType {
  CGSize targetSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
	BOOL isNeed = [self needBeScaledSize:sourceImage targetSize:&targetSize sourceType:sourceType];
  
	if (!isNeed) {
		return sourceImage;
	}
  
  CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
		
    if (widthFactor > heightFactor) {
      scaleFactor = widthFactor; // scale to fit height
    }
    else {
      scaleFactor = heightFactor; // scale to fit width
    }
		
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
		
  }
	
  CGImageRef imageRef = [sourceImage CGImage];
  CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
  CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
  CGContextRef bitmap;
  if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown || sourceImage.imageOrientation == UIImageOrientationRight) {
    bitmap = CGBitmapContextCreate(NULL,
                                   targetWidth,
                                   targetHeight,
                                   CGImageGetBitsPerComponent(imageRef),
                                   CGImageGetBytesPerRow(imageRef),
                                   colorSpaceInfo,
                                   bitmapInfo);
  } else {
    bitmap = CGBitmapContextCreate(NULL,
                                   targetHeight,
                                   targetWidth,
                                   CGImageGetBitsPerComponent(imageRef),
                                   CGImageGetBytesPerRow(imageRef),
                                   colorSpaceInfo,
                                   bitmapInfo);
  }
  
  // ENHANCEMENT FOR NEW IMAGE PORITION Y ADJUSTMENT:
	float newImage_x = 0.0f;
	if (sourceImage.imageOrientation == UIImageOrientationRight
      || sourceImage.imageOrientation == UIImageOrientationLeft) {
		if (targetWidth < targetHeight) {
			newImage_x = targetWidth - targetHeight;
		}
	}
  
  CGContextDrawImage(bitmap, CGRectMake(newImage_x, 0, scaledWidth, scaledHeight), imageRef);
  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage* newImage = [UIImage imageWithCGImage:ref];
	
  CGContextRelease(bitmap);
  CGImageRelease(ref);
	
  return newImage;
  
}

+ (UIImage*)scaleAndRotateImage:(UIImage*)sourceImage
                     sourceType:(UIImagePickerControllerSourceType)sourceType
{
	CGSize targetSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
	BOOL isNeed = [self needBeScaledSize:sourceImage targetSize:&targetSize sourceType:sourceType];
  
	if (!isNeed) {
		return sourceImage;
	}
	
	CGSize imageSize = sourceImage.size;
  CGFloat width = imageSize.width;
  CGFloat height = imageSize.height;
  CGFloat targetWidth = targetSize.width;
  CGFloat targetHeight = targetSize.height;
  CGFloat scaleFactor = 0.0;
  CGFloat scaledWidth = targetWidth;
  CGFloat scaledHeight = targetHeight;
  CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
  if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
    CGFloat widthFactor = targetWidth / width;
    CGFloat heightFactor = targetHeight / height;
		
    if (widthFactor > heightFactor) {
      scaleFactor = widthFactor; // scale to fit height
    }
    else {
      scaleFactor = heightFactor; // scale to fit width
    }
		
    scaledWidth  = width * scaleFactor;
    scaledHeight = height * scaleFactor;
		
    // center the image
    if (widthFactor > heightFactor) {
      thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
    }
    else if (widthFactor < heightFactor) {
      thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
    }
  }
	
  CGImageRef imageRef = [sourceImage CGImage];
  //CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
  CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();//CGImageGetColorSpace(imageRef);
  
  CGContextRef bitmap;
  if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown || sourceImage.imageOrientation == UIImageOrientationRight) {
    bitmap = CGBitmapContextCreate(NULL,
                                   (int)targetWidth,
                                   (int)targetHeight,
                                   CGImageGetBitsPerComponent(imageRef),
                                   (4 * targetWidth),
                                   colorSpaceInfo,
                                   /*bitmapInfo*/kCGImageAlphaPremultipliedFirst);
  } else {
    bitmap = CGBitmapContextCreate(NULL,
                                   (int)targetHeight,
                                   (int)targetWidth,
                                   CGImageGetBitsPerComponent(imageRef),
                                   (4 * targetWidth),
                                   colorSpaceInfo,
                                   /*bitmapInfo*/kCGImageAlphaPremultipliedFirst);
  }
  
  CGColorSpaceRelease(colorSpaceInfo);
  
  // In the right or left cases, we need to switch scaledWidth and scaledHeight,
  // and also the thumbnail point
  if (sourceImage.imageOrientation == UIImageOrientationLeft) {
    
    CGFloat oldScaledWidth = scaledWidth;
    scaledWidth = scaledHeight;
    scaledHeight = oldScaledWidth;
		
    CGContextRotateCTM (bitmap, RADIANS(90));
    CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
  } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
    
    CGFloat oldScaledWidth = scaledWidth;
    scaledWidth = scaledHeight;
    scaledHeight = oldScaledWidth;
		
    CGContextRotateCTM (bitmap, RADIANS(-90));
    CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
  } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
    // NOTHING
  } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
    CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
    CGContextRotateCTM (bitmap, RADIANS(-180.));
  }
	
	// ENHANCEMENT FOR NEW IMAGE PORITION Y ADJUSTMENT:
	float newImage_x = 0.0f;
	if (sourceImage.imageOrientation == UIImageOrientationRight) {
		if (targetWidth < targetHeight) {
			newImage_x = targetWidth - targetHeight;
		}
	}
	
  CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
  
  CGContextDrawImage(bitmap, CGRectMake(newImage_x, 0, scaledWidth, scaledHeight), imageRef);
  CGImageRef ref = CGBitmapContextCreateImage(bitmap);
  UIImage* newImage = [UIImage imageWithCGImage:ref];
	
  CGContextRelease(bitmap);
  CGImageRelease(ref);
	
  return newImage;
}

+ (UIImage *)resizeImage:(UIImage *)image
                   width:(CGFloat)width
                  height:(CGFloat)height
               minLength:(CGFloat)minLength {
  
  if (nil == image) {
    return nil;
  }
  
  UIImage *scaledImage = nil;
  
  CGRect destRect = CGRectMake(0, 0, width, height);
  CGRect sourceRect = CGRectMake(0, 0, image.size.width, image.size.height);
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	if ([WXWCommonUtils currentOSVersion] >= IOS4) {
    
    // 0.0 for scale means "correct scale for device's main screen".
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(minLength, minLength), NO, 0.0);
    
    // cropping happens here.
		CGImageRef sourceImg = CGImageCreateWithImageInRect(image.CGImage, sourceRect);
    
    // create cropped UIImage.
		scaledImage = [UIImage imageWithCGImage:sourceImg scale:0.0 orientation:image.imageOrientation];
    
    // the actual scaling happens here, and orientation is taken care of automatically.
		[scaledImage drawInRect:destRect];
    
		CGImageRelease(sourceImg);
		scaledImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
#endif
	if (!scaledImage) {
		// Try older method.
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, (width * 4),
                                                 colorSpace, kCGImageAlphaPremultipliedLast);
		CGImageRef sourceImg = CGImageCreateWithImageInRect(image.CGImage, sourceRect);
		CGContextDrawImage(context, destRect, sourceImg);
		CGImageRelease(sourceImg);
		CGImageRef finalImage = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		scaledImage = [UIImage imageWithCGImage:finalImage];
		CGImageRelease(finalImage);
	}
  return scaledImage;
}

+ (UIImage *)resizeImage:(UIImage *)image length:(float)length square:(BOOL)square {
  // Resize image if needed.
  float width  = image.size.width;
  float height = image.size.height;
  
  // fail safe
  if (width == 0 || height == 0) return image;
	
	float scale;
  if (square) {
    
    return [self resizeImage:image width:length height:length minLength:length];
    
  } else {
    if (width > length || height > length) {
      
      if (width > height) {
        scale = length / height;
        width *= scale;
        height = length;
      } else {
        scale = length / width;
        height *= scale;
        width = length;
      }
      
      return [self resizeImage:image width:width height:height minLength:length];
    }
    
    return image;
  }
}

+ (UIImage *)cutPartImage:(UIImage *)image
                    width:(CGFloat)width
                   height:(CGFloat)height
                   square:(BOOL)square {
  
  
  float imageWidth  = image.size.width;
  float imageHeight = image.size.height;
  
  if (imageWidth == 0 || imageHeight == 0) {
    return nil;
  }
  
  if (imageHeight < width || imageHeight < height) {
    return image;
  } else {
    
    CGFloat minLength = 0.0f;
    switch ([WXWCommonUtils imageOrientationType:image]) {
      case IMG_LANDSCAPE_TY:
        minLength = width;
        break;
        
      case IMG_PORTRAIT_TY:
        minLength = height;
        break;
        
      default:
        minLength = height;
        break;
    }
    
    return [self resizeImage:image
                      length:minLength
                      square:square];
  }
}

+ (UIImage *)cutPartImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
  return [self cutPartImage:image width:width height:height square:NO];
}

+ (UIImage *)cutMiddlePartImage:(UIImage *)image
                          width:(CGFloat)width
                         height:(CGFloat)height {
  
  float imageWidth  = image.size.width;
  float imageHeight = image.size.height;
  
  if (imageWidth == 0 || imageHeight == 0) {
    return nil;
  }
  
  CGRect sourceRect = CGRectZero;
  
  CGFloat y = 0;
  CGFloat x = 0;
  
  CGFloat croppedWidth = image.size.width;
  CGFloat croppedHeight = image.size.height;
  
  // check current display area orientation
  // aspect ratio: areaHeight/areaWidth = croppedHeight/imageWidth
  if (width > height) {
    
    // display area is landscape, regardless of the image orientation, we should crop the middle part in vertical direction
    croppedHeight = (height * image.size.width)/width;
    y = (image.size.height - croppedHeight)/2.0f;
    
  } else {
    
    // display area is portrait or square, regardless of the image orientation, we should crop the middle part in horizontal direction
    croppedWidth = (width * image.size.height)/height;
    x = (image.size.width - croppedWidth)/2.0f;
  }
  
  sourceRect = CGRectMake(x, y, croppedWidth, croppedHeight);
  
  // cropping happens here.
  CGImageRef sourceImg = CGImageCreateWithImageInRect(image.CGImage, sourceRect);
  
  // create cropped UIImage.
  UIImage *scaledImage = [UIImage imageWithCGImage:sourceImg];
  
  CGImageRelease(sourceImg);
  
  return scaledImage;
}

+ (UIImage *)cutCenterPartImage:(UIImage *)image
                           size:(CGSize)imageSize {
//    CGSize size = image.size;
    float imageScare = image.size.width / image.size.height;
    float destScare = imageSize.width / imageSize.height;
    
    CGRect destRect;
    if (imageScare - destScare < 0.0001) {
        destRect = CGRectMake(0, (image.size.height - image.size.width / destScare )  / 2.0f,
                              image.size.width, image.size.width / destScare);
    }else{
        destRect = CGRectMake((image.size.width - image.size.height*destScare) / 2.0f, 0,
                              image.size.height*destScare, image.size.height);
        
    }
    
//    UIImage *endImage = [CommonMethod regionImage:image withRect:destRect];
//    size = endImage.size;
    
    return [CommonMethod regionImage:image withRect:destRect];
}

#pragma mark - address book
+ (NSString*) telFilter:(NSString*) phoneNO
{
  phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"-" withString:NULL_PARAM_VALUE];
  phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"(" withString:NULL_PARAM_VALUE];
  phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@")" withString:NULL_PARAM_VALUE];
  phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@"+" withString:NULL_PARAM_VALUE];
  phoneNO = [phoneNO stringByReplacingOccurrencesOfString:@" " withString:NULL_PARAM_VALUE];
  
  //  NSLog(@"phoneNO is %@",phoneNO);
  return phoneNO;
}

+ (void)appenSpace:(NSMutableString **)str {
  if ((*str).length > 0) {
    [(*str) appendString:@", "];
  }
}

+ (void)assemblePhoneNumber:(id)person phoneNumberStr:(NSMutableString **)phoneNumberStr {
  ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
  if (nil == phones) {
    return;
  }
  int phonesCount = ABMultiValueGetCount(phones);
  
  for(int i = 0 ;i < phonesCount;i++)
  {
    NSString *phoneNO = [(NSString*)ABMultiValueCopyValueAtIndex(phones, i) autorelease];
    
    phoneNO = [self telFilter:phoneNO];
    
    [(*phoneNumberStr) appendString:phoneNO];
    
    if (i != phonesCount-1) {
      [(*phoneNumberStr) appendString:@","];
    }
    
  }
  
  CFRelease(phones);
}

+ (void)assembleEmails:(id)person emailStr:(NSMutableString **)emailStr {
  ABMultiValueRef mails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
  if (nil == mails) {
    return;
  }
  int mailsCount = ABMultiValueGetCount(mails);
  
  for(int i = 0 ;i < mailsCount;i++)
  {
    NSString *mailNO = [(NSString *)ABMultiValueCopyValueAtIndex(mails, i) autorelease];
    [(*emailStr) appendString: mailNO];
    
    if (i != mailsCount-1) {
      [(*emailStr) appendString:@","];
    }
  }
  
  CFRelease(mails);
}

/*
+ (ABRecordRef)prepareContactData:(Alumni *)alumni {
  ABRecordRef person = ABPersonCreate();
  
  // name
  ABRecordSetValue(person, kABPersonLastNameProperty, alumni.name, NULL);
  ABRecordSetValue(person, kABPersonNoteProperty, alumni.classGroupName, NULL);
  
  // Job title
  if (alumni.companyName && ![alumni.companyName isEqualToString:NULL_PARAM_VALUE]) {
    ABRecordSetValue(person, kABPersonOrganizationProperty, alumni.companyName, NULL);
  }
  if (alumni.jobTitle && ![alumni.jobTitle isEqualToString:NULL_PARAM_VALUE]) {
    ABRecordSetValue(person, kABPersonJobTitleProperty, alumni.jobTitle, NULL);
  }
  
  // phone
  ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
  
  if (alumni.companyPhone && ![alumni.companyPhone isEqualToString:NULL_PARAM_VALUE]) {
    ABMultiValueAddValueAndLabel(multiPhone, alumni.companyPhone,kABPersonPhoneMainLabel, NULL);
  }
  if (alumni.phoneNumber && ![alumni.phoneNumber isEqualToString:NULL_PARAM_VALUE]) {
    ABMultiValueAddValueAndLabel(multiPhone, alumni.phoneNumber,
                                 kABPersonPhoneMobileLabel, NULL);
  }
  if (alumni.companyFax && ![alumni.companyFax isEqualToString:NULL_PARAM_VALUE]) {
    ABMultiValueAddValueAndLabel(multiPhone, alumni.companyFax, kABPersonPhoneWorkFAXLabel, NULL);
  }
  
  ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, nil);
  CFRelease(multiPhone);
  
  // email
  if (alumni.email && ![alumni.email isEqualToString:NULL_PARAM_VALUE]) {
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, alumni.email, kABWorkLabel, NULL);
    ABRecordSetValue(person, kABPersonEmailProperty, multiEmail, NULL);
    CFRelease(multiEmail);
  }
  
  // address
  ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
  
  NSMutableDictionary *addressDictionary = [[[NSMutableDictionary alloc] init] autorelease];
  
  if ((alumni.companyAddressC && ![alumni.companyAddressC isEqualToString:NULL_PARAM_VALUE]) ||
      (alumni.companyAddressE && ![alumni.companyAddressE isEqualToString:NULL_PARAM_VALUE])) {
    addressDictionary[(NSString *) kABPersonAddressStreetKey] = [NSString stringWithFormat:@"%@ %@", alumni.companyAddressC, alumni.companyAddressE];
  }
  if (alumni.companyProvince && ![alumni.companyProvince isEqualToString:NULL_PARAM_VALUE]) {
    
    addressDictionary[(NSString *)kABPersonAddressCityKey] = alumni.companyProvince;
  }
  
  ABMultiValueAddValueAndLabel(multiAddress, addressDictionary, kABWorkLabel, NULL);
  ABRecordSetValue(person, kABPersonAddressProperty, multiAddress, NULL);
  CFRelease(multiAddress);
  
  return (ABRecordRef)[(id)person autorelease];

}
*/

#pragma mark - user default local storage
+ (void)saveIntegerValueToLocal:(NSInteger)value key:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                            forKey:key];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveLongLongIntegerValueToLocal:(long long)value key:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                            forKey:key];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveStringValueToLocal:(NSString *)value key:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:value
                                            forKey:key];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveBoolValueToLocal:(BOOL)value key:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] setObject:@(value)
                                            forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)fetchIntegerValueFromLocal:(NSString *)key {
  NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
  if (nil == number) {
    return 0;
  } else {
    return number.intValue;
  }
}

+ (long long)fetchLonglongIntegerValueFromLocal:(NSString *)key {
  NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
  return number.longLongValue;
}

+ (NSString *)fetchStringValueFromLocal:(NSString *)key {
  return (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)fetchBoolValueFromLocal:(NSString *)key {
  NSNumber *number = (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];
  return number.boolValue;
}

+ (void)removeLocalInfoValueForKey:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
  
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)cacheNamedDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	NSString *documentsDirectory = [paths objectAtIndex:0];
  
  //Create a folder for persisting buffer.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *comDirectory = [documentsDirectory stringByAppendingPathComponent:@"cache"];
	BOOL isExist = [fileManager fileExistsAtPath:comDirectory];
	if (!isExist) {
		BOOL isOK = [fileManager createDirectoryAtPath:comDirectory withIntermediateDirectories:YES attributes:nil error:nil];
		
		if (!isOK) {
			return nil;
		}
	}
  return comDirectory;
}

+ (NSData*)readLocalFile:(NSString*)fileName {
  NSString* filePath = [[WXWCommonUtils cacheNamedDirectory] stringByAppendingFormat:@"/%@", fileName];
  NSData* objData = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
  return objData;
}

+ (void)saveLocalFile:(NSData*)objData fileName:(NSString*)fileName {
  NSString *filePath = [[WXWCommonUtils cacheNamedDirectory] stringByAppendingFormat:@"/%@", fileName];
  
  [objData writeToFile:filePath atomically:YES];
}

+ (BOOL)deleteCacheNamedDirectoryWithFileName:(NSString *)fileName {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  
  // check cache whether exist
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
  
  NSString *filePath = STR_FORMAT(@"cache/%@", fileName);
	NSString *comDirectory = [documentsDirectory stringByAppendingPathComponent:filePath];
	BOOL isExist = [fileManager fileExistsAtPath:comDirectory];
  if (!isExist) {
    // if no cache files exist, then no need to delete again, the flag will be reset to NO
    return YES;
  }
  
  NSError *err = nil;
  BOOL res = [fileManager removeItemAtPath:/*[WXWCommonUtils cacheNamedDirectory]*/comDirectory
                                     error:&err];
  if (err) {
    return NO;
  } else {
    return res;
  }
}

#pragma mark - string utilies methods
+ (NSString *)decodeForText:(NSString *)text {
  if (text) {
    return [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  } else {
    return nil;
  }
}

+ (NSString *)replaceHtmlSpecialChar:(NSString *)text {
  return [text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
}

+ (NSString *)replacePlusForText:(NSString *)text {
  if (text) {
    return [text stringByReplacingOccurrencesOfString:@"+" withString:@" "];
  } else {
    return nil;
  }
}

+ (NSString *)decodeAndReplacePlusForText:(NSString *)text {
  if (text && text.length > 0) {
    text = [self replaceHtmlSpecialChar:text];
    NSString *decodedText = [self decodeForText:text];
    
    if (nil == decodedText) {
      decodedText = text;
    }
    
    return [self replacePlusForText:decodedText];
  } else {
    return nil;
  }
}

+ (NSString *)replaceSpaceForText:(NSString *)text {
  if (text) {
    return [text stringByReplacingOccurrencesOfString:@" " withString:NULL_PARAM_VALUE];
  } else {
    return nil;
  }
}

+ (CGSize)sizeForText:(NSString *)text font:(UIFont *)font attributes:(NSDictionary *)attributes {
  if (text == nil) {
    return CGSizeZero;
  }
  
  if (CURRENT_OS_VERSION >= IOS7) {
    return [text sizeWithAttributes:attributes];
  } else {
    return [text sizeWithFont:font];
  }
}

+ (CGSize)sizeForText:(NSString *)text
                 font:(UIFont *)font
    constrainedToSize:(CGSize)constrainedToSize
        lineBreakMode:(NSLineBreakMode)lineBreakMode
              options:(NSStringDrawingOptions)options
           attributes:(NSDictionary *)attributes {
  
  if (text == nil) {
    return CGSizeZero;
  }
  
  if (CURRENT_OS_VERSION >= IOS7) {
    CGRect frame = [text boundingRectWithSize:constrainedToSize
                                      options:options
                                   attributes:attributes
                                      context:nil];
    return frame.size;
  } else {
    return [text sizeWithFont:font constrainedToSize:constrainedToSize lineBreakMode:lineBreakMode];
  }
}

#pragma mark - remove html tag from string
+ (NSString *)stringByDecodingHTMLEntitiesFromContent:(NSMutableString *)content {
  // Can return self so create new string if we're a mutable string
  return [NSString stringWithString:[content gtm_stringByUnescapingFromHTML]];
}

+ (NSString *)convertingHTMLToPlainTextFromContent:(NSString *)content {
  
  if (nil == content || 0 == content.length) {
    return nil;
  }
  
	// Pool
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
	// Character sets
	NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%d%d%d%d", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%d%d%d%d", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
  
	// Scan and find all tags
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:content.length];
	NSScanner *scanner = [[NSScanner alloc] initWithString:content];
	[scanner setCharactersToBeSkipped:nil];
	[scanner setCaseSensitive:YES];
	NSString *str = nil, *tagName = nil;
	BOOL dontReplaceTagWithSpace = NO;
	do {
    
		// Scan up to the start of a tag or whitespace
		if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
			[result appendString:str];
			str = nil; // reset
		}
    
		// Check if we've stopped at a tag/comment or whitespace
		if ([scanner scanString:@"<" intoString:NULL]) {
      
			// Stopped at a comment or tag
			if ([scanner scanString:@"!--" intoString:NULL]) {
        
				// Comment
				[scanner scanUpToString:@"-->" intoString:NULL];
				[scanner scanString:@"-->" intoString:NULL];
        
			} else {
        
				// Tag - remove and replace with space unless it's
				// a closing inline tag then dont replace with a space
				if ([scanner scanString:@"/" intoString:NULL]) {
          
					// Closing tag - replace with space unless it's inline
					tagName = nil; dontReplaceTagWithSpace = NO;
					if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
						tagName = [tagName lowercaseString];
						dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
                                       [tagName isEqualToString:@"b"] ||
                                       [tagName isEqualToString:@"i"] ||
                                       [tagName isEqualToString:@"q"] ||
                                       [tagName isEqualToString:@"span"] ||
                                       [tagName isEqualToString:@"em"] ||
                                       [tagName isEqualToString:@"strong"] ||
                                       [tagName isEqualToString:@"cite"] ||
                                       [tagName isEqualToString:@"abbr"] ||
                                       [tagName isEqualToString:@"acronym"] ||
                                       [tagName isEqualToString:@"label"]);
					}
          
					// Replace tag with string unless it was an inline
					if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
          
				}
        
				// Scan past tag
				[scanner scanUpToString:@">" intoString:NULL];
				[scanner scanString:@">" intoString:NULL];
        
			}
      
		} else {
      
			// Stopped at whitespace - replace all whitespace and newlines with a space
			if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
				if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
			}
      
		}
    
	} while (![scanner isAtEnd]);
  
	// Cleanup
	[scanner release];
  
	// Decode HTML entities and return
	NSString *retString = [[self stringByDecodingHTMLEntitiesFromContent:result] retain];
	[result release];
  
	// Drain
	[pool drain];
  
	// Return
	return [retString autorelease];
  
}



#pragma mark - sha1 hash
+ (NSString*)sha1:(NSString*)input
{
  const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
  NSData *data = [NSData dataWithBytes:cstr length:input.length];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];
  
  return output;
}

#pragma mark - md5 hash

+ (NSString*)hashStringAsMD5:(NSString*)str {
  
	const char *concat_str = [str UTF8String];
  unsigned char result[CC_MD5_DIGEST_LENGTH];
  CC_MD5(concat_str, strlen(concat_str), result);
  NSMutableString *hash = [NSMutableString string];
  
	for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
    [hash appendFormat:@"%02X", result[i]];
	}
  
	return [hash lowercaseString];
}

@end