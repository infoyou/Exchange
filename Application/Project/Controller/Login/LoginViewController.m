
/*!
 @class LoginViewController.m
 @abstract 登录界面
 */

#import "LoginViewController.h"
#import "CommonHeader.h"
#import "QPlusAPI.h"
#import "AppManager.h"
#import "UIViewController+SharedObject.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "CommonUtils.h"
#import "GoHighDBManager.h"
#import "iChatInstance.h"
#import "CircleMarkegingApplyWindow.h"
#import "CustomeAlertView.h"
#import "UIButton+Underlined.h"
#import "MBProgressHUD.h"
#import "WXWLabel.h"

@interface LoginViewController () <WXWConnectorDelegate, UITextFieldDelegate, CircleMarkegingApplyWindowDelegate>
{
    MBProgressHUD *progressHud;
    int currentUserPageNo;
    bool isFirstLoadUserInfo;
}
@end

enum ALERT_TAG {
    ALERT_TAG_MUST_UPDATE = 1,
    ALERT_TAG_CHOISE_UPDATE = 2,
};

@implementation LoginViewController {
    UIButton *_registerButton;
    UIButton *_loginButton;
    
    UITextField *_customerId;
    UITextField *_userName;
    UITextField *_userPassword;
    //    TPKeyboardAvoidingScrollView *_tpKeyboardAvoidingScrollView;
    
    BOOL  _isAutoLogin;
    BOOL needSavePswd;
    
    UIButton *optionButton;
}

#pragma mark - life cycle methods
- (id)initLoginVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    self = [super initWithMOC:MOC];
    if (self) {
        currentUserPageNo = 1;
        [CommonMethod getInstance].MOC = _MOC;
        
        if (![AppManager instance].isAutoLogout) {
            [AppManager instance].isAutoLogout = YES;
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentUserPageNo = 1;
        self.view.backgroundColor = DEFAULT_VIEW_COLOR;
        
        [self initControls:self.view];
        
        [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
        [CommonMethod viewAddGuestureRecognizer:_loginButton withTarget:self withSEL:@selector(loginButtonTapped:)];
        [CommonMethod viewAddGuestureRecognizer:_registerButton withTarget:self withSEL:@selector(registerButtonTapped:)];
        [self initLisentingKeyboard];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    needSavePswd = YES;
	// Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getDeviceToken:)
                                                 name:GET_DEVICE_TOKEN
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_loginButton setEnabled:YES];
#if APP_TYPE == APP_TYPE_FOSUN
    [_registerButton setEnabled:YES];
#endif
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControls:(UIView *)parentView
{
    UIImageView *bgImgView = [[[UIImageView alloc] init] autorelease];
    if ([CommonUtils screenHeightIs4Inch]) {
        bgImgView.frame = CGRectMake(0, 0, 320, 586);
        bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login4.png");
    } else {
        bgImgView.frame = CGRectMake(0, 0, 320, 480);
        bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login3.5.png");
    }
    [parentView addSubview:bgImgView];
    
    CGSize size = [[HardwareInfo getInstance] getScreenSize];
    int width = 143.5f;
    int height = 56;
    int startX = (size.width - width ) / 2.0f;
    int startY = 82;
    
    int inputLogoRegionWidth = 10;
    int inputLogoRegionHeight = 47;

    UIImageView *logiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    
#if APP_TYPE == APP_TYPE_BASE
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"login_gohigh_logo.png");
#elif APP_TYPE == APP_TYPE_CIO
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"cio_logo.png");
#elif APP_TYPE == APP_TYPE_IALUMNIUSA
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"usa_logo.png");
#elif APP_TYPE == APP_TYPE_FOSUN
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"fosun_logo.png");
#elif APP_TYPE == APP_TYPE_INEARBY
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"nearby_logo.png");
#elif APP_TYPE == APP_TYPE_O2O
    logiImageView.frame = CGRectMake(85, startY, 150, 30);
    logiImageView.image = IMAGE_WITH_IMAGE_NAME(@"o2o_login_logo.png");
