//
//  InformationListCell.m
//  Project
//
//  Created by user on 13-10-9.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "InformationListCell.h"
#import "CommonHeader.h"
#import "InformationList.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "WXWLabel.h"
#import "CommonUtils.h"

#define DATE_LABEL_WIDTH 50.f

#define TITLE_LABEL_HEIGHT 50.f
#define DATE_LABEL_HEIGHT  30.f

@interface InformationListCell()

@end

@implementation InformationListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.frame = CGRectMake(0, 0, CELL_W, CELL_H);
        [self initViews];
        if ([WXWCommonUtils currentOSVersion] < IOS7) {
            self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[CommonMethod createImageWithColor:[UIColor colorWithWhite:.9 alpha:1.]]] autorelease];
        }
        
        self.titleLabel.highlightedTextColor = [UIColor whiteColor];
        self.dateLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawInformationList:(InformationList *)infoList {
    [self resetViews];
    
    //-----------------------------
    self.titleLabel.text = infoList.title;
    
    CGSize size = [WXWCommonUtils sizeForText:self.titleLabel.text
                                         font:self.titleLabel.font
                            constrainedToSize:CGSizeMake(220, 40)
                                lineBreakMode:NSLineBreakByTruncatingTail
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    CGFloat titleLabelY = (CELL_H - size.height) / 2;
    self.titleLabel.frame = CGRectMake(20, titleLabelY, MIN(size.width, 220), size.height);
    
    //-----------------------------
    NSTimeInterval timeStamp = (NSTimeInterval)[infoList.lastUpdateTime doubleValue];
//    
//    self.dateLabel.text = [WXWCommonUtils getElapsedTime:[WXWCommonUtils convertDateTimeFromUnixTS:timeStamp / 1000.0]];
    self.dateLabel.text = [CommonMethod getFormatedTime:timeStamp / 1000];
    
    CGSize size1 = [WXWCommonUtils sizeForText:self.dateLabel.text
                                          font:self.dateLabel.font
                                    attributes:@{NSFontAttributeName : self.dateLabel.font}];
    
    CGFloat dateLabelX = CELL_W - 20.f - size1.width;
    CGFloat dateLabelY = (CELL_H - size1.height) / 2.f;
    self.dateLabel.frame = CGRectMake(dateLabelX, dateLabelY, size1.width, size1.height);
    

    //link
    self.zipURL = infoList.zipURL;
    DLog(@"%@",self.zipURL);
    self.informationID = infoList.informationID.integerValue;
}

- (void)initViews {
    //titleLabel
    self.titleLabel = [self initLabel:CGRectZero
                            textColor:[UIColor colorWithHexString:@"0x333333"]
                          shadowColor:TRANSPARENT_COLOR];
    
    self.titleLabel.font = FONT(16);
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];
    
    //dateLabel
    self.dateLabel = [self initLabel:CGRectZero
                           textColor:[UIColor colorWithHexString:@"0x999999"]
                         shadowColor:TRANSPARENT_COLOR];
    
    self.dateLabel.font = FONT(12);
    [self.contentView addSubview:self.dateLabel];
    
    //line    //---------
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CELL_H - 1, self.frame.size.width - 2*20, 1)];
    lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xcdcdcd"];

    [self.contentView addSubview:lineLabel];
    [lineLabel release];
}

- (void)dealloc {
    self.titleLabel = nil;
    self.dateLabel = nil;
    [super dealloc];
}

- (void)resetViews {
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.dateLabel.text = NULL_PARAM_VALUE;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
