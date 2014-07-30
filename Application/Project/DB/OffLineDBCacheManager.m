//
//  OffLineDBCacheManager.m
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "OffLineDBCacheManager.h"
#import "GoHighDBManager.h"
#import "EntityInstance.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "BusinessImageList.h"
#import "ImageList.h"
#import "InformationList.h"
#import "BusinessCategory.h"
#import "BusinessItemModel.h"
#import "ChildSubCategory.h"
#import "EventList.h"
#import "EventImageList.h"
#import "EventApplyList.h"
#import "ChatGroupDataModal.h"
#import "BookList.h"
#import "OrderList.h"
#import "MessageList.h"
#import "PrivateUserListDataModal.h"

@implementation OffLineDBCacheManager

static OffLineDBCacheManager *instance = nil;

+ (OffLineDBCacheManager *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            
        }
    }
    
    return instance;
}

+ (ConnectionAndParserResultCode)saveMOC:(NSManagedObjectContext *)MOC {
    if (SAVE_MOC(MOC)) {
        return SUCCESS_CODE;
    } else {
        return MOC_SAVE_ERR_CODE;
    }
}


+ (ConnectionAndParserResultCode)handleCoureseChapterDB:(int )couseId MOC:(NSManagedObjectContext *)MOC
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"trainingCourseID == %d and isDelete == 0", couseId];
    
    CourseDetailList *infoList = (CourseDetailList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                 entityName:@"CourseDetailList"
                                                                               sortDescKeys:nil
                                                                                  predicate:predicate];
    
    if (infoList) {
        [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"CourseDetailList" predicate:predicate];
        [WXWCoreDataUtils unLoadObject:MOC predicate:predicate entityName:@"CourseDetailList"];
    }

    {
        infoList = [EntityInstance getCourseDetailEntity:MOC];
        infoList.trainingCourseID = NUMBER(couseId);
        [[GoHighDBManager instance] updateCourseDetailList:infoList];
        [[GoHighDBManager instance] updateCourseChapters:infoList MOC:MOC];
        
        DLog(@"%d", infoList.chapterLists.count);
    }
    
    return [self saveMOC:MOC];
}

+(NSDictionary *)parseBusinessDetail:(WXWStatement *)queryStmt
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:@([queryStmt getInt32:3]) forKey:@"param1"];
    [dict setObject:@([queryStmt getInt32:4]) forKey:@"param2"];
    [dict setObject:[queryStmt getString:5] forKey:@"param3"];
    [dict setObject:[queryStmt getString:6] forKey:@"param4"];
    [dict setObject:[queryStmt getString:7] forKey:@"param5"];
    [dict setObject:[queryStmt getString:8] forKey:@"param6"];
    [dict setObject:[queryStmt getString:9] forKey:@"param7"];
    [dict setObject:[queryStmt getString:10] forKey:@"param8"];
    [dict setObject:[queryStmt getString:11] forKey:@"param9"];
    [dict setObject:[queryStmt getString:12] forKey:@"param10"];
    
    return dict;
}

+(NSMutableArray *)getBusinessDetailByParam:(int)categoryID parentID:(int)parentID
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *array = [NSMutableArray array];
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from businessDetailInfo where categoryID = ? and parentID = ? and isDelete = 0 order by param1 ASC "];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:categoryID forIndex:1];
    [queryStmt bindInt32:parentID forIndex:2];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [array addObject:[self parseBusinessDetail:queryStmt]];
    }
    
    [queryStmt release];
    
    return array;
}

//-------------------------business category
+(NSDictionary *)parseBusinessCategoryDict:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    
#if 0
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(businessId == %d)", param1];
    
    BusinessItemModel *infoList =(BusinessItemModel *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                    entityName:@"BusinessItemModel"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];
    
    if (infoList) {
        [infoList updateDataByData:queryStmt];
    }else
    {
        infoList = (BusinessItemModel *)[NSEntityDescription insertNewObjectForEntityForName:@"BusinessItemModel" inManagedObjectContext:MOC];
        
        [infoList updateDataByData:queryStmt];
    }
    
    return [self saveMOC:MOC];
