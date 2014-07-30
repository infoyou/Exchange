//
//  WXWDBConnection.m
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWDBConnection.h"
#import "WXWStatement.h"
#import "WXWDebugLogOutput.h"
#import "WXWCommonUtils.h"
#import "WXWSystemInfoManager.h"
#import "WXWUIUtils.h"

static sqlite3* theDB		= nil;

@implementation WXWDBConnection

+ (NSString *)assembleBizDBPath:(NSString *)dbFileName {
	NSString *docDir = [WXWCommonUtils documentsDirectory];
	NSString *dbPath = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.sqlite", dbFileName, VERSION]];
	return dbPath;
}

+ (sqlite3 *)doOpenDB:(NSString *)dbPath {
	sqlite3 *instance;
	
	if (sqlite3_open([dbPath UTF8String], &instance) != SQLITE_OK) {
		sqlite3_close(instance);
		
		debugLog(@"Failed to open db. Reason: %s", sqlite3_errmsg(instance));
		NSAssert1(0, @"Failed to open db. Reason: %s", sqlite3_errmsg(instance));
		return nil;
	}
	
	return instance;
}

+ (sqlite3 *)openBizDatabase:(NSString *)dbFilename {
  
	NSString *dbPath = [self assembleBizDBPath:dbFilename];
	return [self doOpenDB:dbPath];
}