#endif

    [parentView addSubview:logiImageView];
    [logiImageView release];
    
    // Email img
    width = 244;
    height = 38;
    startX = 33;
    startY += logiImageView.frame.size.height  + 20;
    
    UIImageView *userNameImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    userNameImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"login_text_bg");
    
    [parentView addSubview:userNameImageViewLogo];
    [userNameImageViewLogo release];
    
    //-----------------------------username input------------------------------------
    startX = userNameImageViewLogo.frame.origin.x +inputLogoRegionWidth;
    width  = userNameImageViewLogo.frame.size.width - 2*inputLogoRegionWidth;
#if APP_TYPE != APP_TYPE_FOSUN
    height = inputLogoRegionHeight;
#else
    height = 38;
#endif
    
    startY =userNameImageViewLogo.frame.origin.y;

    _userName = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.borderStyle = UITextBorderStyleNone;
    _userName.placeholder = LocaleStringForKey(NSLoginUserName, nil);
    [_userName setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userName.textAlignment = UITextAlignmentLeft;
    _userName.delegate = self;
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_userName setFont:FONT_SYSTEM_SIZE(16)];
    [_userName setTextColor:[UIColor lightGrayColor]];
    
    _userName.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userName.leftView.userInteractionEnabled = NO;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_userName];

// Password Img
#if APP_TYPE != APP_TYPE_FOSUN
    startX = (_screenSize.width - width ) / 2.0f;
    width = 266;
    height = inputLogoRegionHeight;
#else
    startX = 33;
    width = 174;
    height = 38;
#endif
    
    startY += userNameImageViewLogo.frame.size.height + 10.f;
    int registY = startY;
    
    UIImageView *passwordImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    passwordImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"login_text_bg.png");
    [parentView addSubview:passwordImageViewLogo];
    [passwordImageViewLogo release];
    
    //----------------------password-------------------------------------------
    startX = passwordImageViewLogo.frame.origin.x +inputLogoRegionWidth;
    width  = passwordImageViewLogo.frame.size.width - 2*inputLogoRegionWidth;
#if APP_TYPE != APP_TYPE_FOSUN
    height = inputLogoRegionHeight;
#else
    height = 38;
#endif
    
    _userPassword = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userPassword.backgroundColor = [UIColor clearColor];
    _userPassword.borderStyle = UITextBorderStyleNone;
    _userPassword.placeholder = LocaleStringForKey(NSLoginPassword, nil);
    [_userPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userPassword.secureTextEntry = YES;
    _userPassword.delegate = self;
    _userPassword.textAlignment = UITextAlignmentLeft;
    _userPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_userName setTextColor:[UIColor lightGrayColor]];

    _userPassword.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userPassword.leftView.userInteractionEnabled = NO;
    _userPassword.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_userPassword];
    
#if APP_TYPE != APP_TYPE_FOSUN
    UIButton *forgetPwdButton = [[UIButton alloc] initWithFrame:CGRectMake(passwordImageViewLogo.frame.origin.x + passwordImageViewLogo.frame.size.width - 60 - 3, passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height +5, 60, 15)];
    
    [forgetPwdButton drawUnderlined];
    
    forgetPwdButton.titleLabel.font = FONT_SYSTEM_SIZE(12);
    
    [forgetPwdButton setTitleColor:BASE_INFO_COLOR forState:UIControlStateNormal];
    
    [forgetPwdButton setTitle:LocaleStringForKey(NSLoginPSWDTitle, nil)
                     forState:UIControlStateNormal];
    
    [forgetPwdButton addTarget:self
                        action:@selector(forgetPasswordButtonClicked:)
              forControlEvents:UIControlEventTouchUpInside];
    
    forgetPwdButton.backgroundColor = TRANSPARENT_COLOR;
    [self.view addSubview:forgetPwdButton];
#else
    
     /*
    int optionButtonY = passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height + 16;
    startX = 33;
    width = 15;
    height = 15;
    
    optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(startX, optionButtonY, width, height);
//    [optionButton addTarget:self action:@selector(markPswd) forControlEvents:UIControlEventTouchUpInside];
    [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionButSel.png") forState:UIControlStateNormal];
    [parentView addSubview:optionButton];
    
    /*
    UIButton *clickOptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickOptionButton.frame = CGRectMake(startX-20.f, optionButtonY-10.f, width+40.f, height+20.f);
    [clickOptionButton addTarget:self action:@selector(markPswd) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:clickOptionButton];
    */
    
    WXWLabel *markPwdLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(33, passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height +3, 254, 15) textColor:[UIColor colorWithHexString:@"0x666666"] shadowColor:TRANSPARENT_COLOR
                                                         font:FONT_SYSTEM_SIZE(13)] autorelease];
    
    markPwdLabel.numberOfLines = 0;
    [markPwdLabel setText:@"激活码将发送到您指定邮箱，请使用激活码登录。"];
    [markPwdLabel sizeToFit];

