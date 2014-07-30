//
//  ExectueCell.m
//  Project
//
//  Created by user on 13-10-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ExectueCell.h"
#import "CommonHeader.h"
#import "UIColor+expanded.h"

CellMargin ECCM = {16.f, 16.f, 0.f, 0.f};

#define ARROW_IMAGE_VIEW_WIDTH  13.f
#define ARROW_IMAGE_VIEW_HEIGHT 13.f

@implementation ExectueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, 320.f, EXECTUE_CELL_HEIGHT);
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xe9edee"]]] autorelease];
        
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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ECCM.left, 0, 320.f, EXECTUE_CELL_HEIGHT)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    _titleLabel.font = FONT_SYSTEM_SIZE(18);
    [self.contentView addSubview:_titleLabel];
    
    CGFloat arrowOriginX = 320.f - ARROW_IMAGE_VIEW_WIDTH - ECCM.right;
    CGFloat arrowOriginY = (EXECTUE_CELL_HEIGHT - ARROW_IMAGE_VIEW_HEIGHT) / 2.f;
    _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(arrowOriginX, arrowOriginY, ARROW_IMAGE_VIEW_WIDTH, ARROW_IMAGE_VIEW_HEIGHT)];
    _arrowImageView.image = IMAGE_WITH_IMAGE_NAME(@"information_aloneMarketing_tableview_arrow");
    _arrowImageView.backgroundColor = TRANSPARENT_COLOR;
    [self.contentView addSubview:_arrowImageView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(ECCM.left, EXECTUE_CELL_HEIGHT - 1, 320.f - ECCM.left - ECCM.right, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
    [self.contentView addSubview:line];
    [line release];
}

- (void)dealloc {
    [_titleLabel release];
    [_arrowImageView release];
    [super dealloc];
}

@end
