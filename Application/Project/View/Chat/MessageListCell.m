//
//  MessageListCell.m
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MessageListCell.h"
#import "GlobalConstants.h"
#import <QuartzCore/QuartzCore.h>
#import "CommonHeader.h"
#import "WXWConstants.h"
#import "GoHighDBManager.h"
#import "ChatModel.h"
#import "AppManager.h"

CellMargin MLCM = {10.f, 10.f, 10.f, 10.f};

@interface MessageListCell()

@property (nonatomic, retain) UIButton *deleteButton;
@property (nonatomic, retain) UIButton *newMessageButton;
@end

@implementation MessageListCell {
    
    UIImageView *_portImageView;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UILabel *_messLabel;
    UILabel *_dateLabel;
    
    PrivateUserListDataModal *_dataModal;
    
//    UIButton *_deleteButton;
//    UIButton *_newMessageButton;
    
    int newMessageCount;
}

@synthesize delegate = _delegate;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Initialization code
        
        [self initSubViews];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate MOC:(NSManagedObjectContext *)MOC {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageDisplayerDelegate = imageDisplayerDelegate;
        
        _MOC = MOC;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubViews];
        
        //        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.image =IMAGE_WITH_IMAGE_NAME(@"communication_group_list_cell_background.png");
        self.backgroundView = imageView;
        [imageView release];
        
        
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionLeft)];
        [self addGestureRecognizer:recognizer];
        
        
        [self initControl];
    }
    return self;
}

- (void)dealloc {
    [_portImageView release];
    [_nameLabel release];
    [_descLabel release];
    [_messLabel release];
//    [_deleteButton release];
    _deleteButton = nil;
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)prepareForReuse{
//    UIImageView *_portImageView;
//    UILabel *_nameLabel;
//    UILabel *_descLabel;
//    UILabel *_messLabel;
//    UILabel *_dateLabel;
    _portImageView.image =IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png") ;
    _nameLabel.text = @"";
    _descLabel.text = @"";
    _messLabel.text = @"";
    _dateLabel.text = @"";
    
//    [self.deleteButton setHidden:YES];
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if ((recognizer.direction & UISwipeGestureRecognizerDirectionRight) == UISwipeGestureRecognizerDirectionRight) {
        
//        [self setDeleteButtonHidden:YES];
    }
    if ((recognizer.direction & UISwipeGestureRecognizerDirectionLeft) == UISwipeGestureRecognizerDirectionLeft) {
        if (_delegate && [_delegate respondsToSelector:@selector(hiddenOtherCellDeleteButton)]) {
            [_delegate hiddenOtherCellDeleteButton];
        }
        [self setDeleteButtonHidden:NO];
    }
}

