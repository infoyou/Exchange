//
//  ChatListViewCell.m
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ChatListViewCell.h"
#import "AppManager.h"
#import "TextPool.h"
#import "CommonHeader.h"
#import "QPlusAPI.h"
#import "WXWCommonUtils.h"

#import "ChatListViewCell.h"
#import "QPlusDataBase.h"
#import "GroupMemberInfo.h"
#import "iChatInstance.h"
#import "UIImage+ResizableImage.h"
#import "UIImageView+WebCache.h"

@interface ChatListViewCell() <WXWImageFetcherDelegate, SDWebImageManagerDelegate, CMPopTipViewDelegate, QPlusProgressDelegate,WXWImageDisplayerDelegate>

@end

@implementation ChatListViewCell {
    NSString *_downloadFile;
}

@synthesize userNameLabel = _userNameLabel;
@synthesize currentPopTipViewTarget = _currentPopTipViewTarget;
@synthesize parentView = _parentView;
@synthesize selfImgUrl = _selfImgUrl;
@synthesize targetImgUrl = _targetImgUrl;
@synthesize bubbleBG = _bubbleBG;
@synthesize secbubbleLabel = _secbubbleLabel;
@synthesize bubbleVoiceImage = _bubbleVoiceImage;
@synthesize muserName = _muserName;
@synthesize isListenImage = _isListenImage;
@synthesize voiceIconTimer = _voiceIconTimer;
@synthesize isPlaying = _isPlaying;
@synthesize targetImageButton = _targetImageButton;

- (id)initWithStyle:(UITableViewCellStyle)style
            message:(QPlusMessage *)message
    reuseIdentifier:(NSString *)reuseIdentifier
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
             alumni:(Alumni *)alumni
             selfId:(NSString *)selfId
                row:(NSInteger)row
           userInfo:(UserBaseInfo *)userInfo
           showTime:(BOOL)showTime
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self updateUserBaseInfo:userInfo message:message];
        
        _delegate = imageClickableDelegate;
        self.selfId = selfId;
        self.row = row;
        //self.membersList = _membersList;
        
        _imageDisplayerDelegate = self;
        
        [self initSubViews:message];
    }
    
    self.backgroundColor = TRANSPARENT_COLOR;
    return self;
}

- (void)updateUserBaseInfo:(UserBaseInfo *)userBaseInfo message:(QPlusMessage *)message {
    
    self.selfImgUrl = userBaseInfo.portraitName;
    self.msg = message;
    if(userBaseInfo) {
        self.targetImgUrl = userBaseInfo.portraitName;
        self.muserInfo = userBaseInfo;
    } else {
        self.targetImgUrl = @"";
    }
    self.muserName = userBaseInfo.chName;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _userNameLabel.text = @"";
    _secbubbleLabel.text = @"";
    _bubbleVoiceImage.image = nil;
    _bubbleImage.image = nil;
    _muserName = @"";
    _isListenImage.text = @"";
    
}

- (void)dealloc {
    self.selfImgUrl = nil;
    self.targetImgUrl = nil;
    self.targetImageButton = nil;
    self.selfImageButton = nil;
    self.msg = nil;
    
    RELEASE_OBJ(_popView);
    RELEASE_OBJ(_bubbleLabel);
    RELEASE_OBJ(_bubbleVoiceImage);
    RELEASE_OBJ(_targetImgView);
    RELEASE_OBJ(_selfImgView);
    RELEASE_OBJ(_bubbleImageView);
    RELEASE_OBJ(_isListenImage);
    RELEASE_OBJ(_secbubbleLabel);
    RELEASE_OBJ(_dateLabel);
    RELEASE_OBJ(_userNameLabel);
    RELEASE_OBJ(_bubbleImage);
    [super dealloc];
}

#pragma mark -- delegate
- (void)imageButtonClicked:(id)sender {
    
    QPlusImageObject *imageObject = self.msg.mediaObject;
    UIImage *image;
    
    if (imageObject.resPath) {
        image = [[[UIImage alloc]initWithContentsOfFile:imageObject.resPath] autorelease];
        if (image == nil) {
            image =[[[UIImage alloc]initWithData:imageObject.thumbData] autorelease];
        }
    } else {
        image =[[[UIImage alloc]initWithData:imageObject.thumbData] autorelease];
    }
    
    [_delegate openImage:image];
}