#else
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@([queryStmt getInt32:0]) forKey:@"param1"];
    [dict setObject:[queryStmt getString:1] forKey:@"param2"];
    [dict setObject:[queryStmt getString:2] forKey:@"param3"];
    [dict setObject:[queryStmt getString:3] forKey:@"param4"];
    [dict setObject:[queryStmt getString:4] forKey:@"param5"];
    [dict setObject:[queryStmt getString:5] forKey:@"param6"];
    [dict setObject:[queryStmt getString:6] forKey:@"param7"];
    [dict setObject:[queryStmt getString:7] forKey:@"param8"];
    [dict setObject:[queryStmt getString:8] forKey:@"param9"];
    [dict setObject:[queryStmt getString:9] forKey:@"param10"];
    [dict setObject:[queryStmt getString:10] forKey:@"param11"];
    [dict setObject:[queryStmt getString:11] forKey:@"param12"];
    [dict setObject:[queryStmt getString:12] forKey:@"param13"];
    [dict setObject:[queryStmt getString:13] forKey:@"param14"];
    [dict setObject:[queryStmt getString:14] forKey:@"param15"];
    [dict setObject:[queryStmt getString:15] forKey:@"param16"];
    [dict setObject:[queryStmt getString:16] forKey:@"param17"];
    [dict setObject:[queryStmt getString:17] forKey:@"param18"];
    [dict setObject:[queryStmt getString:18] forKey:@"param19"];
    [dict setObject:[queryStmt getString:19] forKey:@"param20"];
    
    return dict;
#endif
    
}


+(ConnectionAndParserResultCode)parseBusinessCategory:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(businessId == %d)", param1];
    
    BusinessItemModel *infoList =(BusinessItemModel *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                    entityName:@"BusinessItemModel"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];
    
    if (infoList) {
        [infoList updateDataByData:queryStmt];
    }else
    {
        infoList = (BusinessItemModel *)[NSEntityDescription insertNewObjectForEntityForName:@"BusinessItemModel" inManagedObjectContext:MOC];
        
        [infoList updateDataByData:queryStmt];
    }
    
    return [self saveMOC:MOC];
    
}

+ (NSArray *)handleBusinessCategoryDB:(NSManagedObjectContext *)MOC
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from businessCategoryInfo order by param7 desc, param1 asc"];
        [queryStmt retain];
    }
    
    while ([queryStmt step] != SQLITE_DONE) {
        
        [categoryArray addObject:[self parseBusinessCategoryDict:queryStmt MOC:MOC]];
        
        [self parseBusinessCategory:queryStmt MOC:MOC];
        
        //       if ([self parseBusinessCategory:queryStmt MOC:MOC] != SUCCESS_CODE) {
        //
        //           [queryStmt release];
        //           return ERR_CODE;
        //       } ;
    }
    
    
    [queryStmt release];
    return categoryArray;
}

+ (NSArray * )handleBusinessDetailDB:(int )businessDetailId  MOC:(NSManagedObjectContext *)MOC
{
    NSMutableArray *array = [NSMutableArray array];
    
    array = [self getBusinessDetailByParam:businessDetailId parentID:0];
    
    for (int i = 0; i < array.count; ++i) {
        NSMutableDictionary *subDict = [array objectAtIndex:i];
        int param1 = [[subDict objectForKey:@"param1"] integerValue];
        
        NSMutableArray *subArray = [NSMutableArray array];
        subArray = [self getBusinessDetailByParam:businessDetailId parentID:param1];
        
        if (subArray && subArray.count) {
            [subDict setObject:subArray forKey:@"list1"];
        }
        
    }
    
    return array;
}


+(ConnectionAndParserResultCode)parseBusinessDetailImages:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imageID == %d)", param1];
    
    BusinessImageList *infoList = (BusinessImageList *) [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                    entityName:@"BusinessImageList"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];
    
    if (infoList) {
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }else
    {
        infoList = (BusinessImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"BusinessImageList" inManagedObjectContext:MOC];
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode )handleBusinessDetailImageDB:(int )projectId  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from businessDetailImages where projectId = ?  and isDelete = 0 order by sortOrder ASC "];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:projectId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if ([self parseBusinessDetailImages:queryStmt MOC:MOC] != SUCCESS_CODE) {
            
            [queryStmt release];
            return ERR_CODE;
        } ;
    }
    
    
    [queryStmt release];
    return SUCCESS_CODE;
}


//--------------------------info image wall

+(ConnectionAndParserResultCode)parseInfoImageWall:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imageID == %d)", param1];
    
    ImageList *infoList = (ImageList *) [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                    entityName:@"ImageList"
                                                                  sortDescKeys:nil
                                                                     predicate:predicate];
    
    if (infoList) {
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }else
    {
        infoList = (ImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageList" inManagedObjectContext:MOC];
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }
    
    return [self saveMOC:MOC];
}

