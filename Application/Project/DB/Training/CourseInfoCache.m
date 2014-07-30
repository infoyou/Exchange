//
//  CourseInfoCache.m
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseInfoCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"

@implementation CourseInfoCache

- (double)getLatestCourseInfoTime:(int)courseId
{
    WXWStatement *queryStmt = nil;
    
    double count=0;
    
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select timestamp from courseInfo where trainingCourseId = ? order by timestamp desc limit 1"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:courseId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        count = [NUMBER_DOUBLE([queryStmt getDouble:0]) doubleValue];
	}
    
	[queryStmt reset];
    [queryStmt release];
    
    return count;
}


- (void)updateCourseDetailList:(CourseDetailList *)detail
{
   [self getCourseDetailByCourseId:[detail.trainingCourseID integerValue] withCourseDetailList:detail];
}

- (void)upinsertCourseInfo:(CourseDetailList *)detail isMyCourse:(int)isMyCourse
{
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"INSERT OR REPLACE INTO courseInfo VALUES(?,?,?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
	[inserStmt bindInt32:[detail.trainingCourseID integerValue] forIndex:1];
	[inserStmt bindString:detail.trainingCourseTitle forIndex:2];
	[inserStmt bindString:detail.trainingCourseIntroduction forIndex:3];
	[inserStmt bindInt32:[detail.chapterNumber integerValue] forIndex:4];
	[inserStmt bindInt32:[detail.completedChapterNumber integerValue] forIndex:5];
	[inserStmt bindDouble:[detail.timestamp doubleValue] forIndex:6];
	[inserStmt bindInt32:isMyCourse forIndex:7];
	[inserStmt bindInt32:[detail.isDelete integerValue] forIndex:8];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];

    [inserStmt release];
}

/*
 trainingCourseID integer
 trainingCourseTitle TEXT,
 trainingCourseIntroduction TEXT,
 chapterNumber integer,
 completedChapterNumber integer,
 timestamp double,
 isMyCourse integer,
 isDelete integer,
 */
- (CourseDetailList *)parseCourseDetail:(WXWStatement *)queryStmt withCourseDetailList:(CourseDetailList *)detail
{
    detail.trainingCourseID = NUMBER([queryStmt getInt32:0]);
    detail.trainingCourseTitle =[queryStmt getString:1];
    detail.trainingCourseIntroduction = [queryStmt getString:2];
    detail.chapterNumber = NUMBER([queryStmt getInt32:3]);
    detail.completedChapterNumber = NUMBER([queryStmt getInt32:4]);
    detail.timestamp =NUMBER_DOUBLE([queryStmt getDouble:5]) ;
    detail.isMyCourse = NUMBER([queryStmt getInt32:6]);
    detail.isDelete = NUMBER([queryStmt getInt32:7]);

    return detail;
}

- (CourseDetailList *)parseCourseDetail:(WXWStatement *)queryStmt
{
    CourseDetailList *detail = [[[CourseDetailList alloc] init] autorelease];
    
    detail.trainingCourseID = NUMBER([queryStmt getInt32:0]);
    detail.trainingCourseTitle =[queryStmt getString:1];
    detail.trainingCourseIntroduction = [queryStmt getString:2];
    detail.chapterNumber = NUMBER([queryStmt getInt32:3]);
    detail.completedChapterNumber = NUMBER([queryStmt getInt32:4]);
    detail.timestamp =NUMBER_DOUBLE([queryStmt getDouble:5]) ;
    detail.isMyCourse = NUMBER([queryStmt getInt32:6]);
    detail.isDelete = NUMBER([queryStmt getInt32:7]);
    
    return detail;
}

- (CourseDetailList *)getCourseDetailByCourseId:(int)courseId withCourseDetailList:(CourseDetailList *)detail
{
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"select * from courseInfo where trainingCourseID = ?"];
		[queryStmt retain];
	}
    
	[queryStmt bindInt32:courseId forIndex:1];
    
    if ([queryStmt step] == SQLITE_ROW) {
        [self parseCourseDetail:queryStmt withCourseDetailList:detail];
	}
    [queryStmt release];
    return  detail;
}

- (NSArray *)getMyCourse {
    WXWStatement *queryStmt = nil;
    
    NSMutableArray *courseArr = [[[NSMutableArray alloc] init] autorelease];
    
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM courseInfo WHERE isMyCourse = 1 ORDER BY trainingCourseID ASC"];
        [queryStmt retain];
    }
    
    while ([queryStmt step] != SQLITE_DONE) {
        [courseArr addObject:[self parseCourseDetail:queryStmt]];
    }
    
    [queryStmt release];
    
    return courseArr;
}

@end
