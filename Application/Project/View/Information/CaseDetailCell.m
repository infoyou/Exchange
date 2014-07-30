//
//  CaseDetailCell.m
//  Project
//
//  Created by user on 13-10-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CaseDetailCell.h"
#import "CommonHeader.h"
#import <QuartzCore/QuartzCore.h>

#define ARROW_IMAGE_VIEW_WIDTH  13.f
#define ARROW_IMAGE_VIEW_HEIGHT 13.f

CellMargin CDCM = {23.f, 23.f, 0.f, 0.f};

@implementation CaseDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubViews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)addSubViews {
    
    self.backgroundColor = [UIColor clearColor];
//    self.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    //设置透明度
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 90.f)];
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:backView];
    
//    backView.layer.masksToBounds = NO;
//    //    //设置阴影的高度
//    backView.layer.shadowOffset = CGSizeMake(0, 1);
//    //设置透明度
//    backView.layer.shadowOpacity = 0.7;
//    backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;
    
    CGFloat titleLabelWidth = self.frame.size.width - CDCM.left - CDCM.right - ARROW_IMAGE_VIEW_WIDTH;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CDCM.left, 0, titleLabelWidth, 50)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.font = FONT_SYSTEM_SIZE(18);
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [backView addSubview:_titleLabel];
    
    CGFloat arrowOriginX = 320.f - ARROW_IMAGE_VIEW_WIDTH - CDCM.right;
    CGFloat arrowOriginY = (50.f - ARROW_IMAGE_VIEW_HEIGHT) / 2.f;
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowOriginX, arrowOriginY, ARROW_IMAGE_VIEW_WIDTH, ARROW_IMAGE_VIEW_HEIGHT)];
    _arrowImageView.image = IMAGE_WITH_IMAGE_NAME(@"information_aloneMarketing_tableview_arrow");
    _arrowImageView.backgroundColor = TRANSPARENT_COLOR;
    [backView addSubview:_arrowImageView];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CDCM.left,_titleLabel.frame.origin.y + _titleLabel.frame.size.height, 320.f - CDCM.left - CDCM.right, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
    [backView addSubview:lineLabel];
    [lineLabel release];
    
    
    CGFloat dateLabelOriginY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + 1;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CDCM.left, dateLabelOriginY, 320.f - CDCM.left - CDCM.right, 39)];
    _dateLabel.backgroundColor = TRANSPARENT_COLOR;
    _dateLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    _dateLabel.font = FONT_SYSTEM_SIZE(14);
    [backView addSubview:_dateLabel];
    
    
    
    lineLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0 , backView.frame.size.height - 1, self.frame.size.width, 1)];
    lineLabel.backgroundColor =[UIColor colorWithHexString:@"0xcdcdcd"];
    [backView addSubview:lineLabel];
    [lineLabel release];
    
    [backView release];
}

- (void)dealloc {
    [_titleLabel release];
    [_dateLabel release];
    [super dealloc];
}

@end
