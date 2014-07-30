//
//  JSONParser.m
//  Project
//
//  Created by XXX on 13-4-14.
//
//

#import "JSONParser.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "AppManager.h"
#import "CommonUtils.h"
#import "WXWDebugLogOutput.h"
#import "WXWCommonUtils.h"
#import "Alumni.h"
#import "Post.h"
#import "GroupMemberInfo.h"
#import "WXWCoreDataUtils.h"
#import "GlobalConstants.h"
#import "BusinessItemModel.h"
#import "BusinessItemDetailModel.h"
#import "ImageList.h"
#import "EventList.h"
#import "EventDetailList.h"
#import "ImageObject.h"
#import "BusinessImageList.h"

#import "ChatGroupDataModal.h"
#import "EventImageList.h"
#import "EventImageDetailList.h"
#import "EventApplyMemberList.h"
#import "EventApplyList.h"
#import "EventVoteList.h"
#import "EventOptionList.h"
#import "PrivateUserListDataModal.h"

#import "TrainingList.h"
#import "BookImageList.h"
#import "BookList.h"
#import "ChapterList.h"
#import "CourseDetailList.h"
#import "CourseList.h"
#import "OrderList.h"
#import "OrderDetailList.h"
#import "OrderImageList.h"
#import "MessageList.h"

#import "CommentList.h"
#import "FirendUserListDataModal.h"

@implementation JSONParser


#pragma mark - common utilities

+ (ConnectionAndParserResultCode)saveMOC:(NSManagedObjectContext *)MOC {
    if (SAVE_MOC(MOC)) {
        return SUCCESS_CODE;
    } else {
        return MOC_SAVE_ERR_CODE;
    }
}

+ (void)traceErrorMessageForConnectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                                          url:(NSString *)url
                                     errorMsg:(NSString *)errorMsg {
    
    errorMsg = [WXWCommonUtils decodeAndReplacePlusForText:errorMsg];
    
    debugLog(@"error response description: %@ for url %@", errorMsg, url);
    [connectorDelegate traceParserXMLErrorMessage:errorMsg
                                              url:url];
}


+ (NSInteger)parserResponseDic:(NSDictionary *)dic
             connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                           url:(NSString *)url {
    
    if ([[dic objectForKey:RET_CODE_NAME] isKindOfClass:[NSNull class]]) {
        return NO_DATA_CODE;
    }
    
    
    int code = -1000;
    
    if ([dic objectForKey:@"Code"] != nil) {
        code = [[dic objectForKey:@"Code"] intValue];
    }else {
        code = [[dic objectForKey:RET_CODE_NAME] intValue];
    }
    
//    [AppManager instance].customJumpMsg = [dic objectForKey:RET_DESC_NAME];
    
    if (code != SUCCESS_CODE) {
        [self traceErrorMessageForConnectorDelegate:connectorDelegate
                                                url:url
                                           errorMsg:[dic objectForKey:RET_DESC_NAME]];
    }
    
	return code;
}

+ (ConnectionAndParserResultCode)handleMsgGet:(NSDictionary *)jsonData {
    
    return 0;
}

#pragma mark - upload image

+ (ImageObject *)handleImageUploadResponseData:(NSData *)jsonData

                             connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate

                                           url:(NSString *)url {
    
    
    
    NSLog(@"data str: %@", [[[NSString alloc] initWithData:jsonData
                             
                                                  encoding:NSUTF8StringEncoding] autorelease]);
    
    
    
    NSDictionary *resultDic = [jsonData objectFromJSONData];
    
    NSInteger ret = [self parserResponseDic:resultDic
                     
                          connectorDelegate:connectorDelegate
                     
                                        url:url];
    
    
    
    if (EC_DEBUG) {
        
        NSLog(@"return content: %@", resultDic);
        
    }
    
    
    
    if (ret != SUCCESS_CODE) {
        
        return nil;
        
    }
    
    
    
    ImageObject *imageObj = [[[ImageObject alloc] init] autorelease];
    
    
    
    NSDictionary *thumbnailDic = OBJ_FROM_DIC(resultDic, @"thumbnailImage");
    
    
    
    imageObj.thumbnailUrl = OBJ_FROM_DIC(thumbnailDic, @"imageUrl");
    
    imageObj.thumbnailWidth = FLOAT_VALUE_FROM_DIC(thumbnailDic, @"width");
    
    imageObj.thumbnailHeight = FLOAT_VALUE_FROM_DIC(thumbnailDic, @"height");
    
    
    
    NSDictionary *middleDic = OBJ_FROM_DIC(resultDic, @"middleImage");
    
    imageObj.middleUrl = OBJ_FROM_DIC(middleDic, @"imageUrl");
    
    imageObj.middleSizeWidth = FLOAT_VALUE_FROM_DIC(middleDic, @"width");
    
    imageObj.middleSizeHeight = FLOAT_VALUE_FROM_DIC(middleDic, @"width");
    
    
    
    NSDictionary *originalDic = OBJ_FROM_DIC(resultDic, @"originalImage");
    
    imageObj.originalUrl = OBJ_FROM_DIC(originalDic, @"imageUrl");
    
    imageObj.originalSizeWidth = FLOAT_VALUE_FROM_DIC(originalDic, @"width");
    
    imageObj.originalSizeHeight = FLOAT_VALUE_FROM_DIC(originalDic, @"height");
    
    
    
    return imageObj;
    
}

