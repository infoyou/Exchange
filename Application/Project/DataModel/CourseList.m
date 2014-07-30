//
//  CourseList.m
//  Project
//
//  Created by Yfeng__ on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseList.h"
#import "TrainingList.h"


@implementation CourseList

@dynamic chapterNumber;
@dynamic courseID;
@dynamic courseName;
@dynamic courseType;
@dynamic trainingList;

- (void)updateData:(NSDictionary *)dic {
    self.courseID = [NSNumber numberWithInteger:[[dic objectForKey:@"courseID"] integerValue]];
    self.courseName = [[dic objectForKey:@"courseName"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"courseName"];
    self.courseType = [NSNumber numberWithInteger:[[dic objectForKey:@"courseType"] integerValue]];
    self.chapterNumber = [NSNumber numberWithInteger:[[dic objectForKey:@"chapterNumber"] integerValue]];
}

@end
