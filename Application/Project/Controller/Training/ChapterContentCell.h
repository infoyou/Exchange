//
//  ChapterContentCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "CourseDetailList.h"

#define CHAPTER_CONTENT_CELL_HEIGHT 100.f

@interface ChapterContentCell : BaseTextBoardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)drawContentCell:(CourseDetailList *)list courseCategory:(NSString *)category;

@end
