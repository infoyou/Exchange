//
//  GoHighDBManager.h
//  Project
//
//  Created by XXX on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoHighChatCache.h"
#import "UserCache.h"
#import "CourseInfoCache.h"
#import "ChapterListInfoCache.h"
#import "CourseDetailList.h"
#import "CourseListCache.h"
#import "InformationImageWallCache.h"
#import "CommunicateGroupListCache.h"

#define INFORMATION_SHARE_WEIXIN_KEY   @"informationShareWeixinKey"

@interface GoHighDBManager : NSObject

+ (GoHighDBManager *)instance;


//------------ chat db------------
- (void)insertChatIntoDB:(QPlusMessage *)message groupId:(NSString *)groupId isRead:(int)read;
- (ChatModel *)getGroupLastMessage:(NSString *)groupId;
- (ChatModel *)getPrivateLastMessage:(NSString *)friendId userId:(NSString *)userId;

- (int)getVoiceMessageListened:(QPlusMessage *)message;
- (int)getGroupNewMessageCount:(NSString *)groupId userId:(NSString *)userId;
- (int)getPrivateNewMessageCount:(NSString *)friendId userId:(NSString *)userId;
- (int)getGroupIsDeleted:(NSString *)groupId;


- (void)setVoiceMessageListened:(QPlusMessage *)messsage;
- (void)setGroupMessageReaded:(NSString *)groupId;
- (void)setPrivateMessageReaded:(NSString *)friendId;
- (void)setGroupDeleted:(NSString *)groupId;


//------------ user db------------
- (void)upinsertUserIntoDB:(UserBaseInfo *)userInfo timestamp:(double)timestamp;
- (void)upinsertUserProfile:(UserProfile *)userProfile;
- (UserBaseInfo *)getUserInfoFromDB:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId;
- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId;
- (int)getGroupCountByUserId:(int)userId;
- (int)isFriend:(int)userId;
-(void)updateIsFriend:(NSArray *)array;
-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend;
- (NSMutableArray *)getAllUserInfoFromDB;
- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword;
- (double)getLatestUserTimestamp;

//-----------------courseinfo ---------------------
- (double)getLatestCourseInfoTime:(int)courseId;
- (void)updateCourseDetailList:(CourseDetailList *)detail;
- (void)updateChapterDownloaded:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC;
- (void)upinsertCourseDetail:(NSArray *)courseDetail isMyCourse:(int)isMyCourse;
- (NSArray *)getMyCourse;

//------------------courseListInfo--------------

- (void)updateCourse:(int)courseID categoryId:(int)categoryId;
- (void)upinsertCourses:(NSArray *)courses isMyCourse:(int)isMyCourse categoryId:(int)categoryId;
- (NSArray *)getMyCourseListInMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId;
- (BOOL)isMyCourseByCourseId:(int)courseId categoryId:(int)categoryId;

//-----------------chapterListInfo-------------
- (CourseDetailList *)getCourseDetailByCourseId:(int)courseId withCourseDetailList:(CourseDetailList *)detail;
- (NSMutableArray *)getAllDownloadingCourseDetail:(NSManagedObjectContext *)MOC;
- (NSMutableArray *)getAllDownloadedCourseDetail:(NSManagedObjectContext *)MOC;
- (void)updateCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC;
- (void)deleteChapterWithChapterId:(int)chapterId courseId:(int)courseId;

- (BOOL)isDownloading:(int)courseId withChapterId:(int)chapterId;
- (BOOL)isDownloaded:(int)courseId withChapterId:(int)chapterId;

-(void)resetDownloadInfo:(int)courseId withChapterId:(int)chapterId;

- (void)updateChapterDownloaded:(int)courseId withChapterId:(int)chapterId isDownloaded:(int)downloaded;
- (void)updateChapterPercentage:(int)courseId withChapterId:(int)chapterId percentage:(double)percentage  fileDownloadedSize:(double)fileDownloadedSize fileSize:(double)fileSize;

//---------------business category
-(void)upinsertBusinessCategories:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;
-(double)getLatestBusinessCategoryTime;

//----------------businessItemDetailInfo
- (double)getLatestBusinessDetailInfoTime:(int)projectId;
- (void)upinsertBusinessDetails:(NSDictionary *)contentDic timestamp:(NSString *)timestamp categoryID:(int)categoryID MOC:(NSManagedObjectContext *)MOC;


//----------------business detail image
- (void)upinsertBusinessDetailImages:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;
- (double)getLatestBusinessDetailImageTime:(int)projectId;


//---------------information image wall
- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestInfoImageWallTime;


//--------------information list
- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestInfomationTimestamp;
-(double)getOldestInfomationTimestamp;
-(void)deleteOldInfomationFromTimestamp:(NSString *)timestamp;

- (void)updateInformationCommentCount:(int)infoId count:(int)count;
-(void)updateInformationCommentReader:(int)infoId count:(int)count;

- (int)getInformationCommentCount:(int)infoId;
-(int)getInformationCommentReader:(int)infoId;
//---------------AloneMarketing
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestAloneMarketingTime;


//--------------Circlemarketing
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestCircleMarketingTime:(int)type;

//--------------communicate group list
-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC;
-(double)getLatestCommunicateGroupListTime;
-(void)deleteGroup:(int)groupId;
-(void)deleteAllGroupListData;


//--------------common table
- (void)upinsertCommonTable:(NSString *)key value:(NSString *)value;
- (NSString*)getCommon:(NSString *)key;

//--------------drop tables
- (void)dropTables:(NSArray *)table;
-(void)deleteEntity:(NSArray *)entities MOC:(NSManagedObjectContext *)MOC;

//-----------------book list
- (void)upinsertBookListInfo:(NSArray *)array timestamp:(double)timestamp;
- (double)getLatestBookListTime;

@end