+(ConnectionAndParserResultCode)handleInformationImageWallDB:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from infoScrollWallImages where   isDelete = 0 order by sortOrder ASC , imageID asc "];
        [queryStmt retain];
    }
    
    while ([queryStmt step] != SQLITE_DONE) {
        if ([self parseInfoImageWall:queryStmt MOC:MOC] != SUCCESS_CODE) {
            
            [queryStmt release];
            return ERR_CODE;
        } ;
    }
    
    [queryStmt release];
    return SUCCESS_CODE;
}


//----------------------------

+(ConnectionAndParserResultCode)parseInfomationList:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(informationID == %d)", param1];
    
    InformationList *infoList = (InformationList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                               entityName:@"InformationList"
                                                                             sortDescKeys:nil
                                                                                predicate:predicate];
    
    if (infoList) {
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }else
    {
        infoList = (InformationList *)[NSEntityDescription insertNewObjectForEntityForName:@"InformationList" inManagedObjectContext:MOC];
        //        [infoList updateData:dic projectId:pid];
        [infoList updateDataWithStmt:queryStmt];
    }
    
    return [self saveMOC:MOC];
}

+(ConnectionAndParserResultCode)handleInformationListDB:(int)page count:(int)pageCount  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from infoList where isDelete = 0 ORDER BY sortOrder asc, informationID asc LIMIT ?*?,?"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:page forIndex:1];
    [queryStmt bindInt32:pageCount forIndex:2];
    [queryStmt bindInt32:pageCount forIndex:3];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if ([self parseInfomationList:queryStmt MOC:MOC] != SUCCESS_CODE) {
            
            [queryStmt release];
            return ERR_CODE;
        } ;
    }
    
    [queryStmt release];
    return SUCCESS_CODE;
}

+(ChildSubCategory *)parseAloneMarketing:(WXWStatement *)queryStmt{
    ChildSubCategory *category = [[[ChildSubCategory alloc] init] autorelease];
    
    [category parserDataWithData:queryStmt];
    return category;
}

//---------------------------order list

+ (ConnectionAndParserResultCode)handleOrderListDB:(int)page count:(int)pageCount MOC:(NSManagedObjectContext *)MOC {
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from orderList ORDER BY sortOrder asc, informationID asc LIMIT ?*?,?"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:page forIndex:1];
    [queryStmt bindInt32:pageCount forIndex:2];
    [queryStmt bindInt32:pageCount forIndex:3];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if ([self parseInfomationList:queryStmt MOC:MOC] != SUCCESS_CODE) {
            
            [queryStmt release];
            return ERR_CODE;
        } ;
    }
    
    [queryStmt release];
    return SUCCESS_CODE;
}

+ (ConnectionAndParserResultCode)parserOrderList:(WXWStatement *)statment MOC:(NSManagedObjectContext *)MOC {
    int param1 = [statment getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(informationID == %d)", param1];
    
    OrderList *infoList = (OrderList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                   entityName:@"OrderList"
                                                                 sortDescKeys:nil
                                                                    predicate:predicate];
    
    if (infoList) {
        //        [infoList updateDataWithStmt:statment];
    }else
    {
        infoList = (OrderList *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderList" inManagedObjectContext:MOC];
        //        [infoList updateDataWithStmt:statment];
    }
    
    return [self saveMOC:MOC];
}

//---------------------- message list

+ (ConnectionAndParserResultCode)handleMessageListDB:(int)page count:(int)pageCount MOC:(NSManagedObjectContext *)MOC {
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from messageList ORDER BY sortOrder asc, informationID asc LIMIT ?*?,?"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:page forIndex:1];
    [queryStmt bindInt32:pageCount forIndex:2];
    [queryStmt bindInt32:pageCount forIndex:3];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if ([self parseInfomationList:queryStmt MOC:MOC] != SUCCESS_CODE) {
            
            [queryStmt release];
            return ERR_CODE;
        } ;
    }
    
    [queryStmt release];
    return SUCCESS_CODE;
}

+ (ConnectionAndParserResultCode)parserMessageList:(WXWStatement *)statment MOC:(NSManagedObjectContext *)MOC {
    int param1 = [statment getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(informationID == %d)", param1];
    
    MessageList *infoList = (MessageList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                   entityName:@"MessageList"
                                                                 sortDescKeys:nil
                                                                    predicate:predicate];
    
    if (infoList) {
        //        [infoList updateDataWithStmt:statment];
    }else
    {
        infoList = (MessageList *)[NSEntityDescription insertNewObjectForEntityForName:@"MessageList" inManagedObjectContext:MOC];
        //        [infoList updateDataWithStmt:statment];
    }
    
    return [self saveMOC:MOC];
}

//---------------------------aloneMarketing

+(void)getCategoryByParentId:(NSString *)parentId array:(NSMutableArray *)afterArray
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from aloneMarketing where parentId = ? ORDER BY param5 asc"];
        [queryStmt retain];
    }
    
    [queryStmt bindString:parentId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        NSString *param1 = [queryStmt getString:0];
        if (![param1 isEqualToString:@"-1"]) {
            
            ChildSubCategory *category = [self parseAloneMarketing:queryStmt];
            [category parserDataWithData:queryStmt];
            
            DLog(@"param1:%@, parentId:%@", param1, parentId);
            NSMutableArray *arr = [NSMutableArray array];
            category.list1 = arr;
            [afterArray addObject:category];
            category.param1 = param1;
        }
    }
    
    [queryStmt reset];
    [queryStmt release];
}

