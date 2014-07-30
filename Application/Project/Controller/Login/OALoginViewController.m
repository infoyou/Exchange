
/*!
 @class OALoginViewController.m
 @abstract OA登录界面
 */

#import "OALoginViewController.h"
#import "CommonHeader.h"
#import "QPlusAPI.h"
#import "AppManager.h"
#import "UIViewController+SharedObject.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "GoHighDBManager.h"
#import "iChatInstance.h"
#import "CustomeAlertView.h"
#import "UIWebViewController.h"
#import "WXWNavigationController.h"
#import "CommonUtils.h"
#import "WXWLabel.h"
#import "WXWBarItemButton.h"

#define BACK_BUTTON_WIDTH   48.0f
#define BACK_BUTTON_HEIGHT  44.0f

@interface OALoginViewController () <WXWConnectorDelegate, UITextFieldDelegate>
{
}

@property (nonatomic, copy) NSString *sessionKey;
@end

@implementation OALoginViewController {
    UIButton *_registerButton;
    UIButton *_loginButton;
    
    UITextField *_userName;
    UITextField *_userPassword;
    
    BOOL needSavePswd;
    UIButton *optionButton;
}

#pragma mark - life cycle methods
- (id)initOALoginVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    self = [super initWithMOC:MOC];
        if (self) {
            [CommonMethod getInstance].MOC = _MOC;
            self.parentVC = pVC;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
	// Do any additional setup after loading the view.
    
    //   self.view.hidden = TRUE;
    needSavePswd = YES;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated
{
    [_loginButton setEnabled:YES];
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    _sessionKey = nil;
    //    [_tpKeyboardAvoidingScrollView release];
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
    bgImgView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT- NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT);
    bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login3.5.png");
    [parentView addSubview:bgImgView];
    
    CGSize size = [[HardwareInfo getInstance] getScreenSize];
    int width = 106;
    int height = 45;
    int startY = 77;
    
    int inputLogoRegionWidth = 10;
    int inputLogoRegionHeight = 47;
    
    //92-95
    width = 245.5;
    height = 41;
    int startX = (size.width - width ) / 2.0f;
    
    UIImageView *userNameImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    userNameImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"oa_text.png");
    
    [parentView addSubview:userNameImageViewLogo];
    [userNameImageViewLogo release];
    
    //-----------------------------username input------------------------------------
    startX = userNameImageViewLogo.frame.origin.x +inputLogoRegionWidth - 5;
    startY =userNameImageViewLogo.frame.origin.y;
    width =userNameImageViewLogo.frame.size.width - inputLogoRegionWidth;
    height =inputLogoRegionHeight;
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.borderStyle = UITextBorderStyleNone;
    _userName.placeholder = LocaleStringForKey(NSLoginUserName, nil);
    [_userName setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userName.textAlignment = UITextAlignmentLeft;
    _userName.delegate = self;
    
    NSString *userNameTxt = [AppManager instance].username;
    if ([AppManager instance].OAUser != nil && [AppManager instance].OAUser.length > 0) {
        userNameTxt = [AppManager instance].OAUser;
    }
    
    _userName.text = userNameTxt;
    _userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_userName setFont:FONT_SYSTEM_SIZE(16)];
    [_userName setTextColor:[UIColor lightGrayColor]];
    
    _userName.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userName.leftView.userInteractionEnabled = NO;
    _userName.leftViewMode = UITextFieldViewModeAlways;
    
    [parentView addSubview:_userName];
    
    //92-95
    width = 245.5;
    height = 41;
    startX = (size.width - width ) / 2.0f;
    startY += userNameImageViewLogo.frame.size.height + 10;
    
    UIImageView *passwordImageViewLogo = [[UIImageView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    passwordImageViewLogo.image = IMAGE_WITH_IMAGE_NAME(@"oa_text.png");
    
    [parentView addSubview:passwordImageViewLogo];
    [passwordImageViewLogo release];
    
    //----------------------password-------------------------------------------
    startX = passwordImageViewLogo.frame.origin.x + inputLogoRegionWidth - 5;
    startY = passwordImageViewLogo.frame.origin.y;
    width  = passwordImageViewLogo.frame.size.width - inputLogoRegionWidth;
    height = inputLogoRegionHeight;
    
    _userPassword = [[UITextField alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    _userPassword.backgroundColor = [UIColor clearColor];
    _userPassword.borderStyle = UITextBorderStyleNone;
    _userPassword.placeholder = @"办公系统密码";
    [_userPassword setClearButtonMode:UITextFieldViewModeWhileEditing];
    _userPassword.secureTextEntry = YES;
    _userPassword.delegate = self;
    _userPassword.text = [AppManager instance].OAPswd;
    _userPassword.textAlignment = UITextAlignmentLeft;
    _userPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_userName setTextColor:[UIColor lightGrayColor]];
    
    _userPassword.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _userPassword.leftView.userInteractionEnabled = NO;
    _userPassword.leftViewMode = UITextFieldViewModeAlways;
    [parentView addSubview:_userPassword];

//    自动登录
    /*
    int optionButtonY = passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height + 16;
    startX = 35;
    width = 15;
    height = 15;
    
    optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    optionButton.frame = CGRectMake(startX, optionButtonY, width, height);
    [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionButSel.png") forState:UIControlStateNormal];
    [parentView addSubview:optionButton];
    
    UIButton *clickOptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clickOptionButton.frame = CGRectMake(startX-20.f, 	optionButtonY-10.f, width+40.f, height+20.f);
    [clickOptionButton addTarget:self action:@selector(markPswd) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:clickOptionButton];
    */
    
    /*
    WXWLabel *markPwdLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(35, 35, 254, 15) textColor:[UIColor colorWithHexString:@"0x666666"] shadowColor:TRANSPARENT_COLOR
                                                         font:FONT_SYSTEM_SIZE(13)] autorelease];
    markPwdLabel.numberOfLines = 0;
    [markPwdLabel setText:@"请输入内网门户的用户名及密码登录。"];
    [markPwdLabel sizeToFit];
//    markPwdLabel.userInteractionEnabled = YES;
    [self.view addSubview:markPwdLabel];
    */
    
    //---------------------login button
    startX = passwordImageViewLogo.frame.origin.x;
    startY = passwordImageViewLogo.frame.origin.y + passwordImageViewLogo.frame.size.height + 40 ;
    width = 245.5;
    height = 41;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(startX, startY, width, height);
    [_loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitle:LocaleStringForKey(NSLoginLogin, nil) forState:UIControlStateNormal];
    [_loginButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"oa_login.png") forState:UIControlStateNormal];
    
    [parentView addSubview:_loginButton];
    
//    [parentView setBackgroundColor:COLOR_WITH_IMAGE_NAME(@"login_background.png")];
    
}

- (void)bringToFront
{
    
    if (needSavePswd) {
        [AppManager instance].OAUser = [_userName.text lowercaseString];
        [AppManager instance].OAPswd = _userPassword.text;
        [[AppManager instance] saveOAUserInfoIntoLocal];
    } else {
        [AppManager instance].OAUser = @"";
        [AppManager instance].OAPswd = @"";
        [[AppManager instance] saveOAUserInfoIntoLocal];
    }
    
    [self.parentVC selectOADetail];
    
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
        withPassword:_userPassword.text];
}

