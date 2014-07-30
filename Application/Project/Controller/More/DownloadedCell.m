//
//  DownloadedCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "DownloadedCell.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "CommonHeader.h"

CellMargin DDDM = {16.f, 16.f, 5.f, 5.f};

#define ACCESSORY_WIDTH  12.f
#define ACCESSOTY_HEIGHT 19.f

#define CHECK_BUTTON_WIDTH  19.f
#define CHECK_BUTTON_HEIGHT 18.f

#define TITLE_LABEL_MAX_WIDTH 250.f

@interface DownloadedCell()

@end

@implementation DownloadedCell {
    enum DOWNLOADED_CELL_MODE _mode;
    ChapterList *_chapter;
}

@synthesize delegate = _delegate;
@synthesize checkBox = _checkBox;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_accessoryImage release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          indexPath:(NSIndexPath *)indexPath {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewsWithIndexPath:indexPath];
        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}

- (void)initViewsWithIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat accessoryY = (DOWNLOADED_CELL_HEIGHT - ACCESSOTY_HEIGHT) / 2.f;
    
    _accessoryImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - DDDM.right - ACCESSORY_WIDTH, accessoryY, ACCESSORY_WIDTH, ACCESSOTY_HEIGHT)];
    self.accessoryImage.image = ImageWithName(@"communication_member_right_arrow.png");
    [self.contentView addSubview:self.accessoryImage];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0x666666"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(15);
    [self.contentView addSubview:self.titleLabel];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.backgroundColor = TRANSPARENT_COLOR;
    self.checkButton.tag = indexPath.row;
    [self.checkButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton setImage:ImageWithName(@"check_no.png") forState:UIControlStateNormal];
    [self.checkButton setImage:ImageWithName(@"check_yes.png") forState:UIControlStateSelected];
    [self.contentView addSubview:self.checkButton];
    self.checkButton.hidden = YES;
}

- (void)drawDownloadedCell:(ChapterList *)chapter {
    
    self.checkButton.frame = CGRectMake(DDDM.left, 0, CHECK_BUTTON_WIDTH, CHECK_BUTTON_HEIGHT);
    self.checkButton.selected = NO;
    
    self.titleLabel.text = chapter.chapterTitle;
    _chapter = chapter;
    
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(TITLE_LABEL_MAX_WIDTH, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    CGFloat titleY = (DOWNLOADED_CELL_HEIGHT - titleSize.height) / 2.f;
    
    self.titleLabel.frame = CGRectMake(DDDM.left, titleY, TITLE_LABEL_MAX_WIDTH, titleSize.height);
}


-(void)updateMode:(enum DOWNLOADED_CELL_MODE)mode
{
    _mode = mode;
    
    [self adjustContrlPos:mode];
}

- (void)adjustContrlPos:(enum DOWNLOADED_CELL_MODE)mode
{
    if (mode == DOWNLOADED_CELL_MODE_EDIT) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             self.titleLabel.frame = CGRectMake(DDDM.left + CHECK_BUTTON_WIDTH, self.titleLabel.frame.origin.y, TITLE_LABEL_MAX_WIDTH, self.titleLabel.frame.size.height);
                             self.checkButton.hidden = NO;
        } completion:^(BOOL completion){
            
        }];
    }else if (mode == DOWNLOADED_CELL_MODE_NORMAL) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            
                             self.titleLabel.frame = CGRectMake(DDDM.left, self.titleLabel.frame.origin.y, TITLE_LABEL_MAX_WIDTH, self.titleLabel.frame.size.height);
                             self.checkButton.hidden = YES;
        } completion:^(BOOL completion){
            
        }];
    }
}

- (void)viewTapped:(UIGestureRecognizer *)gesture {
    
    //非编辑模式
    if (_mode != DOWNLOADED_CELL_MODE_EDIT) {
        if (_delegate && [_delegate respondsToSelector:@selector(studyCourse:chapter:)]) {
            [_delegate studyCourse:self chapter:_chapter];
        }
    }else {
        [self checkButtonTapped:self.checkButton];
    }
}

- (void)checkButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(downloadedCell:checkButtonTapped:chapter:)]) {
        [_delegate downloadedCell:self checkButtonTapped:sender chapter:_chapter];
    }
}

- (BOOL)checked
{
    if (_mode == DOWNLOADED_CELL_MODE_EDIT)
        return _checkBox.checked;
    return FALSE;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.checkButton.frame = CGRectMake(DDDM.left, (self.frame.size.height - CHECK_BUTTON_HEIGHT) / 2, CHECK_BUTTON_WIDTH, CHECK_BUTTON_HEIGHT);
    
//    CGPoint c = self.center;
//    c.x = self.accessoryImage.frame.origin.x + self.accessoryImage.frame.size.width / 2;
//    self.accessoryImage.center = c;
//    
//    c.x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width / 2;
//    self.titleLabel.center = c;
}

@end
