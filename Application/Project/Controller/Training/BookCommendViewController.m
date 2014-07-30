//
//  BookCommendViewController.m
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BookCommendViewController.h"
#import "SwitchTabBar.h"
#import "CommonUtils.h"
#import "JSONKit.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "BookCommendViewCell.h"
#import "WXWCommonUtils.h"
#import "BookCommendDetailViewController.h"
#import "GoHighDBManager.h"
#import "OffLineDBCacheManager.h"
#import "SSZipArchive.h"
#import "ZipArchive.h"
#import "FTPHelper.h"
#import "FileUtils.h"

#define TABBAR_HEIGHT  40.f

#define FILTER_VIEW_WIDTH  149.f
#define FILTER_VIEW_HEIGHT 161.f

#define FILTER_CELL_HEIGHT 30.f

@interface BookCommendViewController ()<UIWebViewDelegate, SwitchTabBarDelegate, FTPHelperDelegate,SSZipArchiveDelegate> {
    UIBarButtonItem *_rightBarButton;
    int _currentIndex;
    BOOL isFTPFile;
}

@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) NSInteger bookId;
@property (nonatomic, retain) UIWebView *webview;
@property (nonatomic, retain) NSArray *filterTitleArr;
@property (nonatomic, retain) UIImageView *filterView;
@property (nonatomic, retain) UIButton *currentButton;

@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *zipPath;
@property (nonatomic, copy) NSString *folderPath;
//@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *htmlPath;
@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, copy) NSString *fileURL;

@end

@implementation BookCommendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)VC
           bookID:(int)bookID {
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES
                   tableStyle:UITableViewStylePlain];
    if (self) {
        self.bookId = bookID;
        self.parentVC = VC;
    }
    return self;
}

- (void)dealloc {
    
    RELEASE_OBJ(_webview);
    RELEASE_OBJ(_filterTitleArr);
    RELEASE_OBJ(_filterView);
    
    [super dealloc];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"书目推荐";
    
    _tableView.frame = CGRectMake(0, TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - TABBAR_HEIGHT);
    _tableView.alpha = 1.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self initData];
    [self addTopTabBar];
    [self addFilterView];
    
    [self tabBarSelectedAtIndex:0];
}

- (void)initData {
    _filterTitleArr = [[NSArray alloc] initWithObjects:@"默认排序", @"章节排序", @"视频优先", @"PDF优先", nil];
}

- (void)initNavButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"training_bar_button_filter.png"] forState:UIControlStateNormal];
    
    _rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton release];
    
    [_rightBarButton setStyle:UIBarButtonItemStyleBordered];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
}

- (void)removeNavButton {
    
    //    RELEASE_OBJ(_rightBarButton);
    _rightBarButton = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)addFilterView {
    _filterView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - FILTER_VIEW_WIDTH, 0, FILTER_VIEW_WIDTH, FILTER_VIEW_HEIGHT)];
    self.filterView.image = ImageWithName(@"training_filter_view_bg");
    self.filterView.userInteractionEnabled = YES;
    [self.view addSubview:_filterView];
    self.filterView.hidden = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 1, FILTER_VIEW_WIDTH, FILTER_CELL_HEIGHT)];
    titleLabel.font = FONT_SYSTEM_SIZE(15);
    titleLabel.text = @"排序";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = TRANSPARENT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.filterView addSubview:titleLabel];
    [titleLabel release];
    
    for (int i = 0; i < self.filterTitleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5, (FILTER_CELL_HEIGHT + ((i == 0) ? 3 : 2)) * (i + 1), FILTER_VIEW_WIDTH - 5, FILTER_CELL_HEIGHT);
        btn.tag = i;
        [btn setTitle:self.filterTitleArr[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:FONT_SYSTEM_SIZE(12)];
        [btn setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundImage:ImageWithName(@"training_filter_view_cell_selected") forState:UIControlStateSelected];
        //        [btn setBackgroundColor:[UIColor grayColor]];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
        [btn addTarget:self action:@selector(filterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.filterView addSubview:btn];
        if (i == 1) {
            _currentButton = btn;
            _currentButton.selected = YES;
        }
    }
    [self.view bringSubviewToFront:self.filterView];
}

- (void)rightBarButtonClicked:(id)sender {
    self.filterView.hidden = !self.filterView.hidden;
    //    [UIView animateWithDuration:.2 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
    //        self.filterView.alpha = self.filterView.hidden ? 1.f : 0.f;
    //    } completion:^(BOOL completion){
    //        self.filterView.hidden = !self.filterView.hidden;
    //    }];
}

- (void)setButtonUnseleted:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }
}

