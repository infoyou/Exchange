//
//  PersonalInfoCell.m
//  Project
//
//  Created by user on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "PersonalInfoCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "GlobalConstants.h"

CellMargin PICM = {10.f, 2.f, 5.f, 10.f};
CellDist dist = {0.f, 2.f};

@implementation PersonalInfoCell

- (CGFloat)desLabel:(UILabel *)label heightWithString:(NSString *)string font:(UIFont *)font {
    return [string sizeWithFont:font constrainedToSize:CGSizeMake(label.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
}

- (CGFloat)titleLabelHeight {
    return [self desLabel:_titleLabel heightWithString:_titleLabel.text font:FONT_TITLE];
}

- (CGFloat)subTitleLabelHeight {
    return [self desLabel:_subTitLabel heightWithString:_subTitLabel.text font:FONT_SUBTITLE];
}

- (CGFloat)cellWidth {
    return self.frame.size.width - 20;
}

- (CGFloat)cellHeight {
    return self.frame.size.height;
}

- (CGFloat)cellHeightWithStyle:(CellStyle)style {
    if (style == CellStyle_Header) {
        return PICM.top + HEADER_IMAGE_HEIGHT + _nameLabel.frame.size.height;
    }else if (style == CellStyle_Content) {
        return [self titleLabelHeight] + [self subTitleLabelHeight] + PICM.top + PICM.bottom;
    }
    return 0.f;
}

- (id)initWithStyle:(CellStyle)style reId:(NSString *)reuseIdentifier {
    if (self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        _cellStyle = style;
        self.backgroundColor = TRANSPARENT_COLOR;
        
        if (style == CellStyle_Header) {
            [self initCellOfHeader];
        } else if (style == CellStyle_Content) {
            [self initCellOfContent];
        }
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCellOfHeader {
    CGFloat headerImageOriginX = 15;
    CGFloat headerImageOriginY = 18;
    
    _headerImage = [[GHImageView alloc] initWithFrame:CGRectMake(headerImageOriginX, headerImageOriginY, HEADER_IMAGE_WIDTH, HEADER_IMAGE_HEIGHT) defaultImage:@"chat_person_cell_default.png"];
    _headerImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImage.layer.borderWidth = 4.f;
    _headerImage.layer.masksToBounds = NO;
    //设置阴影的高度
    _headerImage.layer.shadowOffset = CGSizeMake(0, 1);
    //设置透明度
    _headerImage.layer.shadowOpacity = 0.5;
    _headerImage.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _headerImage.layer.shadowRadius = 1.;
    _headerImage.layer.shadowPath = [UIBezierPath bezierPathWithRect:_headerImage.bounds].CGPath;
    
    [self.contentView addSubview:_headerImage];
    
    CGFloat nameLabelOriginX = _headerImage.frame.origin.x + _headerImage.frame.size.width + 10;
    CGFloat nameLabelOriginY = _headerImage.frame.origin.y ;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, nameLabelOriginY, [self cellWidth] - nameLabelOriginX - 5, 25)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithHexString:@"0x37332f"];
    _nameLabel.font = FONT_SYSTEM_SIZE(18);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_nameLabel];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(1, 109, [self cellWidth] - 3, 1)];
    line.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
    [self.contentView addSubview:line];
    [line release];
}

- (void)initCellOfContent {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(PICM.left, PICM.top+5, LABEL_WIDTH, 20)];
    _titleLabel.font = FONT_SYSTEM_SIZE(17);
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_titleLabel];
    
    _subTitLabel = [[UILabel alloc] initWithFrame:CGRectMake(PICM.left, PICM.top + 10 + _titleLabel.frame.size.height, LABEL_WIDTH, 20)];
    _subTitLabel.font = FONT_SYSTEM_SIZE(12);
    _subTitLabel.backgroundColor = TRANSPARENT_COLOR;
    _subTitLabel.textColor = [UIColor colorWithHexString:@"0x7d7871"];
    _subTitLabel.textAlignment = NSTextAlignmentLeft;
    _subTitLabel.numberOfLines = 0;
//    _subTitLabel.preferredMaxLayoutWidth = LABEL_WIDTH;
    [self.contentView addSubview:_subTitLabel];
}

- (void)updateHeaderImageWithImageURL:(NSString *)imageURL {
    [_headerImage updateImage:imageURL];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [_headerImage release];
    [_nameLabel release];
    [_titleLabel release];
    [_subTitLabel release];
    [super dealloc];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, [self titleLabelHeight]);
    _subTitLabel.frame = CGRectMake(_subTitLabel.frame.origin.x, _subTitLabel.frame.origin.y, _subTitLabel.frame.size.width, [self subTitleLabelHeight]);
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(1,[self cellHeight] -0.5, [self cellWidth] + 17, 0.5)];
    [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self addSubview:lineLabel];
    [lineLabel release];
    
    //    [self resizeCellWithStyle:_cellStyle];
}

- (void)resizeCellWithStyle:(CellStyle)style {
    CGRect f = self.frame;
    f.size.height = [self cellHeightWithStyle:style];
    self.frame = f;
    
}

- (void)setBackgroundImageWithIndexFlag:(IndexFlag)indexFlag {
    if (indexFlag == IndexFlag_Top) {
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"communication_cell_bg_top"]] autorelease];
    }else if (indexFlag == IndexFlag_Middle) {
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"communication_cell_bg_middle"]] autorelease];
    }else if (indexFlag == IndexFlag_Bottom) {
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"communication_cell_bg_bottom"]] autorelease];
    }
}

@end
