//
//  ChapterDetailViewController.m
//  Project
//
//  Created by Yfeng__ on 13-11-13.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterDetailViewController.h"
#import "ALMoviePlayerController.h"
#import "CommonHeader.h"
#import "TextPool.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "DirectionMPMoviePlayerViewController.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"
#import "FTPHelper.h"
#import "FileUtils.h"
#import "GoHighDBManager.h"

#define EXTENSION_ZIP @"zip"
#define EXTENSION_HTML @"html"

typedef enum {
    FileType_HTML = 1 << 5,
    FileType_MP4
}FileType;

@interface ChapterDetailViewController ()<UIWebViewDelegate, UIScrollViewDelegate, ALMoviePlayerControllerDelegate, ALMoviePlayerControlsDelegate, SSZipArchiveDelegate>

@property (nonatomic, retain) UIWebView *webview;
@property (nonatomic, retain) UIScrollView *webviewScrollView;
@property (nonatomic, retain) ChapterList *chapterList;
@property (nonatomic, assign) FileType fileType;
@property (nonatomic, copy) NSString *localFile;
@property (nonatomic) CGRect defaultFrame;
@property (nonatomic, retain) ALMoviePlayerController *moviePlayer;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *zipPath;
@property (nonatomic, copy) NSString *folderPath;
//@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *htmlPath;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *fileURL;

@end

@implementation ChapterDetailViewController {
    ChapterCell *_chapterCell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
          chapter:(ChapterList *)chapter
        localFile:(NSString *)localFile {
    self = [super initWithMOC:MOC];
    if (self) {
        self.chapterList = chapter;
        //        self.fileType = [[[chapter.chapterFileURL lastPathComponent] pathExtension] isEqualToString:EXTENSION_ZIP] ? FileType_HTML : FileType_MP4;
        self.localFile = localFile;
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
          chapter:(ChapterList *)chapter
        localFile:(NSString *)localFile
      chapterCell:(ChapterCell *)cell
{
    self = [super initWithMOC:MOC];
    if (self) {
        self.chapterList = chapter;
        //        self.fileType = [[[chapter.chapterFileURL lastPathComponent] pathExtension] isEqualToString:EXTENSION_ZIP] ? FileType_HTML : FileType_MP4;
        self.localFile = localFile;
        _chapterCell = cell;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"background.png")];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    self.navigationItem.title = self.chapterList.chapterTitle;
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }else {
        self.view.frame = CGRectOffset(self.view.frame, 0, 0);
    }
    
    [self addWebView];
    
    if (![CommonMethod isExist:self.htmlPath]) {
        if ([self zipFile] && [FileUtils sizeOfFileAtPath:self.zipPath]) {
        } else{
            
//            [self loadURL:self.htmlPath webView:self.webview];
            
            if ( [FileUtils sizeOfFileAtPath:self.zipPath] == 0) {
                [FileUtils rm:self.zipPath];
            }
            
            [[GoHighDBManager instance] resetDownloadInfo:[self.chapterList.courseID integerValue] withChapterId:[self.chapterList.chapterID integerValue]];
            
            if (_chapterCell) {
                [_chapterCell resetDownloadStatus];
            }
            [WXWUIUtils showNotificationOnTopWithMsg:@"下载失败， 请重新下载"
                                             msgType:INFO_TY
                                  belowNavigationBar:YES
                                      animationEnded:^{
                                      }];
        }
    }else {
        [self loadURL:self.htmlPath webView:self.webview];
    }
    
    
    //    if (self.fileType == FileType_HTML) {
    //        [self addWebView];
    //        [self zipFile];
    //    }else {
    ////        [self addMoviePlayer];
    //    }
    
    //    NSString *mystr = @"http://180.153.88.235/hls/video/ceibs_ialumni/201304/bwl/index.m3u8";
    //    NSURL *myURL = [[NSURL alloc] initWithString:mystr];
    //    [self playMovieAtURL:myURL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    if (![self.webview isLoading]) {
    //        [self loadURL:self.htmlPath webView:self.webview];
    //    }
    
}

- (BOOL)zipFile {
    
    BOOL isExist = FALSE;
    if (!self.localFile) {
        [WXWUIUtils showNotificationOnTopWithMsg:@"该内容无法显示，请联系管理员"
                                         msgType:INFO_TY
                              belowNavigationBar:YES
                                  animationEnded:^{
                                  }];
    }else{
        
        self.fileName = [[self.localFile componentsSeparatedByString:@"/"] lastObject];
        self.zipPath = [NSString stringWithFormat:@"%@/%@",[CommonMethod getLocalTrainingDownloadFolder], self.fileName];
        
        self.folderPath = [NSString stringWithFormat:@"%@/%@",[CommonMethod getLocalTrainingDownloadFolder], [self.fileName stringByDeletingPathExtension]];
        [FileUtils mkdir:self.folderPath];
        
        self.htmlPath = [NSString stringWithFormat:@"%@/%@.html",self.folderPath, [self.fileName stringByDeletingPathExtension]];
        
       isExist = [self zipFileWithURL:self.zipPath];
    }
    
    return isExist;
}

- (BOOL)zipFileWithURL:(NSString *)url {
    if ([CommonMethod isExist:url]) {
        ZipArchive *zip = [[ZipArchive alloc] init];
        if ([zip UnzipOpenFile:url]) {
            if ([zip UnzipFileTo:self.folderPath overWrite:YES]) {
                //                [self loadDocument:self.filePath inView:self.webview];//pdf
                [zip UnzipCloseFile];
                
                //                DLog(@"%d", [self fileExistsAtPath:self.htmlPath]);
                [self loadURL:self.htmlPath webView:self.webview];
            }
        }
        
        [zip release];
        return TRUE;
    }else{
        return FALSE;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.moviePlayer stop];
}

#pragma mark - html

- (void)loadURL:(NSString *)url webView:(UIWebView *)view {
    
#if 1
    NSURL *requestUrl = [NSURL fileURLWithPath:url];
    NSURLRequest *request =  [NSURLRequest requestWithURL:requestUrl];
    [view loadRequest:request];
#elif 1
    NSURL *requestUrl = [NSURL URLWithString:@"http://180.153.154.21:9030/Module/CacheFile/Html/130298418835735090.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
    [view loadRequest:request];
#endif
    
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
    
    if ([self.webview subviews]) {
        self.webviewScrollView = [[self.webview subviews] objectAtIndex:0];
        self.webviewScrollView.delegate = self;
    }
}

- (void)playMovieAtURL:(NSURL*)theURL
{
    DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:theURL];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView];
    [playerView.moviePlayer play];
    //    [self presentMoviePlayerViewControllerAnimated:playerView];
    [CommonMethod pushViewController:playerView withAnimated:YES];
}

