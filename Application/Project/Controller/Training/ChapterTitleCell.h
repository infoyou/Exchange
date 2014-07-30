//
//  ChapterTitleCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "CourseDetailList.h"
#import "ChapterList.h"

@interface ChapterTitleCell : ECImageConsumerCell

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) ChapterList *chapterInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)updateChapterInfo:(ChapterList *)chapterInfo;

@end
