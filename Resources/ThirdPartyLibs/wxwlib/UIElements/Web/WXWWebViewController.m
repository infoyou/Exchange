//
//  WXWWebViewController.m
//  Project
//
//  Created by XXX on 11-11-22.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWWebViewController.h"
#import "WXWTextPool.h"

#define WEBVIEW_TAG 1
#define TOOLBAR 100
#define WITH_NAVIGATIONBTN_HEIGHT     375.0f
#define WITHOUT_NAVIGATIONBTN_HEIGHT  416.0f

@interface WXWWebViewController()
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIBarButtonItem *preBtn;
@property (nonatomic, retain) UIBarButtonItem *nextBtn;
@end

@implementation WXWWebViewController

@synthesize urlStr;
@synthesize toolbar;
@synthesize webView = _webView;
@synthesize preBtn = _preBtn;
@synthesize nextBtn = _nextBtn;

- (id)initWithNeedCloseButton:(BOOL)needCloseButton
               needNavigation:(BOOL)needNavigation
               needHomeButton:(BOOL)needHomeButton
                      isLocal:(BOOL)isLocal {
  self = [super initWithMOC:nil];
  if (self) {
      _needNavigationButtons = needNavigation;
      _needCloseButton = needCloseButton;
      _isLocal = isLocal;
  }
  
  return self;
}

- (id)initWithNeedCloseButton:(BOOL)needCloseButton
               needNavigation:(BOOL)needNavigation
         blockViewWhenLoading:(BOOL)blockViewWhenLoading
               needHomeButton:(BOOL)needHomeButton
                      isLocal:(BOOL)isLocal {
  
  self = [self initWithNeedCloseButton:needCloseButton
                        needNavigation:needNavigation
                        needHomeButton:needHomeButton
                               isLocal:isLocal];
  
  if (self) {
      _blockViewWhenLoading = blockViewWhenLoading;
      _isLocal = isLocal;
  }
  return self;
}

- (UIWebView *)webView {
	if (_webView == nil) {
    CGFloat height = 0.0f;
    if (_needNavigationButtons) {
      height = self.view.frame.size.height - 41.0f;
    } else {
      height = self.view.frame.size.height;
    }
		_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
		_webView.tag = WEBVIEW_TAG;
		_webView.userInteractionEnabled = YES;
		_webView.backgroundColor = [UIColor whiteColor];
		_webView.delegate = self;
		_webView.opaque = NO;
	}
	
	return _webView;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
  /*
  if (_needRefreshButton) {
    // add refresh button
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
                                                                                            target:self 
                                                                                            action:@selector(refresh:)]autorelease];
  }
  */
  
  if (_needCloseButton) {
    [self addRightBarButtonWithTitle:LocaleStringForKey(NSCloseTitle, nil)
                              target:self
                              action:@selector(back:)];
  }
  
  if (_needNavigationButtons) {
    
    //Creat ToolBar
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, WITH_NAVIGATIONBTN_HEIGHT, self.view.frame.size.width, 20)];
    [toolbar setTag:TOOLBAR];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.tintColor = NAVIGATION_BAR_COLOR;
    [toolbar sizeToFit];
    
    // add previous bar button
    UIButton *preBarbtn = [UIButton buttonWithType:UIButtonTypeCustom];   
    [preBarbtn setTitle:LocaleStringForKey(NSPrePageTitle, nil) forState:UIControlStateNormal];
    preBarbtn.titleLabel.font = BOLD_FONT(15);
    [preBarbtn setTitleColor:[UIColor whiteColor] 
                    forState:UIControlStateNormal];
    [preBarbtn setTitleColor:[UIColor lightGrayColor]
                    forState:UIControlStateDisabled];
    preBarbtn.showsTouchWhenHighlighted = YES;
    
    [preBarbtn addTarget:self
                  action:@selector(navigationBack:) 
        forControlEvents:UIControlEventTouchUpInside];
    
    CGSize size = [preBarbtn.titleLabel.text sizeWithFont:[preBarbtn.titleLabel font]];
    
    preBarbtn.frame = CGRectMake(0.0f, 0.0f, size.width,size.height);
    
    self.preBtn = [[[UIBarButtonItem alloc] initWithCustomView:preBarbtn] autorelease];
    self.preBtn.enabled = NO;
    
    UIBarButtonItem *Item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    
    UIBarButtonItem *Item2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];
    UIButton *nextBarbtn = [UIButton buttonWithType:UIButtonTypeCustom];   
    [nextBarbtn setTitle:LocaleStringForKey(NSNextPageTitle, nil) forState:UIControlStateNormal];
    nextBarbtn.titleLabel.font = BOLD_FONT(15);
    [nextBarbtn setTitleColor:[UIColor whiteColor] 
                     forState:UIControlStateNormal];
    [nextBarbtn setTitleColor:[UIColor lightGrayColor]
                     forState:UIControlStateDisabled];
    nextBarbtn.showsTouchWhenHighlighted = YES;
    
    [nextBarbtn addTarget:self
                   action:@selector(navigationForward:) 
         forControlEvents:UIControlEventTouchUpInside];
    
    size = [nextBarbtn.titleLabel.text sizeWithFont:[nextBarbtn.titleLabel font]];
    
    nextBarbtn.frame = CGRectMake(0.0f, 0.0f, size.width,size.height);
    self.nextBtn = [[[UIBarButtonItem alloc] initWithCustomView:nextBarbtn] autorelease];
    self.nextBtn.enabled = NO;
    
    NSArray *items = [[[NSArray alloc] initWithObjects:self.preBtn, Item1, Item2, self.nextBtn, nil] autorelease];//[NSArray arrayWithObjects: self.preBtn, Item1, Item2, self.nextBtn, nil];
    
    [toolbar setItems:items];
    toolbar.hidden = NO;
    [self.view addSubview:toolbar];
    
    [Item1 release];
    Item1 = nil;
    
    [Item2 release];
    Item2 = nil;
  }
}

