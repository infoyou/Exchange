//
//  CommunicationListViewCell.m
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationListViewCell.h"
#import "CommonHeader.h"
#import "ChatGroupDataModal.h"
#import "WXWLabel.h"
#import "GoHighDBManager.h"
#import "ChatAddGroupViewController.h"
#import "FileUtils.h"
#import "iChatInstance.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "GlobalConstants.h"
#import "JSONParser.h"
#import "AppManager.h"
#import "UIImageView+WebCache.h"

@interface CommunicationListViewCell()
{
}

@property (nonatomic, retain) NSString *chatIconUrl;

@end

@implementation CommunicationListViewCell {
    
}

@synthesize delegate = _delegate;
@synthesize downloadFile = _downloadFile;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        newMessageCount = 0;
        [self initControls:self];
        [self viewAddGuestureRecognizer:_avataImageView withSEL:@selector(getMemberList:)];
        [self viewAddGuestureRecognizer:self withSEL:@selector(startToChat:)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_list_cell_background.png");
        self.backgroundView = imageView;
        [imageView release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    
    [_avataImageView release];
    [_checkImageView release];
    [_noticeImageView release];
    [_publicGroupImageView release];
    [_numberLabel release];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initControls:(UIView *)parentView
{
    int distX = 10;
    int distY = 5;
    int height = 45;
    int width = 45;
    int startY = (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - height) /  2.0f;
    int startX = startY;
    int fontSize = 14;
    
    _avataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    
    _avataImageView.image = [CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"chat_group_cell_default.png") withRegionRect:CGRectMake(0, 0, width, height)];
    
    _avataImageView.userInteractionEnabled = YES;
    _avataImageView.contentMode = UIViewContentModeScaleToFill;
    
    [parentView addSubview:_avataImageView];
    
    int iconWidth = 25;
    
    _newMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _newMessageButton.frame =  CGRectMake(startX + width - iconWidth / 2 - 2, startY - iconWidth / 2  + 6, iconWidth, iconWidth);
    _newMessageButton.titleLabel.textAlignment = UITextAlignmentRight;
    
    [_newMessageButton setHidden:YES];
    [_newMessageButton.titleLabel setTextColor:[UIColor whiteColor]];
    [_newMessageButton.titleLabel setFont:FONT_SYSTEM_SIZE(11)];
    _newMessageButton.titleLabel.textAlignment = UITextAlignmentCenter;
    //    _newMessageButton.titleLabel.backgroundColor = [UIColor blueColor];
    [_newMessageButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_pop.png") forState:UIControlStateNormal];
    [parentView addSubview:_newMessageButton];
    
    //---------------------
    _newMessageLabel = [[UILabel alloc] initWithFrame:_newMessageButton.frame];
    [_newMessageLabel setFont:FONT_SYSTEM_SIZE(12)];
    [_newMessageLabel setTextColor:[UIColor whiteColor]];
    [_newMessageLabel setBackgroundColor:TRANSPARENT_COLOR];
    [_newMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [parentView addSubview:_newMessageLabel];
    
    //----------------------------title------------------------------
    int startXX = startX += width +distX;
    height = 25;
    width = self.frame.size.width - startX - distX;
    startY = _avataImageView.frame.origin.y-3;
    
    _titleLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(15)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    [_titleLabel setText:@"标题"];
    [_titleLabel setTextColor:[UIColor colorWithHexString:@"111111"]];
    [_titleLabel setNumberOfLines:1];
    //    [_titleLabel sizeToFit];
    [parentView addSubview:_titleLabel];

    //----------------------------last time------------------------------
    startX =parentView.frame.size.width;
    width = 60;
    height = 20;
    //    startY += height +distY;
    _dateLabel = [CommonMethod addLabel:CGRectMake(startX, startY-12, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(13)];
    _dateLabel.backgroundColor = TRANSPARENT_COLOR;
    
    [_dateLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [_dateLabel setText:[NSString stringWithFormat:@""]];
    [_dateLabel setNumberOfLines:1];
    _dateLabel.textAlignment = NSTextAlignmentRight;
    //    [_dateLabel sizeToFit];
    
    CGRect rect = _dateLabel.frame;
    rect.origin.x = self.frame.size.width - rect.size.width - distX;
    rect.origin.y += (height - rect.size.height ) /2.0;
    _dateLabel.frame = rect;
    [parentView addSubview:_dateLabel];
    
    //-----------
    rect = _titleLabel.frame;
    rect.size.width -= _dateLabel.frame.size.width;
    _titleLabel.frame = rect;
    
    startY += height + 3;
    height = 20;
    //---------------------------------------------------------------------------------
    _groupTypeLabel = [[WXWLabel alloc] initWithFrame:CGRectMake(_titleLabel.frame.origin.x, startY, width, height) textColor:[UIColor colorWithHexString:@"0xf55d22"] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(fontSize)];
    
    _groupTypeLabel.backgroundColor  = TRANSPARENT_COLOR;
    [parentView addSubview:_groupTypeLabel];
    
    //----------------------------last member speak------------------------------
    startX = startXX;
    startY = _groupTypeLabel.frame.origin.y + _groupTypeLabel.frame.size.height - 15;
    width = self.frame.size.width - startX - 5;
    _lastSpeakMemberNameLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(fontSize-1)];
    _lastSpeakMemberNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [_lastSpeakMemberNameLabel setText:@""];
    [_lastSpeakMemberNameLabel setTextColor:[UIColor colorWithHexString:@"999999"]];
    [_lastSpeakMemberNameLabel setNumberOfLines:1];
    //    [_lastSpeakMemberNameLabel sizeToFit];
    _lastSpeakMemberNameLabel.backgroundColor = TRANSPARENT_COLOR;
    [parentView addSubview:_lastSpeakMemberNameLabel];
    
    //----------------------------last member speak content------------------------------
    startX +=_lastSpeakMemberNameLabel.frame.size.width;
    _lastSpeakContentLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(fontSize)];
    _lastSpeakContentLabel.backgroundColor = TRANSPARENT_COLOR;
    [_lastSpeakContentLabel setTextColor:[UIColor darkGrayColor]];
    [_lastSpeakContentLabel setText:[NSString stringWithFormat:@"%d", arc4random() % 100 + 1]];
    [_lastSpeakContentLabel setNumberOfLines:1];
    [_lastSpeakContentLabel sizeToFit];
    
    rect = _lastSpeakContentLabel.frame;
    rect.size.width = self.frame.size.width - startX - distX;
    _lastSpeakContentLabel.frame = rect;
    //-------------------------------------------------------------------------
    
    distX = 3;
    distY = 5;
    startX = _titleLabel.frame.origin.x;
    startY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + distY;
    width = 12;
    height = 14;
    
    //审核
    //    if (![dataModal.auditNeededLevel integerValue])
    {
        _checkImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        _checkImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_check.png");
        [_checkImageView setHidden:YES];
        [self addSubview:_checkImageView];
        startX += width + distX;
    }
    
    //notice
    /*
    width = 16;
    //    if (![dataModal.canChat integerValue])
    {
        _noticeImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        _noticeImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_notice.png");
        [_noticeImageView setHidden:YES];
        [self addSubview:_noticeImageView];
        startX += width + distX;
    }
    */
    
    width= 22;
    height=15;
    {
        _publicGroupImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        _publicGroupImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_public_group.png");
        [_publicGroupImageView setHidden:YES];
        [self addSubview:_publicGroupImageView];
        startX += width + distX;
    }
    
    width = self.frame.size.width - startX - 5;
    height = 25;
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    //    [numberLabel setText:[NSString stringWithFormat:@"%d位成员",[dataModal.userCount integerValue]]];
    [_numberLabel setTextColor:[UIColor colorWithHexString:@"0x999999"]];
    _numberLabel.backgroundColor = TRANSPARENT_COLOR;
    _numberLabel.font = FONT_SYSTEM_SIZE(13);
    
    [self addSubview:_numberLabel];
    //----------------------------
    
    //-----------------------arrow ------------------------
    /*
    height = 18;
    width = 12;
    startX = self.frame.size.width - width - 15;
    startY = (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK - height) / 2.0f;
    UIImageView *arrowImageView= [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    arrowImageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_group_cell_expand.png");
    [self addSubview:arrowImageView];
    [arrowImageView release];
    */
    
    //----------------------------bottom line ------------------------------
    startX = 0;
    startY = COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK;
    width = self.frame.size.width;
    height = 1.f;
    
    _bottomLineLabel = [CommonMethod addLabel:CGRectMake(startX, startY, width, height) withTitle:@"" withFont:FONT_SYSTEM_SIZE(20)];
    _bottomLineLabel.backgroundColor = [UIColor colorWithHexString:@"0xcccccc"];
    
    [parentView addSubview:_bottomLineLabel];
    
}

-(void)prepareForReuse
{
    
    [super prepareForReuse ];
    
    _numberLabel.text=@"";
    _titleLabel.text = @"";
    _lastSpeakMemberNameLabel.text = @"";
    _dateLabel.text = @"";
    _groupTypeLabel.text=@"";
    self.downloadFile=@"";
    _bottomLineLabel.text = @"";
    
    _dataModal = nil;
    _chatModel = nil;
    
    _newMessageLabel.text = nil;
    newMessageCount = 0;
}

- (void)viewAddGuestureRecognizer:(UIView *)view withSEL:(SEL)sel
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:sel];
    
    [view addGestureRecognizer:singleTap];
}

- (void)getMemberList:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getMemberList:)]) {
        [self.delegate getMemberList:_dataModal];
    }
}