- (void)startLogin:(NSString *)userName withPassword:(NSString *)password
{
    
    [_loginButton setEnabled:NO];
    
    NSString *url = [NSString stringWithFormat:@"%@/client.do?method=login&clienttype=Webclient&loginid=%@&password=%@", [AppManager instance].oaUrl, userName, password];
    
    _currentType = LOGIN_OA_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    
    [connFacade fetchGets:url];
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
}

- (void)selfResignFirstResponder
{
    [_userName resignFirstResponder];
    [_userPassword resignFirstResponder];
}

- (void)initLisentingKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

#pragma mark -- keyboard show or hidden
-(void)autoMovekeyBoard:(float)h withDuration:(float)duration{
    
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

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
       
        case LOGIN_OA_TY:
        {
            [self selfResignFirstResponder];
            
            NSDictionary *resultDic = [result objectFromJSONData];
            if (resultDic != nil) {
                self.sessionKey = [resultDic objectForKey:@"sessionkey"];
                if(self.sessionKey != nil && self.sessionKey.length > 0){
                    [self bringToFront];
                } else {
                    NSString *errorDesc = [resultDic objectForKey:@"error"];
                    
                    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSNoteTitle, nil)
                                                 message:errorDesc
                                                delegate:nil
                                       cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil)
                                       otherButtonTitles:nil] autorelease] show];
                }
            } else {
                NSString *myHTML = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                NSLog(@"result = %@", myHTML);
                
                UIWebView* webView = [[UIWebView alloc]initWithFrame:self.view.frame];
                webView.autoresizesSubviews = NO; //自动调整大小
                webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
                [self.view addSubview:webView];
                
                [webView loadHTMLString:myHTML baseURL:[NSURL URLWithString:@"http://baidu.com"]];
            }
            
            break;
        }
            
        default:
            break;
    }
    
    [_loginButton setEnabled:YES];
    
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

#pragma mark -- text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -  customer alert delegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView {
    [alertView release];
}

- (void)markPswd {
    
    if (needSavePswd) {
        [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionBut.png") forState:UIControlStateNormal];
        needSavePswd = NO;
    } else {
        [optionButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"optionButSel.png") forState:UIControlStateNormal];
        needSavePswd = YES;
    }
}

@end
