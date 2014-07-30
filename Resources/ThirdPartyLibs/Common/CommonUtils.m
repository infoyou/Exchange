//
//  CommonUtils.m
//  Project
//
//  Created by XXX on 13-9-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommonUtils.h"
#import "Post.h"
#import "UIDevice+Hardware.h"
#import "WXApi.h"
#import "WXWSystemInfoManager.h"
#import "AppManager.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageGrayscaleFilter.h"
#import "ProjectAPI.h"

#define BUFFER_SIZE 1024 * 100

@implementation CommonUtils

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
    //	switch ([self currentLanguage]) {
    //		case ZH_HANS_TY:
    //		{
    //			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"yyyy年 MM月 dd日 HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"yyyy年 MM月 dd日"];
    //            }
    //
    //			break;
    //		}
    //		case EN_TY:
    //		{
    //            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"dd MMM yyyy HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"dd MMM yyyy"];
    //            }
    //
    //			break;
    //		}
    //		default:
    //			break;
    //	}
	
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd"];
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
    //	switch ([self currentLanguage]) {
    //		case ZH_HANS_TY:
    //		{
    //			[formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"MM月 dd日 HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"MM月 dd日"];
    //            }
    //
    //			break;
    //		}
    //		case EN_TY:
    //		{
    //            [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en"] autorelease]];
    //            if (secondAccuracy) {
    //                [formatter setDateFormat:@"dd MMM HH:mm"];
    //            } else {
    //                [formatter setDateFormat:@"dd MMM"];
    //            }
    //
    //			break;
    //		}
    //		default:
    //			break;
    //	}
    
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease]];
    if (secondAccuracy) {
        [formatter setDateFormat:@"MM/dd HH:mm"];
    } else {
        [formatter setDateFormat:@"MM/dd"];
    }
	
	NSString *timeline = [formatter stringFromDate:date];
    //NSString *timelineResult = [[NSString alloc] initWithFormat:@"%@",timeline];
	[formatter release];
	formatter = nil;
	
	//return timelineResult;
    return timeline;
}

+ (NSString *)getQuantumTimeWithDateFormat:(NSString *)timeline {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    //Set the AM and PM symbols
    //Specify only 1 M for month, 1 d for day and 1 h for hour
    [dateFormatter setAMSymbol:@"AM"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //    NSDate *orderDate = [dateFormatter dateFromString:eventList.startTime];
    NSDate *orderDate = [NSDate dateWithTimeIntervalSince1970:[timeline floatValue] / 1000];
    
    //        NSDate *nowtime = [dateFormatter dateFromString:[dateFormatter stringFromDate:now]];
    
    //下单 与目前相隔多少秒
    
    int time = [[NSDate date] timeIntervalSinceDate:orderDate];
    
    NSString *timeStr = @"";
    
    if (time > 0) {
        if (time / 60 / 60 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟前",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时前",time / 60.f/ 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天前",time / 60.f / 60.f / 24.f];
        }
    }else {
        time *= -1;
        if (time / 60 /60  <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f分钟后",time / 60.f];
        }else if (time / 60 / 60 > 0 && time / 60 / 60 / 24 <= 0) {
            timeStr = [NSString stringWithFormat:@"%.0f小时后",time / 60.f / 60.f];
        }else {
            timeStr = [NSString stringWithFormat:@"%.0f天后",time / 60.f / 60.f / 24.f];
        }
    }
    return timeStr;
}

+ (NSString *)getElapsedTime:(NSDate *)timeline {
    
    NSUInteger desiredComponents = NSDayCalendarUnit | NSHourCalendarUnit
    | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:desiredComponents
                                                                         fromDate:timeline
                                                                           toDate:[NSDate date]
                                                                          options:0];
    // format to be used to generate string to display
    NSInteger number = 0;
    NSString *elapsedTime = nil;
    
    if ([elapsedTimeUnits day] > 0) {
        
        elapsedTime = [CommonUtils simpleFormatDate:timeline secondAccuracy:NO];
        
    } else if ([elapsedTimeUnits hour] > 0) {
        number = [elapsedTimeUnits hour];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHoursAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSHourAgoTitle, nil)];
        }
        
    } else if ([elapsedTimeUnits minute] > 0) {
        number = [elapsedTimeUnits minute];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSMinAgoTitle, nil)];
        }
    } else if ([elapsedTimeUnits second] > 0) {
        number = [elapsedTimeUnits second];
        if (number > 1) {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecsAgoTitle, nil)];
        } else {
            elapsedTime = [NSString stringWithFormat:@"%d %@", number, LocaleStringForKey(NSSecAgoTitle, nil)];
        }
    } else if ([elapsedTimeUnits second] <= 0) {
        
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
    
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *elapsedTimeUnits = [[NSCalendar currentCalendar] components:NSDayCalendarUnit
                                                                         fromDate:currentDate
                                                                           toDate:date
                                                                          options:0];
    return [elapsedTimeUnits day];
}

