//
//  CommunicatGroupPropertyInfoViewController.m
//  Project
//
//  Created by XXX on 13-9-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CommunicatGroupPropertyInfoViewController.h"
#import "CommonHeader.h"
#import "ProjectAPI.h"
#import "GlobalConstants.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "JSONKit.h"
#import "GCPlaceholderTextView.h"
#import "WXWConstants.h"
#import "CommonUtils.h"

@interface CommunicatGroupPropertyInfoViewController ()<UITextViewDelegate,UITextFieldDelegate>
- (void) onClearContent:(id)sender;
@end


@implementation CommunicatGroupPropertyInfoViewController {
    
    UIView *_backgroundView;
    UITextView *_contentTextView;
    UIButton* _uiBtnClose;
    
    int _marginX;
    int _marginY;
    int _distY;
    
    UITextField *_nameTextField;
    ChatGroupDataModal *_dataModal;
    UIBarButtonItem *_rightButton;
    
	UILabel *_characterCountLabel;
    int _macCharacterCount;
}

@synthesize delegate = _delegate;

- (void) dealloc {
    [_backgroundView release];
    [_contentTextView release];
    [_uiBtnClose release];
    [_nameTextField release];
    [_characterCountLabel release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDataModal:(ChatGroupDataModal *)dataModal
{
    if (self = [super init]) {
        
        _dataModal = dataModal;
        
        [self initData];
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithHexString:@"e5ddd2"];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    self.navigationItem.title = self.title;
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    _macCharacterCount = 200;
    
    
//    if (_dataModal.isAdmin)
        [self initNavButton];
    
}

- (void)initNavButton
{
    self.navigationItem.rightBarButtonItem = BAR_BUTTON(@"保存", UIBarButtonItemStylePlain, self, @selector(rightNavButtonClicked:));
    
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    }
}


/*
 groupId			群组ID
 groupName		群组名称
 groupImage		群组图片
 groupDescription	群组简介
 groupPhone		群组电话
 groupEmail		群组邮箱
 groupWebsite	群组网址
 invitationPublicLevel			添加新成员权限级别（0：非公开，仅管理员可添加；1：公开，成员可添加）
 */
- (void)loadUpdateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    switch (self.type) {
        case GROUP_PROPERTY_TYPE_NAME:
            if (_contentTextView.text)
            _dataModal.groupName = _contentTextView.text;
            break;
        case GROUP_PROPERTY_BRIEF:
            if (_contentTextView.text)
                _dataModal.groupDescription = _contentTextView.text;
            break;
        case GROUP_PROPERTY_PHONE:
            if (_contentTextView.text)
                _dataModal.groupPhone = _contentTextView.text;
            break;
        case GROUP_PROPERTY_EMAIL:
            if (_contentTextView.text)
                _dataModal.groupEmail = _contentTextView.text;
            break;
        case GROUP_PROPERTY_WEBSITE:
            if (_contentTextView.text)
                _dataModal.groupWebsite = _contentTextView.text;
            break;
            
            default:
            break;
    }
    
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[_dataModal groupName] forKey:KEY_API_PARAM_GROUP_NAME];
    [specialDict setObject:[_dataModal groupImage] forKey:KEY_API_PARAM_GROUP_IMAGE];
    [specialDict setObject:[_dataModal groupDescription] forKey:KEY_API_PARAM_GROUP_DESCRIPTION];
    [specialDict setObject:[_dataModal groupPhone] forKey:KEY_API_PARAM_GROUP_PHONE];
    [specialDict setObject:[_dataModal groupEmail] forKey:KEY_API_PARAM_GROUP_EMAIL];
    [specialDict setObject:[_dataModal groupWebsite] forKey:KEY_API_PARAM_GROUP_WEBSITE];
    [specialDict setObject:[_dataModal invitationPublicLevel] forKey:KEY_API_PARAM_GROUP_INVITATION_PUBLIC_LEVEL];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_UPDATE_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_UPDATE_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}


- (void)rightNavButtonClicked:(id)sender
{
     [self loadUpdateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP
                                                        object:nil
                                                      userInfo:nil];
}

- (void)initData
{
    _marginX = 10;
    _marginY = 10;
    _distY = 10;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [_nameTextField resignFirstResponder];
}