#pragma mark - group list
+ (ConnectionAndParserResultCode)handleGroupList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSArray *videos = OBJ_FROM_DIC(contentDic, @"groupList");
    for (NSDictionary *dic in videos) {
        
        int groupId = INT_VALUE_FROM_DIC(dic, @"groupId");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(groupId == %d)", groupId];
        ChatGroupDataModal *course =(ChatGroupDataModal *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                        entityName:@"ChatGroupDataModal"
                                                                                      sortDescKeys:nil
                                                                                         predicate:predicate];
        
        if (course) {
            [course updateData:dic];
            continue;
        }else {
            course = (ChatGroupDataModal *)[NSEntityDescription insertNewObjectForEntityForName:@"ChatGroupDataModal" inManagedObjectContext:MOC];
            [course updateData:dic];
        }
        
        DLog(@"%d", [course.canChat integerValue]);
        
        
    }
    
    return [self saveMOC:MOC];
}


#pragma mark - login
+ (ConnectionAndParserResultCode)handleLogin:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }else if([code isEqualToString:@"301"]) {
        return USERNAME_ERR_CODE;
    }else if([code isEqualToString:@"302"]) {
        return PASSWORD_ERR_CODE;
    }else if([code isEqualToString:@"303"]) {
        return ACCOUNT_INVALID_CODE;
    }else if([code isEqualToString:@"103"]) {
        return DB_ERROR_CODE;
    }else{
        return ERR_CODE;
    }
    
    
}



#pragma mark - information list

+ (ConnectionAndParserResultCode)handleInformationList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(informationID == %d)", param1];
        
        InformationList *infoList = (InformationList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                entityName:@"InformationList"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"InformationList" predicate:predicate  ];
            [infoList updateData:dic];
        }else
        {
            infoList = (InformationList *)[NSEntityDescription insertNewObjectForEntityForName:@"InformationList" inManagedObjectContext:MOC];
            [infoList updateData:dic];
        }
        
        //        DLog(@"%@", infoList.title);
        
        
    }
    
    return [self saveMOC:MOC];
}

#pragma mark - imagelist

+ (ConnectionAndParserResultCode)handleImageList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imageID == %d)", param1];
        
        ImageList *infoList = (ImageList *) [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                        entityName:@"ImageList"
                                                                      sortDescKeys:nil
                                                                         predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic];
        }else
        {
            infoList = (ImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"ImageList" inManagedObjectContext:MOC];
            [infoList updateData:dic];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleBusinessImageList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC pid:(int)pid {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(imageID == %d)", param1];
        
        BusinessImageList *infoList = (BusinessImageList *) [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                        entityName:@"BusinessImageList"
                                                                      sortDescKeys:nil
                                                                         predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic projectId:pid];
        }else
        {
            infoList = (BusinessImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"BusinessImageList" inManagedObjectContext:MOC];
            [infoList updateData:dic projectId:pid];
        }
    }
    
    return [self saveMOC:MOC];
}

#pragma mark - update reader

+ (ConnectionAndParserResultCode)handleUpdateReader:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }else
        return ERR_CODE;
}

#pragma mark - user profile
+ (ConnectionAndParserResultCode)handleUserProfile:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
//    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
//    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        NSString *userPageNoCountStr = [dic objectForKey:@"totalPage"];
        [AppManager instance].userPageNoCount = [userPageNoCountStr intValue];
        return SUCCESS_CODE;
    }
    
    return ERR_CODE;
}

#pragma mark - business category
+ (ConnectionAndParserResultCode)handleBusinessCategory:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(businessId == %d)", param1];
        
        BusinessItemModel *infoList =(BusinessItemModel *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                        entityName:@"BusinessItemModel"
                                                                                      sortDescKeys:nil
                                                                                         predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"BusinessItemModel" predicate:predicate];
            [infoList updateData:dic];
        }else
        {
            infoList = (BusinessItemModel *)[NSEntityDescription insertNewObjectForEntityForName:@"BusinessItemModel" inManagedObjectContext:MOC];
            [infoList updateData:dic];
            
            
            //            NSMutableArray *detailArrayList = [NSMutableArray array];
            //
            //            NSArray *detailList = [dic objectForKey:@"list1"];
            //            for (NSDictionary *detailDict in detailList) {
            //
            //
            //                int detailParam1 = INT_VALUE_FROM_DIC(detailDict, @"param1");
            //
            //
            //                NSPredicate *detailPredicate = [NSPredicate predicateWithFormat:@"(id == %d)", detailParam1];
            //
            //            BusinessItemDetailModel *detailModel = (BusinessItemDetailModel *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
            //                                                                                                     entityName:@"BusinessItemDetailModel"
            //                                                                                                   sortDescKeys:nil
            //                                                                                                      predicate:detailPredicate];
            //
            //                [detailArrayList addObject:detailModel];
            //            }
            //
            //            infoList.detailList = detailArrayList;
        }
        
        
    }
    
    return [self saveMOC:MOC];
}

