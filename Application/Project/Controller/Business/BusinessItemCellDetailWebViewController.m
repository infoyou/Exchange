//
//  BusinessItemCellDetailWebViewController.m
//  Project
//
//  Created by XXX on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemCellDetailWebViewController.h"
#import "FTPHelper.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"
#import "FTPHelper.h"
#import "FileUtils.h"
#import "CustomeAlertView.h"
#import "CommonMethod.h"
#import "GlobalConstants.h"

@interface BusinessItemCellDetailWebViewController ()<FTPHelperDelegate, SSZipArchiveDelegate, UIWebViewDelegate>

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) UIWebView *webview;
@property (nonatomic, retain) FTPHelper *downloader;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *zipPath;
@property (nonatomic, copy) NSString *folderPath;
//@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *htmlPath;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *fileURL;

@end

@implementation BusinessItemCellDetailWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUrl:(NSString *)url
            title:(NSString *)title {
    self = [super init];
    if (self) {
        DLog(@"%@",url);
//        if ([url hasPrefix:@"ftp"])
        {
            self.url = url;
        }
        
        self.title = title;
    }
    return self;
}

- (void)dealloc {
    [_webview release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"background.png")];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = self.title;
    
    [self addSubViews];
    
    if (!self.url) {
        [WXWUIUtils showNotificationOnTopWithMsg:@"该内容无法显示，请联系管理员"
                                         msgType:INFO_TY
                              belowNavigationBar:YES
                                  animationEnded:^{
                                  }];
        }else if([self.url hasPrefix:@"ftp:"]){
        
        self.baseURL = [[self.url componentsSeparatedByString:@"\\"] objectAtIndex:0];
        
        self.fileURL = [[self.url stringByReplacingOccurrencesOfString:self.baseURL withString:@""] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        
        self.fileName = [[self.fileURL componentsSeparatedByString:@"/"] lastObject];
        self.zipPath = [NSString stringWithFormat:@"%@/%@",[CommonMethod getLocalDownloadFolder], self.fileName];
        
        self.folderPath = [NSString stringWithFormat:@"%@/%@",[CommonMethod getLocalDownloadFolder], [self.fileName stringByDeletingPathExtension]];
        [FileUtils mkdir:self.folderPath];
        
        self.htmlPath = [NSString stringWithFormat:@"%@/%@.html",self.folderPath, [self.fileName stringByDeletingPathExtension]];
        
        if (![CommonMethod isExist:self.zipPath]) {
            [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
            
            [self downloadFileWithURL:self.fileURL];
        }else {
            if (![CommonMethod isExist:self.htmlPath]) {
                [self zipFileWithURL:self.zipPath];
            }else {
                [self loadURL:self.htmlPath webView:_webview];
            }
            
        }
        }else if([self.url hasPrefix:@"http:"]){
            [self loadWebURL:self.url webView:_webview];
        }
}

- (NSString *)dataFilePathInDocuments:(NSString*)aFilename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0];
    
    return [docDirectory stringByAppendingPathComponent:aFilename];
}

- (BOOL)fileExistsAtPath:(NSString*)aFilepath {
    NSFileManager *fm = [NSFileManager defaultManager];
    return [fm fileExistsAtPath:aFilepath];
}


- (void)downloadFileWithURL:(NSString *)url {
    if (nil != self.url && self.url.length > 0) {
        [[FTPHelper sharedInstance] setUrlString:self.baseURL];
        [[FTPHelper sharedInstance] setFilePath:self.zipPath];
        [[FTPHelper sharedInstance] setUname:@""];
        [[FTPHelper sharedInstance] setPword:@""];
        [[FTPHelper sharedInstance] setDelegate:self];
        [FTPHelper download:url];
    }
}

- (void)zipFileWithURL:(NSString *)url {
    if ([CommonMethod isExist:url]&& [FileUtils sizeOfFileAtPath:url]) {
        ZipArchive *zip = [[ZipArchive alloc] init];
        if ([zip UnzipOpenFile:url]) {
            if ([zip UnzipFileTo:self.folderPath overWrite:YES]) {
                //                [self loadDocument:self.filePath inView:self.webview];//pdf
                [zip UnzipCloseFile];
                
                DLog(@"%d", [self fileExistsAtPath:self.htmlPath]);
                [self loadURL:self.htmlPath webView:self.webview];
            }
        }
        
        [zip release];
    }else{
        [self downloadFileWithURL:self.fileURL];
    }
}

-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

-(void)loadWebURL:(NSString *)urlStr webView:(UIWebView *)view
{
    
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    NSURL     * url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:20.0];
    [view loadRequest:request];
}

- (void)loadURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [NSURL fileURLWithPath:url];
    NSURLRequest *request =  [NSURLRequest requestWithURL:requestUrl];
    [view loadRequest:request];
}

#pragma mark -- ftphelper delegate
- (void)receivedListing:(NSDictionary *)listing
{
    
}

- (void)downloadFinished
{
    DLog(@"download finished...");
    [self zipFileWithURL:self.zipPath];
    [self closeAsyncLoadingView];
    
}
- (void)dataUploadFinished:(NSNumber *)bytes
{
    
}
- (void)progressAtPercent:(NSNumber *)aPercent
{
    
}


// Failures
- (void)listingFailed
{
    
    [FileUtils rm:self.zipPath ];
    [self closeAsyncLoadingView];
}
- (void)dataDownloadFailed:(NSString *)reason
{
    
    [self closeAsyncLoadingView];
    [WXWUIUtils showNotificationOnTopWithMsg:@"网络异常，请检查网络"
                                     msgType:INFO_TY
                          belowNavigationBar:YES
                              animationEnded:^{
                              }];
    
    [FileUtils rm:self.zipPath ];
}
- (void)dataUploadFailed:(NSString *)reason
{
    
}
- (void)credentialsMissing
{
    
}

#pragma mark -- SSZipArchive delegate
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo unzippedPath:(NSString *)unzippedPath
{
    
}

- (void)addSubViews {
    int heigh=0;
    if ([CommonMethod is7System]) {
        heigh = SYS_STATUS_BAR_HEIGHT;
    }
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT  - heigh)];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    self.webview.backgroundColor = TRANSPARENT_COLOR;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //    _webview.scrollView.showsVerticalScrollIndicator = NO;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self closeAsyncLoadingView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self closeAsyncLoadingView];
}


@end
