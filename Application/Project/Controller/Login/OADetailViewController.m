//
//  OADetailViewController.m
//
//  Created by XXX on 14-1-12.
//  Copyright (c) 2014年 _MyCompanyName_. All rights reserved.
//

#import "OADetailViewController.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "UIUtils.h"
#import "WXWBarItemButton.h"
#import "AppManager.h"

#define BACK_BUTTON_WIDTH   48.0f
#define BACK_BUTTON_HEIGHT  44.0f

@interface OADetailViewController()
{
    BOOL needBackImag;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, copy) NSString *sessionKey;

@end

@implementation OADetailViewController
@synthesize strUrl;
@synthesize strTitle;
@synthesize webView;

- (id)initOADetailVC:(WXWRootViewController *)pVC
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.parentVC = pVC;
    }
    return self;
}

- (void)dealloc
{
    self.strUrl = nil;
    self.strTitle = nil;
    self.sessionKey = nil;
    
    [UIUtils closeActivityView];
    [self.webView setDelegate:nil];
    [self.webView stopLoading];
    self.webView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidAppear:(BOOL)animated {
    [self startLogin:[AppManager instance].OAUser withPassword:[AppManager instance].OAPswd];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIUtils showActivityView:self.view text:LocaleStringForKey(NSLoadingTitle, nil)];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];
    
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIUtils closeActivityView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIUtils closeActivityView];
}

- (void)goOAMenu:(id)sender {
    
    [self startLogin:[AppManager instance].OAUser withPassword:[AppManager instance].OAPswd];
}

- (void)doClose:(id)sender {
    
    [self.webView goBack];
//    [UIUtils closeActivityView];
//    [self dismissModalViewControllerAnimated:YES];
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
            NSDictionary *resultDic = [result objectFromJSONData];
            if (resultDic != nil) {
                self.sessionKey = [resultDic objectForKey:@"sessionkey"];
                [self bringToFront];
            } else {
                NSString *myHTML = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                NSLog(@"result = %@", myHTML);
                
                UIWebView *errorWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
                errorWebView.autoresizesSubviews = NO; //自动调整大小
                errorWebView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
                [self.view addSubview:errorWebView];
                
                [errorWebView loadHTMLString:myHTML baseURL:[NSURL URLWithString:@"http://baidu.com"]];
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

- (void)startLogin:(NSString *)userName withPassword:(NSString *)password
{
    
    NSString *url = [NSString stringWithFormat:@"%@/client.do?method=login&clienttype=Webclient&loginid=%@&password=%@", [AppManager instance].oaUrl, userName,password];
    
    _currentType = LOGIN_OA_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    
    [connFacade fetchGets:url];
}

- (void)bringToFront
{
    
    // go OA Screen
    self.strUrl = [NSString stringWithFormat:@"%@/home.do?sessionkey=%@", [AppManager instance].oaUrl, self.sessionKey];
    self.title = @"办公";
    needBackImag = NO;
    
    // left
    /*
    WXWBarItemButton *backButton = [[[WXWBarItemButton alloc] initBackStyleButtonWithFrame:CGRectMake(0, 0, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)] autorelease];
    [backButton addTarget:self action:@selector(doClose:) forControlEvents:UIControlEventTouchUpInside];
    self.parentVC.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    */
    
    // right
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 24, 24);
    [rightButton addTarget:self action: @selector(goOAMenu:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"oaHome.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    [rightBarButton setStyle:UIBarButtonItemStyleDone];
    self.parentVC.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:rightBarButton,nil];
    
    CGRect frame = CGRectMake(0.0, 0.0, SCREEN_WIDTH, SCREEN_HEIGHT-HOMEPAGE_TAB_HEIGHT- NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT);
    
    if (needBackImag) {
        //    background
        UIImageView *bgImgView = [[[UIImageView alloc] init] autorelease];
        bgImgView.frame = frame;
        if ([CommonUtils screenHeightIs4Inch]) {
            bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login4.png");
        } else {
            bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login3.5.png");
        }
        [self.view insertSubview:bgImgView atIndex:0];
    }
    
    //    web view
    CGRect webFrame = frame;
    self.webView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
    
    if (needBackImag) {
        self.webView.backgroundColor = TRANSPARENT_COLOR;
    } else {
        self.webView.backgroundColor = [UIColor whiteColor];
    }
    
    self.webView.opaque = NO;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.userInteractionEnabled = YES;
    
    if (![self.strUrl hasPrefix:@"http://"]) {
        self.strUrl = [NSString stringWithFormat:@"http://%@", self.strUrl];
    }
    
    NSURL *url = [NSURL URLWithString:[self.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
}

@end