#pragma mark - open profile
- (void)openSelfProfile:(id)sender {
    
    if (_delegate) {
        [_delegate openProfile:[AppManager instance].userId userType:[AppManager instance].userType];
    }
}

- (void)openTargetProfile:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(openProfile:userType:)]) {
        [_delegate openProfile:self.msg.senderID userType:nil];
    }
}

#pragma mark - draw view

- (void)updateImage
{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *image = [manager imageWithURL:[NSURL URLWithString:_downloadFile]];
    
    if (image) {
        if (self.isSelf) {
            self.selfImgView.image = image;
        } else {
            self.targetImgView.image = image;
        }
    } else {
        image = [UIImage imageWithContentsOfFile:_downloadFile];
        if (image)  {
            [manager downloadWithURL:[NSURL URLWithString:self.selfImgUrl]  delegate:self];
            
            if (self.isSelf) {
                self.selfImgView.image = image;
            }
            else {
                self.targetImgView.image = image;
            }
        } else {
            DLog(@"image error:%@", _downloadFile);
        }
    }
}

#pragma mark - ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
//    [self updateImage];
}

- (void)initSubViews:(QPlusMessage *)message {
    
    _popView = [[UIView alloc] initWithFrame:CGRectZero];
    _bubbleLabel = [[UILabel alloc] init];
    _bubbleVoiceImage = [[UIImageView alloc] init];
    _targetImgView = [[UIImageView alloc] init];
    _selfImgView = [[UIImageView alloc] init];
    _bubbleImageView = [[UIImageView alloc] init];
    _isListenImage = [[UILabel alloc] init];
    _secbubbleLabel = [[UILabel alloc] init];
    _dateLabel = [[UILabel alloc] init];
    _userNameLabel = [[UILabel alloc] init];
    _bubbleImage = [[UIImageView alloc] init];
}