#pragma mark -- apply member list
+ (ConnectionAndParserResultCode)handleApplyMemberList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSArray *list = OBJ_FROM_DIC(contentDic, @"userList");
    for (NSDictionary *dict in list) {
        {
            
            int userId = INT_VALUE_FROM_DIC(dict, @"userId");
            int eventId = INT_VALUE_FROM_DIC(dict, @"eventId");
            int displayIndex = INT_VALUE_FROM_DIC(dict, @"displayIndex");
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId == %d and eventId = %d and  displayIndex == %d)", userId, eventId,displayIndex];
            
            EventApplyMemberList *infoList =(EventApplyMemberList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                                  entityName:@"EventApplyMemberList"
                                                                                                sortDescKeys:nil
                                                                                                   predicate:predicate];
            
            if (infoList) {
                [infoList updateData:dict];
            }else
            {
                infoList = (EventApplyMemberList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventApplyMemberList" inManagedObjectContext:MOC];
                [infoList updateData:dict];
                
            }
        }
        
    }
    
    return [self saveMOC:MOC];
}

#pragma mark -- submit apply

+ (ConnectionAndParserResultCode)handleSubmitApply:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }
    
    return ERR_CODE;
}

#pragma mark -- submit join chat group

+ (ConnectionAndParserResultCode)handleSubmitJoinChatGroup:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }else if ([code isEqualToString:@"307"]) {
        return GROUP_NEED_AUDIT_JOIN;
    }else if([code isEqualToString:@"308"]) {
        return GROUP_APPLY_JOINED;
    }
    
    return ERR_CODE;
}

+ (ConnectionAndParserResultCode)handleSubmitExitChatGroup:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }else if ([code isEqualToString:@"309"]) {
        return GROUP_EXIT_FAILED;
    }
    
    return [code integerValue];
    return ERR_CODE;
}

#pragma mark - submit vote

+ (ConnectionAndParserResultCode)handleSubmitVote:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }
    
    return ERR_CODE;
}

#pragma mark - category

+ (ConnectionAndParserResultCode)handleCategory:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        
        return SUCCESS_CODE;
        
    }
    
    return ERR_CODE;
}

#pragma mark - eventlist

