//
//  WXWAsyncConnectorFacade.m
//  Project
//
//  Created by ; on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWAsyncConnectorFacade.h"
#import "WXWSystemInfoManager.h"
#import "WXWConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"

@implementation WXWAsyncConnectorFacade

#pragma mark - fetch host
- (void)fetchHost:(NSString *)url {
  // not show alert message avoid the warning be displayed in startup view
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - user
- (void)verifyUser:(NSString *)url showAlertMsg:(BOOL)showAlertMsg {
  [self asyncGet:url showAlertMsg:showAlertMsg];
}

- (void)fetchUserProfile:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

- (void)fetchUserInfoFromLinkedin:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

- (void)confirmBindLinkedin:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load image
- (void)fetchImage:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - hot news
- (void)fetchNews:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - load comment
- (void)fetchComments:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - like action
- (void)likeItem:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - check in action
- (void)checkin:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - favorite action
- (void)favoriteItem:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - upload post

- (NSMutableData *)assembleContentData:(NSDictionary *)dic
                                 photo:(UIImage *)photo
                          originalData:(NSMutableData *)originalData {
  NSString *param = [WXWCommonUtils convertParaToHttpBodyStr:dic];
  
  if (nil != photo) {
    // format the pic as parameter
		param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", WXW_FORM_BOUNDARY]];
		param = [param stringByAppendingString:@"Content-Disposition:form-data; name=\"attach\"; filename=\"pic.jpg\"; Content-Type:application/octet-stream\r\n\r\n"];
  }
  
  [originalData appendData:[param dataUsingEncoding:NSUTF8StringEncoding
                               allowLossyConversion:YES]];
  
  if (nil != photo) {
    // add pic data into parameter
		NSData *jpgPic = UIImageJPEGRepresentation(photo, 0.8);
		[originalData appendData:jpgPic];
  }
  
  // append footer
	NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", WXW_FORM_BOUNDARY];
	[originalData appendData:[footer dataUsingEncoding:NSUTF8StringEncoding
                                allowLossyConversion:YES]];
  /*
  if (WXW_DEBUG) {
    NSLog(@"params: %@", [[[NSString alloc] initWithData:originalData encoding:NSUTF8StringEncoding] autorelease]);
  }
   */
#ifdef DEBUG
  NSLog(@"params: %@", [[[NSString alloc] initWithData:originalData encoding:NSUTF8StringEncoding] autorelease]);
#endif
  return originalData;
}

- (NSMutableData *)assembleImageContentData:(NSDictionary *)dic
                                      photo:(UIImage *)photo
                               originalData:(NSMutableData *)originalData {
    
    NSString *param = [WXWCommonUtils convertParaToHttpBodyStr:dic];
    
    if (nil != photo) {
        // format the pic as parameter
		param = [param stringByAppendingString:[NSString stringWithFormat:@"--%@\r\n", WXW_FORM_BOUNDARY]];
		param = [param stringByAppendingString:@"Content-Disposition:form-data; name=\"attach\"; filename=\"pic.jpg\"; Content-Type:application/octet-stream\r\n\r\n"];
    }
    
    [originalData appendData:[param dataUsingEncoding:NSUTF8StringEncoding
                                 allowLossyConversion:YES]];
    
    if (nil != photo) {
        // add pic data into parameter
		NSData *jpgPic = UIImageJPEGRepresentation(photo, 0.8);
		[originalData appendData:jpgPic];
    }
    
    // append footer
	NSString *footer = [NSString stringWithFormat:@"\r\n--%@--\r\n", WXW_FORM_BOUNDARY];
	[originalData appendData:[footer dataUsingEncoding:NSUTF8StringEncoding
                                  allowLossyConversion:YES]];
    
#ifdef DEBUG
    NSLog(@"params: %@", [[[NSString alloc] initWithData:originalData encoding:NSUTF8StringEncoding] autorelease]);
#endif
    return originalData;
}

- (void)uploadImage:(UIImage *)image url:(NSString *)url dic:(NSDictionary *)dic {
    [self postImageWithUrl:url
                      data:[self assembleImageContentData:dic
                                                    photo:image
                                             originalData:[NSMutableData data]]];
}

- (void)uploadItem:(NSString*)url dic:(NSDictionary *)dic photo:(UIImage *)photo {
  
  NSMutableData *contentData = [NSMutableData data];
  
  [self post:url
        data:[self assembleContentData:dic
                                 photo:photo
                          originalData:contentData]];
}

- (void)uploadItem:(NSDictionary *)dic photo:(UIImage *)photo {
  
  NSMutableData *contentData = [NSMutableData data];
  
  [self post:[WXWCommonUtils assembleUrl:nil]
        data:[self assembleContentData:dic
                                 photo:photo
                          originalData:contentData]];
}

- (void)sendPost:(NSString *)content
         groupId:(NSString *)groupId
          tagIds:(NSString *)tagIds
         placeId:(NSString *)placeId
       placeName:(NSString *)placeName
          cityId:(long long)cityId
           photo:(UIImage *)photo {
  
  NSDictionary *dic = nil;
  if ([WXWSystemInfoManager instance].latitude == 0 && [WXWSystemInfoManager instance].longitude == 0) {
    dic = @{@"action": @"submit_post",
           @"plat": PLATFORM,
           @"session": [WXWSystemInfoManager instance].sessionId,
           @"version": VERSION,
           @"user_id": [WXWSystemInfoManager instance].personId,
           @"group_id": groupId,
           @"text": content,
           @"city_id": LLINT_TO_STRING([WXWSystemInfoManager instance].cityId),
           @"is_suggest": @"0",
           @"locationType": @"3",
           @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
           @"tag_ids": tagIds};
    
  } else {
    
    if (nil != placeId && placeId.length > 0 && nil != placeName && placeName.length > 0) {
      // user selects a specified nearby place
      dic = @{@"action": @"submit_post",
             @"plat": PLATFORM,
             @"session": [WXWSystemInfoManager instance].sessionId,
             @"version": VERSION,
             @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
             @"group_id": groupId,
             @"city_id": LLINT_TO_STRING([WXWSystemInfoManager instance].cityId),
             @"is_suggest": @"0",
             @"locationType": @"3",
             @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
             @"tag_ids": tagIds,
             @"text": content,
             @"place_id": placeId,
             @"place_address": placeName,
             @"lat": DOUBLE_TO_STRING([WXWSystemInfoManager instance].latitude),
             @"long": DOUBLE_TO_STRING([WXWSystemInfoManager instance].longitude)};
      
    } else {
      // although location detected, user does not select a specified nearby place
      dic = @{@"action": @"submit_post",
             @"plat": PLATFORM,
             @"session": [WXWSystemInfoManager instance].sessionId,
             @"version": VERSION,
             @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
             @"group_id": groupId,
             @"city_id": LLINT_TO_STRING([WXWSystemInfoManager instance].cityId),
             @"is_suggest": @"0",
             @"locationType": @"3",
             @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
             @"tag_ids": tagIds,
             @"text": content};
    }
    
  }
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL]
               dic:dic
             photo:photo];
}

