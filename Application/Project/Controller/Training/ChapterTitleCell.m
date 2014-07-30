//
//  ChapterTitleCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterTitleCell.h"
#import "UIColor+expanded.h"
#import "CommonHeader.h"
#import "WXWLabel.h"

#define ICON_WIDTH  32.f
#define ICON_HEIGHT 36.f

@implementation ChapterTitleCell

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

- (void)updateChapterInfo:(ChapterList *)chapterInfo
{
    self.chapterInfo = chapterInfo;
}

- (void)initViews {
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, ICON_WIDTH, ICON_HEIGHT)];
    
//    [self.contentView addSubview:self.icon];
    
//    int startX =self.icon.frame.origin.x + self.icon.frame.size.width + 10;
    int startX = 10;
    
    _titleLabel = [self initLabel:CGRectMake(startX, 0, self.frame.size.width - 2*startX, ICON_HEIGHT)
                        textColor:[UIColor colorWithHexString:@"0x333333"]
                      shadowColor:TRANSPARENT_COLOR];
    
    _titleLabel.font = FONT_SYSTEM_SIZE(18);
    
    [self.contentView addSubview:self.titleLabel];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint c = self.center;
    c.x = self.icon.frame.origin.x + ICON_WIDTH / 2.f;
    self.icon.center = c;
    
//    c.x = self.icon.frame.origin.x + ICON_WIDTH + 10 + self.titleLabel.frame.size.width / 2.f;
    c.x =10 + self.titleLabel.frame.size.width / 2.f;
    self.titleLabel.center = c;
    
    int startX = 13;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(startX, self.frame.size.height - 1, self.frame.size.width - 2*startX, 1)];
//    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
    line.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
    [self.contentView addSubview:line];
    [line release];
}

@end