-(void)updateInfo:(ChatGroupDataModal *)groupInfo
{
    CGSize sizeSingleLine = [@"啊" sizeWithFont:FONT_SYSTEM_SIZE(15)
                             constrainedToSize:CGSizeMake(280.0f, 1000.0f)
                                 lineBreakMode:UILineBreakModeTailTruncation];
    
    CGFloat startX = _marginX;
    CGFloat startY = _marginY + ITEM_BASE_TOP_VIEW_HEIGHT;
    CGFloat width = SCREEN_WIDTH - 2*startX;
    CGFloat height = sizeSingleLine.height*2;
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _backgroundView.layer.cornerRadius = 5.0f;
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backgroundView];
    
    //------------------------------------------------------
    startY = _marginY;
    width = _backgroundView.frame.size.width - 2*startX;
    
    _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, 0.0f, width - 15.0f, height)];
    _contentTextView.font = FONT_SYSTEM_SIZE(15);
    _contentTextView.delegate = self;
    _contentTextView.textColor = [UIColor darkGrayColor];
    _contentTextView.text = _dataModal.groupDescription;
    _contentTextView.backgroundColor = TRANSPARENT_COLOR;
    _contentTextView.returnKeyType = UIReturnKeyDone;
    [_backgroundView addSubview:_contentTextView];
    
    _uiBtnClose = [[UIButton alloc] initWithFrame:CGRectMake(_contentTextView.frame.origin.x + _contentTextView.frame.size.width + 5.0f,
                                                             (height - 14.0f)/2,
                                                             14.0f,
                                                             14.0f)];
    [_uiBtnClose setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
//    [_uiBtnClose addTarget:self action:@selector(onClearContent:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_uiBtnClose];
    
    UIButton *clickOptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickOptionButton.frame = CGRectMake(_uiBtnClose.frame.origin.x-20.f, _uiBtnClose.frame.origin.y-10.f, 54.f, 34.f);
    [clickOptionButton addTarget:self action:@selector(onClearContent:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:clickOptionButton];
    
    _characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _contentTextView.frame.origin.y + _contentTextView.frame.size.height - 10, _contentTextView.frame.size.width, 30)];
    [_characterCountLabel setBackgroundColor:[UIColor clearColor]];
    [_characterCountLabel setFont:FONT_SYSTEM_SIZE(14)];
    _characterCountLabel.textAlignment = UITextAlignmentRight;
    _characterCountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [_backgroundView  addSubview:_characterCountLabel];
    
//    if (!_dataModal.isAdmin) {
        _contentTextView.editable = YES;
//    }
    
    //------------------------------------------------------
    
//    CGRect rect = _backgroundView.frame;
//    rect.size.height = _contentTextView.frame.origin.y + _contentTextView.frame.size.height + _distY;
//    _backgroundView.frame = rect;
    //------------------------------------------------------
//    [self changeTextViewHeight:_contentTextView];

    switch (self.type) {
        case GROUP_PROPERTY_TYPE_NAME:
            _contentTextView.text = _dataModal.groupName;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_NAME;
            break;
            
        case GROUP_PROPERTY_BRIEF:
            _contentTextView.text = _dataModal.groupDescription;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_BRIEF;
            break;
            
        case GROUP_PROPERTY_PHONE:
            _contentTextView.text = _dataModal.groupPhone;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_PHONE;
            break;
            
        case GROUP_PROPERTY_EMAIL:
            _contentTextView.text = _dataModal.groupEmail;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_EMAIL;
            break;
            
        case GROUP_PROPERTY_WEBSITE:
            _contentTextView.text = _dataModal.groupWebsite;
            _macCharacterCount = GROUP_PROPERTY_MAX_COUNT_WEBSITE;
            break;
            
        default:
            break;
    }
    
	[_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d",  _contentTextView.text.length,_macCharacterCount]];
    
    [self changeTextViewHeight:_contentTextView];
    [_contentTextView becomeFirstResponder];
}

- (void)updateCharacterCount
{
    
    CGRect rect = _characterCountLabel.frame;
    rect.origin.y =_backgroundView.frame.origin.y + _backgroundView.frame.size.height - 10;
    _characterCountLabel.frame = rect;
}

- (void) onClearContent:(id)sender {
    _contentTextView.text = nil;
    
    [_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d", 0, _macCharacterCount]];
    [self changeTextViewHeight:_contentTextView];
}

#pragma mark - text field delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case SUBMIT_UPDATE_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"更新成功", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                [self back:nil];
            }
            
            break;
        }
        default:
            break;
    }
    
    [super connectDone:result
                   url:url
           contentType:contentType];
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

#pragma mark -- uitextview delegate

-(void)changeTextViewHeight:(UITextView *)textView
{
    CGRect frame = textView.frame;
    CGSize size = [textView.text sizeWithFont:textView.font
                            constrainedToSize:CGSizeMake(textView.frame.size.width - 10.0f, 1000.0f)
                                lineBreakMode:UILineBreakModeTailTruncation];
//    frame.size.height = size.height > 1 ? size.height + 20 : frame.size.height;
    CGSize sizeSingleLine = [@"啊" sizeWithFont:textView.font
                             constrainedToSize:CGSizeMake(textView.frame.size.width - 10.0f, 1000.0f)
                                 lineBreakMode:UILineBreakModeTailTruncation];
    NSInteger numberOfLines = size.height / sizeSingleLine.height;
    if (numberOfLines == 0) {
        numberOfLines = 1;
    }
    
    if (numberOfLines < 8) {
        CGFloat height = (numberOfLines == 1) ? sizeSingleLine.height * 2 : size.height + 20.0f;
        
        frame.size.height = height;
        textView.frame = frame;
        
        frame = _backgroundView.frame;
        frame.size.height = height;
        _backgroundView.frame = frame;
    }
    
    [self updateCharacterCount];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.length == 1) {
        return YES;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (range.location < _macCharacterCount) {
        return TRUE;
    }
    int count = _macCharacterCount - [[textView text] length];
    if (count <=0)
        return FALSE;
    
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    // Update the character count
	int count = _macCharacterCount - [[textView text] length];
    if (count < 0) {
        textView.text = [textView.text substringToIndex:_macCharacterCount];
        count = 0;
    }
	[_characterCountLabel setText:[NSString stringWithFormat:@"%d/%d", _macCharacterCount - count,_macCharacterCount]];
    
    [self changeTextViewHeight:textView];
}

@end
