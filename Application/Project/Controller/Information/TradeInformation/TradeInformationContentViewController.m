//
//  TradeInformationContentViewController.m
//  Project
//
//  Created by user on 13-10-10.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "TradeInformationContentViewController.h"
#import "CommonMethod.h"
#import "GlobalConstants.h"
#import "UIColor+expanded.h"
#import "InformationList.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "CommonUtils.h"
#import "JSONKit.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"
#import "FTPHelper.h"
#import "FileUtils.h"
#import "CustomeAlertView.h"
#import "CommonMethod.h"
#import "GoHighDBManager.h"
#import "WXApi.h"
#import "CircleMarketingEventCommentViewController.h"

#define BOTTOM_HEIGHT 44.f

#define MARGIN_LEFT   13.f
#define MARGIN_RIGHT  15.f

#define BUTTON_READ_COMMENT_WIDTH  29.f
#define BUTTON_READ_COMMENT_HEIGHT 25.f

#define BUTTON_SHARE_WIDTH  28.f
#define BUTTON_SHARE_HEIGHT 28.f

#define FILE_SUFFIX_HTML @".html"

@interface TradeInformationContentViewController ()<UIWebViewDelegate, FTPHelperDelegate,SSZipArchiveDelegate,CustomeAlertViewDelegate, UIActionSheetDelegate, WXApiDelegate, CircleMarketingEventCommentViewControllerDelegate> {
    
    int _infoID;
}

@property (nonatomic, retain) UILabel *readLabel;
@property (nonatomic, retain) UILabel *commentLabel;
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