+ (ConnectionAndParserResultCode)handleEventList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC type:(int)type {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"eventList");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"eventId");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventId == %d)", param1];
        
        EventList *infoList =(EventList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                        entityName:@"EventList"
                                                                      sortDescKeys:nil
                                                                         predicate:predicate];
        
        if (infoList) {
//            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"EventList" predicate:predicate];
            [infoList updateData:dic withType:type];
        }else {
            infoList = (EventList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventList" inManagedObjectContext:MOC];
            
            NSArray *imageArray = [dic objectForKey:@"imageList"];
            if (![imageArray isEqual:[NSNull null]])
            for (int i  = 0; i < imageArray.count; ++i) {
                NSDictionary *imageDict = [imageArray objectAtIndex:i];
                
                NSString *url = [imageDict objectForKey:@"imageUrl"];
                
                
                EventImageList * im = (EventImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventImageList" inManagedObjectContext:MOC];
                
                im.imageUrl = url;
                [infoList addEventImageListObject:im];
                
            }

            //-----------------
            NSArray *applyList = [dic objectForKey:@"applyList"];
            if (![applyList isEqual:[NSNull null]]) {
                for (int i  = 0; i < applyList.count; ++i) {
                    NSDictionary *applyDict = [applyList objectAtIndex:i];
                    
                    int applyId = [[applyDict objectForKey:@"applyId"] integerValue];
                    NSString *applyResult = [applyDict objectForKey:@"applyResult"];
                    NSString *applyTitle = [applyDict objectForKey:@"applyTitle"];
                                        
                    EventApplyList * apply = (EventApplyList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventApplyList" inManagedObjectContext:MOC];
                    
                    apply.applyId = NUMBER(applyId);
                    apply.applyResult = applyResult;
                    apply.applyTitle = applyTitle;
                    
                    [infoList addEventApplyListObject:apply];
                }
            }
            
            [infoList updateData:dic withType:type];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleEventVoteList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"eventList");
    
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"voteId");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(voteId == %d)", param1];
        
        EventVoteList *infoList =(EventVoteList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                entityName:@"EventVoteList"
                                                                              sortDescKeys:nil
                                                                                 predicate:predicate];
        
        if (infoList) {
//            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"EventVoteList" predicate:predicate];
            [infoList updateData:dic];
        }else {
            infoList = (EventVoteList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventVoteList" inManagedObjectContext:MOC];
            
            NSArray *dataArr = [dic objectForKey:@"displayIndex"];
            
            for (int i  = 0; i < dataArr.count; ++i) {
                NSDictionary *imageDict = [dataArr objectAtIndex:i];
                
                EventOptionList *im = (EventOptionList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventOptionList" inManagedObjectContext:MOC];
                [im updateData:imageDict];
                [infoList addDisplayIndexObject:im];
            }
            
            [infoList updateData:dic];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleEventCommentList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC commentType:(int)type {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    
    [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"CommentList" predicate:nil];
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"eventList");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"commentId");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(commentId == %d)", param1];
        
        CommentList *infoList =(CommentList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                            entityName:@"CommentList"
                                                                          sortDescKeys:nil
                                                                             predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic commentType:type];
        }else
        {
            infoList = (CommentList *)[NSEntityDescription insertNewObjectForEntityForName:@"CommentList" inManagedObjectContext:MOC];
            [infoList updateData:dic commentType:type];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleSubmitComment:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        
        return SUCCESS_CODE;
        
    }
    
    return ERR_CODE;
}

+ (ConnectionAndParserResultCode)handleEventDetailList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC type:(int)type {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    //    for (NSDictionary *dic in list)
        
    int param1 = INT_VALUE_FROM_DIC(contentDic, @"eventId");
    DLog(@"%d", param1);
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(eventId == %d)", param1];
        
    EventDetailList *infoList =(EventDetailList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                    entityName:@"EventDetailList"
                                                                                  sortDescKeys:nil
                                                                                     predicate:predicate];
        
    if (infoList) {
//           [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"EventDetailList" predicate:predicate];
        [infoList updateData:dic];
    }else {
        infoList = (EventDetailList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventDetailList" inManagedObjectContext:MOC];
            
        NSArray *imageArray = [contentDic objectForKey:@"imageList"];
        if (![imageArray isEqual:[NSNull null]])
        for (int i  = 0; i < imageArray.count; ++i) {
            NSDictionary *imageDict = [imageArray objectAtIndex:i];
                
            NSString *url = [imageDict objectForKey:@"imageUrl"];
                
            EventImageDetailList * im = (EventImageDetailList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventImageDetailList" inManagedObjectContext:MOC];
                
            im.imageUrl=url;
            im.eventDetailType = [NSNumber numberWithInt:type];
            [infoList addEventImageDetailListObject:im];
                
        }
            
        NSArray *applyList = [contentDic objectForKey:@"applyList"];
        if (![applyList isEqual:[NSNull null]])
                
            for (NSDictionary *applyDict in applyList) {
                int applyId = INT_VALUE_FROM_DIC(applyDict, @"applyId");
                NSString * applyResult = OBJ_FROM_DIC(applyDict, @"applyResult");
                NSString * applyTitle = OBJ_FROM_DIC(applyDict, @"applyTitle");
                
                EventApplyList * eal = (EventApplyList *)[NSEntityDescription insertNewObjectForEntityForName:@"EventApplyList" inManagedObjectContext:MOC];
                    
                eal.applyId = NUMBER(applyId);
                eal.applyResult = applyResult;
                eal.applyTitle = applyTitle;
                    
                    
                [infoList addEventApplyListObject:eal];
                    
            }
            
        [infoList updateData:contentDic];
    }
    return [self saveMOC:MOC];
}

#pragma mark - training

+ (ConnectionAndParserResultCode)handleCategoryCourse:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"trainingList");
    
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"trainingCategoryID");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trainingCategoryID == %d)", param1];
        
        TrainingList *infoList =(TrainingList *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                entityName:@"TrainingList"
                                                                              sortDescKeys:nil
                                                                                 predicate:predicate];
        
        if (infoList) {
//            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"TrainingList" predicate:predicate];
            [infoList updateData:dic];
        } else {
        
            infoList = (TrainingList *)[NSEntityDescription insertNewObjectForEntityForName:@"TrainingList" inManagedObjectContext:MOC];
            
            NSArray *dataArr = [dic objectForKey:@"courseList"];
            
            for (int i  = 0; i < dataArr.count; ++i) {
                NSDictionary *imageDict = [dataArr objectAtIndex:i];
                
                CourseList *im = (CourseList *)[NSEntityDescription insertNewObjectForEntityForName:@"CourseList"   inManagedObjectContext:MOC];
                [im updateData:imageDict];
                [infoList addCourseListsObject:im];
            
                [infoList updateData:dic];
            }
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleBookList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bookID == %d)", param1];
        
        BookList *infoList = (BookList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                               entityName:@"BookList"
                                                                             sortDescKeys:nil
                                                                                predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic];
        }else
        {
            infoList = (BookList *)[NSEntityDescription insertNewObjectForEntityForName:@"BookList" inManagedObjectContext:MOC];
            [infoList updateData:dic];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleBookImageList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
    for (NSDictionary *dic in list) {
        
        int param1 = INT_VALUE_FROM_DIC(dic, @"param1");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(bookID == %d)", param1];
        
        BookImageList *infoList = (BookImageList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                               entityName:@"BookImageList"
                                                                             sortDescKeys:nil
                                                                                predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic];
        }else
        {
            infoList = (BookImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"BookImageList" inManagedObjectContext:MOC];
            [infoList updateData:dic];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleCoureseChapter:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *dict = OBJ_FROM_DIC(dic, @"content");
    NSDictionary *dict1 = OBJ_FROM_DIC(dict, @"course");
    if (!dict || !dict1) {
        return ERR_CODE;
    }
    int param1 = INT_VALUE_FROM_DIC(dict1, @"trainingCourseID");
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(trainingCourseID == %d)", param1];
    
    CourseDetailList *infoList = (CourseDetailList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                 entityName:@"CourseDetailList"
                                                                               sortDescKeys:nil
                                                                                  predicate:predicate];
        
    if (infoList) {
//            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"CourseDetailList" predicate:predicate];
//        [WXWCoreDataUtils unLoadObject:MOC predicate:predicate entityName:@"CourseDetailList"];
//        [infoList updateData:dict1];
    } else {
        infoList = (CourseDetailList *)[NSEntityDescription insertNewObjectForEntityForName:@"CourseDetailList" inManagedObjectContext:MOC];
    }
    
    [infoList updateData:dict1 withTimestamp:[[dic objectForKey:@"timestamp"] doubleValue]];
    NSArray *dataArr = [dict1 objectForKey:@"chapterList"];
    
    for (int i  = 0; i < dataArr.count; ++i) {
        NSDictionary *imageDict = [dataArr objectAtIndex:i];
        NSString *chapterID = [imageDict objectForKey:@"chapterID"];
        
        
        
        
        if (![chapterID isEqual:[NSNull null]] && ![chapterID isEqualToString:@""]) {
            
            
            NSPredicate *predicateChapter = [NSPredicate predicateWithFormat:@"(chapterID == %d)", [chapterID intValue]];
            
            ChapterList *chapterIm = (ChapterList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                entityName:@"ChapterList"
                                                                              sortDescKeys:nil
                                                                                 predicate:predicateChapter];
            
            
            
            
            if (chapterIm) {
                [chapterIm updateData:imageDict withCourseId:infoList.trainingCourseID];                
                chapterIm.index = NUMBER(i);
            }else{
                
                ChapterList *chapterIm = (ChapterList *)[NSEntityDescription insertNewObjectForEntityForName:@"ChapterList" inManagedObjectContext:MOC];
                [chapterIm updateData:imageDict withCourseId:infoList.trainingCourseID];
                chapterIm.index = NUMBER(i);
                [infoList addChapterListsObject:chapterIm];
            }
            
        }
    }
    
    return [self saveMOC:MOC];
}


+ (ConnectionAndParserResultCode)handleChapterCompletion:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        
        return SUCCESS_CODE;
        
    }
    
    return ERR_CODE;
}


