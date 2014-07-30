//
//  CourseListCache.h
//  Project
//
//  Created by Yfeng__ on 13-11-18.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "CourseList.h"

@interface CourseListCache : NSObject<WXWConnectorDelegate>

- (void)upinsertCourse:(CourseList *)course isMyCourse:(int)isMyCourse categoryID:(int)categoryId;
- (void)updateCourseList:(int)courseid categoryId:(int)categoryId;
- (CourseList *)getCourseByCourseId:(int)courseID inMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId;
- (NSArray *)getMyCourseInMOC:(NSManagedObjectContext *)MOC categoryId:(int)categoryId;
- (BOOL)isMyCourse:(int)courseID cateforyId:(int)categoryId;
-(void)setIsMyCourse:(int)courseID isMycourse:(int)isMyCourse;

@end