- (void)drawChat:(QPlusMessage*)message row:(NSInteger)row showTime:(BOOL)showTime {
    
    DLog(@"%@", self.muserInfo.chName);
    self.row = row;
    
    if([message.senderID isEqualToString:[AppManager instance].userId]) {
        self.isSelf = YES;
    }else
        self.isSelf = NO;
    
	_popView.backgroundColor = TRANSPARENT_COLOR;
    
    _dateLabel.frame = CGRectMake(0, 2, SCREEN_WIDTH, 14);
    _dateLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE-5.0f);
    _dateLabel.backgroundColor = [UIColor colorWithWhite:.65 alpha:1];
    _dateLabel.textAlignment = UITextAlignmentCenter;
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.layer.cornerRadius = _dateLabel.frame.size.height / 2;
    _dateLabel.contentMode = UIViewContentModeCenter;
    
    _userNameLabel.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/2, 14);
    _userNameLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE-5.0f);
    _userNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [_userNameLabel setTextColor:[UIColor darkGrayColor]];
    
    //    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:message.date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    //    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    [formatter release];

    //    dateLabel.text = confromTimespStr;
    _dateLabel.text = [CommonMethod getChatFormatedTime:message.date];
    
    CGSize dateSize = [WXWCommonUtils sizeForText:_dateLabel.text
                                             font:_dateLabel.font
                                       attributes:@{NSFontAttributeName : _dateLabel.font}];
    CGFloat dateLabelWdith = dateSize.width + 25;
    _dateLabel.frame = CGRectMake((self.frame.size.width - dateLabelWdith) / 2, 2, dateLabelWdith, _dateLabel.frame.size.height);
    
    
    if (showTime)
        [self.contentView addSubview:_dateLabel];
    
    // Text
    if ([message.text isEqualToString:DELETE_GROUP_MESSAGE]) {
        
        _bubbleLabel.text = LocaleStringForKey(NSGroupDeleted, nil);
        _bubbleLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE);
        _bubbleLabel.textColor = [UIColor redColor];
    }else{
        _bubbleLabel.text = message.text;
        _bubbleLabel.font = FONT_SYSTEM_SIZE(FONT_SIZE);
//        _bubbleLabel.textColor = [UIColor colorWithHexString:@"424242"];
        
        UIColor* textColor = (self.isSelf) ? [UIColor whiteColor] : [UIColor darkGrayColor];
        [_bubbleLabel setTextColor:textColor];
    }
    
    // image
    _bubbleImage.frame = CGRectMake(20, 24, 60, 60);
    
    NSString *bubbleVoiceImageName = @"";
    if (self.isSelf)
        bubbleVoiceImageName = @"voice_right3";
    else
        bubbleVoiceImageName = @"voice_left3";
    
    _bubbleVoiceImage.image = [UIImage imageNamed:bubbleVoiceImageName];
    if (self.isSelf) {
        _bubbleVoiceImage.frame = CGRectMake(50, 22, 19, 20);
    } else {
        _bubbleVoiceImage.frame = CGRectMake(15, 22, 19, 20);
    }

    CGSize size = [_bubbleLabel.text sizeWithFont:_bubbleLabel.font constrainedToSize:CGSizeMake(180.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    if (message.type == TEXT) {
        size = [_bubbleLabel.text sizeWithFont:_bubbleLabel.font constrainedToSize:CGSizeMake(180.0f, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    }
    if (message.type == SMALL_IMAGE) {
        size = CGSizeMake(70, 70);
    }
    if (message.type == BIG_IMAGE) {
        size = CGSizeMake(70, 70);
    }
    if (message.type == VOICE) {
        size = CGSizeMake(60, 20);
    }
    
	_bubbleLabel.frame = CGRectMake(25.0f, 29.0f, size.width+5, size.height+6);
	_bubbleLabel.backgroundColor = TRANSPARENT_COLOR;
	_bubbleLabel.numberOfLines = 0;
	_bubbleLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    
    // bubble Image
    UIImage *bubbleImg = [UIImage imageNamed:self.isSelf ? @"bubble0_normal.png" : @"bubble0.png"];
    UIEdgeInsets insets = UIEdgeInsetsMake(17.0f, 20.0f, 17.0f, 20.0f);
	[_bubbleImageView setImage:[bubbleImg resizableImage:insets]];
    
	_bubbleImageView.frame = CGRectMake(0.0f, 12.0f, size.width + 40.f, size.height + 15.0f);
    
	if(self.isSelf) {
        self.selfImgView.hidden = NO;
        self.selfImageButton.hidden = NO;
        self.targetImgView.hidden = YES;
        self.targetImageButton.hidden = YES;
        self.selfImgView.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH, size.height, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        self.selfImgView.contentMode = UIViewContentModeScaleAspectFill;
        //        self.selfImgView.backgroundColor = COLOR(234, 234, 234);
        //        self.selfImgView.layer.cornerRadius = 6.0f;
        self.selfImgView.layer.masksToBounds = YES;
        //        self.selfImgView.image = TRANSPARENT_COLOR;
        self.selfImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.selfImgView];
        
        // self Img Button
        self.selfImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selfImageButton.layer.cornerRadius = 6.0f;
        self.selfImageButton.layer.masksToBounds = YES;
        //        self.selfImageButton.layer.borderWidth = 1.0f;
        self.selfImageButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.selfImageButton.showsTouchWhenHighlighted = YES;
        [self.selfImageButton addTarget:self action:@selector(openSelfProfile:) forControlEvents:UIControlEventTouchUpInside];
        self.selfImageButton.frame = CGRectMake(0, 4, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        [self.selfImgView addSubview:self.selfImageButton];
        
		_popView.frame = CGRectMake(self.selfImgView.frame.origin.x - MARGIN*6 - size.width, MARGIN*2 - 4, size.width+40.f, size.height+30.0f);
        _bubbleLabel.frame = CGRectMake(2.0f, 12.0f, size.width+5, size.height+6);
        
        _userNameLabel.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH, size.height + CHART_PHOTO_HEIGHT/*MARGIN*3 + CHART_PHOTO_HEIGHT + 2*/, CHART_PHOTO_WIDTH, 24);
        //        _userNameLabel.text = self.muserInfo.chName;//self.muserName;
	} else {
        
        self.selfImgView.hidden = YES;
        self.selfImageButton.hidden = YES;
        self.targetImgView.hidden = NO;
        self.targetImageButton.hidden = NO;
        
        self.targetImgView.frame = CGRectMake(MARGIN, size.height, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        self.targetImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.targetImgView.backgroundColor = COLOR(234, 234, 234);
        //        self.targetImgView.layer.cornerRadius = 6.0f;
        self.targetImgView.layer.masksToBounds = YES;
        self.targetImgView.backgroundColor = TRANSPARENT_COLOR;
        self.targetImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.targetImgView];
        
        // target Img Button
        self.targetImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.targetImageButton.layer.cornerRadius = 6.0f;
        self.targetImageButton.layer.masksToBounds = YES;
        //        self.targetImageButton.layer.borderWidth = 1.0f;
        self.targetImageButton.layer.borderColor = [UIColor grayColor].CGColor;
        self.targetImageButton.showsTouchWhenHighlighted = YES;
        [self.targetImageButton addTarget:self action:@selector(openTargetProfile:) forControlEvents:UIControlEventTouchUpInside];
        //        self.targetImageButton.frame = CGRectMake(MARGIN, size.height - 10.0f, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        self.targetImageButton.frame = CGRectMake(0, 4, CHART_PHOTO_WIDTH, CHART_PHOTO_HEIGHT);
        
        [self.targetImgView addSubview:self.targetImageButton];
        
		_popView.frame = CGRectMake(2*MARGIN+CHART_PHOTO_WIDTH, MARGIN*2 - 4, size.width+40.f, size.height+30.0f);
        _bubbleLabel.frame = CGRectMake(14.0f, 14.0f, size.width+5, size.height+6);
        
        //muserInfo
        _userNameLabel.frame = CGRectMake(MARGIN, size.height + CHART_PHOTO_HEIGHT/*MARGIN*3+CHART_PHOTO_HEIGHT + 4*/, CHART_PHOTO_WIDTH, 24);
        //        _userNameLabel.text = self.muserInfo.chName;
        
    }
    _userNameLabel.text = self.muserInfo.chName;
    [_userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_userNameLabel];
    
    
	[_popView addSubview:_bubbleImageView];
    //    _bubbleImageView.backgroundColor = RANDOM_COLOR;
    //    _popView.backgroundColor = [UIColor redColor];
    //    [_bubbleImageView release];
    
    if (message.type == TEXT) {
        [_bubbleImageView addSubview:_bubbleLabel];
        //        _bubbleLabel.backgroundColor = WHITE_COLOR;
        CGFloat bubbleX = (_bubbleImageView.frame.size.width - _bubbleLabel.frame.size.width) / 2.f;
        CGFloat bubbleY = (_bubbleImageView.frame.size.height - _bubbleLabel.frame.size.height) / 2.f;
        _bubbleLabel.frame = CGRectMake(bubbleX, bubbleY, _bubbleLabel.frame.size.width, _bubbleLabel.frame.size.height);
        _bubbleImage.hidden = YES;
        _bubbleVoiceImage.hidden = YES;
    }
    
    if (message.type == SMALL_IMAGE || message.type == BIG_IMAGE) {
        QPlusImageObject *imageObject = message.mediaObject;
        UIImage *image;
        CGSize imageSize;
        if (imageObject.resPath) {
            image = [[UIImage alloc]initWithContentsOfFile:imageObject.resPath];
            if (image == nil) {
                image =[[UIImage alloc]initWithData:imageObject.thumbData];
            }
        } else {
            image =[[UIImage alloc]initWithData:imageObject.thumbData];
        }
        
        if(image == nil)
            imageSize = CGSizeMake(60, 0);
        else
            imageSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
        
        if (self.isSelf) {
            
            CGRect rect = _bubbleImageView.frame;
            rect.origin.x += 3;
            if(imageSize.height < (34 - 5 * 2))
            {
                imageSize.width = (34 -  5 * 2) * imageSize.height / imageSize.width;
                imageSize.height = (34 -  5 * 2);
            }
            else if(imageSize.width > 70)
            {
                imageSize.height = 70 * imageSize.height / imageSize.width;
                imageSize.width = 70;
            }else {
                imageSize.height = 70 * imageSize.height / imageSize.width;
                imageSize.width = 70;
            }
            
            rect.size.width = imageSize.width + 14;
            rect.size.height = imageSize.height + 11;
            _bubbleImageView.frame = rect;
            
            self.selfImgView.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH,
                                                rect.size.height - CHART_PHOTO_HEIGHT + 10.0f,
                                                CHART_PHOTO_WIDTH,
                                                CHART_PHOTO_HEIGHT);
            _userNameLabel.frame = CGRectMake(self.frame.size.width - MARGIN - CHART_PHOTO_WIDTH,
                                              rect.size.height + 10.0f,
                                              CHART_PHOTO_WIDTH,
                                              24);
            
        } else {
            
            CGRect rect = _bubbleImageView.frame;
            
            if(imageSize.height < (34 - 5 * 2))
            {
                imageSize.width = (34 -  5 * 2) * imageSize.height / imageSize.width;
                imageSize.height = (34 -  5 * 2);
            }
            else if(imageSize.width > 70)
            {
                imageSize.height = 70 * imageSize.height / imageSize.width;
                imageSize.width = 70;
            }else {
                imageSize.height = 70 * imageSize.height / imageSize.width;
                imageSize.width = 70;
            }
            
            rect.size.width = imageSize.width + 14;
            rect.size.height = imageSize.height + 11;
            _bubbleImageView.frame = rect;
            
            self.targetImgView.frame = CGRectMake(MARGIN,
                                                  rect.size.height,
                                                  CHART_PHOTO_WIDTH,
                                                  CHART_PHOTO_HEIGHT);
            _userNameLabel.frame = CGRectMake(MARGIN,
                                              size.height + CHART_PHOTO_HEIGHT
                                              , CHART_PHOTO_WIDTH,
                                              24);
        }
        
        _bubbleImage.image = image;
        CGFloat startX = self.isSelf ? 5 : 9;
        _bubbleImage.frame = CGRectMake(startX, 5, imageSize.width, imageSize.height);
        [_bubbleImageView addSubview:_bubbleImage];
        _bubbleImage.hidden = NO;
        _bubbleVoiceImage.hidden = YES;
        [image release];
        
        _bubbleImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bubbleImageBtn addTarget:_delegate action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bubbleImageBtn.frame =_bubbleImageView.frame;
        _bubbleImageBtn.tag= self.row;
        
        [_popView addSubview:_bubbleImageBtn];
    }
    
    if (message.type == VOICE) {
        
        _bubbleImage.hidden = YES;
        _bubbleVoiceImage.hidden = NO;
        
        QPlusVoiceObject *voiceObject = message.mediaObject;
        
        _bubbleBG = [UIButton buttonWithType:UIButtonTypeCustom];
        //_bubbleBG.tag = ;
        [_bubbleBG addTarget:_delegate action:@selector(voiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bubbleBG.tag = self.row;
        _bubbleBG.frame = CGRectMake(10, 10.0f, 50, size.height+26.0f);
        if (voiceObject.resPath == 0) {
            //[_bubbleBG setTitle:@"   点击下载" forState:UIControlStateNormal];
            //_bubbleBG.titleLabel.font = [UIFont systemFontOfSize:10];
            //_bubbleBG.titleLabel.textColor = [UIColor blackColor];
            [QPlusAPI downloadRes:message saveTo:[self getVoiceCachePath:message] progressDelegate:self];
            //            bubbleVoiceImage.hidden =YES;
        } else {
            [_bubbleBG setTitle:@"" forState:UIControlStateNormal];
            _bubbleBG.titleLabel.textColor = [UIColor blackColor];
            _bubbleVoiceImage.hidden = NO;
        }
        
        //_bubbleBG.backgroundColor  = [UIColor redColor];
        
        int seconds = MIN(MAX(1, voiceObject.duration / 1000), 60);
        //CGFloat width = 100 + (215 - 100) / 59 * seconds;
        _secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
        _secbubbleLabel.font = FONT_SYSTEM_SIZE(14);
        _secbubbleLabel.frame = CGRectMake(0, 0, 50, 25);
        
        CGRect rect = _bubbleImageView.frame;
        rect.size.width -= 25;
        _bubbleImageView.frame = rect;
        
        if (self.isSelf) {
            rect.origin.x += 15;
            _bubbleImageView.frame = rect;
            int startX = _bubbleImageView.frame.origin.x - 50;
            CGFloat startY = (_bubbleImageView.frame.size.height - _secbubbleLabel.frame.size.height) / 2.f + _bubbleImageView.frame.origin.y;
            _secbubbleLabel.frame = CGRectMake(startX, startY, 50, 25);
            _secbubbleLabel.textAlignment = NSTextAlignmentRight;
        } else {
            
            int startX = _bubbleImageView.frame.origin.x + _bubbleImageView.frame.size.width + 1;
            CGFloat startY = (_bubbleImageView.frame.size.height - _secbubbleLabel.frame.size.height) / 2.f + _bubbleImageView.frame.origin.y;
            _secbubbleLabel.frame = CGRectMake(startX, startY, 50, 25);
            _secbubbleLabel.textAlignment = NSTextAlignmentLeft;
        }
        
        _secbubbleLabel.backgroundColor = [UIColor clearColor];
        
        [_popView addSubview:_bubbleBG];
        
        [_popView addSubview:_secbubbleLabel];
        [_bubbleImageView addSubview:_bubbleVoiceImage];
        
        CGFloat bubbleVoiceImageX = (_bubbleImageView.frame.size.width - _bubbleVoiceImage.frame.size.width) - 8.f;
        CGFloat bubbleVoiceImageY = (_bubbleImageView.frame.size.height - _bubbleVoiceImage.frame.size.height) / 2.f;
        
        CGFloat startX = self.isSelf ? bubbleVoiceImageX : 8;
        _bubbleVoiceImage.frame = CGRectMake(startX, bubbleVoiceImageY, _bubbleVoiceImage.frame.size.width, _bubbleVoiceImage.frame.size.height);
        
        if (!self.isSelf)
        {
            _isListenImage.backgroundColor = COLOR_WITH_IMAGE_NAME(@"unplay.png");
            _isListenImage.frame = CGRectMake(_secbubbleLabel.frame.origin.x + _secbubbleLabel.frame.size.width + 35, _secbubbleLabel.frame.origin.y + 14, 14, 15);
        }
    }
    
    [self.contentView addSubview:_popView];
    
    // copy
    if (message.type == TEXT) {
        _popViewBut = [UIButton buttonWithType:UIButtonTypeCustom];
        _popViewBut.layer.cornerRadius = 6.0f;
        _popViewBut.layer.masksToBounds = YES;
        [_popViewBut addTarget:self action:@selector(doPopView:) forControlEvents:UIControlEventTouchUpInside];
        _popViewBut.frame = _popView.frame;
        [self.contentView addSubview:_popViewBut];
        _popViewBut.tag = self.row;
        if (self.isSelf) {
            
            CGRect rect = _bubbleImageView.frame;
            rect.origin.x -= 10;
            _bubbleImageView.frame = rect;
        }
    }
    
    self.localImageURL = [[[CommonMethod getLocalImageFolder] stringByAppendingString:@"/"] stringByAppendingString:[CommonMethod convertURLToLocal:self.muserInfo.portraitName withId:[NSString stringWithFormat:@"%d", self.muserInfo.userID]]];
    
    [self drawAvatar:self.muserInfo.portraitName];
    
}

- (void)dismissAllPopTipViews {
	while ([[AppManager instance].visiblePopTipViews count] > 0) {
		CMPopTipView *popTipView = ([AppManager instance].visiblePopTipViews)[0];
		[[AppManager instance].visiblePopTipViews removeObjectAtIndex:0];
		[popTipView dismissAnimated:YES];
	}
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self dismissAllPopTipViews];
    [_delegate hideKeyboard];
}

- (void)doPopView:(id)sender {
    [self dismissAllPopTipViews];
   
    if (sender == _currentPopTipViewTarget) {
		// Dismiss the popTipView and that is all
		self.currentPopTipViewTarget = nil;
	} else {
        CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:@"复制"];
        popTipView.delegate = self;
        popTipView.backgroundColor = [UIColor blackColor];
        popTipView.textColor = [UIColor whiteColor];
        popTipView.animation = arc4random() % 2;
        [popTipView presentPointingAtView:_bubbleLabel inView:_parentView animated:YES];
        [[AppManager instance].visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
    }
}

#pragma mark - CMPopTipViewDelegate method
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    NSLog(@"bubbleLabel text is %@", _bubbleLabel.text);
    [AppManager instance].chartContent = _bubbleLabel.text;
    [[AppManager instance].visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:_bubbleLabel.text];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    
    if ([self currentUrlMatchCell:url]) {
        if (self.isSelf)
            self.selfImgView.image = [UIImage imageNamed:@"chat_person_cell_default.png"];
        else
            self.targetImgView.image = [UIImage imageNamed:@"chat_person_cell_default.png"];
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        if (self.isSelf) {
            image = [WXWCommonUtils cutCenterPartImage:image size:self.selfImgView.frame.size];
            self.selfImgView.image = image;
        } else {
            image = [WXWCommonUtils cutCenterPartImage:image size:self.targetImgView.frame.size];
            self.targetImgView.image = image;
        }
        
        [_imageDisplayerDelegate saveDisplayedImage:image];
    }
}


- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {

        if (self.isSelf) {
            image = [WXWCommonUtils cutCenterPartImage:image size:self.selfImgView.frame.size];
            self.selfImgView.image = image;
        }
        else {
            image = [WXWCommonUtils cutCenterPartImage:image size:self.targetImgView.frame.size];
            self.targetImgView.image = image;
        }
    }
}