#pragma mark -- private member list
+ (ConnectionAndParserResultCode)handlePrivateMemberList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSArray *list = OBJ_FROM_DIC(contentDic, @"userList");
    for (NSDictionary *dict in list) {
        {
            int displayIndex = INT_VALUE_FROM_DIC(dict, @"displayIndex");
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(displayIndex == %d)",displayIndex];
            
            PrivateUserListDataModal *infoList =(PrivateUserListDataModal *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                                  entityName:@"PrivateUserListDataModal"
                                                                                                sortDescKeys:nil
                                                                                                   predicate:predicate];
            
            if (infoList) {
                [infoList updateData:dict];
            }else
            {
                infoList = (PrivateUserListDataModal *)[NSEntityDescription insertNewObjectForEntityForName:@"PrivateUserListDataModal" inManagedObjectContext:MOC];
                [infoList updateData:dict];
                
            }
        }
        
    }
    
    return [self saveMOC:MOC];
}


#pragma mark -- friend list
+ (ConnectionAndParserResultCode)handleFriendList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSArray *list = OBJ_FROM_DIC(contentDic, @"userList");
    for (NSDictionary *dict in list) {
        {
            int displayIndex = INT_VALUE_FROM_DIC(dict, @"displayIndex");
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(displayIndex == %d)",displayIndex];
            
            FirendUserListDataModal *infoList =(FirendUserListDataModal *)  [WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                                                          entityName:@"FirendUserListDataModal"
                                                                                                        sortDescKeys:nil
                                                                                                           predicate:predicate];
            
            if (infoList) {
                [infoList updateData:dict];
            }else
            {
                infoList = (FirendUserListDataModal *)[NSEntityDescription insertNewObjectForEntityForName:@"FirendUserListDataModal" inManagedObjectContext:MOC];
                [infoList updateData:dict];
                
            }
        }
        
    }
    
    return [self saveMOC:MOC];
}



#pragma mark -- update chat group
+ (ConnectionAndParserResultCode)handleUpdateChatGroup:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        
        return SUCCESS_CODE;
        
    }
    
    return ERR_CODE;
}

#pragma mark -- update chat group
+ (ConnectionAndParserResultCode)handleUpdateVersion:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC
{
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        
        return SUCCESS_CODE;
        
    }else if ([code isEqualToString:@"220"]) {
        return SOFT_UPDATE_CODE;
    }
    
    return ERR_CODE;
}



