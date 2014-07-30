//
//  GoHighDBManager.m
//  Project
//
//  Created by XXX on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GoHighDBManager.h"
#import "EntityInstance.h"
#import "WXWCoreDataUtils.h"
#import "GoHighBusinessDetailInfoCache.h"
#import "GoHighBusinessDetaiImagesCache.h"
#import "InformationImageWallCache.h"
#import "InformationListCache.h"
#import "GoHighBusinessCategoryInfoCache.h"
#import "AloneMarketingCache.h"
#import "CircleMarketingCahce.h"
#import "CommonTableCache.h"
#import "BookListCache.h"

@implementation GoHighDBManager {
    
    GoHighChatCache *_chatCache;
    UserCache *_userCache;
    CourseInfoCache *_courseInfoCache;
    CourseListCache *_courseListCache;
    ChapterListInfoCache *_chapterListInfoCache;
    GoHighBusinessDetailInfoCache *_goHighBusinessDetailInfoCache;
    GoHighBusinessDetaiImagesCache *_goHighBusinessDetaiImagesCache;
    InformationImageWallCache *_informationImageWallCache;
    InformationListCache *_informationListCache;
    GoHighBusinessCategoryInfoCache *_goHighBusinessCategoryInfoCache;
    AloneMarketingCache *_aloneMarketingCache;
    CircleMarketingCahce *_circleMarketingCahce;
    CommunicateGroupListCache *_communicateGroupListCache;
    CommonTableCache *_commonTableCache;
    BookListCache *_bookListCache;
}

static GoHighDBManager *instance = nil;

+ (GoHighDBManager *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            
            [instance initData];
        }
    }
    
    return instance;
}

- (void)dealloc
{
    [_chatCache release];
    [_userCache release];
    [_courseInfoCache release];
    [_chapterListInfoCache release];
    [_goHighBusinessDetailInfoCache release];
    [_goHighBusinessDetaiImagesCache release];
    [_informationImageWallCache release];
    [_informationListCache release];
    [_goHighBusinessCategoryInfoCache release];
    [_aloneMarketingCache release];
    [_circleMarketingCahce release];
    [_communicateGroupListCache release];
    [_bookListCache release];
    [_commonTableCache release];
    
    [super dealloc];
}

//---------------------------------------init-------------------------------------------------------------
- (void)initData
{
    _chatCache = [[GoHighChatCache alloc] init];
    _userCache = [[UserCache alloc] init];
    _courseInfoCache = [[CourseInfoCache alloc] init];
    _courseListCache = [[CourseListCache alloc] init];
    _chapterListInfoCache = [[ChapterListInfoCache alloc] init];
    _goHighBusinessDetailInfoCache =[[GoHighBusinessDetailInfoCache alloc] init];
    _goHighBusinessDetaiImagesCache = [[GoHighBusinessDetaiImagesCache alloc] init];
    _informationImageWallCache = [[InformationImageWallCache alloc] init];
    _informationListCache = [[InformationListCache alloc]init];
    _goHighBusinessCategoryInfoCache = [[GoHighBusinessCategoryInfoCache alloc] init];
    _aloneMarketingCache = [[AloneMarketingCache alloc] init];
    _circleMarketingCahce = [[CircleMarketingCahce alloc] init];
    _communicateGroupListCache = [[CommunicateGroupListCache alloc] init];
    _bookListCache = [[BookListCache alloc] init];
    _commonTableCache = [[CommonTableCache alloc] init];
}

//----------------------------------------chat------------------------------------------------------------
- (void)insertChatIntoDB:(QPlusMessage *)message groupId:(NSString *)groupId isRead:(int)read
{
    [_chatCache insertChatIntoDB:message groupId:groupId isRead:read];
}


- (ChatModel *)getGroupLastMessage:(NSString *)groupId
{
    return [_chatCache getGroupLastMessage:groupId];
}

