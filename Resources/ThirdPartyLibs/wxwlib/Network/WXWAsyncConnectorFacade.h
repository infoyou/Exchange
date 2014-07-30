//
//  WXWAsyncConnectorFacade.h
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWConnector.h"

@interface WXWAsyncConnectorFacade : WXWConnector {
  
}

- (NSMutableData *)assembleContentData:(NSDictionary *)dic
                                 photo:(UIImage *)photo
                          originalData:(NSMutableData *)originalData;

- (void)uploadItem:(NSString*)url dic:(NSDictionary *)dic photo:(UIImage *)photo;
- (void)uploadImage:(UIImage *)image url:(NSString *)url dic:(NSDictionary *)dic;

#pragma mark - fetch host
- (void)fetchHost:(NSString *)url;

#pragma mark - user
- (void)verifyUser:(NSString *)url showAlertMsg:(BOOL)showAlertMsg;
- (void)fetchUserInfoFromLinkedin:(NSString *)url;
- (void)fetchUserProfile:(NSString *)url;
- (void)confirmBindLinkedin:(NSString *)url;

#pragma mark - load image
- (void)fetchImage:(NSString *)url;

#pragma mark - hot news
- (void)fetchNews:(NSString *)url;

#pragma mark - load comment
- (void)fetchComments:(NSString *)url;

#pragma mark - like action
- (void)likeItem:(NSString *)url;

#pragma mark - check in action
- (void)checkin:(NSString *)url;

#pragma mark - favorite action
- (void)favoriteItem:(NSString *)url;

#pragma mark - modify User Icon
- (void)modifyUserIcon:(UIImage *)photo;

#pragma mark - upload post

- (void)sendPost:(NSString *)content
         groupId:(NSString *)groupId
          tagIds:(NSString *)tagIds
         placeId:(NSString *)placeId
       placeName:(NSString *)placeName
          cityId:(long long)cityId
           photo:(UIImage *)photo;
/*
- (void)sendEventDiscuss:(NSString *)content
                   photo:(UIImage *)photo
                  hasSMS:(NSString *)hasSMS
                 eventId:(NSString *)eventId;
*/
#pragma mark - upload share
- (void)sendPost:(NSString *)content
          tagIds:(NSString *)tagIds
       placeName:(NSString *)placeName
           photo:(UIImage *)photo
        postType:(NSInteger)postType
         groupId:(NSString *)groupId;

#pragma mark - send chart
- (void)sendChat:(NSString *)content;

#pragma mark - load place
- (void)fetchPlaces:(NSString *)url;

#pragma mark - load country
- (void)fetchCountries:(NSString *)url;

#pragma mark - fetch current city
- (void)fetchCurrentCity:(NSString *)url;

#pragma mark - load feeds
- (void)fetchFeeds:(NSString *)url;

#pragma mark - load questions
- (void)fetchQuestions:(NSString *)url;

#pragma mark - delete feed
- (void)deleteFeeds:(NSString *)url;

#pragma mark - delete comment
- (void)deleteComment:(NSString *)url;

#pragma mark - delete question
- (void)deleteQuestion:(NSString *)url;

#pragma mark - load liker list
- (void)fetchLikers:(NSString *)url;

#pragma mark - load checked in alumnus
- (void)fetchCheckedinAlumnus:(NSString *)url;

#pragma mark - load sns friends
- (void)fetchSNSFriends:(NSString *)url;

#pragma mark - invite friends
- (void)inviteByAddressbookPhoneNumbers:(NSString *)phoneNumbers;
- (void)inviteByAddressbookEmails:(NSString *)emails;
- (void)inviteByAddressbookEmails:(NSString *)emails phoneNumbers:(NSString *)phoneNumbers;

/*
#pragma mark - invite linkedin friends
- (void)inviteLinkedinFriends:(NSString *)userIds;
*/
#pragma mark - update user's nationality
- (void)updateUserNationality:(long long)countryId;

#pragma mark - update user's photo
- (void)updateUserPhoto:(UIImage *)photo;

#pragma mark - upload service item, provider comment
- (void)sendServiceItemComment:(NSString *)content
                        itemId:(NSString *)itemId
                       brandId:(NSString *)brandId;

- (void)sendBrandComment:(NSString *)content
                 brandId:(NSString *)brandId;

- (void)sendServiceProviderComment:(NSString *)content
                        providerId:(NSString *)providerId;

#pragma mark - check address book contacts join status
- (void)checkABContactsJoinStatus:(NSString *)emails;

#pragma mark - update username
- (void)updateUserUsername:(NSString *)username;

#pragma mark - update years of user living China
- (void)updateUserLivingYears:(NSString *)years;

#pragma mark - update user's city
- (void)updateUserLivingCity:(long long)cityId;

#pragma mark - load nearby groups
- (void)fetchNearbyGroups:(NSString *)url;

#pragma mark - recommended items for nearby service
- (void)fetchRecommendedItems:(NSString *)url;

#pragma mark - load nearby items
- (void)fetchNearbyItems:(NSString *)url;

#pragma mark - add photo for service item and provider
- (void)addPhotoForServiceItem:(UIImage *)photo
                        itemId:(long long)itemId
                       caption:(NSString *)caption;

- (void)addPhotoForServiceProvider:(UIImage *)photo
                        providerId:(long long)providerId
                           caption:(NSString *)caption;

#pragma mark - load album photo
- (void)fetchAlbumPhoto:(NSString *)url;

#pragma mark - load user meta data
- (void)fetchUserMetaData:(NSString *)url;

#pragma mark - load nearby item detail
- (void)fetchNearbyItemDetail:(NSString *)url;

- (void)fetchGets:(NSString *)url;

- (void)postCommonInfoDic:(NSDictionary *)infoDic url:(NSString *)url;

@end