- (void)viewDidUnload {

  [super viewDidUnload];
}

- (void)back:(id)sender {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self.webView stopLoading];
	[self.webView removeFromSuperview];
	
	[self dismissModalViewControllerAnimated:YES];
	
	[self closeAsyncLoadingView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    NSURL *url = nil;
    NSURLRequest *request = nil;
    
    if (_isLocal) {
        url = [NSURL fileURLWithPath:self.urlStr];
        request = [NSURLRequest requestWithURL:url];
    }else {
        if (self.urlStr && [self.urlStr length] > 0) {
//            NSURL *url = nil;
            self.urlStr = [self.urlStr stringByReplacingOccurrencesOfString:@" "
                                                                 withString:NULL_PARAM_VALUE];
            if ([self.urlStr hasPrefix:@"http://"]) {
                url = [NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            } else {
                url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://%@",self.urlStr]
                                            stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
            request = [NSURLRequest requestWithURL:url
                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                   timeoutInterval:20.0];
        }
    }
    [self.view addSubview:self.webView];
    [self.webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil)
            blockCurrentView:_blockViewWhenLoading];
  
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  
  if (self.webView.canGoBack) {
    self.preBtn.enabled = YES;
  } else {
    self.preBtn.enabled = NO;
  }
  
  if (self.webView.canGoForward) {
    self.nextBtn.enabled = YES;
  } else {
    self.nextBtn.enabled = NO;
  }
  
	[self closeAsyncLoadingView];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView*)webView 
shouldStartLoadWithRequest:(NSURLRequest*)request 
 navigationType:(UIWebViewNavigationType)navigationType {	
	return YES;
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
  
  [_webView stopLoading];
  _webView.delegate = nil;
  
  RELEASE_OBJ(urlStr);
  RELEASE_OBJ(_webView);
	
  self.preBtn = nil;
  
  self.nextBtn = nil;
  
  RELEASE_OBJ(toolbar);
	
	[super dealloc];
}


#pragma mark webView navigation and refresh method
- (void)refresh:(id)sender {
	[self.webView reload];
}

- (void)navigationBack:(id)sender {
	[self.webView goBack];
}

- (void)navigationForward:(id)sender {
	[self.webView goForward];
}

- (void)stop:(id)sender {
	[self.webView stopLoading];
}

#pragma mark toolbar visibility
- (void)hideToolbar {
	toolbar.hidden = YES;
	self.webView.frame = CGRectMake(0, 0, 320, 420);
}

- (void)showToolbar {
	toolbar.hidden = NO;
	self.webView.frame = CGRectMake(0, 0, 320, 380);
}

@end
