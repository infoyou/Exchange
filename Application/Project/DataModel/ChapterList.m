//
//  ChapterList.m
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterList.h"
#import "CourseDetailList.h"


@implementation ChapterList

@dynamic chapterCompletion;
@dynamic chapterFileURL;
@dynamic chapterID;
@dynamic chapterTitle;
@dynamic courseID;
@dynamic isDownloaded;
@dynamic isDelete;
@dynamic percentage;
@dynamic index;
@dynamic courseDetailList;

- (void)updateData:(NSDictionary *)dic  withCourseId:(NSNumber *)courseId{
    self.courseID = courseId;
    self.chapterID = [NSNumber numberWithInteger:[[dic objectForKey:@"chapterID"] integerValue]];
    self.chapterTitle = [[dic objectForKey:@"chapterTitle"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"chapterTitle"];
    self.chapterFileURL = [[dic objectForKey:@"chapterFileURL"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"chapterFileURL"];
    self.chapterCompletion = [[dic objectForKey:@"chapterCompletion"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"chapterCompletion"];
}


- (void)updateDataWithObject:(ChapterList *)object
{
    if (self != object) {
        
        self.chapterCompletion = object.chapterCompletion;
        self.chapterFileURL = object.chapterFileURL;
        self.chapterID = object.chapterID;
        self.chapterTitle = object.chapterTitle;
        self.percentage = object.percentage;
        self.isDelete = object.isDelete;
        self.isDownloaded = object.isDownloaded;
        self.courseID = object.courseID;
        self.courseDetailList = object.courseDetailList;
        
    }
}


@end
