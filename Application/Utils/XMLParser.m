//
//  XMLParser.m
//  Project
//
//  Created by XXX on 11-11-3.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "XMLParser.h"
#import "NSDate+Reporting.h"
#import "WXWDebugLogOutput.h"
#import "DataProvider.h"
#import "Alumni.h"
#import "Tag.h"
#import "PYMethod.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "WXWUIUtils.h"
#import "TextPool.h"
#import "WXWCoreDataUtils.h"
#import "WXWSystemInfoManager.h"

@implementation XMLParser

+ (void)traceErrorMessageForConnectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                                          url:(NSString *)url
                                         code:(NSInteger)code
                                          doc:(CXMLDocument *)doc {
  
  if (connectorDelegate && code != HTTP_RESP_OK) {
    NSArray *respDescs = [doc nodesForXPath:@"//response/desc" error:nil];
    NSString *message = [respDescs.lastObject stringValue];
    message = [WXWCommonUtils decodeAndReplacePlusForText:message];
    
    debugLog(@"error response description: %@ for url %@", message, url);
    [connectorDelegate traceParserXMLErrorMessage:message
                                              url:url];
  }
}

+ (BOOL)converStringToXML:(CXMLDocument **)doc contentStr:(NSString *)contentStr {
  NSError* error = nil;
  *doc = [[CXMLDocument alloc] initWithXMLString:contentStr
                                         options:0
                                           error:&error];
  if (error || nil == *doc) {
    debugLog(@"Parser xml failed: %@", [error domain]);
    [WXWUIUtils alert:nil
           message:LocaleStringForKey(NSParserXmlErrMsg, nil)];
    return NO;
  }
  return YES;
}

+ (BOOL)parserResponseNode:(NSData *)xmlData
                       doc:(CXMLDocument **)doc
         connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                       url:(NSString *)url
                      type:(WebItemType)type {
  
  NSString *xmlStr = [[[NSString alloc] initWithData:xmlData
                                            encoding:NSUTF8StringEncoding] autorelease];
  if (EC_DEBUG) {
    NSLog(@"xml string: %@", xmlStr);
  }
  if (xmlStr == nil || [xmlStr isEqualToString:NULL_PARAM_VALUE] || xmlStr.length == 0) {
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSParserXmlNullMsg, nil)
                                  msgType:ERROR_TY
                       belowNavigationBar:YES];
    
    return NO;
  }
  
  NSRange resRange = [xmlStr rangeOfString:@"<response>"];
  NSInteger resCode = 0;
  
  NSString *contentStr = nil;
  
  if (resRange.length == 0) {
    resRange = [xmlStr rangeOfString:@"<contents>"];
    
    contentStr = xmlStr;
    
    if ([self converStringToXML:doc contentStr:contentStr]) {
      
      resCode = RESP_OK;
      
    } else {
      return NO;
    }
    
  } else {
    
    contentStr = [xmlStr substringFromIndex:resRange.location];
    
    if ([self converStringToXML:doc contentStr:contentStr]) {
      resCode = [[*doc nodesForXPath:@"//response/code" error:nil].lastObject stringValue].intValue;
    } else {
      return NO;
    }
  }
  
  if (connectorDelegate != nil && url.length > 0) {
    [self traceErrorMessageForConnectorDelegate:connectorDelegate
                                            url:url
                                           code:resCode
                                            doc:*doc];
  }
  
  return YES;
}

+ (NSInteger)parserResponseCode:(CXMLDocument *)respDoc {
  NSArray *respCodes = [respDoc nodesForXPath:@"//response/code"
                                        error:nil];
  NSInteger code = 0;
  if (respCodes.count == 0) {
    code = RESP_OK;
  } else {
    code = [[respCodes.lastObject stringValue] intValue];
  }
  return code;
}