+(NSMutableArray *)handleAloneMarketingDB:(NSManagedObjectContext *)MOC
{
    
    __block void (^blockQuerys)(NSMutableArray *, NSString *);
    
    blockQuerys = ^(NSMutableArray * afterArray,NSString *parentId) {
     
         [self getCategoryByParentId:parentId array:afterArray];
        
        for (int i = 0; i < afterArray.count; i++) {
            ChildSubCategory *category = [afterArray objectAtIndex:i];
            blockQuerys(category.list1, category.param1);
        }
    };

    NSMutableArray *array  = [NSMutableArray array];
    
    blockQuerys(array, @"-1");
    
    return array;
}

//---------------------------circleMarketing
+(ConnectionAndParserResultCode )parseCircleMarketingImages:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC eventList:(EventList *)eventList
{
//    int param1 = [queryStmt getInt32:0];
    NSString * url = [queryStmt getString:3];

          EventImageList * im = (EventImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventImageList" inManagedObjectContext:MOC];
        im.imageUrl = url;
        
         [eventList addEventImageListObject:im];
    return [self saveMOC:MOC];
}

+(ConnectionAndParserResultCode)getCircleMarketingImages:(int)eventId MOC:(NSManagedObjectContext *)MOC eventList:(EventList *)eventList
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from circleMarketingImage where eventId = ? and isDelete = 0"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:eventId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if(SUCCESS_CODE != [self parseCircleMarketingImages:queryStmt MOC:MOC eventList:eventList])
            [queryStmt release];
            return ERR_CODE;
    }
    [queryStmt release];
    return SUCCESS_CODE;
    
}

//---------------

//---------------------------circleMarketing
+(ConnectionAndParserResultCode )parseCircleMarketingApply:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC eventList:(EventList *)eventList
{
    
    EventApplyList * im = (EventApplyList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventApplyList" inManagedObjectContext:MOC];

    im.applyId = NUMBER([queryStmt getInt32:1]);
    im.applyResult = [queryStmt getString:2];
    im.applyTitle = [queryStmt getString:3];
    
    [eventList addEventApplyListObject:im];
    return [self saveMOC:MOC];
}


+(ConnectionAndParserResultCode)getCircleMarketingApply:(int)eventId MOC:(NSManagedObjectContext *)MOC eventList:(EventList *)eventList
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from circleMarketingApply where eventId = ? and isDelete = 0"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:eventId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if(SUCCESS_CODE != [self parseCircleMarketingApply:queryStmt MOC:MOC eventList:eventList])
            [queryStmt release];
            return ERR_CODE;
        if (SUCCESS_CODE != [self parseCircleMarketingApply:queryStmt MOC:MOC eventList:eventList]) {
            [queryStmt release];
            return ERR_CODE;
        }
    }
    [queryStmt release];
    return SUCCESS_CODE;
    
}
//------------------
+(ConnectionAndParserResultCode )parseCircleMarketing:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    int param1 = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventId == %d)", param1];
    
    EventList *infoList =(EventList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                    entityName:@"EventList"
                                                                  sortDescKeys:nil
                                                                     predicate:predicate];
    
    if (infoList) {
//        [infoList updateData:dic withType:type];
        [infoList updateDataWithStmt:queryStmt];
    }else {
        infoList = (EventList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventList" inManagedObjectContext:MOC];
        
        [self getCircleMarketingImages:param1 MOC:MOC eventList:infoList];
        
        [infoList updateDataWithStmt:queryStmt];
    }
    return  [self saveMOC:MOC];
}
+(ConnectionAndParserResultCode)handleCircleMarketingDB:(int)type  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from circleMarketingInfo where eventType = ? and isDelete = 0 ORDER BY displayIndex asc"];
        [queryStmt retain];
    }
    
    [queryStmt bindInt32:type forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [self parseCircleMarketing:queryStmt MOC:MOC];
//       if(SUCCESS_CODE != [self parseCircleMarketing:queryStmt MOC:MOC])
//           [queryStmt release];
//           return ERR_CODE;
    }
    [queryStmt  release];
    return SUCCESS_CODE;
}

