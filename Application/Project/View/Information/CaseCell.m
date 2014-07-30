//
//  CaseCell.m
//  Project
//
//  Created by user on 13-10-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CaseCell.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonHeader.h"


#define ARROW_IMAGE_VIEW_WIDTH  13.f
#define ARROW_IMAGE_VIEW_HEIGHT 13.f
CellMargin CCCM = {15.f, 15.f, 0.f, 0.f};

@implementation CaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.frame = CGRectMake(0, 0, 320.f, CASE_CELL_HEIGHT);
        
        [self initSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSubViews {
    self.backgroundColor = [UIColor clearColor];
    
    
//    self.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    //设置透明度
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, CASE_CELL_HEIGHT)];
    backView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:backView];
    
//    backView.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    backView.layer.shadowOffset = CGSizeMake(0, 1);
//    //设置透明度
//    backView.layer.shadowOpacity = 0.7;
//    backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CCCM.left, 0, 200, CASE_CELL_HEIGHT)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.font = FONT_SYSTEM_SIZE(14);
    _titleLabel.textColor =[UIColor colorWithHexString:@"0x333333"];;
    [backView addSubview:_titleLabel];
    
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CCCM.left, CASE_CELL_HEIGHT - 1, self.frame.size.width - 2*CCCM.left, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
    
    [backView addSubview:lineLabel];
    [lineLabel release];
    
    CGFloat arrowOriginX = 320.f - ARROW_IMAGE_VIEW_WIDTH - CCCM.right;
    CGFloat arrowOriginY = (75.f - ARROW_IMAGE_VIEW_HEIGHT) / 2.f;
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowOriginX, arrowOriginY, ARROW_IMAGE_VIEW_WIDTH, ARROW_IMAGE_VIEW_HEIGHT)];
    _arrowImageView.image = IMAGE_WITH_IMAGE_NAME(@"information_aloneMarketing_tableview_arrow");
    _arrowImageView.backgroundColor = TRANSPARENT_COLOR;
//    [backView addSubview:_arrowImageView];
    
    int width = 160;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - CCCM.left - width, _titleLabel.frame.origin.y, width, CASE_CELL_HEIGHT)];
    _dateLabel.backgroundColor = TRANSPARENT_COLOR;
    _dateLabel.font = FONT_SYSTEM_SIZE(14);
    _dateLabel.textColor = [UIColor colorWithHexString:@"0x9d9d9d"];;
    _dateLabel.textAlignment = UITextAlignmentRight;
    [backView addSubview:_dateLabel];
    
    
    [backView release];
}

- (void)dealloc {
    [_titleLabel release];
    [_arrowImageView release];
    [super dealloc];
}

@end
