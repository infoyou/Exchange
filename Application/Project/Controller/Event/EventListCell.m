//
//  EventListCell.m
//  Project
//
//  Created by XXX on 11-12-19.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "EventListCell.h"
#import "EventList.h"
#import "WXWLabel.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "WXWSystemInfoManager.h"

#define DATE_IMG_WIDTH    59.0f
#define DATE_IMG_HEIGHT   67.0f

@interface EventListCell ()
@property (nonatomic, retain) UIImageView *dateImageView;
@property (nonatomic, retain) WXWLabel *weekLabel;
@property (nonatomic, retain) WXWLabel *dayLabel;
@property (nonatomic, retain) WXWLabel *nameLabel;
@property (nonatomic, retain) WXWLabel *groupLabel;
@property (nonatomic, retain) WXWLabel *signUpInfoLabel;
@property (nonatomic, retain) WXWLabel *statusLabel;
@property (nonatomic, retain) WXWLabel *comingDayLabel;

@end

@implementation EventListCell

- (void)initViews {
  self.dateImageView = [[[UIImageView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, DATE_IMG_WIDTH, DATE_IMG_HEIGHT)] autorelease];
  [self.contentView addSubview:self.dateImageView];
  
  self.weekLabel = [self initLabel:CGRectZero
                         textColor:[UIColor whiteColor]
                       shadowColor:TRANSPARENT_COLOR];
  self.weekLabel.font = BOLD_FONT(9);
  [self.dateImageView addSubview:self.weekLabel];
  
  self.dayLabel = [self initLabel:CGRectZero
                        textColor:[UIColor whiteColor]
                      shadowColor:TRANSPARENT_COLOR];
  self.dayLabel.font = LIGHT_FONT(36);
  [self.dateImageView addSubview:self.dayLabel];
  
  self.nameLabel = [self initLabel:CGRectZero
                         textColor:DARK_TEXT_COLOR shadowColor:TRANSPARENT_COLOR];
  self.nameLabel.font = FONT(15);
  self.nameLabel.numberOfLines = 0;
  self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  [self.contentView addSubview:self.nameLabel];
  
  self.groupLabel = [self initLabel:CGRectZero
                          textColor:BASE_INFO_COLOR shadowColor:TRANSPARENT_COLOR];
  self.groupLabel.font = FONT(13);
  self.groupLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  [self.contentView addSubview:self.groupLabel];
  
  self.signUpInfoLabel = [self initLabel:CGRectZero
                               textColor:BASE_INFO_COLOR shadowColor:TRANSPARENT_COLOR];
  self.signUpInfoLabel.font = FONT(13);
  [self.contentView addSubview:self.signUpInfoLabel];
  
  self.statusLabel = [self initLabel:CGRectZero
                           textColor:NAVIGATION_BAR_COLOR shadowColor:TRANSPARENT_COLOR];
  self.statusLabel.font = FONT(13);
  [self.contentView addSubview:self.statusLabel];
  
  self.comingDayLabel = [self initLabel:CGRectZero
                              textColor:NAVIGATION_BAR_COLOR shadowColor:TRANSPARENT_COLOR];
  self.comingDayLabel.font = FONT(13);
  [self.contentView addSubview:self.comingDayLabel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.backgroundColor = COLOR(251, 251, 251);
    self.contentView.backgroundColor = COLOR(251, 251, 251);
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self initViews];
    
  }
  
  return self;
}

- (void)dealloc {
  
  self.dateImageView = nil;
  self.nameLabel = nil;
  self.dayLabel = nil;
  self.weekLabel = nil;
  self.signUpInfoLabel = nil;
  self.groupLabel = nil;
  self.statusLabel = nil;
  self.comingDayLabel = nil;
  
  [super dealloc];
}

- (void)resetViews {
  self.nameLabel.text = NULL_PARAM_VALUE;
  self.dayLabel.text = NULL_PARAM_VALUE;
  self.weekLabel.text = NULL_PARAM_VALUE;
  self.signUpInfoLabel.text = NULL_PARAM_VALUE;
  self.groupLabel.text = NULL_PARAM_VALUE;
  self.statusLabel.text = NULL_PARAM_VALUE;
  self.comingDayLabel.text = NULL_PARAM_VALUE;
}