#pragma mark - upload post
/*
- (void)sendPostForGroup:(Club *)group
                   content:(NSString *)content
                   photo:(UIImage *)photo {
  
  NSString *hostType = NULL_PARAM_VALUE;
  if (group.hostTypeValue && group.hostTypeValue.length > 0) {
    hostType = group.hostTypeValue;
  }
  
  NSString *groupId = [NSString stringWithFormat:@"%@", group.clubId];
  
  NSDictionary *dic = @{@"action": @"submit_post",
  @"plat": PLATFORM,
  @"type_id": group.clubType,
  @"item_id": groupId,
  @"session": [WXWSystemInfoManager instance].sessionId,
  @"version": VERSION,
  @"user_id": [WXWSystemInfoManager instance].personId,
  @"user_name": [WXWSystemInfoManager instance].username,
  @"user_type": [WXWSystemInfoManager instance].userType,
  @"host_id": groupId,
  @"message": content,
  @"latitude": NULL_PARAM_VALUE,
  @"longitude": NULL_PARAM_VALUE};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL]
               dic:dic
             photo:photo];
}


- (void)sendPost:(NSString *)content
           photo:(UIImage *)photo
          hasSms:(NSString *)hasSms
{
  
  NSDictionary *dic = @{@"action": @"submit_post",
                       @"plat": PLATFORM,
                       @"type_id": NULL_PARAM_VALUE,
                       @"item_id": NULL_PARAM_VALUE,
                       @"is_sms_inform": hasSms,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": [WXWSystemInfoManager instance].personId,
                       @"user_name": [WXWSystemInfoManager instance].username,
                       @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType),
  @"host_id": @"0",//[WXWSystemInfoManager instance].clubId,
  @"host_type": @"0",//[WXWSystemInfoManager instance].hostTypeValue,
                       @"message": content,
                       @"latitude": NULL_PARAM_VALUE,
                       @"longitude": NULL_PARAM_VALUE};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL]
               dic:dic
             photo:photo];
}

- (void)sendEventDiscuss:(NSString *)content
                   photo:(UIImage *)photo
                  hasSMS:(NSString *)hasSMS
                 eventId:(NSString *)eventId {
  
  NSDictionary *dic = @{@"action": @"submit_post",
                       @"plat": PLATFORM,
                       @"type_id": [NSString stringWithFormat:@"%d", EVENT_DISCUSS_POST_TY],
                       @"item_id": eventId,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"is_sms_inform": hasSMS,
                       @"user_id": [WXWSystemInfoManager instance].personId,
                       @"user_name": [WXWSystemInfoManager instance].username,
                       @"user_type": [WXWSystemInfoManager instance].userType,
                       @"message": content};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL]
               dic:dic
             photo:photo];
}
 */