+ (sqlite3 *)prepareBizDB {
	
	if (theDB == nil) {
		theDB = [self openBizDatabase:DB_NAME];
	}
	
    WXWStatement *imgStmt;
    int ret;
    //-------------------------------web cache-----------------------------
	// prepare table images that be used to cache the images
	imgStmt = [self statementWithQuery:"create table if not exists images (url TEXT PRIMARY KEY, image BLOB, updated_at double);"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'images' table.");
		NSAssert1(0, @"Failed to create 'images' table.", nil);
	}
    //-------------------------------chat cache-----------------------------
    
#if  0
    
    @property (nonatomic, readonly) NSString *uuid;
    
     @property (nonatomic, assign) QPlusMessageType type;
     @property (nonatomic, assign) BOOL isRoomMsg;/*是否是来自群的消息*/
    @property (nonatomic, assign) long date;
    @property (nonatomic, copy) NSString *text;
    @property (nonatomic, strong) id mediaObject;
    @property (nonatomic, assign, setter = setPrivate:) BOOL isPrivate;
    @property (nonatomic, copy) NSString *senderID;
    @property (nonatomic, copy) NSString *receiverID;

#endif
	// prepare table images that be used to cache the images
	imgStmt = [self statementWithQuery:"create table if not exists chats (uuid TEXT PRIMARY KEY, type integer, isRoomMsg integer, data double, text TEXT, messageObject blob, isPrivate integer, senderID TEXT, receiverID text, groupID text, insertData double, isRead integer);"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'images' table.");
		NSAssert1(0, @"Failed to create 'images' table.", nil);
	}
    
    
	// prepare table chatsImage that be used to cache the images
	imgStmt = [self statementWithQuery:"create table if not exists chatsImage (uuid TEXT PRIMARY KEY, resPath TEXT,resURL TEXT, thumbData blob, thumbDataSize long );"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'chatsImage' table.");
		NSAssert1(0, @"Failed to create 'chatsImage' table.", nil);
	}
    
    
    
	// prepare table chatsVoice that be used to cache the images
	imgStmt = [self statementWithQuery:"create table if not exists chatsVoice (uuid TEXT PRIMARY KEY, resPath TEXT,resID TEXT, duration long );"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'chatsVoice' table.");
		NSAssert1(0, @"Failed to create 'chatsVoice' table.", nil);
	}
    
    //-------------------------------user cache-----------------------------
    
    /*
     @property (nonatomic) int userID; //用户id
     @property (nonatomic, copy) NSString *portraitName; //头像
     @property (nonatomic, copy) NSString *chName; //中文名
     @property (nonatomic, copy) NSString *enName; //英文名
     @property (nonatomic, copy) NSString *company; //公司
     @property (nonatomic, copy) NSString *department; //部门
     @property (nonatomic, copy) NSString *position; //职位
     @property (nonatomic, copy) NSString *city; //城市
     @property (nonatomic, copy) NSString *address; //地址
     
     @property (nonatomic, copy) NSString *phone; //手机
     @property (nonatomic, copy) NSString *weixin; //微讯
     @property (nonatomic, copy) NSString *email; //邮箱
     */
	// prepare table images that be used to cache the images
	imgStmt = [self statementWithQuery:"create table if not exists user (userId integer PRIMARY KEY, portraitName TEXT, chName TEXT, enName TEXT, company TEXT, department TEXT, position TEXT, city TEXT, address TEXT, phone TEXT, weixin TEXT,email TEXT, firstChar TEXT, isActivation integer, isFriend integer, timestamp long, isDelete integer);"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'user' table.");
		NSAssert1(0, @"Failed to create 'user' table.", nil);
	}
    //------------------------------------------------------------
    
    //-------------------------------userProp-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists userProfile (userId integer, groupId integer, displayIndex integer, propName TEXT, propValue TEXT,  isFriend integer,  isDelete integer, PRIMARY KEY(userId , groupId, displayIndex));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'user' table.");
		NSAssert1(0, @"Failed to create 'user' table.", nil);
	}
    
    //-------------------------------courseInfo-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists courseInfo (trainingCourseID integer ,trainingCourseTitle TEXT,trainingCourseIntroduction TEXT,  chapterNumber integer, completedChapterNumber integer,timestamp double,isMyCourse integer, isDelete integer, PRIMARY KEY(trainingCourseID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'courseInfo' table.");
		NSAssert1(0, @"Failed to create 'courseInfo' table.", nil);
	}
    
    //--------------------------------courseListInfo-----------------------------
    imgStmt = [self statementWithQuery:"create table if not exists courseListInfo (courseID integer ,courseTitle TEXT, courseType integer, chapterNumber integer, isMyCourse integer default 0, categoryID integer, PRIMARY KEY(courseID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'courseListInfo' table.");
		NSAssert1(0, @"Failed to create 'courseListInfo' table.", nil);
	}
    
    //-------------------------------chapterListInfo-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists chapterListInfo (chapterID  integer ,courseID   integer ,chapterTitle TEXT,chapterFileURL TEXT,  chapterCompletion TEXT,percentage float, isDownloaded integer, isDelete integer, downloadedSize double default 0, fileSize double default 0, PRIMARY KEY(chapterID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'chapterListInfo' table.");
		NSAssert1(0, @"Failed to create 'chapterListInfo' table.", nil);
	}
    
    //-------------------------------business list-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists businessCategoryInfo (param1 integer,param2 TEXT,param3 TEXT,param4 TEXT,param5 TEXT,param6 TEXT,param7 TEXT,param8 TEXT,param9 TEXT,param10 TEXT,param11 TEXT,param12 TEXT, param13 TEXT,param14 TEXT,param15 TEXT,param16 TEXT,param17 TEXT,param18 TEXT,param19 TEXT,param20 TEXT, timestamp double,isDelete integer,PRIMARY KEY(param1));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'businessCategoryInfo' table.");
		NSAssert1(0, @"Failed to create 'businessCategoryInfo' table.", nil);
	}
    //-------------------------------business detail-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists businessDetailInfo (categoryID integer,parentID integer,timestamp double,  param1 TEXT, param2 TEXT, param3 TEXT, param4 TEXT, param5 TEXT, param6 TEXT, param7 TEXT, param8 TEXT, param9 TEXT, param10 TEXT,isDelete int, PRIMARY KEY(categoryID,parentID,param1,param2));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'businessDetailInfo' table.");
		NSAssert1(0, @"Failed to create 'businessDetailInfo' table.", nil);
	}
    
    /*
     @property (nonatomic, retain) NSNumber * imageID;
     @property (nonatomic, retain) NSString * imageURL;
     @property (nonatomic, retain) NSNumber * sortOrder;
     @property (nonatomic, retain) NSString * target;
     @property (nonatomic, retain) NSString * title;
     @property (nonatomic, retain) NSNumber * projectId;
     */
    
    //-------------------------------business detail images-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists businessDetailImages (imageID integer,projectId integer, timestamp double, imageURL TEXT, sortOrder integer, target TEXT, title TEXT,isDelete int, PRIMARY KEY(imageID,projectId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'businessDetailImages' table.");
		NSAssert1(0, @"Failed to create 'businessDetailImages' table.", nil);
	}
    
    
    //--------------
    /*
     @property (nonatomic, retain) NSNumber * imageID;
     @property (nonatomic, retain) NSString * imageURL;
     @property (nonatomic, retain) NSNumber * sortOrder;
     @property (nonatomic, retain) NSString * target;
     @property (nonatomic, retain) NSString * title;
     */
    //-------------------------------info scroll wall view images-----------------------------
	// prepare table images that be used to cache the images
    
	imgStmt = [self statementWithQuery:"create table if not exists infoScrollWallImages (imageID integer, imageURL TEXT, sortOrder integer, target TEXT, title TEXT,timestamp double,isDelete int, PRIMARY KEY(imageID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'infoScrollWallImages' table.");
		NSAssert1(0, @"Failed to create 'infoScrollWallImages' table.", nil);
	}
    
    
    /*
     @property (nonatomic, retain) NSNumber * informationID;
     @property (nonatomic, retain) NSString * title;
     @property (nonatomic, retain) NSString * lastUpdateTime;
     @property (nonatomic, retain) NSNumber * clientID;
     @property (nonatomic, retain) NSString * zipURL;
     @property (nonatomic, retain) NSNumber * sortOrder;
     @property (nonatomic, retain) NSNumber * comment;
     @property (nonatomic, retain) NSNumber * reader;
     @property (nonatomic, retain) NSNumber * linkType;
     @property (nonatomic, retain) NSString * link;
     @property (nonatomic, retain) NSNumber * informationType;
     */
    //-------------------------------brif information list-----------------------------
    
	imgStmt = [self statementWithQuery:"create table if not exists infoList (informationID integer, title TEXT, lastUpdateTime TEXT,clientID integer,zipURL TEXT, htmlURL TEXT, sortOrder integer, comment integer , reader integer , linkType integer, link TEXT, informationType integer, timestamp double, isDelete integer , PRIMARY KEY(informationID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'infoList' table.");
		NSAssert1(0, @"Failed to create 'infoList' table.", nil);
	}
    
    //-------------------------------alone marketing-----------------------------
    
	imgStmt = [self statementWithQuery:"create table if not exists aloneMarketing (param1 TEXT,param2 TEXT,param3 TEXT,param4 TEXT,param5 TEXT,param6 TEXT,param7 TEXT,param8 TEXT,param9 TEXT,param10 TEXT,param11 TEXT,param12 TEXT, param13 TEXT,param14 TEXT,param15 TEXT,param16 TEXT,param17 TEXT,param18 TEXT,param19 TEXT,param20 TEXT, parentId TEXT,timestamp double,isDelete integer,PRIMARY KEY(param1));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'aloneMarketing' table.");
		NSAssert1(0, @"Failed to create 'aloneMarketing' table.", nil);
	}
    
    //-------------------------------circleMarketingImage-----------------------------
    
	imgStmt = [self statementWithQuery:"create table if not exists circleMarketingImage (eventId integer, imageIndex integer,imageType integer, url TEXT,isDelete integer,PRIMARY KEY(eventId, url));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'circleMarketingImage' table.");
		NSAssert1(0, @"Failed to create 'circleMarketingImage' table.", nil);
	}
    
    
    //-------------------------------circleMarketing apply-----------------------------
    
	imgStmt = [self statementWithQuery:"create table if not exists circleMarketingApply (eventId integer, applyId integer,applyResult TEXT, applyTitle TEXT, isDelete integer,PRIMARY KEY(eventId, applyId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'circleMarketingImage' table.");
		NSAssert1(0, @"Failed to create 'circleMarketingImage' table.", nil);
	}
    
    //-------------------------------circleMarketingInfo-----------------------------

	imgStmt = [self statementWithQuery:"create table if not exists circleMarketingInfo (eventId integer,applyCount integer,displayIndex integer,endTime double,endTimeStr TEXT,eventAddress TEXT,eventDescription TEXT,eventTitle TEXT,param1 TEXT,param2 TEXT,param3 TEXT,startTime double,startTimeStr TEXT,eventURL TEXT, eventType integer,applyCheck integer,zipUrl TEXT, applyStatus integer, timestamp double,isDelete integer,PRIMARY KEY(eventId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'circleMarketingInfo' table.");
		NSAssert1(0, @"Failed to create 'circleMarketingInfo' table.", nil);
	}
    
    
    //-------------------------------communicateGroupList-----------------------------
    
	imgStmt = [self statementWithQuery:"create table if not exists communicateGroupList (userId TEXT,canChat integer, canDelete integer,canInvite integer,canQuit integer, canViewLog integer, displayIndex integer, groupDescription TEXT, groupEmail TEXT, groupId integer, groupImage TEXT, groupName TEXT,groupPhone TEXT, groupType integer,groupWebsite TEXT, invitationPublicLevel integer, userCount integer, userStatus integer, auditNeededLevel integer, groupUserImageArray TEXT, groupUserIdArray TEXT, groupUserNameArray TEXT, timestamp double, isDelete integer,PRIMARY KEY(userId,groupId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'circleMarketingInfo' table.");
		NSAssert1(0, @"Failed to create 'circleMarketingInfo' table.", nil);
	}
    //--------------------------------common table-------------------------------------
    
    imgStmt = [self statementWithQuery:"create table if not exists commonTable (commonKey TEXT, commonValue TEXT,PRIMARY KEY(commonKey));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'commonTable' table.");
		NSAssert1(0, @"Failed to create 'commonTable' table.", nil);
	}
    
    
    //--------------------------------book list
    /*
     @property (nonatomic, retain) NSNumber * bookID;
     @property (nonatomic, retain) NSString * bookImage;
     @property (nonatomic, retain) NSString * bookTitle;
     @property (nonatomic, retain) NSString * bookCategory;
     @property (nonatomic, retain) NSNumber * clientID;
     @property (nonatomic, retain) NSNumber * informationType;
     @property (nonatomic, retain) NSString * lastUpdateTime;
     @property (nonatomic, retain) NSString * commendReason;
     @property (nonatomic, retain) NSString * zipURL;
     @property (nonatomic, retain) NSNumber * sortOrder;
     @property (nonatomic, retain) NSNumber * reader;
     @property (nonatomic, retain) NSNumber * linkType;
     @property (nonatomic, retain) NSString * link;
     @property (nonatomic, retain) NSNumber * comment;
     @property (nonatomic, retain) NSString * title;
     */
    imgStmt = [self statementWithQuery:"create table if not exists bookList (bookID integer, bookImage TEXT, bookTitle TEXT,bookCategory TEXT, clientID integer, informationType integer,  lastUpdateTime TEXT, commendReason TEXT, zipURL TEXT,sortOrder integer, reader integer, linkType integer, link TEXT,comment integer, title TEXT, timestamp double, isDelete integer,  PRIMARY KEY(bookID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'commonTable' table.");
		NSAssert1(0, @"Failed to create 'commonTable' table.", nil);
	}
    
    //-------------------------------order list
    
    /*
     @property (nonatomic, retain) NSString * orderCode;
     @property (nonatomic, retain) NSString * orderDate;
     @property (nonatomic, retain) NSString * orderID;
     @property (nonatomic, retain) NSNumber * status;
     @property (nonatomic, retain) NSString * statusDesc;
     @property (nonatomic, retain) NSNumber * totalAmount;
     @property (nonatomic, retain) NSNumber * totalQty;
     @property (nonatomic, retain) NSString * userName;
     @property (nonatomic, retain) NSNumber * vipLevel;
     @property (nonatomic, retain) NSString * timestamp;
     */
    
    imgStmt = [self statementWithQuery:"create table if not exists orderList (orderID TEXT, orderCode TEXT, orderDate TEXT, statusDesc TEXT, status integer, totalAmount integer, totalQty integer, userName TEXT, vipLevel integer, timestamp double, PRIMARY KEY(orderID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'orderList' table.");
		NSAssert1(0, @"Failed to create 'orderList' table.", nil);
	}
    
    //---------------------------------message list
    
    /*
     @property (nonatomic, retain) NSString * messageId;
     @property (nonatomic, retain) NSString * vipId;
     @property (nonatomic, retain) NSString * text;
     @property (nonatomic, retain) NSString * imageUrl;
     @property (nonatomic, retain) NSString * videoUrl;
     @property (nonatomic, retain) NSString * voiceUrl;
     @property (nonatomic, retain) NSString * title;
     @property (nonatomic, retain) NSString * oriUrl;
     */
    
    imgStmt = [self statementWithQuery:"create table if not exists messageList (messageId TEXT, vipId TEXT, text TEXT, imageUrl TEXT, videoUrl TEXT, voiceUrl TEXT, title TEXT, oriUrl TEXT, timestamp double, PRIMARY KEY(messageId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'messageList' table.");
		NSAssert1(0, @"Failed to create 'messageList' table.", nil);
	}
    
    //------------------------- customer table----------
    
    imgStmt = [self statementWithQuery:"create table if not exists customer (vipID TEXT, openID TEXT, weixinID TEXT, headImageUrl TEXT, vipName TEXT, timestamp double, PRIMARY KEY(vipID));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'customer' table.");
		NSAssert1(0, @"Failed to create 'customer' table.", nil);
	}
    
    //------------------------- message table----------
    
    imgStmt = [self statementWithQuery:"create table if not exists message (messageId TEXT, vipId TEXT, materialTypeId integer, text TEXT, imageUrl TEXT, videoUrl TEXT, voiceUrl TEXT, oriUrl TEXT, createTime TEXT, lastUpdateTime TEXT, timestamp double, isMyMessage integer, senderId TEXT, receiverId TEXT, isRead integer, PRIMARY KEY(messageId));"];
    ret = [imgStmt step];
	if (ret != SQLITE_DONE) {
		debugLog(@"Failed to create 'message' table.");
		NSAssert1(0, @"Failed to create 'message' table.", nil);
	}
    
	return theDB;
}

+ (void)closeDB {
	if (theDB) {
		sqlite3_close(theDB);
	}
	
	theDB = nil;
}

+ (WXWStatement *)statementWithQuery:(const char *)sql {
  if (theDB) {
    WXWStatement *stmt = [WXWStatement statementWithDB:theDB query:sql];
    return stmt;
  } else {
    return nil;
  }
}

+ (void)beginTransaction {
	char *errMsg;
	sqlite3_exec(theDB, "BEGIN", NULL, NULL, &errMsg);
}

+ (void)commitTransaction {
	char *errMsg;
	sqlite3_exec(theDB, "COMMIT", NULL, NULL, &errMsg);
}

@end
