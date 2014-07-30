//
//  CourseDetailList.m
//  Project
//
//  Created by XXX on 13-11-18.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseDetailList.h"
#import "ChapterList.h"


@implementation CourseDetailList

@dynamic chapterNumber;
@dynamic completedChapterNumber;
@dynamic isDelete;
@dynamic timestamp;
@dynamic trainingCourseID;
@dynamic trainingCourseIntroduction;
@dynamic trainingCourseTitle;
@dynamic isMyCourse;
@dynamic chapterLists;

- (void)updateData:(NSDictionary *)dic  withTimestamp:(double )timestamp{
    self.trainingCourseID = [NSNumber numberWithInteger:[[dic objectForKey:@"trainingCourseID"] integerValue]];
    self.trainingCourseIntroduction = [[dic objectForKey:@"trainingCourseIntroduction"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"trainingCourseIntroduction"];
    self.trainingCourseTitle = [[dic objectForKey:@"trainingCourseTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"trainingCourseTitle"];
    self.chapterNumber = [NSNumber numberWithInteger:[[dic objectForKey:@"chapterNumber"] integerValue]];
    self.completedChapterNumber = [NSNumber numberWithInteger:[[dic objectForKey:@"completedChapterNumber"] integerValue]];
    self.timestamp = [NSNumber numberWithDouble:timestamp];
    self.isDelete = [NSNumber numberWithInteger:[[dic objectForKey:@"isDelete"] integerValue]];
}


- (void)updateDataWithObject:(CourseDetailList *)object
{
    self.chapterNumber = object.chapterNumber;
    self.completedChapterNumber = object.completedChapterNumber;
    self.trainingCourseID = object.trainingCourseID;
    self.trainingCourseIntroduction = object.trainingCourseIntroduction;
    self.trainingCourseTitle = object.trainingCourseTitle;
    self.timestamp = object.timestamp;
    self.isDelete = object.isDelete;
}

@end