- (ChatModel *)getPrivateLastMessage:(NSString *)friendId userId:(NSString *)userId
{
    return [_chatCache getPrivateLastMessage:friendId userId:userId];
}


- (int)getVoiceMessageListened:(QPlusMessage *)message
{
    
    return [_chatCache getVoiceMessageListened:message];
}

- (int)getGroupNewMessageCount:(NSString *)groupId userId:(NSString *)userId
{
    return [_chatCache getGroupNewMessageCount:groupId userId:userId];
}


- (int)getPrivateNewMessageCount:(NSString *)friendId userId:(NSString *)userId
{
    return [_chatCache getPrivateNewMessageCount:friendId userId:userId];
}

- (int)getGroupIsDeleted:(NSString *)groupId
{
    return  [_communicateGroupListCache getGroupIsDeleted:groupId];
}

- (void)setVoiceMessageListened:(QPlusMessage *)messsage
{
    [_chatCache setVoiceMessageListened:messsage];
}
- (void)setGroupMessageReaded:(NSString *)groupId
{
    [_chatCache setGroupMessageReaded:groupId];
}
- (void)setPrivateMessageReaded:(NSString *)friendId
{
    [_chatCache setPrivateMessageReaded:friendId];
}
- (void)setGroupDeleted:(NSString *)groupId
{
    [_communicateGroupListCache deleteGroup:[groupId integerValue]];
}
//------------------------------------------user----------------------------------------------------------

- (void)upinsertUserIntoDB:(UserBaseInfo *)userInfo timestamp:(double)timestamp
{
    [_userCache upinsertUserIntoDB:userInfo timestamp:timestamp];
}

- (void)upinsertUserProfile:(UserProfile *)userProfile
{
    [_userCache upinsertUserProfile:userProfile];
}

- (UserBaseInfo *)getUserInfoFromDB:(int)userId
{
    return [_userCache getUserInfoFromDB:userId];
}

- (NSMutableArray *)getUserPropertiesByUserId:(int)userId
{
    return [_userCache getUserPropertiesByUserId:userId];
}


- (NSMutableArray *)getUserPropertiesByUserId:(int)userId groupId:(int)groupId
{
    return [_userCache getUserPropertiesByUserId:userId groupId:groupId];
}

- (int)getGroupCountByUserId:(int)userId
{
    return [_userCache getGroupCountByUserId:userId];
}

- (int)isFriend:(int)userId
{
    return [_userCache isFriend:userId];
}

-(void)updateIsFriend:(NSArray *)array
{
    [_userCache updateIsFriend:array];
}

-(void)updateIsFriendWithId:(NSString *)userId isFriend:(BOOL)isFriend
{
    [_userCache updateIsFriendWithId:userId isFriend:isFriend] ;
}

- (NSMutableArray *)getAllUserInfoFromDB
{
    return [_userCache getAllUserInfoFromDB];
}

- (NSMutableArray *)getUserInfoWithKeyword:(NSString *)keyword {
    return [_userCache getUserInfoWithKeyword:keyword];
}

-(double)getLatestUserTimestamp
{
    return [_userCache getLatestUserTimestamp];
}
//-----------------courselistinfo------------------\

- (void)upinsertCourses:(NSArray *)courses isMyCourse:(int)isMyCourse categoryId:(int)categoryId {
    for (int i=0; i < courses.count; ++i) {
        CourseList *detail = [courses objectAtIndex:i];
        
        [_courseListCache upinsertCourse:detail isMyCourse:isMyCourse categoryID:categoryId];
        
    }
}

- (BOOL)isMyCourseByCourseId:(int)courseId categoryId:(int)categoryId {
    return [_courseListCache isMyCourse:courseId cateforyId:categoryId];
}

- (void)updateCourse:(int)courseID categoryId:(int)categoryId {
    [_courseListCache updateCourseList:courseID categoryId:categoryId];
}

