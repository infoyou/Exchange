//
//  ChapterContentCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterContentCell.h"
#import "CommonHeader.h"
#import "WXWCommonUtils.h"
#import "WXWLabel.h"
#import "FTPDownloaderManager.h"

CellMargin CCCCM = {12.f, 12.f, 15.0f, 20.f};

@interface ChapterContentCell() {
    
}

@property (nonatomic, retain) WXWLabel *chapNumberLabel;
@property (nonatomic, retain) WXWLabel *learnedLabel;
@property (nonatomic, retain) WXWLabel *courseCateLabel;
@property (nonatomic, retain) WXWLabel *courseInfoLabel;

@end

@implementation ChapterContentCell

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
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    _chapNumberLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x333333"]
                           shadowColor:TRANSPARENT_COLOR];
    self.chapNumberLabel.font = FONT_SYSTEM_SIZE(16);
//    [self.contentView addSubview:self.chapNumberLabel];
    
    _learnedLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x333333"]
                           shadowColor:TRANSPARENT_COLOR];
    self.learnedLabel.font = FONT_SYSTEM_SIZE(16);
    self.learnedLabel.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:self.learnedLabel];
    
    _courseCateLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x333333"]
                           shadowColor:TRANSPARENT_COLOR];
    self.courseCateLabel.font = FONT_SYSTEM_SIZE(15);
//    [self.contentView addSubview:self.courseCateLabel];
    
    _courseInfoLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x333333"]
                           shadowColor:TRANSPARENT_COLOR];
    self.courseInfoLabel.text = @"加载中...";
    self.courseInfoLabel.font = FONT_SYSTEM_SIZE(17);
    [self.contentView addSubview:self.courseInfoLabel];
    
}

- (void)resetViews {
    self.chapNumberLabel.text = NULL_PARAM_VALUE;
    self.learnedLabel.text = NULL_PARAM_VALUE;
    self.courseCateLabel.text = NULL_PARAM_VALUE;
    self.courseInfoLabel.text = @"加载中...";
}


