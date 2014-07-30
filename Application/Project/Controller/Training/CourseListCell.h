//
//  CourseListCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "CourseList.h"

#define COURSE_CELL_HEIGHT  62.f

@interface CourseListCell : ECImageConsumerCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier;

- (void)drawCourseCell:(CourseList *)courseList;

@end