// When the movie is done, release the controller.
- (void)myMovieFinishedCallback:(NSNotification*)aNotification
{
    DirectionMPMoviePlayerViewController* theMovie = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:theMovie];
    
    //    [theMovie release];
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.webviewScrollView) {
        CGFloat currentY = scrollView.contentOffset.y;
        CGFloat maxY = scrollView.contentSize.height;
        CGFloat delta = scrollView.frame.size.height;
        
        if (maxY > delta) {
            if ((currentY >= maxY - delta) && currentY >= 0.f) {
                NSLog(@"scroll to the end");
                [self submitChapterCompletion];
            }
        }else {
            NSLog(@"did end");
            [self submitChapterCompletion];
        }
        
    }
    
}

/*
 #pragma mark - mp4
 
 - (void)addMoviePlayer {
 //create a player
 _moviePlayer = [[ALMoviePlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
 self.moviePlayer.view.alpha = 0.f;
 self.moviePlayer.delegate = self; //IMPORTANT!
 
 //create the controls
 ALMoviePlayerControls *movieControls = [[ALMoviePlayerControls alloc] initWithMoviePlayer:self.moviePlayer style:ALMoviePlayerControlsStyleDefault];
 movieControls.delegate = self;
 //[movieControls setAdjustsFullscreenImage:NO];
 [movieControls setBarColor:[UIColor colorWithHexString:@"0xe83e0b"]];
 [movieControls setTimeRemainingDecrements:YES];
 [movieControls setFadeDelay:5.0];
 [movieControls setBarHeight:50.f];
 [movieControls setSeekRate:2.f];
 
 //assign controls
 [self.moviePlayer setControls:movieControls];
 //    [self.view addSubview:self.moviePlayer.view];
 [movieControls release];
 
 //THEN set contentURL
 //    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:self.fileName];
 //    [self.moviePlayer setContentURL:fileURL];
 //    [fileURL release];
 
 //    [self.moviePlayer setContentURL:[NSURL fileURLWithPath:self.fileName]];
 
 //delay initial load so statusBarOrientation returns correct value
 double delayInSeconds = 0.3;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 [self configureViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
 [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
 self.moviePlayer.view.alpha = 1.f;
 } completion:^(BOOL finished) {
 self.navigationItem.leftBarButtonItem.enabled = YES;
 self.navigationItem.rightBarButtonItem.enabled = YES;
 
 }];
 });
 
 //    [self.moviePlayer play];
 }
 
 - (void)configureViewForOrientation:(UIInterfaceOrientation)orientation {
 CGFloat videoWidth = 0;
 CGFloat videoHeight = 0;
 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
 videoWidth = 700.f;
 videoHeight = 535.f;
 } else {
 videoWidth = self.view.frame.size.width;
 videoHeight = 220.f;
 }
 
 //calulate the frame on every rotation, so when we're returning from fullscreen mode we'll know where to position the movie plauyer
 self.defaultFrame = CGRectMake(self.view.frame.size.width/2 - videoWidth/2, self.view.frame.size.height/2 - videoHeight/2, videoWidth, videoHeight);
 
 //only manage the movie player frame when it's not in fullscreen. when in fullscreen, the frame is automatically managed
 if (self.moviePlayer.isFullscreen)
 return;
 
 //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
 [self.moviePlayer setFrame:self.defaultFrame];
 }
 
 //IMPORTANT!
 - (void)moviePlayerWillMoveFromWindow {
 //movie player must be readded to this view upon exiting fullscreen mode.
 if (![self.view.subviews containsObject:self.moviePlayer.view])
 [self.view addSubview:self.moviePlayer.view];
 
 //you MUST use [ALMoviePlayerController setFrame:] to adjust frame, NOT [ALMoviePlayerController.view setFrame:]
 [self.moviePlayer setFrame:self.defaultFrame];
 }
 */

