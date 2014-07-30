//
//  ChatListViewCell.h
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
#import "QPlusProgressDelegate.h"
#import "ECClickableElementDelegate.h"
#import "GroupMemberInfo.h"
#import "UserHeader.h"
#import "ECImageConsumerCell.h"
#import "WXWImageDisplayerDelegate.h"

#define FONT_SIZE       15.0f

@interface ChatListViewCell : ECImageConsumerCell
{
    UIView *_parentView;
    UILabel *_bubbleLabel;
    UIView *_popView;
    UILabel *_dateLabel;
    UIImageView *_bubbleImageView;
    NSString *_selfImgUrl;
    NSString *_targetImgUrl;
    
    UIButton *_popViewBut;
    UIButton *_bubbleBG;
    UIButton *_bubbleImageBtn;
    
    UILabel *_secbubbleLabel;
    UIImageView *_bubbleVoiceImage;
    UILabel *_isListenImage;
    
    UIImageView *_targetImgView;
    UIImageView *_selfImgView;
    UIButton *_selfImageButton;
    UIButton *_targetImageButton;
    
    UIImageView *_bubbleImage;
    
    id<ECClickableElementDelegate> _delegate;
    UILabel *_userNameLabel;
    
    BOOL _isSelf;
}

@property (nonatomic, retain) UIView *parentView;
@property (nonatomic, retain) UIView *popView;
@property (nonatomic, copy) NSString *selfImgUrl;
@property (nonatomic, copy) NSString *targetImgUrl;
@property (nonatomic, retain) UIImageView *bubbleImageView;
@property (nonatomic, retain) UILabel *secbubbleLabel;
@property (nonatomic, retain) UIButton *bubbleBG;
@property (nonatomic, retain) UIImageView *bubbleVoiceImage;
@property (nonatomic, retain) UILabel *isListenImage;
@property (nonatomic, retain) UILabel *userNameLabel;

@property (nonatomic, assign) NSTimer *voiceIconTimer;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, retain) id currentPopTipViewTarget;
@property (nonatomic, retain) UIImageView *selfImgView;
@property (nonatomic, retain) UIButton *selfImageButton;
@property (nonatomic, retain) UIImageView *targetImgView;
@property (nonatomic, retain) UIButton *targetImageButton;
@property (nonatomic, retain) UIImageView *bubbleImage;
@property (nonatomic, retain) QPlusMessage *msg;
@property (nonatomic, retain) NSString *selfId;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, retain) UserBaseInfo *muserInfo;
@property (nonatomic, retain) NSString *muserName;
//@property (nonatomic, retain) NSMutableArray *membersList;
@property (nonatomic, copy) NSString *localImageURL;
@property (nonatomic, copy) NSString *localThumbImageURL;


+ (NSString*)getMsgText:(QPlusMessage*)msg;
+ (CGFloat)calculateHeightForMsg:(QPlusMessage *)msg;

- (void)drawChat:(QPlusMessage*)msg row:(NSInteger)row showTime:(BOOL)showTime;

- (id)initWithStyle:(UITableViewCellStyle)style
            message:(QPlusMessage *)message
    reuseIdentifier:(NSString *)reuseIdentifier
imageClickableDelegate:(id<ECClickableElementDelegate>)imageClickableDelegate
             alumni:(Alumni *) alumni
             selfId:(NSString *)selfId
                row:(NSInteger)row
           userInfo:(UserBaseInfo *)userInfo
           showTime:(BOOL)showTime;
- (void)updateUserBaseInfo:(UserBaseInfo *)userBaseInfo message:(QPlusMessage *)message;
- (void)drawAvatar:(NSString *)imageUrl;
- (NSString *)getVoiceCachePath:(QPlusMessage *)msg;
- (void)dismissAllPopTipViews;
- (void)updateBubbleVoiceImage:(UIImage *)image;
- (BOOL)isSelf;
- (void)setPlayedIcon;
- (void)updateTimer:(QPlusMessage *)message;

@end