+ (ConnectionAndParserResultCode)handleSubmitPrivateLetter:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSString *code = [dic objectForKey:@"code"];
    if (![code isEqual:[NSNull null]]) {
        if ([code isEqualToString:@"200"]) {
            return SUCCESS_CODE;
        }
    }
    
    return ERR_CODE;
}

+ (ConnectionAndParserResultCode)handleOrderList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"orderList");
    for (NSDictionary *dic in list) {
        
        NSString *param1 = [dic objectForKey:@"orderId"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(orderID == %@)", param1];
        
        OrderList *infoList = (OrderList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                       entityName:@"OrderList"
                                                                     sortDescKeys:nil
                                                                        predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"InformationList" predicate:predicate  ];
            [infoList updateData:dic];
        }else {
            
            infoList = (OrderList *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderList"
                                                                  inManagedObjectContext:MOC];
            
//            NSArray *details = OBJ_FROM_DIC(dic, @"orderDetailList");
//            
//            for (NSDictionary *dic1 in details) {
//                
//                OrderDetailList *orderDetail = (OrderDetailList *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderDetailList" inManagedObjectContext:MOC];
//                [orderDetail updateData:dic1];
//                [infoList addDetailListObject:orderDetail];
//                
//                NSArray *images = OBJ_FROM_DIC(dic1, @"imageList");
//                
//                for (NSDictionary *dic2 in images) {
//                    OrderImageList *orderImage = (OrderImageList *)[NSEntityDescription insertNewObjectForEntityForName:@"OrderImageList" inManagedObjectContext:MOC];
//                    [orderImage updateData:dic2];
//                    [orderDetail addImagesObject:orderImage];
//                }
//            }
            [infoList updateData:dic];
        }
        
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleMessageList:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    //    NSLog(@"dic: %@", contentDic);
    
    NSArray *list = OBJ_FROM_DIC(contentDic, @"msgList");
    for (NSDictionary *dic in list) {
        
        NSString *param1 = OBJ_FROM_DIC(dic, @"MessageId");
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(messageId == %@)", param1];
        
        MessageList *infoList = (MessageList *)[WXWCoreDataUtils hasSameObjectAlready:MOC
                                                                           entityName:@"MessageList"
                                                                         sortDescKeys:nil
                                                                            predicate:predicate];
        
        if (infoList) {
            //            [WXWCoreDataUtils deleteEntitiesFromMOC:MOC entityName:@"ImageList" predicate:predicate];
            
            [infoList updateData:dic];
        }else
        {
            infoList = (MessageList *)[NSEntityDescription insertNewObjectForEntityForName:@"MessageList" inManagedObjectContext:MOC];
            [infoList updateData:dic];
        }
    }
    
    return [self saveMOC:MOC];
}

+ (ConnectionAndParserResultCode)handleSendText:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSString *code = [dic objectForKey:@"Code"];
    if (![code isEqual:[NSNull null]]) {
        if ([code isEqualToString:@"200"]) {
            return SUCCESS_CODE;
        }
    }
    
    return ERR_CODE;
}

+ (ConnectionAndParserResultCode)handleSendImage:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSString *code = [dic objectForKey:@"Code"];
    if (![code isEqual:[NSNull null]]) {
        if ([code isEqualToString:@"200"]) {
            return SUCCESS_CODE;
        }
    }
    
    return ERR_CODE;
}

+ (ConnectionAndParserResultCode)handleChangePwd:(NSDictionary *)dic MOC:(NSManagedObjectContext *)MOC {
    NSString *code = [dic objectForKey:@"code"];
    if ([code isEqualToString:@"200"]) {
        return SUCCESS_CODE;
    }else if ([code isEqualToString:@"425"]) {
        return PASSWORD_OLD_ERR_CODE;
    }else {
        return ERR_CODE;
    }
}