- (void)initControl
{
    
//    int distX = 10;
//    int distY = 5;
    int height = 35;
    int width = 55;
    int startY = (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - height) /  2.0f  + 15;
    int startX = self.frame.size.width - width - 10;
//    int fontSize = 14;
    
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(startX, startY, width, height);
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
    [self.deleteButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_cell_delete") forState:UIControlStateNormal];
    
    [self.deleteButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteButton];
    [self.deleteButton setHidden:YES];
}


- (void)deleteUser:(id)sender
{
//    [sender release];
    if (_delegate && [_delegate respondsToSelector:@selector(deleteUserInfo:)]) {
        [_delegate deleteUserInfo:_dataModal];
    }
}

- (void)initSubViews {
    
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = NO;
    //    //设置阴影的高度
    self.layer.shadowOffset = CGSizeMake(0, 0);
    //设置透明度
    self.layer.shadowOpacity = 0.4;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK + COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    //    backView.layer.masksToBounds = NO;
    //    //    //设置阴影的高度
    //    backView.layer.shadowOffset = CGSizeMake(0, 1);
    //    //设置透明度
    //    backView.layer.shadowOpacity = 0.7;
    //    backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;
    //    backView.layer.backgroundColor = [UIColor blackColor].cg;
    
//    int distX = 10;
//    int distY = 5;
    int height = 50;
    int width = height;
    int startY = (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - height) /  2.0f;
    int startX = startY;
//    int fontSize = 14;
    
    
    
    _portImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    
//    _portImageView.image =[CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png") withRegionRect:_portImageView.frame];
    _portImageView.image =IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png") ;
    
    _portImageView.userInteractionEnabled = YES;
    _portImageView.contentMode = UIViewContentModeScaleToFill;
    //    _logoImageView.layer.cornerRadius = 5.0f;
    //    _logoImageView.layer.borderWidth = 0.5f;
    //    _logoImageView.layer.borderColor=[UIColor blackColor].CGColor;
    
    [backView addSubview:_portImageView];
    
    
    //---------------------
    
    int iconWidth = 25;
    
    _newMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _newMessageButton.frame =                 CGRectMake(startX + width - iconWidth / 2, startY - iconWidth / 2 , iconWidth, iconWidth);
    
    //    [_newMessageLabel setBackgroundColor:[UIColor colorWithPatternImage:[CommonMethod createImageWithColor:COLOR_WITH_IMAGE_NAME(@"communication_group_cell_pop.png") withRect:CGRectMake(0, 0, iconWidth, iconWidth)]]];
    //    [_newMessageLabel setTextColor:[UIColor whiteColor]];
    //    [_newMessageLabel setFont:FONT_SYSTEM_SIZE(8)];
    ////    [_newMessageLabel setText:@"12"];
    //    [_newMessageLabel setHidden:YES];
    //    _newMessageLabel.textAlignment = UITextAlignmentCenter;
    
    [_newMessageButton setHidden:YES];
    [_newMessageButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_newMessageButton.titleLabel setFont:FONT_SYSTEM_SIZE(8)];
    _newMessageButton.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [_newMessageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_pop.png") forState:UIControlStateNormal];
    
    [backView addSubview:_newMessageButton];
    
    //--------------------
    
    CGFloat nameLabelOriginX = MLCM.left + IMAGEVIEW_WIDTH + 5;
    CGFloat nameLabelWidth = self.frame.size.width - nameLabelOriginX - MLCM.right - DATELABEL_WIDTH;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabelOriginX, MLCM.top, nameLabelWidth, 20)];
    _nameLabel.backgroundColor = TRANSPARENT_COLOR;
    _nameLabel.font = FONT_SYSTEM_SIZE(17);
    [backView addSubview:_nameLabel];
    
    
    CGFloat dateLabelOriginX = _nameLabel.frame.origin.x + _nameLabel.frame.size.width - 15;
    CGFloat dateLabelOriginY = _nameLabel.frame.origin.y + (_nameLabel.frame.size.height - DATELABEL_HEIGHT) / 2.f;
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabelOriginX, dateLabelOriginY, DATELABEL_WIDTH, DATELABEL_HEIGHT)];
    _dateLabel.font = FONT_SYSTEM_SIZE(13);
    _dateLabel.textColor = [UIColor lightGrayColor];
    _dateLabel.backgroundColor = TRANSPARENT_COLOR;
    _dateLabel.textAlignment = NSTextAlignmentRight;
    _dateLabel.text = @"";
    [backView addSubview:_dateLabel];
    
    CGFloat messLabelOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 10;
    _messLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, messLabelOriginY, self.frame.size.width - _nameLabel.frame.origin.x - 40, 20)];
    _messLabel.backgroundColor = TRANSPARENT_COLOR;
    _messLabel.font = FONT_SYSTEM_SIZE(15);
    _messLabel.textColor = [UIColor lightGrayColor];
    [backView addSubview:_messLabel];
    
    //----------------------------bottom line ------------------------------
    startX = 0;
    //    startY = COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK;
//    height = COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT;
    height = 1;
    startY = backView.frame.size.height - height;
    width = self.frame.size.width;
    
    UILabel *_bottomLineLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(20)];
    _bottomLineLabel.backgroundColor = [UIColor lightGrayColor];
    
    [backView addSubview:_bottomLineLabel];
//    [_bottomLineLabel release];
    
    
    [CommonMethod viewAddGuestureRecognizer:backView withTarget:self withSEL:@selector(cellTapped:)];
    [CommonMethod viewAddGuestureRecognizer:_portImageView withTarget:self withSEL:@selector(imageTapped:)];
    
    [backView release];
}

- (void)imageTapped:(UIGestureRecognizer *)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(getMemberInfo:)]) {
        [_delegate getMemberInfo:_dataModal];
    }
    
}


