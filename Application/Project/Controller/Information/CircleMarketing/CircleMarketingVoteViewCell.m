//
//  CircleMarketingVoteViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingVoteViewCell.h"
#import "WXWLabel.h"
#import "UIColor+expanded.h"
#import "WXWCommonUtils.h"
#import "NSDate+Utils.h"
#import "CommonMethod.h"

#define VOTE_BUTTON_WIDTH  61.f
#define VOTE_BUTTON_HEIGHT 32.f

@interface CircleMarketingVoteViewCell() {
    
}

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *voteButton;
@property (nonatomic, retain) UIImageView *line;

@end

@implementation CircleMarketingVoteViewCell {
    EventVoteList *_evList;
}

@synthesize delegate = _delegate;

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
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _titleLabel = [self initLabel:CGRectZero textColor:[UIColor blackColor] shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = FONT(15);
    [self.contentView addSubview:self.titleLabel];
    
    _voteButton = [self initLabel:CGRectZero
                        textColor:[UIColor whiteColor]
                      shadowColor:TRANSPARENT_COLOR];

    [self.contentView addSubview:self.voteButton];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.line.image = ImageWithName(@"line_d.png");
    [self.contentView addSubview:self.line];
}

- (void)dealloc {
    [_line release];
    [super dealloc];
}

- (void)resetViews {
    self.titleLabel.text = NULL_PARAM_VALUE;
}

- (void)drawEventVoteList:(EventVoteList *)evList {
    [self resetViews];
    
    _evList = evList;
    //title label
    self.titleLabel.text = [NSString stringWithFormat:@"%d. %@",[evList.voteId intValue], evList.voteTitle];
    
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(215, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(20, 20, 215, titleSize.height);
    
    //vote button
    [self.voteButton setText:([evList.voteFlag intValue] == 0) ? @"未投票" : @"已投票"];
    [self.voteButton setTextColor:[UIColor whiteColor]];
    [self.voteButton setBackgroundColor:([evList.voteFlag intValue] == 0) ? [UIColor colorWithHexString:@"0x999999"] : [UIColor colorWithHexString:@"0xe83e0b"]];
    self.voteButton.frame = CGRectMake(self.frame.size.width - VOTE_BUTTON_WIDTH - 20, 0, VOTE_BUTTON_WIDTH, VOTE_BUTTON_HEIGHT);
    
    CGPoint center = self.titleLabel.center;
    center.x = self.frame.size.width - VOTE_BUTTON_WIDTH/2 - 20;
    self.voteButton.center = center;
    
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.line.frame = CGRectMake(20, self.frame.size.height - 1, 280, 1);
}

-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(selecteVoteCell:)]) {
        [_delegate selecteVoteCell:_evList];
    }
}

@end