- (NSArray *)getMyCourseListInMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId {
    return [_courseListCache getMyCourseInMOC:MOC categoryId:categoryId];
}

//-----------------courseinfo ---------------------
- (double)getLatestCourseInfoTime:(int)courseId
{
    return  [_courseInfoCache getLatestCourseInfoTime:courseId];
}


- (void)updateCourseDetailList:(CourseDetailList *)detail
{
    [_courseInfoCache updateCourseDetailList:detail];
}


- (void)updateChapterDownloading:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    [_chapterListInfoCache updateDownloadingCourseChapters:detail MOC:MOC];
}

- (void)updateChapterDownloaded:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    [_chapterListInfoCache updateDownloadedCourseChapters:detail MOC:MOC];
}


- (void)upinsertCourseDetail:(NSArray *)courseDetail isMyCourse:(int)isMyCourse
{
    for (int i=0; i < courseDetail.count; ++i) {
        CourseDetailList *detail = [courseDetail objectAtIndex:i];
        
        [_courseInfoCache upinsertCourseInfo:detail isMyCourse:isMyCourse];
        
        for (ChapterList *chapter in detail.chapterLists) {
            [_chapterListInfoCache upinsertChapterInfo:chapter];
        }
    }
}

- (NSArray *)getMyCourse {
    return [_courseInfoCache getMyCourse];
}

//----------------------------ChapterListInfo---------------

- (CourseDetailList *)getCourseDetailByCourseId:(int)courseId withCourseDetailList:(CourseDetailList *)detail
{
    //    CourseDetailList *detail = [_courseInfoCache getCourseDetailByCourseId:courseId];
    return nil;
}

- (NSMutableArray *)getAllDownloadingCourseDetail:(NSManagedObjectContext *)MOC
{
    NSArray *array = [_chapterListInfoCache getAllDownloadingCourseId];
    NSMutableArray * downloadedCourseArray = [NSMutableArray array];
    for (int i = 0; i < array.count;++i) {
        
        NSNumber *courseId =[array objectAtIndex:i];
        
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trainingCourseID == %d)", [courseId integerValue]];
        //        CourseDetailList *infoList = (CourseDetailList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
        //                                                                                     entityName:@"CourseDetailList"
        //                                                                                   sortDescKeys:nil
        //                                                                                      predicate:predicate];
        //
        //        if (infoList) {
        //
        //        }else{
        //
        //            infoList = [EntityInstance getCourseDetailEntity:MOC];
        //
        //            infoList.trainingCourseID = courseId;
        //            [[GoHighDBManager instance] updateCourseDetailList:infoList];
        //            [[GoHighDBManager instance] updateChapterDownloading:infoList MOC:MOC];
        //        }
        CourseDetailList *infoList = [EntityInstance getCourseDetailEntity:MOC];
        
        infoList.trainingCourseID = courseId;
        [[GoHighDBManager instance] updateCourseDetailList:infoList];
        [[GoHighDBManager instance] updateChapterDownloading:infoList MOC:MOC];
        
        [downloadedCourseArray addObject:infoList];
    }
    return downloadedCourseArray;
    
}

- (BOOL)isDownloaded:(int)courseId withChapterId:(int)chapterId {
    return [_chapterListInfoCache isDownloaded:courseId withChapterId:chapterId];
}

- (BOOL)isDownloading:(int)courseId withChapterId:(int)chapterId {
    return [_chapterListInfoCache isDownloading:courseId withChapterId:chapterId];
}

-(void)resetDownloadInfo:(int)courseId withChapterId:(int)chapterId
{
    [_chapterListInfoCache resetDownloadInfo:courseId withChapterId:chapterId];
}

