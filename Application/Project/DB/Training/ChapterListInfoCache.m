//
//  ChapterListInfoCache.m
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterListInfoCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "EntityInstance.h"
#import "WXWCoreDataUtils.h"
#import "GoHighDBManager.h"

@implementation ChapterListInfoCache

/*
 chapterID  integer ,
 courseId integer
 chapterTitle TEXT,
 chapterFileURL TEXT,  
 chapterCompletion float,
 percentage float, 
 isDownloaded integer,
 isDelete integer
 */
- (void)upinsertChapterInfo:(ChapterList *)chapter
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO chapterListInfo VALUES(?,?,?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
	[inserStmt bindInt32:[chapter.chapterID integerValue] forIndex:1];
	[inserStmt bindInt32:[chapter.courseID integerValue] forIndex:2];
	[inserStmt bindString:chapter.chapterTitle forIndex:3];
	[inserStmt bindString:chapter.chapterFileURL forIndex:4];
	[inserStmt bindString:chapter.chapterCompletion  forIndex:5];
	[inserStmt bindInt32:[chapter.percentage floatValue] forIndex:6];
	[inserStmt bindInt32:0 forIndex:7];
	[inserStmt bindInt32:[chapter.isDelete integerValue] forIndex:8];
	[inserStmt bindDouble:0 forIndex:9];
	[inserStmt bindDouble:0 forIndex:10];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];

}


- (void)updateChapterDownloaded:(int)courseId withChapterId:(int)chapterId isDownloaded:(int)downloaded
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update chapterListInfo set isDownloaded = ?,percentage = 1.0  where chapterId = ? and courseID = ?"];
		[inserStmt retain];
	}
    
	[inserStmt bindInt32:downloaded forIndex:1];
	[inserStmt bindInt32:chapterId forIndex:2];
	[inserStmt bindInt32:courseId forIndex:3];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}


- (void)updateChapterPercentage:(int)courseId withChapterId:(int)chapterId percentage:(double)percentage fileDownloadedSize:(double)fileDownloadedSize fileSize:(double)fileSize
{
    
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"update chapterListInfo set percentage = ?, downloadedSize = ? , fileSize = ? where chapterId = ? and courseID = ?"];
		[inserStmt retain];
	}
    
	[inserStmt bindDouble:percentage forIndex:1];
	[inserStmt bindDouble:fileDownloadedSize forIndex:2];
	[inserStmt bindDouble:fileSize forIndex:3];
	[inserStmt bindInt32:chapterId forIndex:4];
	[inserStmt bindInt32:courseId forIndex:5];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}


- (void)updateCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    NSMutableArray * array = [self getChapterDetailSetByCourseId:[detail.trainingCourseID integerValue] MOC:MOC];
    for (ChapterList *chapter in array) {
        [detail addChapterListsObject:chapter ];
    }
    
    DLog(@"%d", detail.chapterLists.count);
}


- (void)updateDownloadingCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    NSMutableArray * array = [self getDownloadingChapterDetailsByCourseId:[detail.trainingCourseID integerValue] MOC:MOC];
    for (ChapterList *chapter in array) {
        [detail addChapterListsObject:chapter ];
    }
    
    DLog(@"%d", detail.chapterLists.count);
}


- (void)updateDownloadedCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC
{
    NSMutableArray * array = [self getDownloadedChapterDetailsByCourseId:[detail.trainingCourseID integerValue] MOC:MOC];
    for (ChapterList *chapter in array) {
        [detail addChapterListsObject:chapter ];
    }
    
    DLog(@"%d", detail.chapterLists.count);
}

- (NSArray *)getAllDownloadingCourseId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *courseIdArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"SELECT courseID FROM chapterListInfo WHERE isDownloaded = 0 AND isDelete = 0 and percentage > 0 GROUP BY courseID ORDER BY courseID"];
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [courseIdArray addObject:NUMBER([queryStmt getInt32:0])];
    }
    
    [queryStmt release];
    return  courseIdArray;
}

- (NSArray *)getAllDownloadedCourseId
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *courseIdArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"SELECT courseID FROM chapterListInfo WHERE isDownloaded = 1 AND isDelete = 0 GROUP BY courseID ORDER BY courseID"];
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [courseIdArray addObject:NUMBER([queryStmt getInt32:0])];
    }
    
    [queryStmt release];
    return  courseIdArray;
}

- (NSArray *)getAllDownloadedChapters:(NSManagedObjectContext *)MOC
{    WXWStatement *queryStmt = nil;
    NSMutableArray *chaptersArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from chapterListInfo where isDownloaded = 1 and isDelete = 0"];
		[queryStmt retain];
	}
    
    while ([queryStmt step] != SQLITE_DONE) {
        [chaptersArray addObject:[self parseChapterList:queryStmt MOC:MOC]];
    }
    
    [queryStmt release];
    return  chaptersArray;
}

