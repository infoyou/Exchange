//
//  CircleMarketingEventCommitViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingEventCommentViewCell.h"
#import "WXWLabel.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "UIColor+expanded.h"
#import "EventImageList.h"
#import "NSDate+Utils.h"
#import "CommonHeader.h"
#import "CommentList.h"
#import "GoHighDBManager.h"



@interface CircleMarketingEventCommentViewCell() {
    CGFloat disX;
    CGFloat disY;
}

@property (nonatomic, retain) WXWLabel *nameLabel;
@property (nonatomic, retain) WXWLabel *contentLabel;
@property (nonatomic, retain) WXWLabel *timeLabel;
@property (nonatomic, retain) WXWLabel *composLabel;
@property (nonatomic, retain) UIImageView *headImage;

@end

@implementation CircleMarketingEventCommentViewCell

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
        self.headImage.image = nil;
    }
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        self.headImage.image = nil;
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [self.headImage.layer addAnimation:imageFadein forKey:nil];
        self.headImage.image = image;
        //        self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    //    self.headImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
    self.headImage.image = image;
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC {
    
    //    _imageDisplayerDelegate = imageDisplayerDelegate;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageDisplayerDelegate = imageDisplayerDelegate;
        
        _MOC = MOC;
        
        self.backgroundColor = TRANSPARENT_COLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}

- (void)initViews {
    
    disX = 10.f;
    disY = 10.f;
    
    _headImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.headImage];
    
    _nameLabel = [self initLabel:CGRectZero
                       textColor:[UIColor blackColor]
                     shadowColor:TRANSPARENT_COLOR];
    self.nameLabel.font = FONT_SYSTEM_SIZE(15);
    self.nameLabel.textColor = [UIColor colorWithHexString:@"0x353535"];
    [self.contentView addSubview:self.nameLabel];
    
    _composLabel = [self initLabel:CGRectZero
                         textColor:[UIColor blackColor]
                       shadowColor:TRANSPARENT_COLOR];
    self.composLabel.font = FONT_SYSTEM_SIZE(15);
    self.composLabel.textColor = [UIColor colorWithHexString:@"0x353535"];
    [self.contentView addSubview:self.composLabel];
    
    _contentLabel = [self initLabel:CGRectZero
                          textColor:[UIColor blackColor]
                        shadowColor:TRANSPARENT_COLOR];
    self.contentLabel.font = FONT_SYSTEM_SIZE(13);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [UIColor colorWithHexString:@"0x353535"];
    [self.contentView addSubview:self.contentLabel];
    
    _timeLabel = [self initLabel:CGRectZero
                       textColor:[UIColor blackColor]
                     shadowColor:TRANSPARENT_COLOR];
    self.timeLabel.font = FONT_SYSTEM_SIZE(12);
    self.timeLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [self.contentView addSubview:self.timeLabel];
    
}

- (void)resetViews {
    self.nameLabel.text = NULL_PARAM_VALUE;
    self.composLabel.text = NULL_PARAM_VALUE;
    self.contentLabel.text = NULL_PARAM_VALUE;
    self.timeLabel.text = NULL_PARAM_VALUE;
}

- (void)drawEventCommit:(CommentList *)comList {
    [self resetViews];
    
    [self drawAvatar:comList.userImageUrl];
    self.headImage.frame = CGRectMake(disX, disY, HEAD_IMAGE_WIDTH, HEAD_IMAGE_HEIGHT);
    
    //namelabel
    self.nameLabel.text = comList.userName;
    CGSize nameSize = [WXWCommonUtils sizeForText:self.nameLabel.text
                                             font:self.nameLabel.font
                                constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByCharWrapping
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName : self.nameLabel.font}];
    
    self.nameLabel.frame = CGRectMake(HEAD_IMAGE_WIDTH + disX * 2, disY - 3, nameSize.width, nameSize.height);
    
    //composlabel
    
    UserBaseInfo *ubi =// (UserBaseInfo *)[CommonMethod userBaseInfoWithUserID:comList.userId.integerValue];
    [[GoHighDBManager instance] getUserInfoFromDB:[comList.userId integerValue]];
    if (ubi)
    self.composLabel.text = [NSString stringWithFormat:@" | %@ %@",ubi.company, ubi.position];
    else
        self.composLabel.text = [NSString stringWithFormat:@""];
    
    CGSize composSize = [WXWCommonUtils sizeForText:self.composLabel.text
                                               font:self.composLabel.font
                                  constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                      lineBreakMode:NSLineBreakByCharWrapping
                                            options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                         attributes:@{NSFontAttributeName : self.composLabel.font}];
    
    CGFloat composY = (self.nameLabel.frame.size.height - composSize.height) / 2.f + self.nameLabel.frame.origin.y;
    self.composLabel.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width, composY, composSize.width, composSize.height);
    
    //contentlabel
    self.contentLabel.text = comList.content;
    CGSize contentSize = [WXWCommonUtils sizeForText:self.contentLabel.text
                                                font:self.contentLabel.font
                                   constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByCharWrapping
                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                          attributes:@{NSFontAttributeName : self.contentLabel.font}];
    
    CGFloat contentY = self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + disY / 2;
    self.contentLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, contentY, contentSize.width, contentSize.height);
    
    //timelabel
    self.timeLabel.text = comList.createTime;
    CGSize timeSize = [WXWCommonUtils sizeForText:self.timeLabel.text
                                             font:self.timeLabel.font
                                constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                    lineBreakMode:NSLineBreakByCharWrapping
                                          options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                       attributes:@{NSFontAttributeName : self.timeLabel.font}];
    
    CGFloat timeY = self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height + disY / 2.f;
    
    self.timeLabel.frame = CGRectMake(self.nameLabel.frame.origin.x, timeY, timeSize.width, timeSize.height);
}

@end