- (void)sendChat:(NSString *)content{
  
  NSDictionary *dic = @{@"ReqContent": content};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, CHART_SUBMIT_URL]
               dic:dic
             photo:nil];
}

#pragma mark - upload share
- (void)sendPost:(NSString *)content
          tagIds:(NSString *)tagIds
       placeName:(NSString *)placeName
           photo:(UIImage *)photo
        postType:(NSInteger)postType
         groupId:(NSString *)groupId
{
  
  NSDictionary *dic = nil;

  if ([WXWSystemInfoManager instance].latitude == 0 && [WXWSystemInfoManager instance].longitude == 0) {
    dic = @{@"action": @"submit_post",
           @"plat": PLATFORM,
           @"item_id": groupId,
           @"host_id": groupId,
           @"tag_ids": tagIds,
           @"type_id": INT_TO_STRING(postType),
           @"session": [WXWSystemInfoManager instance].sessionId,
           @"version": VERSION,
           @"user_id": [WXWSystemInfoManager instance].personId,
           @"user_name": [WXWSystemInfoManager instance].username,
           @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType),
           @"message": content};
    
  } else {
    
    if (placeName.length > 0) {
      
      dic = @{@"action": @"submit_post",
             @"plat": PLATFORM,
             @"item_id": groupId,
             @"host_id": groupId,
             @"place": placeName,
             @"tag_ids": tagIds,
             @"type_id": INT_TO_STRING(postType),
             @"session": [WXWSystemInfoManager instance].sessionId,
             @"version": VERSION,
             @"user_id": [WXWSystemInfoManager instance].personId,
             @"user_name": [WXWSystemInfoManager instance].username,
             @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType),
             @"message": content,
             @"latitude": DOUBLE_TO_STRING([WXWSystemInfoManager instance].latitude),
             @"longitude": DOUBLE_TO_STRING([WXWSystemInfoManager instance].longitude)};
    } else {
      
      dic = @{@"action": @"submit_post",
             @"plat": PLATFORM,
             @"item_id": groupId,
             @"host_id": groupId,
             @"tag_ids": tagIds,
             @"type_id": INT_TO_STRING(postType),
             @"session": [WXWSystemInfoManager instance].sessionId,
             @"version": VERSION,
             @"user_id": [WXWSystemInfoManager instance].personId,
             @"user_name": [WXWSystemInfoManager instance].username,
             @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType),
             @"message": content};
    }
  }
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",
                    [WXWSystemInfoManager instance].hostUrl,
                    POST_METHOD_URL]
               dic:dic
             photo:photo];
}

/*
#pragma mark - upload comment
- (void)sendComment:(NSString *)content
     originalItemId:(NSString *)originalItemId
              photo:(UIImage *)photo {
  
  if (nil == originalItemId || [originalItemId length] == 0) {
    return;
  }
  
  NSString *clubId = @"0";// DEBUG [WXWSystemInfoManager instance].clubId;
  if (nil == clubId) {
    clubId = NULL_PARAM_VALUE;
  }
  
  NSString *clubType = @"0";// DEBUG [WXWSystemInfoManager instance].hostTypeValue;
  if (nil == clubType) {
    clubType = NULL_PARAM_VALUE;
  }
  
  NSDictionary *dic = nil;
  dic = @{@"action": @"submit_post_comment",
         @"plat": PLATFORM,
         @"type_id": NULL_PARAM_VALUE,
         @"post_id": originalItemId,
         @"session": [WXWSystemInfoManager instance].sessionId,
         @"version": VERSION,
         @"user_id": [WXWSystemInfoManager instance].personId,
         @"user_name": [WXWSystemInfoManager instance].username,
         @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType),
         @"host_id": clubId,
         @"host_type": clubType,
         @"message": content,
         @"latitude": DOUBLE_TO_STRING([WXWSystemInfoManager instance].latitude),
         @"longitude": DOUBLE_TO_STRING([WXWSystemInfoManager instance].longitude)};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:photo];
}
*/