- (void)deleteChapterWithChapter:(int)chapterId courseId:(int)courseId {
    WXWStatement *deleteStmt = nil;
    
    if (deleteStmt == nil) {
        deleteStmt = [WXWDBConnection statementWithQuery:"UPDATE chapterListInfo SET percentage = 0.0, downloadedSize = 0.0 , fileSize = 0.0, isDownloaded = 0 where chapterId = ? and courseID = ?"];
        [deleteStmt retain];
    }
    
    [deleteStmt bindInt32:chapterId forIndex:1];
	[deleteStmt bindInt32:courseId forIndex:2];
    
	//ignore error
	[deleteStmt step];
	[deleteStmt reset];
    
    [deleteStmt release];
}

- (ChapterList *)parseChapterList:(WXWStatement *)queryStmt MOC:(NSManagedObjectContext *)MOC
{
    ChapterList *chapter = [EntityInstance getChapterListEntity:MOC];
    
    chapter.chapterID = NUMBER([queryStmt getInt32:0]);
    chapter.courseID = NUMBER([queryStmt getInt32:1]);
    chapter.chapterTitle = [queryStmt getString:2];
    chapter.chapterFileURL = [queryStmt getString:3];
    chapter.chapterCompletion = [queryStmt getString:4];
    chapter.percentage = NUMBER_DOUBLE([[queryStmt getString:5] floatValue]);
    chapter.isDownloaded = NUMBER([queryStmt getInt32:6]);
    chapter.isDelete = NUMBER([queryStmt getInt32:7]);
    
    return chapter;
}

- (NSMutableArray *)getChapterDetailSetByCourseId:(int)courseId  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *chapterArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from chapterListInfo where courseID=? order by chapterID DESC"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:courseId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [chapterArray addObject:[self parseChapterList:queryStmt MOC:MOC]];
    }
    
    [queryStmt release];
    return  chapterArray;
}


- (NSMutableArray *)getDownloadingChapterDetailsByCourseId:(int)courseId  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *chapterArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from chapterListInfo where courseID=? and isDownloaded = 0 and percentage > 0.001 order by chapterID DESC"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:courseId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [chapterArray addObject:[self parseChapterList:queryStmt MOC:MOC]];
    }
    
    [queryStmt release];
    return  chapterArray;
}

- (BOOL)isDownloading:(int)courseId withChapterId:(int)chapterId {
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM chapterListInfo WHERE courseID=? AND chapterID = ? AND isDownloaded = 0 AND percentage > 0.001"];
    }
    
    [queryStmt bindInt32:courseId forIndex:1];
    [queryStmt bindInt32:chapterId forIndex:2];
    
    BOOL result = NO;
    
    while ([queryStmt step] == SQLITE_ROW) {
        result = YES;
    }
    return result;
}

- (BOOL)isDownloaded:(int)courseId withChapterId:(int)chapterId {
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM chapterListInfo WHERE courseID=? AND chapterID = ? AND isDownloaded = 1"];
    }
    
    [queryStmt bindInt32:courseId forIndex:1];
    [queryStmt bindInt32:chapterId forIndex:2];
    
    BOOL result = NO;
    
    while ([queryStmt step] == SQLITE_ROW) {
        result = YES;
    }
    return result;
}


-(void)resetDownloadInfo:(int)courseId withChapterId:(int)chapterId
{
    WXWStatement *updateStmt = nil;
    
    if (updateStmt == nil) {
        updateStmt = [WXWDBConnection statementWithQuery:"UPDATE chapterListInfo SET percentage = 0.0, downloadedSize = 0.0 , fileSize = 0.0, isDownloaded = 0 where chapterId = ? and courseID = ?"];
        [updateStmt retain];
    }
    
    [updateStmt bindInt32:chapterId forIndex:1];
	[updateStmt bindInt32:courseId forIndex:2];
    
	//ignore error
	[updateStmt step];
	[updateStmt reset];
    
    [updateStmt release];
}

- (NSMutableArray *)getDownloadedChapterDetailsByCourseId:(int)courseId  MOC:(NSManagedObjectContext *)MOC
{
    WXWStatement *queryStmt = nil;
    NSMutableArray *chapterArray = [[[NSMutableArray alloc] init] autorelease];
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from chapterListInfo where courseID=? and isDownloaded = 1 order by chapterID DESC"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:courseId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [chapterArray addObject:[self parseChapterList:queryStmt MOC:MOC]];
    }
    
    [queryStmt release];
    return  chapterArray;
}


@end
