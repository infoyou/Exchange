//
//  CourseListCache.m
//  Project
//
//  Created by Yfeng__ on 13-11-18.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseListCache.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"
#import "GlobalConstants.h"
#import "EntityInstance.h"

@implementation CourseListCache

- (void)upinsertCourse:(CourseList *)course isMyCourse:(int)isMyCourse categoryID:(int)categoryId {
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"REPLACE INTO courseListInfo(courseID, courseTitle, courseType, chapterNumber, isMyCourse, categoryID) VALUES(?,?,?,?,?,?)"];
		[inserStmt retain];
	}
    
	[inserStmt bindInt32:[course.courseID integerValue] forIndex:1];
	[inserStmt bindString:course.courseName forIndex:2];
	[inserStmt bindInt32:[course.courseType integerValue] forIndex:3];
	[inserStmt bindInt32:[course.chapterNumber integerValue] forIndex:4];
    if ([self isMyCourse:course.courseID.intValue cateforyId:categoryId]) {
        [inserStmt bindInt32:1 forIndex:5];
    }else {
        [inserStmt bindInt32:isMyCourse forIndex:5];
    }
	[inserStmt bindInt32:categoryId forIndex:6];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}

- (BOOL)isMyCourse:(int)courseID cateforyId:(int)categoryId {
    WXWStatement *queryStmt = nil;
    if (queryStmt == nil) {
        queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM courseListInfo WHERE courseID = ? AND categoryID = ?"];
    }
    
    [queryStmt bindInt32:courseID forIndex:1];
    [queryStmt bindInt32:categoryId forIndex:2];
    
    int result = 0;
    while ([queryStmt step] == SQLITE_ROW) {
        result = [queryStmt getInt32:4];
        DLog(@"result %d",result);
    }
    if (result == 1) {
        return YES;
    }else
        return NO;
}


-(void)setIsMyCourse:(int)courseID isMycourse:(int)isMyCourse
{
    
}

- (CourseList *)parserCourse:(WXWStatement *)stmt MOC:(NSManagedObjectContext *)MOC {
    CourseList *cl = [EntityInstance getCourseEntity:MOC];
    
    cl.courseID = NUMBER([stmt getInt32:0]);
    cl.courseName = [stmt getString:1];
    cl.courseType = NUMBER([stmt getInt32:2]);
    cl.chapterNumber = NUMBER([stmt getInt32:3]);
    
    return cl;
}

- (CourseList *)getCourseByCourseId:(int)courseID inMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId {
    WXWStatement *queryStmt = nil;
    
    CourseList *cl = nil;
    
    if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM courseListInfo WHERE courseID = ? AND categoryID = ?"];
		[queryStmt retain];
	}
    
    [queryStmt bindInt32:courseID forIndex:1];
    [queryStmt bindInt32:categoryId forIndex:2];
    
    while ([queryStmt step] != SQLITE_DONE) {
        cl = [self parserCourse:queryStmt MOC:MOC];
    }
    
    [queryStmt release];
    return cl;
}

- (void)updateCourseList:(int)courseid categoryId:(int)categoryId {
    WXWStatement *inserStmt = nil;
	if (inserStmt == nil) {
		inserStmt = [WXWDBConnection statementWithQuery:"UPDATE courseListInfo SET isMyCourse = 1 WHERE courseID = ? AND  categoryID = ?"];
		[inserStmt retain];
	}

	[inserStmt bindInt32:courseid forIndex:1];
    [inserStmt bindInt32:categoryId forIndex:2];
    
	//ignore error
	[inserStmt step];
	[inserStmt reset];
    
    [inserStmt release];
}

- (NSArray *)getMyCourseInMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId {
    WXWStatement *queryStmt = nil;
    NSMutableArray *courseList = [[[NSMutableArray alloc] init] autorelease];
	if (queryStmt == nil) {
		queryStmt = [WXWDBConnection statementWithQuery:"SELECT * FROM courseListInfo WHERE categoryID = ? AND isMyCourse = 1 ORDER BY courseID ASC"];
		[queryStmt retain];
	}
    
    [queryStmt bindInt32:categoryId forIndex:1];
    
    while ([queryStmt step] != SQLITE_DONE) {
        [courseList addObject:[self parserCourse:queryStmt MOC:MOC]];
    }
    
    [queryStmt release];
    return courseList;
}

@end
