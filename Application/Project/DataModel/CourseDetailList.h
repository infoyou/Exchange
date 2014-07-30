//
//  CourseDetailList.h
//  Project
//
//  Created by XXX on 13-11-18.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChapterList;

@interface CourseDetailList : NSManagedObject

@property (nonatomic, retain) NSNumber * chapterNumber;
@property (nonatomic, retain) NSNumber * completedChapterNumber;
@property (nonatomic, retain) NSNumber * isDelete;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * trainingCourseID;
@property (nonatomic, retain) NSString * trainingCourseIntroduction;
@property (nonatomic, retain) NSString * trainingCourseTitle;
@property (nonatomic, retain) NSNumber * isMyCourse;
@property (nonatomic, retain) NSSet *chapterLists;

- (void)updateData:(NSDictionary *)dic  withTimestamp:(double )timestamp;
- (void)updateDataWithObject:(CourseDetailList *)object;


@end

@interface CourseDetailList (CoreDataGeneratedAccessors)

- (void)addChapterListsObject:(ChapterList *)value;
- (void)removeChapterListsObject:(ChapterList *)value;
- (void)addChapterLists:(NSSet *)values;
- (void)removeChapterLists:(NSSet *)values;

@end