#pragma mark - Share to WeChat
+ (BOOL)shareByWeChat:(NSInteger)scene
                title:(NSString *)title
                image:(NSString *)image
          description:(NSString *)description
                  url:(NSString *)url {
    
    // 发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    
    // avoid length larger than the specification
    if (title.length > MAX_WECHAT_MAX_TITLE_CHAR_COUNT) {
        title = [title substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_TITLE_CHAR_COUNT)];
        
        NSMutableString *reducedTitle = [NSMutableString stringWithString:title];
        [reducedTitle appendString:@"..."];
        message.title = reducedTitle;
    } else {
        message.title = title;
    }
    
    if (description.length > MAX_WECHAT_MAX_DESC_CHAR_COUNT) {
        description = [description substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_DESC_CHAR_COUNT)];
        NSMutableString *reducedDesc = [NSMutableString stringWithString:description];
        [reducedDesc appendString:@"..."];
        message.description = reducedDesc;
    } else {
        message.description = description;
    }
    
    [message setThumbImage:[UIImage imageNamed:image]];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"";
    ext.url = url;
    
    /*
     Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
     memset(pBuffer, 0, BUFFER_SIZE);
     NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
     free(pBuffer);
     ext.fileData = data;
     */
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    return [WXApi sendReq:req];
}

+ (BOOL)sharePostByWeChat:(Post *)post
                    scene:(NSInteger)scene
                      url:(NSString *)url
                    image:(UIImage *)image {
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    NSString *title = [NSString stringWithFormat:@"dsfadfafdfdsafdsa"/*LocaleStringForKey(NSSharedFromiAlumniTitle, nil), post.elapsedTime, post.authorName*/];
    
    // avoid length larger than the specification
    if (title.length > MAX_WECHAT_MAX_TITLE_CHAR_COUNT) {
        title = [title substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_TITLE_CHAR_COUNT)];
        
        NSMutableString *reducedtitle = [NSMutableString stringWithString:title];
        [reducedtitle appendString:@"..."];
        
        message.title = reducedtitle;
    } else {
        message.title = title;
    }
    
    NSString *desc = post.content;
    if (desc.length > MAX_WECHAT_MAX_DESC_CHAR_COUNT) {
        desc = [desc substringWithRange:NSMakeRange(0, MAX_WECHAT_MAX_DESC_CHAR_COUNT)];
        
        NSMutableString *reducedDesc = [NSMutableString stringWithString:desc];
        [reducedDesc appendString:@"..."];
        message.description = reducedDesc;
    } else {
        message.description = desc;
    }
    
    if (image) {
        if (post.thumbnailImageUrl && post.thumbnailImageUrl.length > 0) {
            NSData *imageData = nil;
            if ([post.thumbnailImageUrl rangeOfString:@".png"].length > 0) {
                imageData = UIImagePNGRepresentation(image);
            } else if ([post.thumbnailImageUrl rangeOfString:@".jpg"].length > 0) {
                imageData = UIImageJPEGRepresentation(image, 0.1f);
            }
            
            // If the image data size is larger than 32k, then sharing action
            // will failed. So if the size is larger than 32k, then no need to
            // set the thumb image.
            if (imageData.length < MAX_WECHAT_ATTACHED_IMG_SIZE) {
                message.thumbData = imageData;
            }
        }
    }
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"";
    ext.url = url;
    
    /*
     Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
     memset(pBuffer, 0, BUFFER_SIZE);
     NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
     free(pBuffer);
     ext.fileData = data;
     
     message.mediaObject = ext;
     
     SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
     req.bText = NO;
     req.message = message;
     req.scene = scene;
     [WXApi sendReq:req];
     */
    return [self sendToWechatWithExtObject:ext message:message];
}

+ (BOOL)sendToWechatWithExtObject:(WXAppExtendObject *)ext message:(WXMediaMessage *)message {
    Byte* pBuffer = (Byte *)malloc(BUFFER_SIZE);
    memset(pBuffer, 0, BUFFER_SIZE);
    NSData* data = [NSData dataWithBytes:pBuffer length:BUFFER_SIZE];
    free(pBuffer);
    ext.fileData = data;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    return [WXApi sendReq:req];
    
}