@implementation TradeInformationContentViewController {
    //    InformationList *_informationList;
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
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
      information:(InformationList *)list {
    self = [super initWithMOC:MOC];
    if (self) {
        
        if ( [url hasPrefix:@"ftp"]) {
            self.url = url;
        }
        //        _informationList = list;
        _infoID = [list.informationID integerValue];
        self.title = @"资讯内容";
    }
    return self;
}


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
    informationID:(int)informationID
{
    self = [super initWithMOC:MOC];
    if (self) {
        
        if ( [url hasPrefix:@"ftp"]) {
            self.url = url;
        }
        _infoID = informationID;
        self.title = @"资讯内容";
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
      information:(InformationList *)info
{
    if (self = [self initWithMOC:MOC parentVC:pVC url:url information:info]) {
        self.title = title;
        //        _infoID = infoID;
        //        _informationList = info;
        _infoID = [[info informationID] integerValue];
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
              url:(NSString *)url
            title:(NSString *)title
    informationID:(int)informationID
{
    if (self = [self initWithMOC:MOC parentVC:pVC url:url informationID:informationID]) {
        self.title = title;
        //        _infoID = infoID;
        //        _informationList = info;
        _infoID = informationID;
    }
    return self;
}
- (void)dealloc {
    
    if (CURRENT_OS_VERSION >= IOS6) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    }
    
    [_commentLabel release];
    [_readLabel release];
    [_webview release];
    [super dealloc];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"资讯内容";
    
    [self addSubViews];
    
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
        
        if (![CommonMethod isExist:self.zipPath] || [FileUtils sizeOfFileAtPath:self.zipPath] == 0 ) {
            if ([FileUtils sizeOfFileAtPath:self.zipPath] == 0) {
                [FileUtils rm:self.zipPath ];
                [FileUtils rm:self.folderPath];
            }
            
            [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
            [self downloadFileWithURL:self.fileURL];
        }else {
            [self zipFileWithURL:self.zipPath];
        }
    }
    
    [self fetchContentFromMOC];
    
    InformationList *il = (InformationList *)[self.fetchedRC.fetchedObjects objectAtIndex:0];
    [self updateLabelTexts:il];
    
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
    [FileUtils rm:self.folderPath];
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
    
    //    if (nil != self.url && self.url.length > 0) {
    //        [self loadURL:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:_webview];
    //    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Rotation
// IOS5支持的屏幕方向
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// IOS6开启旋转
- (BOOL)shouldAutorotate {
    return YES;
}
// IOS6支持的屏幕方向
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
// IOS6默认支持竖屏
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

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

- (void)addSubViews {
    int heigh=0;
    if ([CommonMethod is7System]) {
        heigh = SYS_STATUS_BAR_HEIGHT;
    }
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - BOTTOM_HEIGHT - NAVIGATION_BAR_HEIGHT  - heigh)];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    self.webview.backgroundColor = TRANSPARENT_COLOR;
    self.webview.allowsInlineMediaPlayback = YES;
    self.webview.mediaPlaybackRequiresUserAction = NO;
    self.webview.contentMode = UIViewContentModeScaleToFill;
    //    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //    _webview.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.webview];
    
    [self addBottomView];
}

- (void)addBottomView {
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0,  [GlobalInfo getDeviceSize].height - BOTTOM_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottom.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"bottomBg.png")];
    
    //    bottom.layer.masksToBounds = NO;
    //    //    //设置阴影的高度
    //    bottom.layer.shadowOffset = CGSizeMake(0, 0);
    //    //设置透明度
    //    bottom.layer.shadowOpacity = 1;
    //    bottom.layer.shadowPath = [UIBezierPath bezierPathWithRect:bottom.bounds].CGPath;
    [self.view addSubview:bottom];
    
    
    CGFloat readOriginY = (BOTTOM_HEIGHT - BUTTON_READ_COMMENT_HEIGHT) / 2.f;
    
    UIImageView *readImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, readOriginY, 29, 25.f)];
    readImageView.image = IMAGE_WITH_NAME(@"information_read.png");
    [bottom addSubview:readImageView];
    
    _readLabel = [[UILabel alloc] initWithFrame:CGRectMake(readImageView.frame.size.width + readImageView.frame.origin.x+8, readOriginY, 90, BUTTON_READ_COMMENT_HEIGHT)];
    self.readLabel.backgroundColor = TRANSPARENT_COLOR;
    self.readLabel.font = FONT_SYSTEM_SIZE(14);
    self.readLabel.text = @"阅读:0";
    self.readLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:self.readLabel];
    [readImageView release];
    
    CGFloat commentOriginY = (BOTTOM_HEIGHT - BUTTON_READ_COMMENT_HEIGHT) / 2.f;
    
    UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + BUTTON_READ_COMMENT_WIDTH + 90, commentOriginY, BUTTON_READ_COMMENT_WIDTH, BUTTON_READ_COMMENT_HEIGHT)];
    commentImageView.image = IMAGE_WITH_NAME(@"information_comment.png");
    [bottom addSubview:commentImageView];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentImageView.frame.size.width + commentImageView.frame.origin.x+8, commentOriginY, 90, BUTTON_READ_COMMENT_HEIGHT)];
    self.commentLabel.backgroundColor = TRANSPARENT_COLOR;
    self.commentLabel.font = FONT_SYSTEM_SIZE(14);
    self.commentLabel.text = @"评论:0";
    self.commentLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:self.commentLabel];
    
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(commentImageView.frame.origin.x - 5, 0, commentImageView.frame.size.width + _commentLabel.frame.size.width - 20, BOTTOM_HEIGHT);
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:commentButton];
    [commentImageView release];
    
    
    CGFloat shareOriginY = (BOTTOM_HEIGHT - BUTTON_SHARE_HEIGHT) / 2.f;
    CGSize shareLabelSize = [CommonMethod sizeWithText:@"分享" font:FONT_SYSTEM_SIZE(14)];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - MARGIN_RIGHT - shareLabelSize.width, shareOriginY, shareLabelSize.width, BUTTON_READ_COMMENT_HEIGHT)];
    shareLabel.backgroundColor = TRANSPARENT_COLOR;
    shareLabel.font = FONT_SYSTEM_SIZE(14);
    shareLabel.text = @"分享";
    shareLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:shareLabel];
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(shareLabel.frame.origin.x - BUTTON_SHARE_WIDTH-8, shareOriginY, BUTTON_SHARE_WIDTH, BUTTON_SHARE_HEIGHT)];
    shareImageView.image = IMAGE_WITH_IMAGE_NAME(@"information_share.png");
    [bottom addSubview:shareImageView];
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(shareImageView.frame.origin.x, 0, shareLabelSize.width + BUTTON_SHARE_WIDTH, BOTTOM_HEIGHT);
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:shareButton];
    
    [shareImageView release];
    [shareLabel release];
    
    [bottom release];
}