- (void)fetchImageFromLocal:(NSString *)imageUrl
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];
    
    if (self.isSelf) {
        UIImage *image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:self.selfImgView.frame.size];
        
        image = [WXWCommonUtils cutCenterPartImage:image size:self.selfImgView.frame.size];
        self.selfImgView.image = image;
    } else {
        UIImage *image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:self.targetImgView.frame.size];
        
        image = [WXWCommonUtils cutCenterPartImage:image size:self.targetImgView.frame.size];
        self.targetImgView.image = image;
    }
    
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

+ (CGFloat)calculateHeightForMsg:(QPlusMessage *)msg {
    CGFloat height = 60;
    switch (msg.type) {
        case TEXT:
        {
            UIFont* font = FONT_SYSTEM_SIZE(FONT_SIZE);
            CGSize constrainedSize = CGSizeMake(180, 10000.0f);
            CGSize textSize = [[ChatListViewCell getMsgText:msg] sizeWithFont:font
                                                             constrainedToSize:constrainedSize
                                                                 lineBreakMode:NSLineBreakByWordWrapping];
            height = MAX(textSize.height + 10, 34) + 10 + 16;
        }
            break;
        case SMALL_IMAGE:
        case BIG_IMAGE:
        {
            QPlusImageObject *imageObject = msg.mediaObject;
            UIImage *image;
            CGSize imageSize;
            
            if (imageObject.resPath) {
                image = [[[UIImage alloc]initWithContentsOfFile:imageObject.resPath] autorelease];
                if (image == nil) {
                    image =[[[UIImage alloc]initWithData:imageObject.thumbData] autorelease];
                }
            } else {
                image =[[[UIImage alloc]initWithData:imageObject.thumbData] autorelease];
            }
            
            if (image == nil) {
                imageSize = CGSizeMake(60, 0);
            } else {
                imageSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
            }
            
            if (imageSize.height < (34 - 5 * 2)) {
                imageSize.width = (34 -  5 * 2) * imageSize.height / imageSize.width;
                imageSize.height = (34 -  5 * 2);
            } else if (imageSize.width > 70) {
                imageSize.height = 70 * imageSize.height / imageSize.width;
                imageSize.width = 70;
            }
            
            height = imageSize.height + 10 + 10 + 26;
        }
            break;
            
        default:
            break;
    }
    
    return height;
}