#pragma mark - validate json data
+ (id)validateResult:(NSDictionary *)contentDic dicKey:(NSString *)key
{
    if (nil == contentDic) {
        return nil;
    }
    
    if (nil == key || key.length == 0) {
        return nil;
    }
    
    if ([contentDic isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    id result = [contentDic objectForKey:key];
    
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    } else {
        if (result) {
            if ([@"null" isEqualToString:result]) {
                return nil;
            } else {
                return result;
            }
        } else {
            return nil;
        }
    }
}


#pragma mark - validate password format
+ (BOOL)passwordFormatIsValidated:(NSString *)passwordStr {
    
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    
    NSRange range = [passwordStr rangeOfCharacterFromSet:notAllowedChars];
    if (range.location != NSNotFound && range.length > 0) {
        
        ShowAlert(nil, nil,
                  LocaleStringForKey(NSPwdFormatIncorrectMsg, nil),
                  LocaleStringForKey(NSSureTitle, nil));
        
        return NO;
    } else {
        return YES;
    }
}

+ (NSString *)deviceModel {
	UIDevice *device = [[[UIDevice alloc] init] autorelease];
	return [device platformString];
}

+ (NSString *)documentsDirectory {
	return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

+ (CGFloat)currentOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

#pragma mark - system language
+ (LanguageType)currentLanguage {
    //    return [WXWSystemInfoManager instance].currentLanguageCode;
    return ZH_HANS_TY;
}

+ (NSString *)datetimeWithFormat:(NSString *)format datetime:(NSDate *)datetime
{
    NSDateFormatter* dayFormater = [[[NSDateFormatter alloc] init] autorelease];
    [dayFormater setDateFormat:format];
    switch ([self currentLanguage]) {
        case EN_TY:
            dayFormater.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"] autorelease];
            break;
            
        default:
            dayFormater.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
            break;
    }
    return [dayFormater stringFromDate:datetime];
}

#pragma mark - Gene JSON
/**
 param eg:
 NSDictionary *specialDict = [NSDictionary dictionaryWithObjectsAndKeys:@"101", @"id", nil];
 */
+ (NSString *)geneJSON:(NSDictionary *)specialDict
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    NSString *userId = @"";
    if ([AppManager instance].userId && [AppManager instance].userId.length>0) {
        userId = [AppManager instance].userId;
    }
    
    NSString *sessionId = @"";
    if ([AppManager instance].sessionId && [AppManager instance].sessionId.length>0) {
        sessionId = [AppManager instance].sessionId;
    }
    
    NSString *deviceToken = @"";
    if ([AppManager instance].deviceToken && [AppManager instance].deviceToken.length>0) {
        deviceToken = [AppManager instance].deviceToken;
    }
    
    NSString *channel = @"";
    if ([AppManager instance].releaseChannelType) {
        channel = [NSString stringWithFormat:@"%d", [AppManager instance].releaseChannelType];
    }
    
    NSDictionary *commonDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                [WXWSystemInfoManager instance].currentLanguageDesc, @"locale",
                                userId,                                              @"userId",
                                sessionId,                                           @"sessionId",
                                VERSION,                                             @"version",
                                PLATFORM,                                            @"plat",
                                deviceToken,                                         @"deviceToken",
                                STR_FORMAT(@"%.1f", [CommonUtils currentOSVersion]),                                            @"osInfo",
                                channel,                                             @"channel",
                                nil];
    
    [resultDict setObject:commonDict forKey:@"common"];
    
    // special
    if ([specialDict count] > 0) {
        [resultDict setObject:specialDict forKey:@"special"];
    } else {
        [resultDict setObject:@"" forKey:@"special"];
    }
    
    NSLog(@"resultDict: %@",resultDict);
    
    NSString *jsonString = [resultDict JSONString];
    NSLog(@"dictionary jsonString:%@", jsonString);
    
    return jsonString;
}