- (NSMutableArray *)getAllDownloadedCourseDetail:(NSManagedObjectContext *)MOC
{
    NSArray *array = [_chapterListInfoCache getAllDownloadedCourseId];
    NSMutableArray * downloadedCourseArray = [NSMutableArray array];
    for (int i = 0; i < array.count;++i) {
        
        NSNumber *courseId =[array objectAtIndex:i];
        //
        //        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trainingCourseID == %d)", [courseId integerValue]];
        //        CourseDetailList *infoList = (CourseDetailList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
        //                                                                                     entityName:@"CourseDetailList"
        //                                                                                   sortDescKeys:nil
        //                                                                                      predicate:predicate];
        //
        //        if (infoList) {
        //
        //        }else{
        //
        //            infoList = [EntityInstance getCourseDetailEntity:MOC];
        //
        //            infoList.trainingCourseID = courseId;
        //            [[GoHighDBManager instance] updateCourseDetailList:infoList];
        //            [[GoHighDBManager instance] updateChapterDownloaded:infoList MOC:MOC];
        //        }
        
        CourseDetailList *infoList = [EntityInstance getCourseDetailEntity:MOC];
        
        infoList.trainingCourseID = courseId;
        [[GoHighDBManager instance] updateCourseDetailList:infoList];
        [[GoHighDBManager instance] updateChapterDownloaded:infoList MOC:MOC];
        
        [downloadedCourseArray addObject:infoList];
    }
    return downloadedCourseArray;
    
}

- (void)deleteChapterWithChapterId:(int)chapterId courseId:(int)courseId {
    [_chapterListInfoCache deleteChapterWithChapter:chapterId courseId:courseId];
}

- (void)updateCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    [_chapterListInfoCache updateCourseChapters:detail MOC:MOC];
}

- (void)updateChapterDownloaded:(int)courseId withChapterId:(int)chapterId isDownloaded:(int)downloaded
{
    [_chapterListInfoCache updateChapterDownloaded:courseId withChapterId:chapterId isDownloaded:downloaded];
}

- (void)updateChapterPercentage:(int)courseId withChapterId:(int)chapterId percentage:(double)percentage fileDownloadedSize:(double)fileDownloadedSize fileSize:(double)fileSize
{
    [_chapterListInfoCache updateChapterPercentage:courseId withChapterId:chapterId percentage:percentage fileDownloadedSize:fileDownloadedSize fileSize:fileSize];
}

//---------------business category
-(void)upinsertBusinessCategories:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    [_goHighBusinessCategoryInfoCache upinsertBusinessCategories:array timestamp:timestamp MOC:MOC];
}

-(double)getLatestBusinessCategoryTime
{
    return [_goHighBusinessCategoryInfoCache getLatestBusinessCategoryTime];
}

//---------------------

- (double)getLatestBusinessDetailInfoTime:(int)projectId
{
    return [_goHighBusinessDetailInfoCache getLatestBusinessDetailInfoTime:projectId];
}

- (void)upinsertBusinessDetails:(NSDictionary *)contentDic timestamp:(NSString *)timestamp categoryID:(int)categoryID MOC:(NSManagedObjectContext *)MOC
{
    [_goHighBusinessDetailInfoCache upinsertBusinessDetails:contentDic timestamp:timestamp categoryID:categoryID MOC:MOC];
}

//----------------business detail image

- (void)upinsertBusinessDetailImages:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    [_goHighBusinessDetaiImagesCache upinsertBusinessDetailImages:array timestamp:timestamp MOC:MOC];
}


- (double)getLatestBusinessDetailImageTime:(int)projectId
{
    return [_goHighBusinessDetaiImagesCache getLatestBusinessDetailImageTime:projectId];
}

//---------------information image wall
- (void)upinsertInfomationImageWall:(NSArray *)array timestamp:(double)timestamp
{
    [_informationImageWallCache upinsertInfomationImageWall:array timestamp:timestamp];
}


-(double)getLatestInfoImageWallTime
{
    return [_informationImageWallCache getLatestInfoImageWallTime];
}



//--------------information list
- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp
{
    [_informationListCache upinsertInfomationInfo:array timestamp:timestamp];
}