+(NSString*)getMsgText:(QPlusMessage*)msg
{
    if(msg.isPrivate)
    {
        if([[QPlusDataBase loginUserID] isEqualToString:msg.senderID])
        {
            return [NSString stringWithFormat:@"[私][to:%@]%@",msg.receiverID, msg.text];
        }
        else
        {
            return [NSString stringWithFormat:@"[私]%@",msg.text];
        }
    }
    
    return msg.text;
}

-(NSString *)getVoiceCachePath:(QPlusMessage *)msg {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *resFilePath = [paths objectAtIndex:0];
    NSString *savePath = [resFilePath stringByAppendingPathComponent:msg.uuid];
    return savePath;
}

- (void)onProgressUpdate:(QPlusMessage *)msgObejct percent:(float)percent {
    //IChatListCell *cell = _downloadingCell[msgObejct.uuid];
    //if (cell != nil) {
    int percentage = percent * 100;
    _secbubbleLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    if (percentage >= 100) {
        //     [_downloadingCell removeObjectForKey:msgObejct.uuid];
        QPlusVoiceObject *voiceObject = msgObejct.mediaObject;
        int seconds = MIN(MAX(1, voiceObject.duration / 1000), 60);
        
        _secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
    }
}

- (void)updateBubbleVoiceImage:(UIImage *)image
{
    self.bubbleVoiceImage.image = image;
}

