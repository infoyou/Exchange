//
//  CourseInfoCache.h
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "CourseDetailList.h"

@interface CourseInfoCache : NSObject <WXWConnectorDelegate>

- (double)getLatestCourseInfoTime:(int)courseId;
- (void)updateCourseDetailList:(CourseDetailList *)detail;

- (void)upinsertCourseInfo:(CourseDetailList *)detail isMyCourse:(int)isMyCourse;
- (CourseDetailList *)getCourseDetailByCourseId:(int)courseId withCourseDetailList:(CourseDetailList *)detail;
- (NSArray *)getMyCourse;

@end
