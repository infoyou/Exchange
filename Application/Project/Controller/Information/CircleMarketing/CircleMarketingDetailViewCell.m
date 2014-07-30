//
//  CircleMarketingDetailViewCell.m
//  Project
//
//  Created by Jang on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingDetailViewCell.h"
#import "WXWLabel.h"
#import "UIColor+expanded.h"
#import "WXWCommonUtils.h"


#define ICON_WIDTH  18.f
#define ICON_HEIGHT 18.f

#define CONTENT_LABEL_X 50.f
#define CONTENT_LABEL_WIDTH 235.f

CellMargin CMDCM = {15.f, 15.f, 10.f, 8.f};

@implementation CircleMarketingDetailViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(CMDCM.left, CMDCM.top, ICON_WIDTH, ICON_HEIGHT)];
    [self.contentView addSubview:self.iconView];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0x324886"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(13);
    [self.contentView addSubview:self.titleLabel];
    
    _contentLabel = [self initLabel:CGRectZero
                          textColor:[UIColor colorWithHexString:@"0x333333"]
                        shadowColor:TRANSPARENT_COLOR];
    self.contentLabel.font = FONT_SYSTEM_SIZE(12);
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.line.image = ImageWithName(@"circleMarketing_line.png");
    [self.contentView addSubview:self.line];
}

- (void)resetViews {
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.contentLabel.text = NULL_PARAM_VALUE;
}

- (void)dealloc {
    [_iconView release];
    [_line release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
//    CGFloat titleY = self.iconView.frame.origin.y + (self.iconView.frame.size.height - titleSize.height) / 2.f;
    self.titleLabel.frame = CGRectMake(self.iconView.frame.origin.x + self.iconView.frame.size.width + 5, CMDCM.top, titleSize.width, titleSize.height);
    
    CGSize contentSize = [WXWCommonUtils sizeForText:self.contentLabel.text
                                                font:self.contentLabel.font
                                   constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByCharWrapping
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : self.contentLabel.font}];
    self.contentLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8, 240, contentSize.height);
    
    self.line.frame = CGRectMake(CMDCM.left, self.frame.size.height - 1, 270, 1);
}

@end