- (void)submitChapterCompletion {
    
    _currentType = SUBMIT_CHAPTER_COMPLETION_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:self.chapterList.chapterID forKey:KEY_API_PARAM_COURSE_ID];
    [specialDict setObject:self.chapterList.courseID forKey:KEY_API_PARAM_CHAPTER_ID];
    [specialDict setObject:@(1) forKey:KEY_API_PARAM_COMPLETION];
    //        [specialDict setObject:@(_paramId) forKey:KEY_API_PARAM_EVENT_ID];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_TRAINING,API_NAME_GET_TRAINING_CHAPTER_SCHEDULE];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    [connFacade post:urlString data:[requestDict JSONData]];
}

/*
 #pragma mark - delegate
 
 - (void)movieTimedOut {
 NSLog(@"MOVIE TIMED OUT");
 }
 
 - (void)moviePlayFinished {
 [self submitChapterCompletion];
 }
 
 - (BOOL)shouldAutorotate {
 return YES;
 }
 
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
 return toInterfaceOrientation == UIInterfaceOrientationPortrait;
 }
 
 - (NSUInteger)supportedInterfaceOrientations {
 return UIInterfaceOrientationMaskAllButUpsideDown;
 }
 
 - (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
 [self configureViewForOrientation:toInterfaceOrientation];
 }
 */

- (void)dealloc {
    if (_moviePlayer != nil) {
        [_moviePlayer stop];
        [_moviePlayer.view removeFromSuperview];
        [_moviePlayer release];
    }
    [_chapterList release];
    [_webview release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
//    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case SUBMIT_CHAPTER_COMPLETION_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                DLog(@"submit chapter completion successd");
            }
            
        } break;
            
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

@end