#pragma mark - modify User Icon
- (void)modifyUserIcon:(UIImage *)photo {
  
  NSDictionary *dic = @{@"action": @"submit_wap_user_avatar",
                       @"plat": PLATFORM,
                       @"locale": [WXWSystemInfoManager instance].currentLanguageDesc,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"person_id": [WXWSystemInfoManager instance].personId,
                       @"user_name": [WXWSystemInfoManager instance].username,
                       @"user_type": INT_TO_STRING([WXWSystemInfoManager instance].userType)};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:photo];
}

#pragma mark - upload brand, service item, provider comment
- (void)sendServiceItemComment:(NSString *)content
                        itemId:(NSString *)itemId
                       brandId:(NSString *)brandId {
  
  if (nil == itemId || [itemId length] == 0) {
    return;
  }
  
  NSDictionary *dic = @{@"action": @"service_comment_submit",
                       @"plat": PLATFORM,
                       @"version": VERSION,
                       @"user_name": [WXWSystemInfoManager instance].username,
                       @"person_id": [WXWSystemInfoManager instance].personId,
                       @"service_id": itemId,
                       @"channel_id": brandId,
                       @"message": content,
                       @"locale": [WXWSystemInfoManager instance].currentLanguageDesc};
  [self uploadItem:dic photo:nil];
}

- (void)sendBrandComment:(NSString *)content
                 brandId:(NSString *)brandId {
  
  if (nil == brandId || [brandId length] == 0) {
    return;
  }
  
  NSDictionary *dic = @{@"action": @"service_comment_submit",
                       @"plat": PLATFORM,
                       @"version": VERSION,
                       @"user_name": [WXWSystemInfoManager instance].username,
                       @"person_id": [WXWSystemInfoManager instance].personId,
                       @"channel_id": brandId,
                       @"message": content,
                       @"locale": [WXWSystemInfoManager instance].currentLanguageDesc};
  [self uploadItem:dic photo:nil];
}

- (void)sendServiceProviderComment:(NSString *)content
                        providerId:(NSString *)providerId {
  
  if (nil == providerId || providerId.length == 0) {
    return;
  }
  
  NSDictionary *dic = @{@"action": @"service_provider_comment_submit",
                       @"plat": PLATFORM,
                       @"session": NULL_PARAM_VALUE,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"service_provider_id": providerId,
                       @"message": content,
                       @"locale": [WXWSystemInfoManager instance].currentLanguageDesc};
  [self uploadItem:dic photo:nil];
}