-(double)getLatestInfomationTimestamp
{
    return [_informationListCache getLatestInfomationTimestamp];
}

-(double)getOldestInfomationTimestamp
{
    
    return [_informationListCache getOldestInfomationTimestamp];
}

-(void)deleteOldInfomationFromTimestamp:(NSString *)timestamp
{
    [_informationListCache deleteOldInfomationFromTimestamp:timestamp];
}


- (void)updateInformationCommentCount:(int)infoId count:(int)count
{
    [_informationListCache updateInformationCommentCount:infoId count:count];
}

-(void)updateInformationCommentReader:(int)infoId count:(int)count
{
    [_informationListCache updateInformationCommentReader:infoId count:count];
}


- (int)getInformationCommentCount:(int)infoId
{
    return [_informationListCache getInformationCommentCount:infoId];
}

-(int)getInformationCommentReader:(int)infoId
{
    return [_informationListCache getInformationCommentReader:infoId];
}

//---------------AloneMarketing
- (void)upinsertAloneMarketing:(NSArray *)array timestamp:(double)timestamp
{
    [_aloneMarketingCache upinsertAloneMarketing:array timestamp:timestamp];
}

-(double)getLatestAloneMarketingTime
{
    return [_aloneMarketingCache getLatestAloneMarketingTime];
}


//--------------Circlemarketing
- (void)upinsertCircleMarketing:(NSArray *)array timestamp:(double)timestamp
{
    [_circleMarketingCahce upinsertCircleMarketing:array timestamp:timestamp];
}

-(double)getLatestCircleMarketingTime:(int)type
{
    return [_circleMarketingCahce getLatestCircleMarketingTime:type];
}
//--------------communicate group list
-(void)upinsertCommunicateGroupList:(NSString *)userId array:(NSArray *)array timestamp:(NSString *)timestamp MOC:(NSManagedObjectContext *)MOC
{
    [_communicateGroupListCache upinsertCommunicateGroupList:userId array:array timestamp:timestamp MOC:MOC];
}

-(double)getLatestCommunicateGroupListTime
{
    return [_communicateGroupListCache getLatestCommunicateGroupListTime];
}


-(void)deleteGroup:(int)groupId
{
    [_communicateGroupListCache deleteGroup:groupId];
}

-(void)deleteAllGroupListData
{
    [_communicateGroupListCache deleteAllGroupListData];
}
//--------------common table

- (void)upinsertCommonTable:(NSString *)key value:(NSString *)value {
    [_commonTableCache upinsertCommon:key value:value];
}

-(NSString*)getCommon:(NSString *)key
{
    return [_commonTableCache getCommon:key];
}
//-----------------book list
- (void)upinsertBookListInfo:(NSArray *)array timestamp:(double)timestamp
{
    [_bookListCache upinsertBookListInfo:array timestamp:timestamp];
}

-(double)getLatestBookListTime
{
    return [_bookListCache getLatestBookListTime];
}

//--------------drop table

- (void)dropTables:(NSArray *)table {
    WXWStatement *dropStmt = nil;
    
//    //drop/truncate table if exists '?'
//    
//    if (dropStmt == nil) {
//        
////        dropStmt = [WXWDBConnection statementWithQuery:"delete from ?"];
//        [dropStmt retain];
//    }
    
    for (int i = 0; i < table.count; i++) {
        NSString *tableName = table[i];
        NSString *strSQL = [NSString  stringWithFormat:@"delete from %@", tableName];
        
		dropStmt = [WXWDBConnection statementWithQuery:[strSQL UTF8String]];
        
        [dropStmt step];
        [dropStmt reset];
    }
    
}


-(void)deleteEntity:(NSArray *)entities MOC:(NSManagedObjectContext *)MOC
{
    for (int i = 0; i < entities.count; ++i) {
        
         [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:[entities objectAtIndex:i] predicate:nil];
        
        [WXWCoreDataUtils saveMOCChange:MOC];
    }
}
@end
