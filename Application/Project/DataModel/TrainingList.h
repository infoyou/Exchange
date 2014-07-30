//
//  TrainingList.h
//  Project
//
//  Created by XXX on 13-12-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CourseList;

@interface TrainingList : NSManagedObject

@property (nonatomic, retain) NSNumber * courseNumber;
@property (nonatomic, retain) NSNumber * trainingCategoryID;
@property (nonatomic, retain) NSString * trainingCategoryName;
@property (nonatomic, retain) NSSet *courseLists;
@end

@interface TrainingList (CoreDataGeneratedAccessors)

- (void)addCourseListsObject:(CourseList *)value;
- (void)removeCourseListsObject:(CourseList *)value;
- (void)addCourseLists:(NSSet *)values;
- (void)removeCourseLists:(NSSet *)values;

@end