#pragma mark - check address book contacts join status
- (void)checkABContactsJoinStatus:(NSString *)emails {
  NSDictionary *dic = @{@"action": @"user_exist_check_email",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"emails": emails,
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc};
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

#pragma mark - load place
- (void)fetchPlaces:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load country
- (void)fetchCountries:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - fetch current city
- (void)fetchCurrentCity:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - load feeds
- (void)fetchFeeds:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - load questions
- (void)fetchQuestions:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

#pragma mark - delete feed
- (void)deleteFeeds:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - delete comment
- (void)deleteComment:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - delete question
- (void)deleteQuestion:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load liker list
- (void)fetchLikers:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load checked in alumnus
- (void)fetchCheckedinAlumnus:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load sns friends
- (void)fetchSNSFriends:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - invite address book friends
- (void)inviteByAddressbookPhoneNumbers:(NSString *)phoneNumbers {
  NSDictionary *dic = nil;
  
  dic = @{@"action": @"invite_friends",
         @"plat": PLATFORM,
         @"version": VERSION,
         @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
         @"mobile": phoneNumbers};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

- (void)inviteByAddressbookEmails:(NSString *)emails {
  NSDictionary *dic = nil;
  
  dic = @{@"action": @"invite_friends",
         @"plat": PLATFORM,
         @"version": VERSION,
         @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
         @"email": emails};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

- (void)inviteByAddressbookEmails:(NSString *)emails phoneNumbers:(NSString *)phoneNumbers {
  NSDictionary *dic = nil;
  
  dic = @{@"action": @"invite_friends",
         @"plat": PLATFORM,
         @"version": VERSION,
         @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
         @"email": emails,
         @"mobile": phoneNumbers};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

/*
#pragma mark - invite linkedin friends
- (void)inviteLinkedinFriends:(NSString *)userIds {
  NSDictionary *dic = nil;
  
  dic = @{@"action": @"user_message",
         @"plat": PLATFORM,
         @"version": VERSION,
         @"user_id": [WXWSystemInfoManager instance].userId,
         @"linkedinid": userIds};
  
  [self uploadItem:dic photo:nil snsType:LINKEDIN_DOMAIN_TY];
}
 */

#pragma mark - update user's nationality
- (void)updateUserNationality:(long long)countryId {
  NSDictionary *dic = @{@"action": @"user_info_update",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
                       @"country_id": LLINT_TO_STRING(countryId)};
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

#pragma mark - update user's photo
- (void)updateUserPhoto:(UIImage *)photo {
  NSDictionary *dic = @{@"action": @"user_info_update",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:photo];
}

#pragma mark - update years of user living China
- (void)updateUserLivingYears:(NSString *)years {
  NSDictionary *dic = @{@"action": @"user_info_update",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
                       @"living_years": years};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

#pragma mark - update user's city
- (void)updateUserLivingCity:(long long)cityId {
  NSDictionary *dic = @{@"action": @"user_info_update",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
                       @"city_id": LLINT_TO_STRING(cityId)};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

#pragma mark - update username
- (void)updateUserUsername:(NSString *)username {
  NSDictionary *dic = @{@"action": @"user_info_update",
                       @"plat": PLATFORM,
                       @"session": [WXWSystemInfoManager instance].sessionId,
                       @"version": VERSION,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc,
                       @"user_name": username};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL] dic:dic photo:nil];
}

#pragma mark - add photo for service item and provider
- (void)addPhotoForServiceItem:(UIImage *)photo
                        itemId:(long long)itemId
                       caption:(NSString *)caption {
  NSDictionary *dic = @{@"action": @"service_photo_submit",
                       @"plat": PLATFORM,
                       @"session": NULL_PARAM_VALUE,
                       @"person_id": [WXWSystemInfoManager instance].personId,
                       @"version": VERSION,
                       @"service_id": [NSString stringWithFormat:@"%lld", itemId],
                       @"message": caption,
                       @"locale": [WXWSystemInfoManager instance].currentLanguageDesc};
  
  [self uploadItem:[NSString stringWithFormat:@"%@%@",[WXWSystemInfoManager instance].hostUrl, POST_METHOD_URL]
               dic:dic
             photo:photo];
}

- (void)addPhotoForServiceProvider:(UIImage *)photo
                        providerId:(long long)providerId
                           caption:(NSString *)caption {
  
  NSDictionary *dic = @{@"action": @"service_provider_photo_submit",
                       @"plat": PLATFORM,
                       @"session": NULL_PARAM_VALUE,
                       @"user_id": LLINT_TO_STRING([WXWSystemInfoManager instance].userId),
                       @"version": VERSION,
                       @"service_provider_id": LLINT_TO_STRING(providerId),
                       @"message": caption,
                       @"lang": [WXWSystemInfoManager instance].currentLanguageDesc};
  
  [self uploadItem:dic photo:photo];
}

#pragma mark - load nearby groups
- (void)fetchNearbyGroups:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - recommended items for nearby service
- (void)fetchRecommendedItems:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load nearby items
- (void)fetchNearbyItems:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load album photo
- (void)fetchAlbumPhoto:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load user meta data
- (void)fetchUserMetaData:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - load nearby item detail
- (void)fetchNearbyItemDetail:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - get & show
- (void)fetchGets:(NSString *)url {
  [self asyncGet:url showAlertMsg:YES];
}

#pragma mark - get whithout alert
- (void)fetchGetsWithoutAlert:(NSString *)url {
  [self asyncGet:url showAlertMsg:NO];
}

- (void)postCommonInfoDic:(NSDictionary *)infoDic url:(NSString *)url {
    [self post:url data:[[CommonUtils geneJSON:infoDic] dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