- (void)startToChat:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(startToChat:withDataModal:newMessageCount:)]) {
        [self.delegate startToChat:self withDataModal:_dataModal newMessageCount:newMessageCount];
    }
}

- (CGRect )updateDataInfo:(ChatGroupDataModal *)dataModal chatModel:(ChatModel *)chatModel
{
    
    UserBaseInfo *userInfo = [[GoHighDBManager instance] getUserInfoFromDB:[chatModel.senderID integerValue]];
    
    NSString *userName = userInfo.chName == nil ? @"" : userInfo.chName;
    
    if ([chatModel.type integerValue] == TEXT) {
        NSString *lastMessage =  chatModel.text;
        if (lastMessage ) {
            if ([lastMessage isEqualToString:DELETE_GROUP_MESSAGE]) {
                _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@",LocaleStringForKey(NSGroupDeleted, nil)];
                [_lastSpeakMemberNameLabel setTextColor:[UIColor redColor]];
            } else {
            _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,lastMessage];
            }
        }
        
    } else if ([chatModel.type integerValue] == SMALL_IMAGE || [chatModel.type integerValue] == BIG_IMAGE) {
        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"图片"];
    } else if ([chatModel.type integerValue] == VOICE) {
        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"语音"];
    } else {
        _lastSpeakMemberNameLabel.text = [NSString stringWithFormat:@"%@:%@", userName,@"未知"];
    }
    
    NSNumber *date = chatModel.date;
    if (date) {
        _dateLabel.text = [NSString stringWithFormat:@"%@", [CommonMethod getFormatedTime:[date doubleValue]]];
    }
    
    int distX = 3;
    int distY = 5;
    int startX = _titleLabel.frame.origin.x;
    int startY = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + distY;
    int width = 12;
    int height = 14;
    
    _titleLabel.numberOfLines = 1;
    [_titleLabel sizeToFit];
    
    CGRect rect = _titleLabel.frame;
        // 优化聊天标题显示