+ (NSInteger)parserResponseJsonData:(NSData *)jsonData
                               type:(WebItemType)type
                                MOC:(NSManagedObjectContext *)MOC
                  connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                                url:(NSString *)url
                            paramID:(int)pid {
    
    NSDictionary *resultDic = [jsonData objectFromJSONData];
    NSInteger ret = [self parserResponseDic:resultDic
                          connectorDelegate:connectorDelegate
                                        url:url];
    
    if (EC_DEBUG) {
        //        NSLog(@"return content: %@", resultDic);
    }
    
    switch (type) {
            
        case LOGIN_TY:
            ret = [self handleLogin:resultDic MOC:MOC];;
            break;
            
        case SUBMIT_CREAT_CHAT_GROUP_TY:
        case LOAD_COMMUNICATE_GROUP_LIST_TY:
            ret = [self handleGroupList:resultDic MOC:MOC];
            break;
        case LOAD_INFORMATION_LIST_TY:
            ret = [self handleInformationList:resultDic MOC:MOC];
            break;
        case LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY:
            ret = [self handleInformationList:resultDic MOC:MOC];
            break;
        case SEARCH_INFORMATION_LIST_TY:
            ret = [self handleInformationList:resultDic MOC:MOC];
            break;
        case LOAD_IMAGE_LIST_TY:
            ret = [self handleImageList:resultDic MOC:MOC];
            break;
        case LOAD_BUSINESS_IMAGE_LIST_TY:
            ret = [self handleBusinessImageList:resultDic MOC:MOC pid:pid];
            break;
        case UPDATE_READER_TY:
            ret = [self handleUpdateReader:resultDic MOC:MOC];
            break;
        case GET_USER_PROFILES:
            ret = [self handleUserProfile:resultDic MOC:MOC];
            break;
        case LOAD_CATEGORY_TY:
            ret = [self handleCategory:resultDic MOC:MOC];
            break;
        case LOAD_EVENT_PRE_TY:
            ret = [self handleEventList:resultDic MOC:MOC type:1];
            break;
        case LOAD_EVENT_REV_TY:
            ret = [self handleEventList:resultDic MOC:MOC type:2];
            break;
        case LOAD_EVENT_DETAIL_PRE_TY:
            ret = [self handleEventDetailList:resultDic MOC:MOC type:1];
            break;
        case LOAD_EVENT_DETAIL_REV_TY:
            ret = [self handleEventDetailList:resultDic MOC:MOC type:2];
            break;
        case LOAD_EVENT_VOTE_LIST:
            ret = [self handleEventVoteList:resultDic MOC:MOC];
            break;
        case LOAD_EVENT_COMMENT_TY:
            ret = [self handleEventCommentList:resultDic MOC:MOC commentType:2];
            break;
        case SUBMIT_EVENT_COMMENT_TY:
            ret = [self handleSubmitComment:resultDic MOC:MOC];
            break;
        case LOAD_INFORMATION_COMMENT_TY:
            ret = [self handleEventCommentList:resultDic MOC:MOC commentType:1];
            break;
        case SUBMIT_INFORMATION_COMMENT_TY:
            ret = [self handleSubmitComment:resultDic MOC:MOC];
            break;
            
        case GET_BUSINESS_CATEGORY:
            ret = [self handleBusinessCategory:resultDic MOC:MOC];
            break;
            
        case GET_APPLY_MEMBER_LIST_TY:
            ret = [self handleApplyMemberList:resultDic MOC:MOC];
            break;
        case SUBMIT_APPLY_TY:
            ret = [self handleSubmitApply:resultDic MOC:MOC];
            break;
        case SUBMIT_VOTE_TY:
            ret = [self handleSubmitVote:resultDic MOC:MOC];
            break;
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
            ret = [self handleSubmitJoinChatGroup:resultDic MOC:MOC];
            break;
            
        case SUBMIT_QUIT_CHAT_GROUP_TY:
            ret = [self handleSubmitExitChatGroup:resultDic MOC:MOC];
            break;
            
        case GET_BOOK_LIST_TY:
            ret = [self handleBookList:resultDic MOC:MOC];
            break;
        case GET_BOOK_IMAGE_LIST:
            ret = [self handleBookImageList:resultDic MOC:MOC];
            break;

        case GET_TRAINING_LIST_TY:
            ret = [self handleCategoryCourse:resultDic MOC:MOC];
            break;
        case GET_COURSE_CHAPTER_TY:
            ret = [self handleCoureseChapter:resultDic MOC:MOC];
            break;
        case SUBMIT_CHAPTER_COMPLETION_TY:
            ret = [self handleChapterCompletion:resultDic MOC:MOC];
            break;
            
        case GET_FRIEND_LETTER_USER_LIST_TY:
            ret = [self handleFriendList:resultDic MOC:MOC];
            break;
        case GET_PRIVATE_LETTER_USER_LIST_TY:
            ret = [self handlePrivateMemberList:resultDic MOC:MOC];
            break;
            
        case LOAD_UPDATE_VERSION_TY:
            ret = [self handleUpdateVersion:resultDic MOC:MOC];
            break;
            
        case SUBMIT_DELETE_CHAT_GROUP_TY:
        case SUBMIT_UPDATE_CHAT_GROUP_TY:
        case SUBMIT_FEEDBACK_TY:
            ret = [self handleUpdateChatGroup:resultDic MOC:MOC];
            break;
            
        case LOAD_BIZ_POST_TY:
            ret = [self handlePost:resultDic MOC:MOC];
            break;
            
        case SUBMIT_PRIVETE_LETTER_TY:
            ret = [self handleSubmitPrivateLetter:resultDic MOC:MOC];
            break;
        case LOAD_ORDER_LIST_TY:
            ret = [self handleOrderList:resultDic MOC:MOC];
            break;
        case LOAD_MESSAGE_LIST_TY:
            ret = [self handleMessageList:resultDic MOC:MOC];
            break;
        case SEND_MESSAGE_TEXT_TY:
            ret = [self handleSendText:resultDic MOC:MOC];
            break;
        case SEND_MESSAGE_IMAGE_TY:
            ret = [self handleSendImage:resultDic MOC:MOC];
            break;
        case SUBMIT_NEW_PWD_TY:
            ret = [self handleChangePwd:resultDic MOC:MOC];
            break;
        default:
            break;
    }
    return ret;
}

