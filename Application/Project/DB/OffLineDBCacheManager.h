//
//  OffLineDBCacheManager.h
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"
#import "CourseDetailList.h"
#import "ChapterList.h"
#import "InformationImageWallCache.h"
#import "WXWCoreDataUtils.h"
#import "WXWConnectorDelegate.h"
#import "CourseList.h"

@interface OffLineDBCacheManager : NSObject <WXWConnectorDelegate>


+ (OffLineDBCacheManager *)instance;


+ (ConnectionAndParserResultCode)handleCoureseChapterDB:(int)couseId MOC:(NSManagedObjectContext *)MOC;


+ (ChapterList *)getChapterListEntity:(NSManagedObjectContext *)MOC;

+ (ConnectionAndParserResultCode)handleCourseDB:(int)courseid inMOC:(NSManagedObjectContext *)MOC;

//-------------------------business category
+ (NSArray *)handleBusinessCategoryDB:(NSManagedObjectContext *)MOC;

//--------------------------business detail image
+ (ConnectionAndParserResultCode)handleBusinessDetailImageDB:(int)projectId MOC:(NSManagedObjectContext *)MOC;

//--------------------------business detail
+ (NSArray *)handleBusinessDetailDB:(int)businessDetailId MOC:(NSManagedObjectContext *)MOC;


//--------------------------info image wall
+(ConnectionAndParserResultCode)handleInformationImageWallDB:(NSManagedObjectContext *)MOC;

//-------------------------information list
+(ConnectionAndParserResultCode)handleInformationListDB:(int)page count:(int)pageCount  MOC:(NSManagedObjectContext *)MOC;

//--------------------------order list
+ (ConnectionAndParserResultCode)handleOrderListDB:(int)page count:(int)pageCount MOC:(NSManagedObjectContext *)MOC;

//--------------------------message list
+ (ConnectionAndParserResultCode)handleMessageListDB:(int)page count:(int)pageCount MOC:(NSManagedObjectContext *)MOC;

//---------------------------aloneMarketing
+(NSMutableArray *)handleAloneMarketingDB:(NSManagedObjectContext *)MOC;

//---------------------------circleMarketing
+(ConnectionAndParserResultCode)handleCircleMarketingDB:(int)type  MOC:(NSManagedObjectContext *)MOC;



//---------------------------communicate group list
+(ConnectionAndParserResultCode)handleCommunicateGroupListDB:(NSString *)userId  MOC:(NSManagedObjectContext *)MOC;

//--------------------------book recommand
+(ConnectionAndParserResultCode)handleBookRecommandDB:(NSManagedObjectContext *)MOC;


//----------------------------chat message
+(NSArray *)handleGroupChatMessages:(NSString *)groupId pageNo:(int)pageNo count:(int)count;

//--------------------------private user list
+(ConnectionAndParserResultCode )handlePrivateUserListDataModal:(NSString *)privateUserId MOC:(NSManagedObjectContext *)MOC;
@end