//    markPwdLabel.userInteractionEnabled = YES;
    [self.view addSubview:markPwdLabel];
#endif
    
    //---------------------login button
    startY = passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height +45;
#if APP_TYPE == APP_TYPE_FOSUN
    startX = 33;
    width = 244.f;
    height = 38.f;
#else
    startX = passwordImageViewLogo.frame.origin.x;
    width = passwordImageViewLogo.frame.size.width;
    height = inputLogoRegionHeight;
#endif
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(startX, startY, width, height);
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:LocaleStringForKey(NSLoginLogin, nil) forState:UIControlStateNormal];
    [_loginButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"loginBut.png") forState:UIControlStateNormal];
    
    [parentView addSubview:_loginButton];
    
    //---------------------register button
#if APP_TYPE == APP_TYPE_FOSUN
    startX = 211;
    width = 66;
    height = 37;
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(startX, registY+1, width, height);
    [_registerButton addTarget:self action:@selector(registerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_registerButton setTitle:LocaleStringForKey(NSRegistLogin, nil) forState:UIControlStateNormal];
//    [_registerButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_registerButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"loginCode") forState:UIControlStateNormal];
    
    [parentView addSubview:_registerButton];
#endif
    
//    [parentView setBackgroundColor:COLOR_WITH_IMAGE_NAME(@"login_background.png")];
    
}

- (void)autoLogin
{
   _userName.text = [[AppManager instance].userDefaults usernameRemembered];
    
    NSString *md5Password = @"";
    
    if([[AppManager instance].userDefaults passwordRemembered] != nil)
        md5Password = [[AppManager instance].userDefaults passwordRemembered];
    
    [[AppManager instance] getUserInfoFromLocal];
    _userName.text  = [AppManager instance].username;
    
    if ([AppManager instance].passwd != nil) {
        md5Password = [CommonMethod hashStringAsMD5:[AppManager instance].passwd];
    }
    
    if (_userName.text.length > 0 && md5Password.length > 0) {
        [self startLogin:_userName.text withPassword:md5Password];
        
        [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:[[AppManager instance].userDefaults passwordRemembered]];
        _isAutoLogin = TRUE;
        return;
    }

    [self bringToFront];
}

- (void)bringToFront
{
    self.view.hidden = NO;
    BaseAppDelegate *delegate = (BaseAppDelegate *)APP_DELEGATE;
    [delegate.window addSubview:self.view];
    [delegate.window bringSubviewToFront:self.view];
}

- (BOOL)checkFields {
    if (0 == _userName.text.length ||
        0 == _userPassword.text.length) {
        ShowAlert(nil, nil, LocaleStringForKey(NSSignInInfoMandatoryMsg, nil), LocaleStringForKey(NSIKnowTitle, nil));
        
        return NO;
    }
    
    return YES;
}

- (void)registerButtonClicked:(id)sender
{
    if (!_userName.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginUserNameEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return;
    }
    
    [self startRegist:[_userName.text lowercaseString]];
}