#pragma mark - Gene Url
+ (NSString *)geneJSONUrl:(NSDictionary *)param itemType:(WebItemType)itemType
{
    NSString *url = nil;
    
    switch (itemType) {
            
        case GET_GROUP_USER_LIST:
            url = @"chatgroupService/GetChatGroupUser";
            break;
            
        case LOAD_BIZ_POST_TY:
            url = @"http://180.153.154.21:9007/PostService/GetPosts";
            break;
            
        case LOAD_USER_LIST_TY:
            url = @"UserService/GetUserNearby";
            break;
            
        case POST_FAVORITE_ACTION_TY:
        case POST_UNFAVORITE_ACTION_TY:
            url = @"http://180.153.154.21:9007/PostService/submitPostAttention";
            break;
            
        case DELETE_POST_COMMENTS_TY:
            url = @"http://180.153.154.21:9007/PostService/deletePostComments";
            break;
            
        case DELETE_POST_TY:
            url = @"http://180.153.154.21:9007/PostService/deletePost";
            break;
            
        case COMMENT_LIST_TY:
            url = @"http://180.153.154.21:9007/PostService/GetPostComments";
            break;
            
        case SAVE_INFO_TO_SERVER:
        case GET_USER_PROFILES:
            url = @"UserService/UserProfile";
            break;
            
        default:
            break;
    }
    
    NSString *reqContent = [self geneJSON:param];
    
    reqContent = [reqContent stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    if ([url hasPrefix:@"http://"]) {
        url = [NSString stringWithFormat:@"%@?ReqContent=%@", url, reqContent];
    } else {
        url = [NSString stringWithFormat:@"%@/%@?ReqContent=%@", VALUE_API_PREFIX, url, reqContent];
    }
    
    return url;
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
    
    if ([text isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
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

+ (BOOL)screenHeightIs4Inch {
    float height = (APP_DELEGATE).window.frame.size.height;
    float width = (APP_DELEGATE).window.frame.size.width;
    
    if(height / width == 1.5f)
    {
        return NO;
    } else {
        return YES;
    }
    
//    if ([[CommonUtils deviceModel] rangeOfString:IPHONE_5_NAMESTRING].length > 0 ||
//        [[CommonUtils deviceModel] rangeOfString:IPHONE_5S_NAMESTRING].length > 0 ||
//        [[CommonUtils deviceModel] rangeOfString:IPHONE_5C_NAMESTRING].length > 0) {
//        return YES;
//    } else {
//        return NO;
//    }
}

+ (BOOL)needBeScaledSize:(UIImage *)sourceImage
              targetSize:(CGSize *)targetSize
              sourceType:(UIImagePickerControllerSourceType)sourceType {
	NSString *model = [CommonUtils deviceModel];
	
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
            || (sourceImage.size.width <= PHOTO_SHORT_LEN_4G && sourceImage.size.height <= PHOTO_LONG_LEN_4G)) {
            
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
	if (CURRENT_OS_VERSION >= IOS4) {
        
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
        switch ([CommonUtils imageOrientationType:image]) {
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

+ (CGFloat)screenWidth {
   
    float width = (APP_DELEGATE).window.frame.size.width;
    float height = (APP_DELEGATE).window.frame.size.height;
    
    if ([self currentOrientationIsLandscape]) {
        return height;
    } else {
        return width;
    }
}

+ (CGFloat)screenHeight {
    
    float width = (APP_DELEGATE).window.frame.size.width;
    float height = (APP_DELEGATE).window.frame.size.height;

    if ([self currentOrientationIsLandscape]) {
        return width;
    } else {
        return height;
    }
}

#pragma mark - combine image show chat icon by XXX
+ (UIImage *)combineImage:(NSMutableArray *)imageArray {
    
    int baseWidth = 52;
    int baseHeight = 52;
    
    int imageW = 52;
    int imageH = 52;
    int offsetX = 5;
    int orginY = 10;
    
    int size = [imageArray count];
    
    switch (size) {
        case 1:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            return image1;
        }
            break;
            
        case 2:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            
            offsetX = 5;
            imageW = (baseWidth - offsetX*3) / 2;
            imageH = imageW;
            orginY = (baseHeight - imageH) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            NSLog(@"CGSize1 is %@",NSStringFromCGSize(CGSizeMake(baseWidth, imageH)));
            NSLog(@"CGSize2 is %@",NSStringFromCGSize(image1.size));
            
            [image1 drawInRect:CGRectMake(offsetX, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX*2 + imageW, orginY, imageW, imageH)];
        }
            break;
            
        case 3:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            
            offsetX = 5;
            imageW = (baseWidth - offsetX*3) / 2;
            imageH = imageW;
            orginY = (baseHeight - imageH*2-offsetX) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake((baseWidth-imageW) / 2, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            
        }
            break;
            
        case 4:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            
            offsetX = 5;
            imageW = (baseWidth - offsetX*3) / 2;
            imageH = imageW;
            orginY = (baseHeight - imageH*2-offsetX) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake(offsetX, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX*2 + imageW, orginY, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            
        }
            break;
            
        case 5:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            UIImage *image5 = [imageArray objectAtIndex:4];
            
            offsetX = 3;
            imageW = (baseWidth - offsetX*4) / 3;
            imageH = imageW;
            orginY = (baseHeight - imageH*2-offsetX) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake((baseWidth - imageW*2-offsetX)/2, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake((baseWidth - imageW*2-offsetX)/2 + imageW + offsetX, orginY, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            [image5 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH + offsetX, imageW, imageH)];
            
        }
            break;
            
        case 6:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            UIImage *image5 = [imageArray objectAtIndex:4];
            UIImage *image6 = [imageArray objectAtIndex:5];
            
            offsetX = 3;
            imageW = (baseWidth - offsetX*4) / 3;
            imageH = imageW;
            orginY = (baseHeight - imageH*2-offsetX) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake(offsetX, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX*2 + imageW, orginY, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image5 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            [image6 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH + offsetX, imageW, imageH)];
            
        }
            break;
            
        case 7:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            UIImage *image5 = [imageArray objectAtIndex:4];
            UIImage *image6 = [imageArray objectAtIndex:5];
            UIImage *image7 = [imageArray objectAtIndex:6];
            
            offsetX = 3;
            imageW = (baseWidth - offsetX*4) / 3;
            imageH = imageW;
            orginY = (baseHeight - imageH*3-offsetX*2) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake((baseWidth-imageW) / 2, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH + offsetX, imageW, imageH)];
            [image5 drawInRect:CGRectMake(offsetX, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image6 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image7 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH*2 + offsetX*2, imageW, imageH)];
        }
            break;
            
        case 8:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            UIImage *image5 = [imageArray objectAtIndex:4];
            UIImage *image6 = [imageArray objectAtIndex:5];
            UIImage *image7 = [imageArray objectAtIndex:6];
            UIImage *image8 = [imageArray objectAtIndex:7];
            
            offsetX = 3;
            imageW = (baseWidth - offsetX*4) / 3;
            imageH = imageW;
            orginY = (baseHeight - imageH*3-offsetX*2) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake((baseWidth - imageW*2-offsetX)/2, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake((baseWidth - imageW*2-offsetX)/2 + imageW + offsetX, orginY, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            [image5 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH + offsetX, imageW, imageH)];
            [image6 drawInRect:CGRectMake(offsetX, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image7 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image8 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH*2 + offsetX*2, imageW, imageH)];
        }
            break;
            
        case 9:
        {
            UIImage *image1 = [imageArray objectAtIndex:0];
            UIImage *image2 = [imageArray objectAtIndex:1];
            UIImage *image3 = [imageArray objectAtIndex:2];
            UIImage *image4 = [imageArray objectAtIndex:3];
            UIImage *image5 = [imageArray objectAtIndex:4];
            UIImage *image6 = [imageArray objectAtIndex:5];
            UIImage *image7 = [imageArray objectAtIndex:6];
            UIImage *image8 = [imageArray objectAtIndex:7];
            UIImage *image9 = [imageArray objectAtIndex:8];
            
            offsetX = 3;
            imageW = (baseWidth - offsetX*4) / 3;
            imageH = imageW;
            orginY = (baseHeight - imageH*3-offsetX*2) / 2;
            
            UIGraphicsBeginImageContext(CGSizeMake(baseWidth, baseHeight));
            [image1 drawInRect:CGRectMake(offsetX, orginY, imageW, imageH)];
            [image2 drawInRect:CGRectMake(offsetX*2 + imageW, orginY, imageW, imageH)];
            [image3 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY, imageW, imageH)];
            [image4 drawInRect:CGRectMake(offsetX, orginY + imageH + offsetX, imageW, imageH)];
            [image5 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH + offsetX, imageW, imageH)];
            [image6 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH + offsetX, imageW, imageH)];
            [image7 drawInRect:CGRectMake(offsetX, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image8 drawInRect:CGRectMake(offsetX*2 + imageW, orginY + imageH*2 + offsetX*2, imageW, imageH)];
            [image9 drawInRect:CGRectMake(offsetX*3 + imageW*2, orginY + imageH*2 + offsetX*2, imageW, imageH)];
        }
            break;
            
        default:
            break;
    }
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
