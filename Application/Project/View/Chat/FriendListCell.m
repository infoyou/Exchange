//
//  FriendListCell.m
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "FriendListCell.h"
#import "GlobalConstants.h"

CellMargin FLCM = {10.f, 10.f, 10.f, 10.f};

@implementation FriendListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index {
    if (self = [self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviewsWithIndex:index];
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

- (void)dealloc {
    [_portImageView release];
    [_nameLabel release];
    [_descLabel release];
    [super dealloc];
}

- (void)initSubviewsWithIndex:(int)index {
    _portImageView = [[UIImageView alloc] initWithFrame:CGRectMake(FLCM.left, FLCM.top, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    _portImageView.backgroundColor = RANDOM_COLOR;
//    _portImageView.layer.cornerRadius=5.0f;
    
    _portImageView.tag = BASE_TAG + index;
    _portImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)] autorelease];
    [_portImageView addGestureRecognizer:tap];
    
    [self.contentView addSubview:_portImageView];
    
    CGFloat nameLabelOriginX = _portImageView.frame.origin.x + IMAGEVIEW_WIDTH + 10;
    CGFloat nameLabelWidth = self.frame.size.width - _portImageView.frame.size.width - FLCM.left - FLCM.right - 10;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, FLCM.top, nameLabelWidth, 30)];
    _nameLabel.font = FONT_SYSTEM_SIZE(20);
    _nameLabel.backgroundColor = TRANSPARENT_COLOR;
    [self.contentView addSubview:_nameLabel];
    
    CGFloat descLabelOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, descLabelOriginY, nameLabelWidth, 25)];
    _descLabel.backgroundColor = TRANSPARENT_COLOR;
    _descLabel.font = FONT_SYSTEM_SIZE(18);
    [self.contentView addSubview:_descLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)imageTapped:(UIGestureRecognizer *)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(friendListCell:imageTappedWithIndex:)]) {
        [_delegate friendListCell:self imageTappedWithIndex:_portImageView.tag];
    }
}

@end