- (void)loginButtonClicked:(id)sender
{
    if (!_userName.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginUserNameEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return;
    }
    
    if (!_userPassword.text.length) {
        [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:LocaleStringForKey(NSLoginPasswordEmpty, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
        return;
    }
    
    [self startLogin:[_userName.text lowercaseString]
        withPassword:[CommonMethod hashStringAsMD5:_userPassword.text]];
    [AppManager instance].passwd = _userPassword.text;
}

- (void)markPswd {

    if (needSavePswd) {
        [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionBut.png") forState:UIControlStateNormal];
        needSavePswd = NO;
    } else {
        [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionButSel.png") forState:UIControlStateNormal];
        needSavePswd = YES;
    }
    
    [AppManager instance].isAutoLogout = needSavePswd;
}

- (void)startRegist:(NSString *)userName {
    [_registerButton setEnabled:NO];
    
    NSDictionary *common = [AppManager instance].common;
    NSMutableDictionary *mCommon = [NSMutableDictionary dictionaryWithDictionary:common];
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]])
        [mCommon setObject:[AppManager instance].deviceToken forKey:@"deviceToken"];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:mCommon forKey:@"common"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[_userName.text lowercaseString] forKey:@"email"];
    [requestDict setObject:dict forKey:@"special"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/CommonService/ActivationEmail", VALUE_API_PREFIX];
    
    _currentType = REGIST_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
}

- (void)startLogin:(NSString *)userName withPassword:(NSString *)password
{
    
    [_loginButton setEnabled:NO];
    
    NSDictionary *common = [AppManager instance].common;
    NSMutableDictionary *mCommon = [NSMutableDictionary dictionaryWithDictionary:common];
    
    
    if (![IPHONE_SIMULATOR isEqualToString:[WXWCommonUtils deviceModel]])
        [mCommon setObject:[AppManager instance].deviceToken forKey:@"deviceToken"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[_userName.text lowercaseString] forKey:@"loginName"];
    //    [dict setValue:[CommonMethod hashStringAsMD5:_userPassword.text] forKey:@"password"];
    [dict setValue:password forKey:@"password"];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:mCommon forKey:@"common"];
    [requestDict setObject:dict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@", VALUE_API_PREFIX,API_SERVICE_USER, API_NAME_USER_SIGN_IN];
    _currentType = LOGIN_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
}

- (void)forgetPasswordButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:FORGET_PASSWORD_LINK]];
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self selfResignFirstResponder];
}


- (void)loginButtonTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self loginButtonClicked:nil];
}

- (void)registerButtonTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self registerButtonClicked:nil];
}

- (void)selfResignFirstResponder
{
    [_customerId resignFirstResponder];
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)initLisentingKeyboard
{
    //çå¬é®çé«åº¦çåæ¢
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

#pragma mark - keyboard show or hidden
-(void) autoMovekeyBoard: (float) h withDuration:(float)duration{
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGRect rect = self.view.frame;
        int height = (rect.origin.y == SYSTEM_STATUS_BAR_HEIGHT ? 60 : 0);
        if (h) {
            rect.origin.y -= height;
            self.view.frame = rect;
        }else{
            
            rect.origin.y = ([CommonMethod is7System] ? 0 : 0);
            self.view.frame = rect;
        }
        
    } completion:^(BOOL finished) {
        // stub
    }];
    
}

#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height withDuration:animationDuration];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self autoMovekeyBoard:0 withDuration:animationDuration];
}