- (void)cellTapped:(UIGestureRecognizer *)gesture {
    
    if (_delegate && [_delegate respondsToSelector:@selector(startToChat:withDataModal:newMessageCount:)]) {
        [_delegate startToChat:self withDataModal:_dataModal newMessageCount:newMessageCount];
    }
}


#pragma mark --


- (void)updateItemInfo:(PrivateUserListDataModal *)dataModal withContext:(NSManagedObjectContext*)context
{
    _dataModal = dataModal;
    
    _nameLabel.text = dataModal.userName;
    
    ChatModel *chatModel=[[GoHighDBManager instance] getPrivateLastMessage:[dataModal.userId stringValue] userId:[AppManager instance].userId];
//    if (chat) {
//        UserBaseInfo *userInfo = [[GoHighDBManager instance] getUserInfoFromDB:chat.senderID.integerValue];
//        if (chat.text)         _messLabel.text =[NSString stringWithFormat:@"%@:%@", userInfo.chName,chat.text];
//        if (chat.date) _dateLabel.text = [CommonMethod getFormatedTime:[chat.date doubleValue]];
//    }
    
    
    //--------------------------
    UserBaseInfo *userInfo = [[GoHighDBManager instance] getUserInfoFromDB:[chatModel.senderID integerValue]];
    
    NSString *userName = userInfo.chName == nil ? @"" : userInfo.chName;
    
    if ([chatModel.type integerValue] == TEXT) {
        NSString *lastMessage =  chatModel.text;
        if (lastMessage ) {
            _messLabel.text = [NSString stringWithFormat:@"%@:%@", userName,lastMessage];
        }
        
    }else if ([chatModel.type integerValue] == SMALL_IMAGE || [chatModel.type integerValue] == BIG_IMAGE) {
        _messLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"图片"];
    }else if ([chatModel.type integerValue] == VOICE) {
        _messLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"语音"];
    }else{
        _messLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"未知"];
    }
    
    NSNumber *date = chatModel.date;
    if (date) {
        _dateLabel.text = [NSString stringWithFormat:@"%@", [CommonMethod getFormatedTime:[date doubleValue]]];
    }
    
    //--------------------------
    
    [self drawAvatar:dataModal.userImageUrl];
}


- (void)setDeleteButtonHidden:(BOOL)hidden
{
    [self.deleteButton setHidden:hidden];
}

#pragma mark -- image

- (void)drawAvatar:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        NSMutableArray *urls = [NSMutableArray array];
        [urls addObject:imageUrl];
        [self fetchImage:urls forceNew:NO];
    } else {
//        _portImageView.image = nil;
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
    }
}

- (void)updateImage
{
//    UIImage *productImage = [[UIImage alloc] initWithContentsOfFile:_downloadFile];
//    [_portImageView setImage:productImage];
//    [productImage release];
}


#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
//        _portImageView.image = nil;
        _portImageView.image = IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png");
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        [_portImageView.layer addAnimation:imageFadein forKey:nil];
        //        self.headImageView.image = image;
        //        _itemImageView.image = [WXWCommonUtils cutCenterPartImage:image size:self.headImageView.frame.size];
        
        //        _portImageView.image =[CommonMethod drawImageToRect:image withRegionRect:_portImageView.frame];
        _portImageView.image = image;
        
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    
    _portImageView.image =[CommonMethod drawImageToRect:image withRegionRect:_portImageView.frame];
    _portImageView.image = image;
    
    
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}

- (void)updateMessageCount
{
    
    [_newMessageButton setHidden:NO];
    
    [_newMessageButton setTitle:[NSString stringWithFormat:@"%d", ++newMessageCount] forState:UIControlStateNormal];
}

- (void)updateMessageCount:(int)count
{
    if (count > 0) {
        [_newMessageButton setHidden:NO];
        newMessageCount = count;
        [_newMessageButton setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
    }else{
        [_newMessageButton setHidden:YES];
    }
}


-(int)newMessageCount
{
    return newMessageCount;
}


-(PrivateUserListDataModal *)getPrivateUserListDataModal
{
    return _dataModal;
}


-(void)hiddenDeleteButton:(BOOL)hidden
{
    [self.deleteButton setHidden:YES];
}


@end