#pragma mark - comment

- (void)comment:(UIButton *)sender {
    CircleMarketingEventCommentViewController *vc = [[[CircleMarketingEventCommentViewController alloc] initWithMOC:_MOC parentVC:self commentType:CommentType_Informtaion paramId:_infoID] autorelease];
    vc.delegate = self;
    [CommonMethod pushViewController:vc withAnimated:YES];
}

#pragma mark -- CircleMarketingEventCommentViewControllerDelegate delegate
- (void)updateCommentCount:(int)count
{
    self.commentLabel.text = [NSString stringWithFormat:@"评论:%d", count];
    
    [[GoHighDBManager instance] updateInformationCommentCount:_infoID count:count];
}

#pragma mark - share

- (void)share:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到:"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"微信" ,nil];
    //otherButtonTitles:@"聊天界面", @"朋友圈", @"收藏", nil];
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
}

- (void)updateLabelTexts:(InformationList *)infoList {
    DLog(@"%d",infoList.reader.integerValue);
    self.readLabel.text = [NSString stringWithFormat:@"阅读:%d", [[GoHighDBManager instance] getInformationCommentReader:_infoID]];
    
    ;
    self.commentLabel.text = [NSString stringWithFormat:@"评论:%d", [[GoHighDBManager instance] getInformationCommentCount:_infoID]];
}



#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        //        [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
    }else {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            BOOL reult = [CommonUtils shareByWeChat:buttonIndex
                                              title:self.title
                                              image:[CommonMethod getAppIcon]
                                        description:@""
                                                url:[NSString stringWithFormat:@"%@%d",[[GoHighDBManager instance] getCommon:INFORMATION_SHARE_WEIXIN_KEY], _infoID]];
            if (reult) {
                DLog(@"share sucessfully");
            }
        }else {
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"免费下载微信", nil];
            [alView show];
            [alView release];
        }
    }
    
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
    }
}

#pragma mark -- weixin delegate

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark -

- (void)configureMOCFetchConditions {
    self.entityName = @"InformationList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"informationID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    self.predicate = [NSPredicate predicateWithFormat:@"informationID == %d", _infoID];
}

#pragma mark - webview delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self updateReader];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)updateReader {
    _currentType = UPDATE_READER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(_infoID) forKey:KEY_API_PARAM_INFORTMATION_ID];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_UPDATE_INFORMATION_READER withCommon:commonDict withSpecial:specialDict];
    
    
    //    _currentType = LOAD_CATEGORY_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    
    //    [connFacade post:url data:[specialDict JSONData]];
    [connFacade fetchGets:url];
}

- (void)loadInformation {
    _currentType = UPDATE_READER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(_infoID) forKey:KEY_API_PARAM_INFORTMATION_ID];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_UPDATE_INFORMATION_READER withCommon:commonDict withSpecial:specialDict];
    
    
    //    _currentType = LOAD_CATEGORY_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    
    //    [connFacade post:url data:[specialDict JSONData]];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case UPDATE_READER_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
                //                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                int reader = INT_VALUE_FROM_DIC(resultDic, @"reader");
                
                [[GoHighDBManager instance] updateInformationCommentReader:_infoID count:reader];
                self.readLabel.text = [NSString stringWithFormat:@"阅读:%d",reader];
                
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


@end