- (void)hideKeyboard {
    
    //[self.inputToolbar.textView resignFirstResponder];
    //keyboardIsVisible = NO;
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:0.0];
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    
    if (contentType == GET_USER_PROFILES) {
        [self showAsyncLoadingView:LocaleStringForKey(NSLoadingUserDataTitle, nil) blockCurrentView:YES];
    }
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case REGIST_TY:
        {
            [self selfResignFirstResponder];
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            NSString *msg = @"";
            if (ret == SUCCESS_CODE) {
                msg = @"登录密码已经发到您的邮箱，请查收！";
            } else if(ret == EMAIL_ACCOUNT_NOT_CODE) {
                msg = @"账号不存在！";
            } else if(ret == EMAIL_TEXT_ERR_CODE){
                msg = @"邮箱输入不正确。";
            } else if(ret == EMAIL_SEND_ERR_CODE){
                msg = @"邮件发送失败。";
            } else {
                msg = [NSString stringWithFormat:@"%d", ret];
            }
            
            [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSNoteTitle, nil)
                                         message:msg
                                        delegate:nil
                               cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil)
                               otherButtonTitles:nil] autorelease] show];
            
             [_registerButton setEnabled:YES];
        }
            break;
            
        case LOGIN_TY:
        {
            [self selfResignFirstResponder];
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDict = [result objectFromJSONData];
                NSDictionary *dict = [resultDict objectForKey:@"content"];
                
                 [[AppManager instance] updateLoginSuccess:dict];
                
                // refreshTime
                NSString *refreshTime = [dict objectForKey:@"refreshTime"];
                if (!refreshTime || [refreshTime isEqual:[NSNull null]] || [refreshTime isEqual:@"<null>"]) {
                    [AppManager instance].checkInterval = 120;
                } else {
                    [AppManager instance].checkInterval = [refreshTime intValue];
                }
                
                // groupViable
                NSString *groupViable = [dict objectForKey:@"groupViable"];
                if (!groupViable || [groupViable isEqual:[NSNull null]] || [groupViable isEqual:@"<null>"]) {
                    [AppManager instance].groupVisiable = NO;
                } else {
                    [AppManager instance].groupVisiable = [groupViable boolValue];
                }
                
                // oaUrl
                NSString *oaUrl = [dict objectForKey:@"oaUrl"];
                if (!oaUrl || [oaUrl isEqual:[NSNull null]] || [oaUrl isEqual:@"<null>"]) {
                    [AppManager instance].oaUrl = @"http://oa.fosun.com:8080";
                } else {
                    [AppManager instance].oaUrl = oaUrl;
                }
                
                NSString *updateURL = [dict objectForKey:@"updateURL"];
                if (!updateURL || [updateURL isEqual:[NSNull null]] || [updateURL isEqual:@"<null>"]) {
                    [self doLoginLogic];
                } else {
                    [AppManager instance].updateURL = updateURL;
                    
                    NSString *isMandatory = [dict objectForKey:@"isMandatoryUpdate"];
                    if (!isMandatory || [isMandatory isEqual:[NSNull null]] || [isMandatory isEqual:@"<null>"]) {
                    } else {
                        [AppManager instance].isMandatory = [isMandatory integerValue];
                        DLog(@"%d", [AppManager instance].isMandatory);
                        
                        if ([AppManager instance].isMandatory == 1) {
                            CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                            [customeAlertView setMessage:@"有版本更新,您必须更新后才可使用."
                                                   title:@"温馨提示"];
                            customeAlertView.applyDelegate = self;
                            customeAlertView.tag = ALERT_TAG_MUST_UPDATE;
                            [customeAlertView show];
                        } else {
                            CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                            [customeAlertView setMessage:@"有新版本发布,需要更新吗?"
                                                   title:@"温馨提示"];
                            customeAlertView.applyDelegate = self;
                            customeAlertView.tag = ALERT_TAG_CHOISE_UPDATE;
                            [customeAlertView show];
                        }
                    }
                }
                
            } else if (ret == CUSTOMER_NAME_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorCustomer, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
            } else if (ret == USERNAME_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorUserName, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            } else if (ret == PASSWORD_ERR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorPassword, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            } else if (ret == ACCOUNT_INVALID_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorIDIllegal, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            } else if (ret == DB_ERROR_CODE){
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(NSLoginErrorDB, nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
                
            } else {
                [self bringToFront];
                [[[[UIAlertView alloc]initWithTitle:LocaleStringForKey(NSCommonError, nil) message:LocaleStringForKey(@"", nil) delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles: nil] autorelease]show];
            }
            break;
        }

        case SET_USER_LOGIN_LICALL:
        {
            [self doLoadUserMsg];
        }
            break;
            
        case GET_USER_PROFILES:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            
                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParam:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            //保存用户到DB
                            [[GoHighDBManager instance] upinsertUserIntoDB:[CommonMethod userBaseInfoWithDictUserProfile:userProfile] timestamp:[timestamp doubleValue]];
                            [[GoHighDBManager instance] upinsertUserProfile:userProfile];
                            