- (void)drawEvent:(EventList *)event {
  
  [self resetViews];
  
    NSString *monthWeekInfo = @"";
    NSString *monthDayInfo = @"";
    
    NSDate *datetime = [CommonUtils convertDateTimeFromUnixTS:([event.startTime doubleValue]/1000)];
    if ([WXWSystemInfoManager instance].currentLanguageCode == EN_TY) {
        monthWeekInfo = STR_FORMAT(@"%@ %@",
                                         [CommonUtils datetimeWithFormat:@"MMM" datetime:datetime],
                                         [CommonUtils datetimeWithFormat:@"EEEE" datetime:datetime]);
    } else {
        monthWeekInfo = STR_FORMAT(@"%@月 %@",
                                         [CommonUtils datetimeWithFormat:@"MM" datetime:datetime],
                                         [CommonUtils datetimeWithFormat:@"EEEE" datetime:datetime]);
    }
    
    monthDayInfo = [CommonUtils datetimeWithFormat:@"dd" datetime:datetime];
    
  self.weekLabel.text = monthWeekInfo;
  CGSize size = [WXWCommonUtils sizeForText:self.weekLabel.text
                                       font:self.weekLabel.font
                                 attributes:@{NSFontAttributeName : self.weekLabel.font}];
  self.weekLabel.frame = CGRectMake((DATE_IMG_WIDTH - size.width)/2.0f,
                                    9, size.width, size.height);
  
  self.dayLabel.text = monthDayInfo;
  size = [WXWCommonUtils sizeForText:self.dayLabel.text
                                font:self.dayLabel.font
                          attributes:@{NSFontAttributeName : self.dayLabel.font}];
  self.dayLabel.frame = CGRectMake((DATE_IMG_WIDTH - size.width)/2.0f, self.weekLabel.frame.origin.x + self.weekLabel.frame.size.height + MARGIN, size.width, size.height);
  
  self.nameLabel.text = event.eventTitle;
  CGSize textFrameSize = [WXWCommonUtils sizeForText:self.nameLabel.text
                                                font:self.nameLabel.font
                                   constrainedToSize:CGSizeMake(220, 40)
                                       lineBreakMode:NSLineBreakByTruncatingTail
                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : self.nameLabel.font}];
  self.nameLabel.frame = CGRectMake(self.dateImageView.frame.origin.x + self.dateImageView.frame.size.width + MARGIN * 2, self.dateImageView.frame.origin.y, textFrameSize.width, textFrameSize.height);
  
  self.groupLabel.text = @"";
  textFrameSize = [WXWCommonUtils sizeForText:self.groupLabel.text
                                         font:self.groupLabel.font
                            constrainedToSize:CGSizeMake(220, 20)
                                lineBreakMode:NSLineBreakByTruncatingTail
                                      options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName : self.groupLabel.font}];
  self.groupLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 7.0f, textFrameSize.width, textFrameSize.height);
  
  self.signUpInfoLabel.text = STR_FORMAT(LocaleStringForKey(NSPlacedSignUpCountMsg, nil), event.applyCount);
  size = [WXWCommonUtils sizeForText:self.signUpInfoLabel.text
                                font:self.signUpInfoLabel.font
                          attributes:@{NSFontAttributeName : self.signUpInfoLabel.font}];
  self.signUpInfoLabel.frame = CGRectMake(self.nameLabel.frame.origin.x,
                                          self.dateImageView.frame.origin.y + self.dateImageView.frame.size.height,
                                          size.width, size.height);
  // 测试目的
  if (event.eventId.longLongValue % 2 == 0) {
    self.dateImageView.image = IMAGE_WITH_NAME(@"eventRedIcon.png");
    
//    self.statusLabel.text = @"event.actionStr";
//    
//    size = [WXWCommonUtils sizeForText:self.statusLabel.text
//                                  font:self.statusLabel.font
//                            attributes:@{NSFontAttributeName : self.statusLabel.font}];
//    self.statusLabel.frame = CGRectMake(205, self.signUpInfoLabel.frame.origin.y, size.width, size.height);
    
  } else {
    self.dateImageView.image = IMAGE_WITH_NAME(@"eventGrayIcon.png");
  }
  
  // interval day
    int interValDay = [CommonUtils getElapsedDayCount:datetime];
     [self drawInterValDay:interValDay];
//  [self drawInterValDay:abs(interValDay)];
}

#pragma mark - interval day
- (void)drawInterValDay:(int)interValDay{
  
  if (0 == interValDay) {
    self.comingDayLabel.text = LocaleStringForKey(NSInProcessTitle, nil);
  } else if (interValDay > 0){
    self.comingDayLabel.text = [NSString stringWithFormat:@"%d %@", interValDay, LocaleStringForKey(NSHoldDayTitle, nil)];
    
    CGSize size = [WXWCommonUtils sizeForText:self.comingDayLabel.text
                                         font:self.comingDayLabel.font
                                   attributes:@{NSFontAttributeName : self.comingDayLabel.font}];
    self.comingDayLabel.frame = CGRectMake(self.frame.size.width - 8 - size.width, self.signUpInfoLabel.frame.origin.y, size.width, size.height);
  }
  
}
@end