- (void)setPlayedIcon
{
    [_isListenImage removeFromSuperview];
    _isListenImage.backgroundColor = TRANSPARENT_COLOR;
}

- (void)updateTimer:(QPlusMessage *)message
{
    if (message.type == VOICE) {
        QPlusVoiceObject *voiceObject = message.mediaObject;
        
        int seconds = MIN(MAX(1, voiceObject.duration / 1000), 60);
        //CGFloat width = 100 + (215 - 100) / 59 * seconds;
        
        _secbubbleLabel.text = [NSString stringWithFormat:@"%d''", seconds];
    }
}

- (void)drawAvatar:(NSString *)imageUrl {
    
    // 缺省图片
    if (self.isSelf) {
        self.selfImgView.image = [UIImage imageNamed:@"chat_person_cell_default.png"];
    } else {
        self.targetImgView.image = [UIImage imageNamed:@"chat_person_cell_default.png"];
    }
    
    // 更换图片
    if (imageUrl && imageUrl.length > 0 ) {
        
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        
//        /*
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *selfImgCached = [manager imageWithURL:[NSURL URLWithString:self.selfImgUrl]];
        
        if (selfImgCached) {
            self.selfImgView.image = selfImgCached;
        } else {
            [manager downloadWithURL:[NSURL URLWithString:self.selfImgUrl]  delegate:self];
        }
        
        UIImage *targetImgCached = [manager imageWithURL:[NSURL URLWithString:self.targetImgUrl]];
        
        if (targetImgCached) {
            self.targetImgView.image = targetImgCached;
        } else {
            [manager downloadWithURL:[NSURL URLWithString:self.targetImgUrl]  delegate:self];
        }
//        */
        /*
        if ([CommonMethod isExist:self.localImageURL]) {
            [self fetchImageFromLocal:self.localImageURL];
        } else {
            [self fetchImage:urls forceNew:YES];            
        }
         */
    }
}

#pragma mark - WXWImageDisplayerDelegate method
- (void)saveDisplayedImage:(UIImage *)image
{
    [CommonMethod writeImage:image toFileAtPath:self.localImageURL];
}

- (void)registerImageUrl:(NSString *)url
{
    
}

#pragma mark - SDWebImageManagerDelegate method
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
    // Do something with the downloaded image
    
    UIImage *selfImgCached = [imageManager imageWithURL:[NSURL URLWithString:self.selfImgUrl]];
    
    if (selfImgCached) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        // Use the cached image immediatly
        self.selfImgView.image = selfImgCached;
    }
    
    UIImage *targetImgCached = [imageManager imageWithURL:[NSURL URLWithString:self.targetImgUrl]];
    
    if (targetImgCached) {
        self.targetImgView.image = targetImgCached;
    }
    
    [self updateImage];
}

@end