//    rect.size.width = rect.size.width > 140 ? 140 : rect.size.width;
    rect.size.width = rect.size.width > 180 ? 180 : rect.size.width;
    _titleLabel.frame = rect;
    
    startX = _titleLabel.frame.origin.x + _titleLabel.frame.size.width + 3;
    startY = _titleLabel.frame.origin.y;
    width = self.frame.size.width - startX - 5 - _dateLabel.frame.size.width;
    
    //------------------------
    _numberLabel.frame = CGRectMake(startX, startY, width, height);
    [_numberLabel setText:[NSString stringWithFormat:@" [%d人]",[dataModal.userCount integerValue]]];
    if ([AppManager instance].groupVisiable) {
        [_numberLabel setHidden:NO];
    } else {
        [_numberLabel setHidden:YES];
    }
    _numberLabel.numberOfLines = 1;
    [_numberLabel sizeToFit];
    
    rect = _numberLabel.frame;
    rect.origin.y = _titleLabel.frame.origin.y + (_titleLabel.frame.size.height - _numberLabel.frame.size.height) - 2;
    _numberLabel.frame = rect;
    
    //---------------------------
    rect = _dateLabel.frame;
    rect.origin.y = _titleLabel.frame.origin.y + (_titleLabel.frame.size.height - _dateLabel.frame.size.height);
    _dateLabel.frame = rect;
    //---------------------------
       
    startX = _dateLabel.frame.origin.x;
    startY = _dateLabel.frame.origin.y + _dateLabel.frame.size.height;
    
    rect = _lastSpeakMemberNameLabel.frame;
    rect.origin.y = startY+5;
    rect.size.width =  startX - rect.origin.x;
    _lastSpeakMemberNameLabel.frame = rect;
    
    return rect;
}

