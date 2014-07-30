//
//  GuideViewController.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GuideViewController.h"
#import "CommonHeader.h"

CellMargin viewMargin = {10.f, 10.f, 10.f, 10.f};

@interface GuideViewController ()<UIWebViewDelegate> {
}

@property (nonatomic, retain) UIWebView *webview;
@property (nonatomic, retain) RootCategory *rootCate;

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootCategory:(RootCategory *)rc {
    self = [super init];
    if (self) {
        self.rootCate = rc;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    [self addWebview];
}

- (void)loadURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:requestUrl];
    [view loadRequest:request];
    
    [requestUrl release];
    [request release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.rootCate.param8 && self.rootCate.param8.length > 0) {
        [self loadURL:[self.rootCate.param8 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:self.webview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addWebview {
    _webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.scalesPageToFit = YES;
    self.webview.backgroundColor = TRANSPARENT_COLOR;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.frame = CGRectMake(0, 0, [GlobalInfo  getDeviceSize].width, [GlobalInfo getDeviceSize].height - ALONE_MARKETING_TAB_HEIGHT - SYSTEM_STATUS_BAR_HEIGHT  -  44);
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webview];
}

#pragma mark - webview delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)dealloc {
    [_webview release];
    
    [super dealloc];
}

@end