- (void)filterButtonClicked:(UIButton *)sender {
    sender.selected = YES;
    
    if (_currentButton == sender) {
        _currentButton.selected = YES;
        
    }else {
        [self setButtonUnseleted:_currentButton];
        _currentButton = sender;
    }
    
    self.filterView.hidden = YES;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_autoLoaded) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    [self refreshTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWebView {
    [self addWebView];
    
//    if (SUCCESS_CODE == [OffLineDBCacheManager handleBookRecommandDB:_MOC]) {
//        DLog(@"ok");
//        [self fetchContentFromMOC];
//        if (self.fetchedRC.fetchedObjects.count) {
//            BookList *bookList = (BookList *)self.fetchedRC.fetchedObjects[0];
//            self.url = bookList.zipURL;
//            
//            isFTPFile = [self.url hasPrefix:@"ftp://"];
//            
//            [self loadWebViewIsFTP:isFTPFile];
//        }
//    }
    [self fetchContentFromMOC];
    if (self.fetchedRC.fetchedObjects.count) {
        BookList *bookList = (BookList *)self.fetchedRC.fetchedObjects[0];
        self.url = bookList.zipURL;
        
        isFTPFile = [self.url hasPrefix:@"ftp://"];
        
        [self loadWebViewIsFTP:isFTPFile];
    }
}

- (void)loadWebViewIsFTP:(BOOL)isFTP {
    
    if (isFTP) {
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
    }else {
        [self loadRomateURL:[self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:self.webview];
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
                [self loadLocalURL:self.htmlPath webView:self.webview];
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

- (void)removeWebView {
    [self.webview removeFromSuperview];
    self.webview = nil;
}

- (void)addTopTabBar {
    SwitchTabBar *tabBar = [[SwitchTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TABBAR_HEIGHT)
                                                    titleArray:@[@"最新推荐", @"更多推荐"]
                                              hasSeparatorLine:YES];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
}

- (void)addWebView {
    CGFloat offsetHeight = self.view.frame.size.height < _screenSize.height ? 0 : NAVIGATION_BAR_HEIGHT + SYS_STATUS_BAR_HEIGHT;
    
    if (_webview) {
        [_webview removeFromSuperview];
        _webview = nil;
    }
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, TABBAR_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - TABBAR_HEIGHT - offsetHeight)];
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    self.webview.backgroundColor = TRANSPARENT_COLOR;
    self.webview.contentMode = UIViewContentModeScaleToFill;
//    self.webview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.webview];
}

- (void)loadLocalURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [NSURL fileURLWithPath:url];
    NSURLRequest *request =  [NSURLRequest requestWithURL:requestUrl];
    [view loadRequest:request];
}

- (void)loadRomateURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:requestUrl];
    [view loadRequest:request];
    
    [requestUrl release];
    [request release];
}

#pragma mark - switch tabbar delegate

- (void)tabBarSelectedAtIndex:(int)index {
    _currentIndex = index;
    if (index == 1) {
        [self initNavButton];
        [self removeWebView];
        self.tableView.hidden = NO;
        [self refreshTable];
    }else {

        [self loadWebView];
        [self removeNavButton];
        self.tableView.hidden = YES;
    }
}

#pragma mark - load data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_BOOK_LIST_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(4) forKey:KEY_API_PARAM_INFORMATION_TYPE];
    
//    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestBookListTime] / 1000.0f ]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:[CommonMethod convertLongTimeToString:0 ] forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:0]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_KEYWORD];
    [specialDict setObject:NUMBER(0) forKey:KEY_API_PARAM_SPECIFIED_ID];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_LIST withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}

#pragma mark - tableview delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self calculateCellHeight:tableView atIndexPath:indexPath];
}

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.fetchedRC.fetchedObjects.count) {
        BookList *bl = (BookList *)[self.fetchedRC objectAtIndexPath:indexPath];
        CGFloat height =
        [WXWCommonUtils sizeForText:bl.bookTitle
                               font:FONT_SYSTEM_SIZE(15)
                  constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                      lineBreakMode:NSLineBreakByCharWrapping
                            options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                         attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(15)}].height +
        
        [WXWCommonUtils sizeForText:bl.bookCategory
                               font:FONT_SYSTEM_SIZE(11)
                  constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                      lineBreakMode:NSLineBreakByCharWrapping
                            options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                         attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(11)}].height +
        
        [WXWCommonUtils sizeForText:bl.commendReason
                               font:FONT_SYSTEM_SIZE(12)
                  constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                      lineBreakMode:NSLineBreakByCharWrapping
                            options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                         attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height + 70.f;
        return MAX(BOOK_COMMEND_DEFAULT_HEIGHT, height);
    }else {
        return BOOK_COMMEND_DEFAULT_HEIGHT;
    }
    
}

- (BookCommendViewCell *)drawBookCommendCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *bookcellid = @"book_cell";
    BookCommendViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bookcellid];
    if (!cell) {
        cell = [[[BookCommendViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bookcellid] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BookList *booklist = (BookList *)[self.fetchedRC objectAtIndexPath:indexPath];
    [cell drawBookCommendCell:booklist];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        
        return [self drawBookCommendCell:tableView atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    BookList *booklist = (BookList *)[self.fetchedRC objectAtIndexPath:indexPath];
    
    BookCommendDetailViewController *vc = [[[BookCommendDetailViewController alloc] initWithMOC:_MOC url:booklist.zipURL] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case GET_BOOK_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                _autoLoaded = YES;
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                [[GoHighDBManager instance] upinsertBookListInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
                if (_currentIndex == 1) {
                    [self refreshTable];
                }else {
                    [self fetchContentFromMOC];
                    
                    if (self.fetchedRC.fetchedObjects.count) {
                        
                        BookList *bookList = (BookList *)self.fetchedRC.fetchedObjects[0];
                        self.url = bookList.zipURL;
                        if (self.url) {
                            [self loadWebViewIsFTP:[self.url hasPrefix:@"ftp://"]];
                        }
                        
                    }
                }
                
            }
            break;
        }
            
        default:
            break;
    }
    
    _autoLoaded = YES;
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

- (void)configureMOCFetchConditions {
    self.entityName = @"BookList";
    
    if (_currentIndex == 0) {
        self.predicate = [NSPredicate predicateWithFormat:@"bookID == %d",self.bookId];
    }else {
        self.predicate = nil;
    }
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"bookID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}


@end