-(void)prepareForReuse
{
    [super prepareForReuse];
    self.chapNumberLabel.text=@"";
    self.learnedLabel.text=@"";
    self.courseCateLabel.text=@"";
    self.courseInfoLabel.text=@"";
    
}
- (void)drawContentCell:(CourseDetailList *)list courseCategory:(NSString *)category {
    [self resetViews];
    CGFloat disY = 12.f;
    
    //------------------
    self.chapNumberLabel.text = [NSString stringWithFormat:@"章节：%d",list.chapterNumber.intValue];
    
    CGSize cnSize = [WXWCommonUtils sizeForText:self.chapNumberLabel.text
                                           font:self.chapNumberLabel.font
                                     attributes:@{NSFontAttributeName : self.chapNumberLabel.font}];
    self.chapNumberLabel.frame = CGRectMake(CCCCM.left, CCCCM.top, cnSize.width, cnSize.height);
    [self resetTextColor:self.chapNumberLabel
                   color:[UIColor colorWithHexString:@"0xea5123"]
                   range:[self.chapNumberLabel.text rangeOfString:[NSString stringWithFormat:@"%d",list.chapterNumber.intValue]]];
    
    //------------------
    self.learnedLabel.text = [NSString stringWithFormat:@"已学习：%d",list.completedChapterNumber.intValue];
    
    CGSize ldSize = [WXWCommonUtils sizeForText:self.learnedLabel.text
                                           font:self.learnedLabel.font
                                     attributes:@{NSFontAttributeName : self.learnedLabel.font}];
    self.learnedLabel.frame = CGRectMake(self.frame.size.width - CCCCM.right - ldSize.width, CCCCM.top, ldSize.width, ldSize.height);
    [self resetTextColor:self.learnedLabel
                   color:[UIColor colorWithHexString:@"0xea5123"]
                   range:[self.learnedLabel.text rangeOfString:[NSString stringWithFormat:@"%d",list.completedChapterNumber.intValue]]];
    
    //------------------
    self.courseCateLabel.text = [NSString stringWithFormat:@"课程类别：%@",category];
    
    CGSize ccSize = [WXWCommonUtils sizeForText:self.courseCateLabel.text
                                           font:self.courseCateLabel.font
                                     attributes:@{NSFontAttributeName : self.courseCateLabel.font}];
//    self.courseCateLabel.frame = CGRectMake(CCCCM.right, self.chapNumberLabel.frame.origin.y + self.chapNumberLabel.frame.size.height + disY, ccSize.width, ccSize.height);
    self.courseCateLabel.frame = CGRectMake(CCCCM.right, self.chapNumberLabel.frame.origin.y , ccSize.width, ccSize.height);
    [self resetTextColor:self.courseCateLabel
                   color:[UIColor colorWithHexString:@"0x666666"]
                   range:[self.courseCateLabel.text rangeOfString:category]];
    
    //------------------
    
    NSString *introduction = ([list.trainingCourseIntroduction isEqualToString:@""] || nil == list.trainingCourseIntroduction) ? @"" : list.trainingCourseIntroduction;

    
    self.courseInfoLabel.text = [NSString stringWithFormat:@"课程介绍"];
    
    CGSize ciSize = [WXWCommonUtils sizeForText:self.courseInfoLabel.text
                                           font:self.courseInfoLabel.font
                                     attributes:@{NSFontAttributeName : self.courseInfoLabel.font}];
//    self.courseInfoLabel.frame = CGRectMake(CCCCM.right, self.courseCateLabel.frame.origin.y + self.courseCateLabel.frame.size.height + disY, MIN(ciSize.width, self.frame.size.width - CCCCM.left - CCCCM.right), ciSize.height);
    
    self.courseInfoLabel.frame = CGRectMake(CCCCM.right, self.chapNumberLabel.frame.origin.y, MIN(ciSize.width, self.frame.size.width - CCCCM.left - CCCCM.right), ciSize.height);
    
    
    self.courseInfoLabel.numberOfLines = 0;
    [self.courseInfoLabel sizeToFit];
    
//    [self resetTextColor:self.courseInfoLabel
//                   color:[UIColor colorWithHexString:@"0x666666"]
//                   range:[self.courseInfoLabel.text rangeOfString:introduction]];
    
    
    int startY = self.courseInfoLabel.frame.origin.y + self.courseInfoLabel.frame.size.height + 5;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CCCCM.left, startY, self.frame.size.width - CCCCM.left - CCCCM.right, CHAPTER_CONTENT_CELL_HEIGHT )];
    
    
    contentLabel.text = [NSString stringWithFormat:@"%@",introduction];
    contentLabel.font = FONT_SYSTEM_SIZE(16);
    contentLabel.textColor = [UIColor colorWithHexString:@"b3b3b3"];
    contentLabel.numberOfLines = 2;
    [contentLabel sizeToFit];
    
    [self.contentView addSubview:contentLabel];
    
//    self.cour
//    CGRect rect = self.contentView.frame;
//    rect.size.width = self.courseInfoLabel.frame.origin.y + self.courseInfoLabel.frame.size.width + 11;
//    self.contentView.frame = rect;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    int height = 10;
//    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAPTER_CONTENT_CELL_HEIGHT - 5.5, self.frame.size.width, height)];
//    //    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
//    line.backgroundColor = COLOR_WITH_IMAGE_NAME(@"training_cell_bottom.png");
////    line.backgroundColor = [UIColor greenColor];
//    [self.contentView addSubview:line];
//    [line release];
}

- (void)resetTextColor:(WXWLabel *)label color:(UIColor *)color range:(NSRange)range {
    if (CURRENT_OS_VERSION >= IOS6) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        
        [str addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:range];
        
        label.attributedText = str;
        [str release];
    }
}


@end