- (void)updateCellInfo:(ChatGroupDataModal *)dataModal chatModel:(ChatModel *)chatModel
{
    
    DLog(@"%@:%@", [dataModal.groupId stringValue], chatModel.groupID);
    _dataModal = [dataModal retain];
    _chatModel = [chatModel retain];
    _titleLabel.text = dataModal.groupName;
    //    _dateLabel.text = chatModel.date
    
    CGRect rect = [self updateDataInfo:dataModal chatModel:chatModel];
    
    int distX = 3;
    int distY = 5;
    int startX = 0;
    int startY = rect.origin.y;
    int width = 12;
    int height = 14;
    
    int startXX = startX =_dateLabel.frame.origin.x +_dateLabel.frame.size.width ;
    if (![dataModal.canChat integerValue]) {
        
        width = 12;
        height = 14;
        startXX == startX ? (startX -= width) : (startX -=width + distX);
        
        [_checkImageView setHidden:NO];
        _checkImageView.frame = CGRectMake(startX, startY, width, height);
    } else {
        [_checkImageView setHidden:YES];
    }
    
    if ([dataModal.groupType integerValue] == CHAT_GROUP_TYPE_UN_OPEN) {
        width = 16;
        startXX == startX ? (startX -= width) : (startX -=width + distX);
        [_noticeImageView setHidden:NO];
        _noticeImageView.frame = CGRectMake(startX, startY, width, height);
    } else {
        [_noticeImageView setHidden:YES];
    }
    
    if ([dataModal.groupType integerValue] == CHAT_GROUP_TYPE_PUBLIC) {
        width = 22;
        height = 15;
        
        startXX == startX ? (startX -= width) : (startX -=width + distX);
        
        [_publicGroupImageView setHidden:NO];
        _publicGroupImageView.frame = CGRectMake(startX, startY, width, height);
    } else {
        [_publicGroupImageView setHidden:YES];
    }
    
    // 加载群头像
    self.chatIconUrl = @"";
    
    if ([_dataModal.userCount intValue] == 2) {
        if(_dataModal.groupUserImageArray && [_dataModal.groupUserImageArray hasPrefix:@"http://"]){
            self.chatIconUrl = _dataModal.groupUserImageArray;
        } else {
            self.chatIconUrl = @"";
            
            _avataImageView.image =[CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"chat_person_cell_default.png") withRegionRect:CGRectMake(0, 0, 45.f, 45.f)];
        }
        
        if(_dataModal.groupUserNameArray && _dataModal.groupUserNameArray.length > 0){
            _titleLabel.text = _dataModal.groupUserNameArray;
        }
        
    }
    
    if (_dataModal.groupImage && [_dataModal.groupImage hasPrefix:@"http://"]) {
        self.chatIconUrl = _dataModal.groupImage;
    }
}

- (void)updateImage
{

    if ([self.chatIconUrl isEqualToString:@""]) {
        return;
    }
    
    UIImage *productImage = [UIImage imageWithContentsOfFile:self.downloadFile];
    DLog(@"%.2f:%.2f:%@", productImage.size.width, productImage.size.height,self.downloadFile);
    
    if (productImage.size.width == 0 || productImage.size.height == 0) {
        
        self.downloadFile = [CommonMethod getLocalDownloadFileName:self.chatIconUrl
                                                            withId:[NSString stringWithFormat:@"%@", _dataModal.groupId]];
        [FileUtils rm:self.downloadFile];
        if (self.downloadFile)
            [CommonMethod loadImageWithURL:self.chatIconUrl
                               delegateFor:self
                                 localName:self.downloadFile
                                  finished:^{
                                      [self updateImage];
                                  }];
    } else {
        _avataImageView.image = [CommonMethod drawImageToRect:productImage
                                               withRegionRect:CGRectMake(0, 0, _avataImageView.frame.size.width,    _avataImageView.frame.size.height)];
    }
    
}

- (void)updateMessageCount
{
    [_newMessageLabel setHidden:NO];
    [_newMessageButton setHidden:NO];
    [_newMessageLabel setText:[NSString stringWithFormat:@" %d", ++newMessageCount] ];
    [_newMessageButton setTitle:[NSString stringWithFormat:@" %d", ++newMessageCount] forState:UIControlStateNormal];
}

- (void)updateMessageCount:(int)count
{
    if (count > 0) {
        [_newMessageLabel setHidden:NO];
        [_newMessageButton setHidden:NO];
        newMessageCount = count;
        
        [_newMessageLabel setText:[NSString stringWithFormat:@"%d", count] ];
        [_newMessageButton setTitle:[NSString stringWithFormat:@"%d", count] forState:UIControlStateNormal];
    } else {
        [_newMessageLabel setHidden:YES];
        [_newMessageButton setHidden:YES];
    }
}

- (void)updateGroupName:(NSString *)groupName
{
    _titleLabel.text = groupName;
}

-(void)updateData:(ChatGroupDataModal *)dataModal  chatModel:(ChatModel *)chatModel
{
    [self updateDataInfo:dataModal chatModel:chatModel];
    
}
- (int)newMessageCount
{
    return newMessageCount;
}

- (ChatGroupDataModal *)getGroupDataModal
{
    return _dataModal;
}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ( ![self.chatIconUrl isEqualToString:@""] ) {
        self.downloadFile = [CommonMethod getLocalDownloadFileName:self.chatIconUrl
                                                            withId:[NSString stringWithFormat:@"%@", _dataModal.groupId]];

        [self loadGroupIcon:self.chatIconUrl];
    }
}

- (void)loadGroupIcon:(NSString *)groupIconUrl {
    
    [CommonMethod loadImageWithURL:groupIconUrl
                       delegateFor:self
                         localName:self.downloadFile
                          finished:^{
                              [self updateImage];
                          }];
}


@end
