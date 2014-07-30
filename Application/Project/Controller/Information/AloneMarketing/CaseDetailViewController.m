//
//  CaseDetailViewController.m
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CaseDetailViewController.h"
#import "CommonHeader.h"

@interface CaseDetailViewController ()<UIWebViewDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, retain) UIWebView *webview;

@end

@implementation CaseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithURL:(NSString *)url andTitle:(NSString *)tit {
    self = [super init];
    if (self) {
        self.url = url;
        self.navTitle = tit;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = self.navTitle;
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
    if (self.url && self.url.length > 0) {
        [self loadURL:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:self.webview];
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
    self.webview.frame = CGRectMake(0, 0, [GlobalInfo  getDeviceSize].width, [GlobalInfo getDeviceSize].height - SYSTEM_STATUS_BAR_HEIGHT  -  44);
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
