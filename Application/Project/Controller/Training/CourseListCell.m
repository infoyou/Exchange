//
//  CourseListCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseListCell.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "UIColor+expanded.h"
#import "CommonHeader.h"

#define ICON_TYPE_WIDTH  32.f
#define ICON_TYPE_HEIGHT 36.f

#define CHAPTER_BG_WIDTH  71.f
#define CHAPTER_BG_HEIGHT 31.f

@interface CourseListCell()

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *chapterLabel;
@property (nonatomic, retain) UIImageView *typeIcon;
@property (nonatomic, retain) UIImageView *chapterBG;

@end

@implementation CourseListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    CGFloat iconY = (COURSE_CELL_HEIGHT - ICON_TYPE_HEIGHT) / 2.f;
    
    _typeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, iconY, ICON_TYPE_WIDTH, ICON_TYPE_HEIGHT)];
    [self.contentView addSubview:self.typeIcon];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@""]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(15);
    [self.contentView addSubview:self.titleLabel];
    
    
    CGFloat chapterY = (COURSE_CELL_HEIGHT - CHAPTER_BG_HEIGHT) / 2.f;
    
    _chapterBG = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 10 - CHAPTER_BG_WIDTH, chapterY, CHAPTER_BG_WIDTH, CHAPTER_BG_HEIGHT)];
    self.chapterBG.image = [UIImage imageNamed:@"training_chapter_bg.png"];
    [self.contentView addSubview:self.chapterBG];
    
    _chapterLabel = [self initLabel:self.chapterBG.frame
                          textColor:[UIColor whiteColor]
                        shadowColor:TRANSPARENT_COLOR];
    self.chapterLabel.font = FONT_SYSTEM_SIZE(15);
    self.chapterLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.chapterLabel];
}

- (void)resetView {
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.chapterLabel.text = NULL_PARAM_VALUE;
}

- (void)drawCourseCell:(CourseList *)courseList {
    [self resetView];
    
    self.titleLabel.text = courseList.courseName;
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(160.f, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGFloat titleY = (COURSE_CELL_HEIGHT - titleSize.height) / 2.f;
    self.titleLabel.frame = CGRectMake(self.typeIcon.frame.origin.x + self.typeIcon.frame.size.width + 10, titleY, 160, titleSize.height);
    self.typeIcon.image = (courseList.courseType.intValue == 1) ? ImageWithName(@"icon_html.png") : ImageWithName(@"icon_video.png");
    
    self.chapterLabel.text = [NSString stringWithFormat:@"章节:%d",courseList.chapterNumber.intValue];
    
    if ([self.titleLabel.text isEqualToString:@""] || nil == self.titleLabel.text) {
        self.typeIcon.hidden = YES;
        self.chapterBG.hidden = YES;
        
    }
}

@end
