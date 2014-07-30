//
//  CircleMarketingMoreDetailViewController.m
//  Project
//
//  Created by Jang on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingMoreDetailViewController.h"
#import "ContentView.h"
#import "GlobalInfo.h"
#import "CommonHeader.h"

@interface CircleMarketingMoreDetailViewController () {
    
}

@property (nonatomic, retain) UIWebView *webview;
@property (nonatomic, copy) NSString *content;

@end

@implementation CircleMarketingMoreDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC content:(NSString *)content {
    
    if (self = [super initWithMOC:MOC]) {
        self.content = content;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"更多详情";
//    [self addContentView];
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
//    if (self.content && self.content.length > 0) {
//        [self loadURL:[self.content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:self.webview];
//    }
}

- (void)addWebview {
    _webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webview.scalesPageToFit = YES;
    self.webview.backgroundColor = TRANSPARENT_COLOR;
    //    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webview.frame = CGRectMake(0, 0, [GlobalInfo getDeviceSize].width, [GlobalInfo getDeviceSize].height - SYSTEM_STATUS_BAR_HEIGHT  -  44);
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webview];
    [self.webview loadHTMLString:self.content baseURL:nil];
}

- (void)addContentView {
    ContentView *content = [[ContentView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height - 40 - NAVIGATION_BAR_HEIGHT) andContent:self.content];
    [self.view addSubview:content];
    [content release];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