#pragma mark - entry points
+ (BOOL)parserResponseXml:(NSData *)xmlData
                     type:(WebItemType)type
                      MOC:(NSManagedObjectContext *)MOC
        connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                      url:(NSString *)url {
  
  CXMLDocument *doc = nil;
	
	if (![self parserResponseNode:xmlData
                            doc:&doc
              connectorDelegate:connectorDelegate
                            url:url
                           type:type]) {
		return NO;
	}
  
  BOOL ret = YES;

  switch (type) {
    case EVENTLIST_TY:
      ret = [self handleFetchEventList:doc MOC:MOC];
      break;
      
    case LOAD_KNOWN_ALUMNUS_TY:
      ret = [self handleKnownAlumnus:doc MOC:MOC];
      break;
      
      case SUPPLY_DEMAND_TAG_TY:
          ret = [self handlePostTag:doc MOC:MOC];
          break;
          
      case POST_FAVORITE_ACTION_TY:
      case POST_UNFAVORITE_ACTION_TY:
          ret = [self handleFavoriteItem:doc];
          break;
          
    default:
      break;
  }
  return ret;
}

#pragma mark - fetch Post Tag
+ (BOOL)handlePostTag:(CXMLDocument *)respDoc MOC:(NSManagedObjectContext *)MOC{
    
    NSArray *respCodes = [respDoc nodesForXPath:@"//response/code"
                                          error:nil];
    
    if (RESP_OK == [[[respCodes lastObject] stringValue] intValue]) {
        NSArray *tagList = [respDoc nodesForXPath:@"//content/tags/tag" error:nil];
        for (int i = 0; i < [tagList count]; i++) {
            NSString *name = nil;
            int tagId = 0;
            int order = 0;
            int typeId = 0;
            int part = 0;
            long long groupId = 0ll;
            
            CXMLElement *el = (CXMLElement *)tagList[i];
            NSArray *idArray = [el elementsForName:@"id"];
            if ([idArray count]) {
                tagId = [[[idArray lastObject] stringValue] intValue];
            }
            
            NSArray *urlArray = [el elementsForName:@"name"];
            if ([urlArray count]) {
                
                name = [[urlArray lastObject] stringValue];
            }
            if (nil == name) {
                name = NULL_PARAM_VALUE;
            }
            
            NSArray *sorts = [el elementsForName:@"sort"];
            if ([sorts count]) {
                order = [[[sorts lastObject] stringValue] intValue];
            }
            
            NSArray *types = [el elementsForName:@"type_id"];
            if ([types count]) {
                typeId = [[[types lastObject] stringValue] intValue];
            }
            
            NSArray *parts = [el elementsForName:@"part"];
            if ([parts count]) {
                part = [[[parts lastObject] stringValue] intValue];
            }
            
            NSArray *groupIds = [el elementsForName:@"item_id"];
            if (groupIds.count > 0) {
                groupId = [groupIds.lastObject stringValue].longLongValue;
            }
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(tagId == %d)", tagId];
            Tag *checkPoint = (Tag *)[WXWCoreDataUtils fetchObjectFromMOC:MOC entityName:@"Tag" predicate:predicate];
            if (checkPoint) {
                checkPoint.tagName = name;
                checkPoint.order = @(order);
                checkPoint.part = @(part);
                checkPoint.typeId = @(typeId);
                checkPoint.groupId = @(groupId);
                continue;
            }
            
            Tag *tag = (Tag *)[NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:MOC];
            tag.tagId = [NSNumber numberWithLongLong:tagId];
            tag.tagName = name;
            //tag.type = [NSNumber numberWithInt:SHARE_TY];
            tag.typeId = @(typeId);
            tag.order = @(order);
            tag.selected = @(NO);
            tag.part = @(part);
            tag.groupId = @(groupId);
        }
       if (SAVE_MOC(MOC)) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

#pragma mark - user
+ (BOOL)handleUserVerify:(CXMLDocument *)respDoc MOC:(NSManagedObjectContext *)MOC {
  if ([self parserResponseCode:respDoc] == HTTP_RESP_OK) {
    
    NSArray *userIds = [respDoc nodesForXPath:@"//response/user_id" error:nil];
    if (userIds.count > 0) {
      [DataProvider instance].userId = [userIds.lastObject stringValue];
      [WXWCommonUtils saveStringValueToLocal:[DataProvider instance].userId key:USER_ID_LOCAL_KEY];
    }
    
    NSArray *usernames = [respDoc nodesForXPath:@"//response/user_name" error:nil];
    if (usernames.count > 0) {
      [DataProvider instance].username = [usernames.lastObject stringValue];
      [WXWCommonUtils saveStringValueToLocal:[DataProvider instance].username key:USER_NAME_LOCAL_KEY];
    }
    
    NSArray *sessions = [respDoc nodesForXPath:@"//response/session_value" error:nil];
    if (sessions.count > 0) {
      [DataProvider instance].sessionId = [sessions.lastObject stringValue];
    }
    
    return YES;
  } else {
    return NO;
  }
}

+ (BOOL)parserSyncResponseXml:(NSData *)xmlData
                         type:(WebItemType)type
                          MOC:(NSManagedObjectContext *)MOC {
  
  CXMLDocument *doc = nil;
  
  if (![self parserResponseNode:xmlData
                            doc:&doc
              connectorDelegate:nil
                            url:nil
                           type:type]) {
    
    return NO;
    
  }

  BOOL ret = YES;
  
  switch (type) {
      
    case LOGIN_TY:
      ret = [self handleUserMsg:doc MOC:MOC];
      break;
      
    default:
      break;
  }
  
  RELEASE_OBJ(doc);
  
  return ret;
}

+ (BOOL)handleUserMsg:(CXMLDocument *)respDoc MOC:(NSManagedObjectContext *)MOC {
  
  NSArray *respCodes = [respDoc nodesForXPath:@"//contents/code" error:nil];  
  
  if (RESP_OK != [[[respCodes lastObject] stringValue] intValue]) {
    
    return NO;
  }
  
  NSArray *alumniList = [respDoc nodesForXPath:@"//content" error:nil];
  
  for (CXMLElement *el in alumniList) {
    
    NSArray *sessionIds = [el elementsForName:@"sessionId"];
    if ([sessionIds count] > 0) {
      [DataProvider instance].sessionId = [[[sessionIds lastObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *personIds = [el elementsForName:@"personId"];
    if (personIds.count > 0) {
      [DataProvider instance].personId = [[personIds lastObject] stringValue];
    }
    
    NSArray *userIds = [el elementsForName:@"userId"];
    if ([userIds count] > 0) {
      [DataProvider instance].userId = [[[userIds lastObject] stringValue]lowercaseString];

    }
    
    NSArray *names = [el elementsForName:@"name"];
    if ([names count] > 0) {
      [DataProvider instance].username = [[[names lastObject] stringValue]lowercaseString];
    }
    
  }
  
  return YES;
}

#pragma mark - event list
+ (EventDateCategory)getEventDateCategoryByDatetime:(NSTimeInterval)timestamp {
  
  NSTimeInterval tomorrowMidnight = [WXWCommonUtils convertToUnixTS:[NSDate midnightTomorrow]];
  
  NSTimeInterval todayMidnight = [WXWCommonUtils convertToUnixTS:[NSDate midnightToday]];
  
  if (timestamp <= tomorrowMidnight && timestamp > todayMidnight) {
    return TODAY_CATEGORY_EVENT;
  } else {
    NSTimeInterval firstDayOfNextMonth = [WXWCommonUtils convertToUnixTS:[NSDate firstDayOfNextMonth]];
    
    NSTimeInterval firstDayOfCurrentMonth = [WXWCommonUtils convertToUnixTS:[NSDate firstDayOfCurrentMonth]];
    
    if (timestamp <= firstDayOfNextMonth && timestamp > firstDayOfCurrentMonth) {
      return THIS_MONTH_CATEGORY_EVENT;
    }
  }
  
  return OTHER_CATEGORY_EVENT;
}

+ (void)parserEvent:(NSArray *)eventList MOC:(NSManagedObjectContext *)MOC {
    
    /*
  for (CXMLElement *el in eventList) {
    
    NSArray *eventIds = [el elementsForName:@"id"];
    long long eventId = 0;
    if ([eventIds count] > 0) {
      eventId = [[[eventIds lastObject] stringValue] longLongValue];
    }
    
    NSArray *statusTypes = [el elementsForName:@"join_status_type"];
    NSInteger statusType = 0;
    if (statusTypes.count > 0) {
      statusType = [statusTypes.lastObject stringValue].intValue;
    }
    
    NSArray *statusTexts = [el elementsForName:@"join_status_text"];
    NSString *statusText = NULL_PARAM_VALUE;
    if (statusTexts.count > 0) {
      statusText = [statusTexts.lastObject stringValue];
    }
    
    NSArray *likeCounts = [el elementsForName:@"apply_count"];
    NSInteger signUpCount = 0;
    if ([likeCounts count] > 0) {
      signUpCount = [[[likeCounts lastObject] stringValue] intValue];
    }
    
    NSArray *checkinCounts = [el elementsForName:@"checkin_count"];
    NSInteger checkinCount = 0;
    if ([checkinCounts count] > 0) {
      checkinCount = [[[checkinCounts lastObject] stringValue] intValue];
    }
    
    NSArray *intervalDayCounts = [el elementsForName:@"interval_days"];
    NSInteger intervalDayCount = -1;
    if (intervalDayCounts.count > 0) {
      if (![NULL_PARAM_VALUE isEqualToString:[intervalDayCounts.lastObject stringValue]]) {
        intervalDayCount = [intervalDayCounts.lastObject stringValue].intValue;
      }
    }
    
    NSArray *orders = [el elementsForName:@"orders"];
    NSInteger order = 0;
    if ([orders count] > 0) {
      order = [[[orders lastObject] stringValue] intValue];
    }
    
    NSArray *screenTypes = [el elementsForName:@"screen_type"];
    NSInteger screenType = 0;
    if ([screenTypes count] > 0) {
      screenType = [[[screenTypes lastObject] stringValue] intValue];
    }
    
    NSString *hostName = NULL_PARAM_VALUE;
    NSArray *descs = [el elementsForName:@"host_name"];
    if ([descs count] > 0) {
      hostName = [[[descs lastObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *backerCounts = [el elementsForName:@"participation_count"];
    NSInteger backerCount = 0;
    if (backerCounts.count > 0) {
      backerCount = [backerCounts.lastObject stringValue].intValue
      ;    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventId == %lld)", eventId];
    Event *event = (Event *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                        entityName:@"Event"
                                                      sortDescKeys:nil
                                                         predicate:predicate];
    if (event) {
      event.checkinCount = @(checkinCount);
      event.signupCount = @(signUpCount);
      event.intervalDayCount = @(intervalDayCount);
      event.showOrder = @(order);
      event.screenType = @(screenType);
      event.hostName = hostName;
      event.backerCount = @(backerCount);
      event.actionType = @(statusType);
      event.actionStr = statusText;
      continue;
    } else {
      event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:MOC];
    }
    
    event.eventId = @(eventId);
    event.intervalDayCount = @(intervalDayCount);
    event.screenType = @(screenType);
    event.hostName = hostName;
    event.backerCount = @(backerCount);
    event.actionType = @(statusType);
    event.actionStr = statusText;
    
    if (eventId < 0ll) {
      event.fake = @(YES);
      event.intervalDayCount = @(FAKE_EVENT_INTERVAL_DAY);
    } else {
      event.fake = @(NO);
    }
    
    event.showOrder = @(order);
    
    NSArray *status = [el elementsForName:@"status"];
    if ([status count] > 0) {
      event.status = [[[status lastObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *titles = [el elementsForName:@"title"];
    if ([titles count] > 0) {
      event.title = [[[titles lastObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *citys = [el elementsForName:@"city_name"];
    if ([citys count] > 0) {
      event.city = [[[citys lastObject] stringValue] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSArray *urls = [el elementsForName:@"host_id"];
    if ([urls count] > 0) {
      event.hostId = [[urls lastObject] stringValue];
    }
    
    NSArray *imageUrls = [el elementsForName:@"image_url"];
    if (imageUrls.count > 0) {
      event.imageUrl = [imageUrls.lastObject stringValue];
    }
    
    NSArray *dates = [el elementsForName:@"timeInt"];
    if ([dates count] > 0) {
      NSString *datetimeStr = [[dates lastObject] stringValue];
      event.date = datetimeStr;
      
      event.dateCategory = [NSNumber numberWithInt:[self getEventDateCategoryByDatetime:datetimeStr.doubleValue]];
      
    }
    
    event.signupCount = @(signUpCount);
    event.checkinCount = @(checkinCount);
    
  }
     */
}

+ (BOOL)handleFetchEventList:(CXMLDocument *)respDoc MOC:(NSManagedObjectContext *)MOC {
  NSArray *respCodes = [respDoc nodesForXPath:@"//response/code"
                                        error:nil];
  
  if (RESP_OK == [[[respCodes lastObject] stringValue] intValue]) {
    
    NSArray *eventList = [respDoc nodesForXPath:@"//event" error:nil];
    
    [self parserEvent:eventList MOC:MOC];
    
    return SAVE_MOC(MOC);
  } else {
    return NO;
  }
}

+ (Alumni *)prepareForAlumniParserWithElement:(CXMLElement *)el
                                          MOC:(NSManagedObjectContext *)MOC
                               alumniTypeName:(NSString *)alumniTypeName {
  
  NSArray *personIds = [el elementsForName:@"personId"];
  NSString *personId = [[personIds lastObject] stringValue];
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(personId == %@)", personId];
  id alumni = [WXWCoreDataUtils hasSameObjectAlready:MOC
                                     entityName:alumniTypeName
                                   sortDescKeys:nil
                                      predicate:predicate];
  
  if (nil == alumni) {
    alumni = [NSEntityDescription insertNewObjectForEntityForName:alumniTypeName
                                           inManagedObjectContext:MOC];
  }
  
  ((Alumni *)alumni).userId = personId;
  
  return alumni;
}

+ (Alumni *)parserAlumniInfo:(CXMLElement *)el
                    personId:(NSString *)personId
                      alumni:(Alumni *)alumni
                         MOC:(NSManagedObjectContext *)MOC
                    itemType:(NSInteger)itemType
                       index:(int)index {
  
  alumni.userId = personId;
  
  NSArray *userTypes = [el elementsForName:@"user_type"];
  if ([userTypes count] > 0) {
    alumni.userType = [[userTypes lastObject] stringValue];
  }
  if (alumni.userType == nil) {
    alumni.userType = @"1";
  }
  
  alumni.containerType = @(itemType);
  
  NSArray *userIds = [el elementsForName:@"userId"];
  if ([userIds count] > 0) {
    alumni.userId = [[userIds lastObject] stringValue];
  }
  
  NSArray *tableInfos = [el elementsForName:@"table_info"];
  alumni.tableInfo = nil;
  if (tableInfos.count > 0) {
    alumni.tableInfo = [WXWCommonUtils decodeAndReplacePlusForText:[tableInfos.lastObject stringValue]];
  }
  
  NSDate *mDate = nil;
  NSTimeInterval timestamp = 0;
  NSArray *times = [el elementsForName:@"times"];
  if ([times count] > 0) {
    timestamp = [[[times lastObject] stringValue] doubleValue];
    mDate = [WXWCommonUtils convertDateTimeFromUnixTS:timestamp];
    alumni.time = [WXWCommonUtils getElapsedTime:mDate];
  }
  
  NSArray *distances = [el elementsForName:@"distance"];
  if ([distances count] > 0) {
    alumni.distance = [[distances lastObject] stringValue];
  }
  
  NSInteger order = 0;
  NSArray *orders = [el elementsForName:@"orders"];
  if ([orders count] > 0) {
    order = [[[orders lastObject] stringValue] intValue];
    alumni.orderId = @(order);
  } else {
    alumni.orderId = @(index);
  }
  
  NSArray *companyCountryCs = [el elementsForName:@"companyCountryC"];
  if ([companyCountryCs count] > 0) {
    alumni.companyCountryC = [[companyCountryCs lastObject] stringValue];
  }
  
  NSArray *companyCountryEs = [el elementsForName:@"companyCountryE"];
  if ([companyCountryEs count] > 0) {
    alumni.companyCountryE = [[companyCountryEs lastObject] stringValue];
  }
  
  NSArray *isApproves = [el elementsForName:@"is_approve"];
  if ([isApproves count] > 0) {
    alumni.isApprove = [[isApproves lastObject] stringValue];
  }
  
  NSArray *companyProvinces = [el elementsForName:@"companyProvince"];
  if ([companyProvinces count] > 0) {
    alumni.companyProvince = [[companyProvinces lastObject] stringValue];
  }
  
  NSArray *companyCities = [el elementsForName:@"companyCity"];
  if ([companyCities count] > 0) {
    alumni.companyCity = [[companyCities lastObject] stringValue];
  }
  
  NSArray *jobTitles = [el elementsForName:@"jobTitle"];
  if ([jobTitles count] > 0) {
    alumni.jobTitle = [[jobTitles lastObject] stringValue];
  }
  
  NSArray *names = [el elementsForName:@"name"];
  if ([names count] > 0) {
    alumni.userName = [[names lastObject] stringValue];
    if (alumni.userName && alumni.userName.length > 0) {
      alumni.firstNamePinyinChar = [PYMethod firstCharOfNamePinyin:alumni.userName];
    } else {
      alumni.firstNamePinyinChar = @"#";
    }
  }
  
  NSArray *companyNames = [el elementsForName:@"companyName"];
  if ([companyNames count] > 0) {
    alumni.companyName = [[companyNames lastObject] stringValue];
  }
  if (alumni.companyName && alumni.companyName.length == 0) {
    alumni.companyName = NULL_PARAM_VALUE;
  }
  
  NSArray *imageUrls = [el elementsForName:@"imageUrl"];
  if ([imageUrls count] > 0) {
    alumni.imageUrl = [[imageUrls lastObject] stringValue];
  }
  if (alumni.imageUrl && alumni.imageUrl.length == 0) {
    alumni.imageUrl = NULL_PARAM_VALUE;
  }
  
  NSArray *classNames = [el elementsForName:@"class"];
  if ([classNames count] > 0) {
    alumni.classGroupName = [[classNames lastObject] stringValue];
  }
  
  NSArray *companyAddressCs = [el elementsForName:@"companyAddressC"];
  if ([companyAddressCs count] > 0) {
    alumni.companyAddressC = [[companyAddressCs lastObject] stringValue];
  }
  
  NSArray *companyAddressEs = [el elementsForName:@"companyAddressE"];
  if ([companyAddressEs count] > 0) {
    alumni.companyAddressE = [[companyAddressEs lastObject] stringValue];
  }
  
  NSArray *companyPhones = [el elementsForName:@"companyPhone"];
  if ([companyPhones count] > 0) {
    alumni.companyPhone = [[companyPhones lastObject] stringValue];
  }
  if (alumni.companyPhone == nil) {
    alumni.companyPhone = NULL_PARAM_VALUE;
  }
  
  NSArray *companyFaxs = [el elementsForName:@"companyFax"];
  if ([companyFaxs count] > 0) {
    alumni.companyFax = [[companyFaxs lastObject] stringValue];
  }
  
  NSArray *emails = [el elementsForName:@"email"];
  if ([emails count] > 0) {
    alumni.email = [[emails lastObject] stringValue];
  }
  if (alumni.email == nil) {
    alumni.email = NULL_PARAM_VALUE;
  }
  
  NSArray *phones = [el elementsForName:@"mobile"];
  if ([phones count] > 0) {
    alumni.mobile = [[phones lastObject] stringValue];
  }
  if (nil == alumni.mobile) {
    alumni.mobile = NULL_PARAM_VALUE;
  }
  
  BOOL isCheck;
  NSArray *isChecks = [el elementsForName:@"is_check"];
  if ([isChecks count] > 0) {
    isCheck = ([[[isChecks lastObject] stringValue] intValue] == 1) ? YES : NO;
    alumni.isCheckIn = @(isCheck);
  }
  
  NSArray *plats = [el elementsForName:@"plat"];
  if ([plats count] > 0) {
    alumni.plat = [[plats lastObject] stringValue];
  }
  if (nil == alumni.email) {
    alumni.plat = NULL_PARAM_VALUE;
  }
  
  NSArray *versions = [el elementsForName:@"version"];
  if ([versions count] > 0) {
    alumni.version = [[versions lastObject] stringValue];
  }
  if (nil == alumni.version) {
    alumni.version = NULL_PARAM_VALUE;
  }
  
  NSArray *shakePlaces = [el elementsForName:@"shake_where"];
  if ([shakePlaces count] > 0) {
    alumni.shakePlace = [[shakePlaces lastObject] stringValue];
  }
  if (nil == alumni.shakePlace) {
    alumni.shakePlace = NULL_PARAM_VALUE;
  }
  
  NSArray *shakeThings = [el elementsForName:@"shake_what"];
  if ([shakeThings count] > 0) {
    alumni.shakeThing = [[shakeThings lastObject] stringValue];
  }
  if (nil == alumni.shakeThing) {
    alumni.shakeThing = NULL_PARAM_VALUE;
  }
  
  NSArray *lastMsg = [el elementsForName:@"last_message"];
  if ([lastMsg count] > 0) {
    alumni.lastMsg = [[lastMsg lastObject] stringValue];
  }
  if (nil == alumni.lastMsg) {
    alumni.lastMsg = NULL_PARAM_VALUE;
  }
  
  NSArray *notReadMsgCount = [el elementsForName:@"not_read_count"];
  if ([notReadMsgCount count] > 0) {
    order = [[[notReadMsgCount lastObject] stringValue] intValue];
    alumni.notReadMsgCount = @(order);
  }
  if (nil == alumni.notReadMsgCount) {
    alumni.notReadMsgCount = @0;
  }
  
  NSArray *isLastMessageFromSelf = [el elementsForName:@"is_last_message_from_self"];
  if ([isLastMessageFromSelf count] > 0) {
    order = [[[isLastMessageFromSelf lastObject] stringValue] intValue];
    alumni.isLastMessageFromSelf = @(order);
  }
  if (nil == alumni.isLastMessageFromSelf) {
    alumni.isLastMessageFromSelf = @0;
  }
  
  NSArray *latitudes = [el elementsForName:@"latitude"];
  if ([latitudes count] > 0) {
    alumni.latitude = [[latitudes lastObject] stringValue];
  }
  if (nil == alumni.latitude) {
    alumni.latitude = NULL_PARAM_VALUE;
  }
  
  NSArray *longitudes = [el elementsForName:@"longitude"];
  if ([longitudes count] > 0) {
    alumni.longitude = [[longitudes lastObject] stringValue];
  }
  if (nil == alumni.longitude) {
    alumni.longitude = NULL_PARAM_VALUE;
  }
  
  NSArray *memberLevels = [el elementsForName:@"member_level"];
  if ([memberLevels count] > 0) {
    alumni.memberLevel = [[memberLevels lastObject] stringValue];
  }
  if (nil == alumni.memberLevel) {
    alumni.memberLevel = NULL_PARAM_VALUE;
  }
  
  NSArray *hasApplieds = [el elementsForName:@"has_applied"];
  if ([hasApplieds count] > 0) {
    alumni.hasApplied = [[hasApplieds lastObject] stringValue];
  }
  if (nil == alumni.hasApplied) {
    alumni.hasApplied = @"0";
  }
  
  NSArray *feeToPays = [el elementsForName:@"fee_to_pay"];
  if ([feeToPays count] > 0) {
    alumni.feeToPay = [[feeToPays lastObject] stringValue];
  }
  if (nil == alumni.feeToPay) {
    alumni.feeToPay = NULL_PARAM_VALUE;
  }
  
  NSArray *feePaids = [el elementsForName:@"fee_paid"];
  if ([feePaids count] > 0) {
    alumni.feePaid = [[feePaids lastObject] stringValue];
  }
  if (nil == alumni.feePaid) {
    alumni.feePaid = NULL_PARAM_VALUE;
  }
  
  return alumni;
}

#pragma mark - favorite
+ (BOOL)handleFavoriteItem:(CXMLDocument *)respDoc {
    
    if ([self parserResponseCode:respDoc] == HTTP_RESP_OK) {
        return YES;
    } else {
        return NO;
    }
}

@end