//---------------------------communicate group list
+ (ConnectionAndParserResultCode) parseCommunicateGroupList:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC

{
    int groupId = [queryStmt getInt32:9];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(groupId == %d)", groupId];
    ChatGroupDataModal *group =(ChatGroupDataModal *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                    entityName:@"ChatGroupDataModal"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];    
    if (group) {
        [group updateDataWithStmt:queryStmt];
    }else {
        group = (ChatGroupDataModal *)[NSEntityDescription insertNewObjectForEntityForName:@"ChatGroupDataModal" inManagedObjectContext:MOC];
        [group updateDataWithStmt:queryStmt];
    }
    
    return  [self saveMOC:MOC];
}

+(ConnectionAndParserResultCode)handleCommunicateGroupListDB:(NSString *)userId  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from communicateGroupList where userId = ? and isDelete = 0 ORDER BY displayIndex asc"];
        [queryStmt retain];
    }
    
    [queryStmt bindString:userId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        if(SUCCESS_CODE != [self parseCommunicateGroupList:queryStmt MOC:MOC]) {
            [queryStmt release];
            return ERR_CODE;
        }
        
    }
    [queryStmt release];
    return SUCCESS_CODE;
}


//--------------------------book recommand
+ (ConnectionAndParserResultCode) parseBookRecommand:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC

{
    int bookId = [queryStmt getInt32:0];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bookID == %d)", bookId];
    
    BookList *infoList = (BookList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                 entityName:@"BookList"
                                                               sortDescKeys:nil
                                                                  predicate:predicate];
    
    if (infoList) {
        [infoList updateDataByData:queryStmt];
    }else
    {
        infoList = (BookList *)[NSEntityDescription insertNewObjectForEntityForName:@"BookList" inManagedObjectContext:MOC];
        [infoList updateDataByData:queryStmt];
    }

    return [self saveMOC:MOC];
}

+(ConnectionAndParserResultCode)handleBookRecommandDB:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from bookList order by sortOrder ASC"];
        [queryStmt retain];
    }
    
    
    while ([queryStmt step] != SQLITE_DONE) {
        if(SUCCESS_CODE != [self parseBookRecommand:queryStmt MOC:MOC])
            [queryStmt release];
            return ERR_CODE;
    }
    [queryStmt release];
    return SUCCESS_CODE;
}


//----------------------------chat message
+(QPlusMessage *)parseChatMessage:(WXWStatement *)queryStmt
{
    QPlusMessage *message = [[[QPlusMessage alloc] init] autorelease];

//    message.uuid = [queryStmt getString:0];
    message.type = [queryStmt getInt32:1];
    message.isRoomMsg = [queryStmt getInt32:2];
    message.date = [queryStmt getDouble:3];
    message.text = [queryStmt getString:4];
    message.isPrivate = [queryStmt getInt32:5];
    
    
    return message;
}
+(NSArray *)handleGroupChatMessages:(NSString *)groupId pageNo:(int)pageNo count:(int)count
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *array = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"select * from chats where groupID = ? and isRoomMsg = 1 order by data desc LIMIT ?*?,?"];
        [queryStmt retain];
    }
    
    [queryStmt bindString:groupId forIndex:1];
    [queryStmt bindInt32:pageNo forIndex:2];
    [queryStmt bindInt32:count forIndex:3];
    [queryStmt bindInt32:count forIndex:4];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [array addObject:[self parseChatMessage:queryStmt ]];
    }
    
    [queryStmt  release];
    return array;
}


//--------------------------private user list
+(ConnectionAndParserResultCode)handlePrivateUserListDataModal:(NSString *)privateUserId MOC:(NSManagedObjectContext *)MOC
{
    UserBaseInfo *userInfo = [[GoHighDBManager instance] getUserInfoFromDB:privateUserId.integerValue];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %d)",privateUserId.integerValue];
    
    PrivateUserListDataModal *infoList =(PrivateUserListDataModal *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                                  entityName:@"PrivateUserListDataModal"
                                                                                                sortDescKeys:nil
                                                                                                   predicate:predicate];
    
    if (infoList) {
        [infoList updateDataByData:userInfo];
    }else
    {
        infoList = (PrivateUserListDataModal *)[NSEntityDescription insertNewObjectForEntityForName:@"PrivateUserListDataModal" inManagedObjectContext:MOC];
        [infoList updateDataByData:userInfo];
        
    }
    
    return [self saveMOC:MOC];
}
@end