//                            NSMutableArray *arr = [[GoHighDBManager instance] getUserPropertiesByUserId:userProfile.userID] ;
//                            DLog(@"%d",arr.count);
                        }
                    }
                    
                    if (currentUserPageNo < [AppManager instance].userPageNoCount){
                        currentUserPageNo ++;
                        [self loadDataUserProfile:currentUserPageNo];
                    } else {
                        isFirstLoadUserInfo = NO;
                        currentUserPageNo = 1;
                        [AppManager instance].userPageNoCount = 0;
                        
                        [self doRegistPushNotify];
                        
                        [self  doLoginSuccess];
                        
                        [super connectDone:result
                                       url:url
                               contentType:contentType];
                    }
                }
            }
            break;
        }
            
        case REGIST_PUSH_NOTIFY_TY:
            {
                NSLog(@"### REGIST PUSH NOTIFY TY connectDone ###");
            }
            break;
            
            
        default:
            break;
    }
    
    [_loginButton setEnabled:YES];

}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if (contentType == REGIST_PUSH_NOTIFY_TY)
        {
            NSLog(@"### REGIST PUSH NOTIFY TY connectFailed ###");
            return;
        }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(closeSplash)]) {
        [self.delegate closeSplash];
    }
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

#pragma mark - text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)doRegistPushNotify
{
        NSMutableDictionary *specialDict = [[NSMutableDictionary alloc] init];
        [specialDict setObject:[AppManager instance].deviceToken forKey:@"DeviceToken"];
        [specialDict setObject:[AppManager instance].userId forKey:@"AppUserID"];
    
        NSString *url = [NSString stringWithFormat:@"http://mo.fosun.com:8045/DynamicInterface/data/DataService.asmx/submitUserToken?ReqContent=%@", [specialDict JSONString]];
        [specialDict release];
    
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                  contentType:REGIST_PUSH_NOTIFY_TY];
        
        [connFacade fetchGets:url];
}

#pragma mark - circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
    
     [alertView release];
    
    switch (alertView.tag) {
            
        case ALERT_TAG_MUST_UPDATE:
        {
            [alertView release];
            exit(0);
        }
            break;
            
        case ALERT_TAG_CHOISE_UPDATE:
        {
            [self doLoginLogic];
        }
            break;
            
        default:
            break;
    }
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    
    [alertView release];
    
    switch (alertView.tag) {
            
        case ALERT_TAG_MUST_UPDATE:
        case ALERT_TAG_CHOISE_UPDATE:
        {
            [CommonMethod update:[AppManager instance].updateURL];
            exit(0);
        }
            break;
            
        default:
            break;
    }

}

#pragma mark -  customer alert delegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView {
    [alertView release];
}

- (void)loadDataUserProfile:(int)pageNo
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_ALLUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setObject:@(pageNo) forKey:@"pageNo"];
    
    if ( ! isFirstLoadUserInfo ) {
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestUserTimestamp] / 1000] forKey:KEY_API_PARAM_START_TIME];
    } else {
        [specialDict setObject:@"" forKey:KEY_API_PARAM_START_TIME];
    }
    
    //    [specialDict setObject:[CommonMethod convertLongTimeToString:0 forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    
    [connFacade fetchGets:url];
}

- (void)doLoginSuccess {
    
    if (_isAutoLogin)
    {
        [[AppManager instance].userDefaults rememberUsername:[_userName.text lowercaseString] andPassword:[[AppManager instance].userDefaults passwordRemembered]];
    } else {
        [[AppManager instance].userDefaults rememberUsername:[_userName.text lowercaseString] andPassword:[CommonMethod hashStringAsMD5:_userPassword.text]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginSuccessful:)]) {
        [self.delegate loginSuccessful:self];
    }
}

- (void)doLoadUserMsg {
    
    if ([[GoHighDBManager instance] getLatestUserTimestamp] < 1) {
        // 初始化用户数据
        isFirstLoadUserInfo = YES;
    } else {
        isFirstLoadUserInfo = NO;
    }
    
    [self loadDataUserProfile:1];
}

- (void)doLoginLogic {

    // 判断是否爱聊注册
    if ([[AppManager instance].isLoginLicall isEqualToString:@"0"]) {
        
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
        [dict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
        
        NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_SET_USER_LOGIN_LICALL withCommon:[AppManager instance].common  withSpecial:dict];
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                  contentType:SET_USER_LOGIN_LICALL];
        [connFacade fetchGets:url];
    } else {
        [self doLoadUserMsg];
    }
}

- (void)getDeviceToken:(id)sender
{
//    UIAlertView *pswdAlert = [[[UIAlertView alloc] initWithTitle:@"提示" message:[AppManager instance].deviceToken delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
//    
//    [pswdAlert show];
}

@end
