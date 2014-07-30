//
//  CircleMarketingViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingViewCell.h"
#import "WXWLabel.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "WXWConstants.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "UIColor+expanded.h"
#import "EventImageList.h"
#import "NSDate+Utils.h"
#import "CommonHeader.h"
#import "CircleMarketingDetailViewController.h"
#import "EventList.h"
#import "EventImageList.h"

#define IMAGE_BG_WIDTH  302.f
#define IMAGE_BG_HEIGHT 215.f

CellMargin CMCM = {8.f, 8.f, 13.f, 5.f};

@interface CircleMarketingViewCell()

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *timeLabel;
@property (nonatomic, retain) WXWLabel *dateLabel;
@property (nonatomic, retain) WXWLabel *applyCountLabel;
@property (nonatomic, retain) UIImageView *contentImageView;
@property (nonatomic, retain) UIImageView *headImageView;
@property (nonatomic, retain) UIImageView *titleBG;

@end

@implementation CircleMarketingViewCell {
    EventList *_eventList;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate MOC:(NSManagedObjectContext *)MOC {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageDisplayerDelegate = imageDisplayerDelegate;
        
        _MOC = MOC;
        
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (_delegate && [_delegate respondsToSelector:@selector(cellTapped)]) {
        [_delegate cellTapped];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)initViews {
    _contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CMCM.left, CMCM.top, self.frame.size.width - 2 * CMCM.left, IMAGE_BG_HEIGHT)];
    self.contentImageView.image = ImageWithName(@"information_circleMarketing_cell_bg.png");
    self.contentImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.contentImageView];
    
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, IMAGE_BG_WIDTH - 2, IMAGE_BG_HEIGHT - 70)];
    self.headImageView.backgroundColor = TRANSPARENT_COLOR;
    
    self.headImageView.userInteractionEnabled = YES;
    [self.contentImageView addSubview:self.headImageView];
    
    _titleBG = [[UIImageView alloc] initWithFrame:CGRectMake(2, 128, IMAGE_BG_WIDTH - 1, 30)];
    self.titleBG.image = ImageWithName(@"information_titleLabel_bg.png");
    [self.contentImageView addSubview:self.titleBG];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0x2e2e2e"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(14);
    self.titleLabel.numberOfLines = 0;
    [self.titleBG addSubview:self.titleLabel];
    
    _dateLabel = [self initLabel:CGRectZero
                       textColor:[UIColor colorWithHexString:@"0x868686"]
                     shadowColor:TRANSPARENT_COLOR];
    self.dateLabel.font = FONT_SYSTEM_SIZE(14);
    self.dateLabel.numberOfLines = 2;
    [self.contentImageView addSubview:self.dateLabel];
    
    _timeLabel = [self initLabel:CGRectZero
                       textColor:[UIColor colorWithHexString:@"0xe83e0b"]
                     shadowColor:TRANSPARENT_COLOR];
    self.timeLabel.font = FONT_SYSTEM_SIZE(14);
    [self.contentImageView addSubview:self.timeLabel];
    
    _applyCountLabel = [self initLabel:CGRectZero
                             textColor:[UIColor colorWithHexString:@"0x868686"]
                           shadowColor:TRANSPARENT_COLOR];
    self.applyCountLabel.font = FONT_SYSTEM_SIZE(14);
//    [self.contentImageView addSubview:self.applyCountLabel];
}

- (void)resetViews {
    self.timeLabel.text = NULL_PARAM_VALUE;
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.dateLabel.text = NULL_PARAM_VALUE;
    self.applyCountLabel.text = NULL_PARAM_VALUE;
}

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        self.headImageView.image = nil;
    }
}

- (void)hideTimeLabel {
    self.timeLabel.hidden = YES;
}

- (void)showTimeLabel {
    self.timeLabel.hidden = NO;
}

- (void)drawEventList:(EventList *)eventList {
    
    _eventList = eventList;
    for (EventImageList *image in eventList.eventImageList) {
        [self drawAvatar:image.imageUrl];
    }
    
    //title
    self.titleLabel.text = eventList.eventTitle;
    
    int width = 286;
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(width, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    self.titleBG.frame = CGRectMake(self.titleBG.frame.origin.x, self.titleBG.frame.origin.y, self.titleBG.frame.size.width, 30 + titleSize.height / 2);
    self.contentImageView.frame = CGRectMake(self.contentImageView.frame.origin.x, self.contentImageView.frame.origin.y, self.contentImageView.frame.size.width, IMAGE_BG_HEIGHT + titleSize.height / 2);
    
    CGFloat titleY = (self.titleBG.frame.size.height - titleSize.height) / 2 + 10;
    self.titleLabel.frame = CGRectMake(10.f, titleY, MIN(titleSize.width, width), titleSize.height);
    
    titleSize.height = 0;
    
    //time
    self.timeLabel.text = [CommonUtils getQuantumTimeWithDateFormat:[NSString stringWithFormat:@"%@",eventList.startTime]];
    CGSize timeSize = [WXWCommonUtils sizeForText:self.timeLabel.text
                                             font:self.timeLabel.font
                                       attributes:@{NSFontAttributeName : self.timeLabel.font}];
    
    CGFloat timeY = self.titleBG.frame.origin.y + (self.titleBG.frame.size.height - timeSize.height) / 2 + 10;
    self.timeLabel.frame = CGRectMake(IMAGE_BG_WIDTH - timeSize.width - CMCM.right, timeY, MIN(timeSize.width, 80), timeSize.height);
    
    //date
    NSString *start = [_eventList.startTimeStr componentsSeparatedByString:@" "][0];
    NSString *end =  [_eventList.endTimeStr componentsSeparatedByString:@" "][0];
    
    if ([start isEqualToString:end]){
        self.dateLabel.text = [NSString stringWithFormat:@"%@", start];
    }
    else{
        self.dateLabel.text = [NSString stringWithFormat:@"%@~%@", start,end];
    }
    
    CGSize dateSize = [WXWCommonUtils sizeForText:self.dateLabel.text
                                             font:self.dateLabel.font
                                       attributes:@{NSFontAttributeName : self.dateLabel.font}];
    int height = 40;

    CGFloat dateY = self.titleBG.frame.origin.y + self.titleBG.frame.size.height + 12;
    self.dateLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + 3, dateY, self.titleBG.frame.size.width - 2*self.titleLabel.frame.origin.x, height);
    
    //applyCount
    self.applyCountLabel.text = [NSString stringWithFormat:@"已报名:%d人",[eventList.applyCount intValue]];
    CGSize applySize = [WXWCommonUtils sizeForText:self.applyCountLabel.text
                                              font:self.applyCountLabel.font
                                        attributes:@{NSFontAttributeName : self.applyCountLabel.font}];
    
    CGFloat applyY = self.dateLabel.frame.origin.y + (applySize.height - applySize.height) / 2 - 3;
    self.applyCountLabel.frame = CGRectMake(IMAGE_BG_WIDTH - applySize.width - CMCM.right, applyY, MIN(applySize.width, 120), timeSize.height);
    CGPoint c = self.dateLabel.center;
    self.applyCountLabel.center = CGPointMake(IMAGE_BG_WIDTH - applySize.width - CMCM.right + applySize.width / 2, c.y);
    
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        self.headImageView.image = nil;
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [self.headImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

@end
