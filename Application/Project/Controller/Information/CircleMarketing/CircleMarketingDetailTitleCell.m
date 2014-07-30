//
//  CircleMarketingDetailTitleCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingDetailTitleCell.h"
#import "WXWLabel.h"
#import "CommonHeader.h"
#import "WXWCommonUtils.h"

#define BUTTON_WIDTH  130.f
#define BUTTON_HEIGHT 32.f

#define TITLE_LABEL_X 15.f
#define TITLE_LABEL_WIDTH 270.f

CellMargin CMTCM = {15.f, 15.f, 10.f, 10.f};

@implementation CircleMarketingDetailTitleCell

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
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor blackColor]
                      shadowColor:TRANSPARENT_COLOR];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = FONT_SYSTEM_SIZE(16);
    [self.contentView addSubview:self.titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectZero;
    [self.leftButton setBackgroundColor:[UIColor colorWithHexString:@"0x324886"]];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton.titleLabel setFont:FONT_SYSTEM_SIZE(14)];
    [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectZero;
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:FONT_SYSTEM_SIZE(14)];
    [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(TITLE_LABEL_WIDTH, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(CMTCM.left, CMTCM.top, TITLE_LABEL_WIDTH, titleSize.height);
    
    //left button
    self.leftButton.frame = CGRectMake(CMTCM.left, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, BUTTON_WIDTH, BUTTON_HEIGHT);
//    
    self.leftButton.hidden = YES;
    //right button
//    self.rightButton.frame = CGRectMake(self.frame.size.width - BUTTON_WIDTH - CMTCM.right, self.leftButton.frame.origin.y, BUTTON_WIDTH, BUTTON_HEIGHT);
    self.rightButton.frame = CGRectMake(CMTCM.left, self.leftButton.frame.origin.y, 2*BUTTON_WIDTH, BUTTON_HEIGHT);

}

- (void)leftButtonClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(circleMarketingDetailTitleCell:leftButtonClicked:)]) {
        [_delegate circleMarketingDetailTitleCell:self leftButtonClicked:sender];
    }
}

- (void)rightButtonClicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(circleMarketingDetailTitleCell:rightButtonClicked:)]) {
        [_delegate circleMarketingDetailTitleCell:self rightButtonClicked:sender];
    }
}

@end
