//
//  CircleMarketingVoteCommitCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingVoteCommitCell.h"
#import "WXWLabel.h"
#import "UIColor+expanded.h"
#import "WXWCommonUtils.h"
#import "NSDate+Utils.h"
#import "CommonHeader.h"

#define OPTION_BUTTON_WIDTH   60.f
#define OPTION_BUTTON_HEIGHT  40.f

@interface CircleMarketingVoteCommitCell() {
    
}

@property (nonatomic, retain) UIButton *currentButton;

@end

@implementation CircleMarketingVoteCommitCell

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
//        [self initViews];
    }
    return self;
}

//- (void)initViews {
//    _optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    self.optionButton.tag = BUTTON_TAG;
//    self.optionButton.frame = CGRectMake(0, 0, OPTION_BUTTON_WIDTH, OPTION_BUTTON_HEIGHT);
//    
//    CGPoint center = self.center;
//    center.y += 10.f;
//    
//    self.optionButton.center = center;
//    [self.optionButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xcccccc"]] forState:UIControlStateNormal];
//    [self.optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//    [self.optionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [self.optionButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xe83e0b"]] forState:UIControlStateSelected];
//    [self.optionButton.titleLabel setFont:FONT(15)];
//    
//    [self.optionButton addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:self.optionButton];
//}

- (void)drawVoteCommitCellWithArray:(NSArray *)arr {
    for (int i = 0; i < arr.count; i ++) {
        
        EventOptionList *opl = (EventOptionList *)arr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
        btn.frame = CGRectMake((self.frame.size.width - OPTION_BUTTON_WIDTH) / 2, 20 + i * OPTION_BUTTON_HEIGHT, OPTION_BUTTON_WIDTH, 30);
        
        [btn setTitle:opl.optionTitle forState:UIControlStateNormal];
        btn.tag = opl.optionId.intValue;
        [btn setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xcccccc"]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xe83e0b"]] forState:UIControlStateSelected];
        [btn.titleLabel setFont:FONT(15)];
        
        [btn addTarget:self action:@selector(optionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        
        if (i == 0) {
            self.currentButton = btn;
//            self.currentButton.selected = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)optionButtonClicked:(UIButton *)sender {
    sender.selected = YES;
    if (self.currentButton == sender) {
        self.currentButton.selected = YES;
        
    }else {
        [self setButtonUnseleted:self.currentButton];
        self.currentButton = sender;
    }
    
    if ([_delegate respondsToSelector:@selector(circleMarketingVoewCommiteCell:selectedWithOptionID:)]) {
        [_delegate circleMarketingVoewCommiteCell:self selectedWithOptionID:sender.tag];
    }
}

- (void)setButtonUnseleted:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }
}

@end