#pragma mark - handle post list

+ (ConnectionAndParserResultCode)handlePost:(NSDictionary *)dic
                                        MOC:(NSManagedObjectContext *)MOC {
    
    NSDictionary *contentDic = [dic objectForKey:@"content"];
    if ([contentDic isKindOfClass:[NSNull class]]) {
        return NO_DATA_CODE;
    }
    
    NSArray *posts = OBJ_FROM_DIC(contentDic, @"posts");
    if(posts == nil || ![posts isKindOfClass:[NSArray class]]) {
        return NO_DATA_CODE;
    }
    
    for (NSDictionary* postDic in posts) {
        
        NSString *postId = OBJ_FROM_DIC(postDic, @"postId");
        if ([WXWCoreDataUtils objectInMOC:MOC
                               entityName:@"Post"
                                predicate:[NSPredicate predicateWithFormat:@"(postId == %@)", postId]]) {
            continue;
        }
        
        Post *post = (Post *)[NSEntityDescription insertNewObjectForEntityForName:@"Post"
                                                           inManagedObjectContext:MOC];
        post.postId = postId;
        post.postType = @(INT_VALUE_FROM_DIC(postDic, @"postType"));
        post.content = [CommonUtils decodeAndReplacePlusForText:OBJ_FROM_DIC(postDic, @"message")];
        post.authorId = OBJ_FROM_DIC(postDic, @"authorId");
        post.authorName = OBJ_FROM_DIC(postDic, @"authorName");
        post.authorComany = OBJ_FROM_DIC(postDic, @"authorComany");
        post.authorImageUrl = OBJ_FROM_DIC(postDic, @"authorImageUrl");
        if(post.authorImageUrl==nil)
            post.authorImageUrl = @"";
        post.authorSchoolInfo = OBJ_FROM_DIC(postDic, @"authorSchoolInfo");
        post.createdTime = OBJ_FROM_DIC(postDic, @"createTime");
        post.timestamp =  OBJ_FROM_DIC(postDic, @"timestamp");
        post.distance = @(INT_VALUE_FROM_DIC(postDic, @"distance"));
        post.imageUrl = OBJ_FROM_DIC(postDic, @"image");
        post.thumbnailImageUrl = OBJ_FROM_DIC(postDic, @"thumbnailImageUrl");
        post.middleImageUrl = OBJ_FROM_DIC(postDic, @"middleImageUrl");
        post.liked = @(INT_VALUE_FROM_DIC(postDic, @"isLike"));
        post.likeCount = @(INT_VALUE_FROM_DIC(postDic, @"likeCount"));
        post.attentionCount = @(INT_VALUE_FROM_DIC(postDic, @"attentionCount"));
        post.isAttention =@(INT_VALUE_FROM_DIC(postDic, @"isAttention"));
        post.latitude = @(INT_VALUE_FROM_DIC(postDic, @"latitude"));
        post.longitude = @(INT_VALUE_FROM_DIC(postDic, @"lontitude"));
        post.plat = OBJ_FROM_DIC(postDic, @"plat");
        if (post.plat.length == 0) {
            post.plat = @"pc";
        }
        post.version = OBJ_FROM_DIC(postDic, @"version");
        post.commentCount = @(INT_VALUE_FROM_DIC(postDic, @"commentCount"));
        post.shareCount = @(INT_VALUE_FROM_DIC(postDic, @"shareCounts"));
        post.order = @(INT_VALUE_FROM_DIC(postDic, @"displayIndex"));
        post.groupId = @(INT_VALUE_FROM_DIC(postDic, @"groupId"));
        post.hasImage =@(INT_VALUE_FROM_DIC(postDic, @"hasImage"));
        post.originalImageHeight = @(INT_VALUE_FROM_DIC(postDic, @"originalImageWidth"));
        post.originalImageWidth = @(INT_VALUE_FROM_DIC(postDic, @"originalImageHeight"));
        post.thumbnailWidth = @(INT_VALUE_FROM_DIC(postDic, @"thumbnailWidth"));
        post.thumbnailHeight = @(INT_VALUE_FROM_DIC(postDic, @"thumbnailHeight"));
        post.middleSizeWidth = @(INT_VALUE_FROM_DIC(postDic, @"middleImageWidth"));
        post.middleSizeHeight = @(INT_VALUE_FROM_DIC(postDic,@"middleImageHeight"));
        
        post.tagNames = OBJ_FROM_DIC(postDic, @"tags");
        post.attentionType = @(INT_VALUE_FROM_DIC(postDic,@"attentionType"));
        
        NSDate *postDate = nil;
        NSTimeInterval timestamp = 0;
        if (post.createdTime && post.createdTime.length > 0) {
            timestamp = [post.createdTime doubleValue];
            postDate = [CommonUtils convertDateTimeFromUnixTS:timestamp];
            post.elapsedTime = [CommonUtils getElapsedTime:postDate];
        }
    }
    
    return [self saveMOC:MOC];
}

@end
