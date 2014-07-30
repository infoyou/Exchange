//
//  BookCommendDetailViewController.m
//  Project
//
//  Created by Yfeng__ on 13-11-11.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookCommendDetailViewController.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"
#import "FTPHelper.h"
#import "FileUtils.h"
#import "CommonHeader.h"

@interface BookCommendDetailViewController ()<UIWebViewDelegate, SSZipArchiveDelegate, FTPHelperDelegate>

@property (nonatomic, copy) NSString *url;
@property (nonatomic, retain) UIWebView *webview;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *zipPath;
@property (nonatomic, copy) NSString *folderPath;
//@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *htmlPath;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *fileURL;

@end

@implementation BookCommendDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC url:(NSString *)url {
    self = [super initWithMOC:MOC];
    if (self) {
        self.url = url;
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
    self.navigationItem.title = @"更多推荐";
    
    [self addWebView];
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
    if ([CommonMethod isExist:url] && [FileUtils sizeOfFileAtPath:url]) {
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
    
    [FileUtils rm:self.zipPath];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadWebView];
}

- (void)loadWebView {
    if (!self.url) {
        [WXWUIUtils showNotificationOnTopWithMsg:@"该内容无法显示，请联系管理员"
                                         msgType:INFO_TY
                              belowNavigationBar:YES
                                  animationEnded:^{
                                  }];
    }else{
        
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
            [self zipFileWithURL:self.zipPath];
        }
    }
}

- (void)addWebView {
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT)];
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

- (void)loadURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [NSURL fileURLWithPath:url];
    NSURLRequest *request =  [NSURLRequest requestWithURL:requestUrl];
    [view loadRequest:request];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
