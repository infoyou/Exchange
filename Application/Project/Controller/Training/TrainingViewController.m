//
//  TrainingViewController.m
//  Project
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "TrainingViewController.h"
#import "SquareBlockView.h"
#import "CommonUtils.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "BookImageList.h"
#import "BookCommendViewController.h"
#import "WXWCoreDataUtils.h"
#import "WXWDebugLogOutput.h"
#import "TrainingList.h"
#import "CourseListViewController.h"
#import "FTPDownloaderManager.h"
#import "GoHighDBManager.h"
#import "CourseDetailViewController.h"


#define VIDEO_35INCH_HEIGHT   150.0f
#define VIDEO_40INCH_HEIGHT   238.0f

#define GRID_WIDTH            145.0f
#define GRID_HEIGHT           117.f

#define CELL_COUNT            2

#define COMMON_STUFF_CELL_HEIGHT  275.0f

enum {
    VIDEO_CELL,
    OTHER_INFO_CELL,
};

@interface TrainingViewController ()<ImageWallDelegate,CourseListViewControllerDelegate> {
    int currentCount;
}

@property (nonatomic, retain) NSArray *numberLabelColors;
@property (nonatomic, retain) NSArray *backgroundColors;
@property (nonatomic, retain) NSFetchedResultsController *frc;

@end

@implementation TrainingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:NO
                   tableStyle:UITableViewStylePlain];
    if (self) {
        //        _MOC = MOC;
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
#if 0
    //testing -----
    DownloadInfo *info = [[[DownloadInfo alloc] init] autorelease];
    info.userName = @"appupload";
    info.password = @"appuploadKey";
    info.downloadPath = @"ftp://weixun.co/weiyaodian/ios/cpos.ipa";
    info.localPath = [NSString stringWithFormat:@"%@/%@", [CommonMethod getLocalTrainingDownloadFolder],@"copsx.ipa"];
    
   KLFTPTransfer * transfer = [[FTPDownloaderManager instance] getTransferByItem:
                               [[FTPDownloaderManager instance] getTransferItem:info]];
    [transfer start];
    //end testing----
#endif
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    _noNeedDisplayEmptyMsg = YES;
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.alpha = 1.f;
    _tableView.hidden = NO;
    
    [self initData];
}

- (void)initData {
    _backgroundColors = [[NSArray alloc] initWithObjects:@"0xf17545", @"0xea5123", @"0xdca65e", @"0xb0936d", nil];
    _numberLabelColors = [[NSArray alloc] initWithObjects:@"0xf9c8b5", @"0xf7b9a7", @"0xf1dbbf", @"0xdfd4c5", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_autoLoaded) {
        [self loadCategoryCourse:TRIGGERED_BY_AUTOLOAD forNew:YES];
        [self loadBookListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    
    [self refreshTable];
    [self updateLastSelectedCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stopPlay {
//    if (_imageWallContainer) {
//        [_imageWallContainer stopPlay];
//    }
}

- (void)dealloc {
    [_numberLabelColors release];
    [_backgroundColors release];
//    if (_imageWallContainer) {
//        [_imageWallContainer removeFromSuperview];
//        //        _imageWallContainer = nil;
//        RELEASE_OBJ(_imageWallContainer);
//    }
    [_imageWallScrollView release];
    [super dealloc];
}

#pragma mark - load data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    _reloading = NO;
    [self loadCategoryCourse:triggerType forNew:forNew];
    [self loadBookListData:triggerType forNew:forNew];
}


-(void)reloadCourseList:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    _reloading = NO;
    [self loadCategoryCourse:triggerType forNew:forNew];
}
- (void)loadBookListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_BOOK_IMAGE_LIST;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
//    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
//    [specialDict setObject:NUMBER(4) forKey:KEY_API_PARAM_INFORMATION_TYPE];
//    [specialDict setObject:@"" forKey:KEY_API_PARAM_START_TIME];
//    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
//    [specialDict setObject:@"" forKey:KEY_API_PARAM_KEYWORD];
//    [specialDict setObject:NUMBER(0) forKey:KEY_API_PARAM_SPECIFIED_ID];
    
    [specialDict setObject:NUMBER(3) forKey:KEY_API_PARAM_IMAGE_TYPE];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_SIDEIMAGE withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}

- (void)loadCategoryCourse:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_TRAINING_LIST_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_TRAINING withApiName:API_NAME_GET_TRAINING_LIST withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
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
            
            
        case GET_TRAINING_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _autoLoaded = YES;
                [self refreshTable];
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:TRAINING_VIEW_CONTROLLER_REFRESH_COURSE_LIST object:nil userInfo:nil];
                
            }
            break;
        }
            
        case GET_BOOK_IMAGE_LIST:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _autoLoaded = YES;
                [self fetchContentOfBookImageListFromMOC];
                [_tableView reloadData];
//                [_imageWallContainer loadImagesDataWith:self.frc.fetchedObjects type:ListType_Book];
                
                [_imageWallScrollView updateImageListArray:self.frc.fetchedObjects];
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
    self.entityName = @"TrainingList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"trainingCategoryID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}

- (void)fetchContentOfBookImageListFromMOC {
    self.frc = nil;
//    [NSFetchedResultsController deleteCacheWithName:@"BookListCache"];
    
    NSString *entityName = @"BookImageList";
    NSMutableArray *descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"bookID"
                                                              ascending:YES] autorelease];
    [descriptors addObject:sortDesc];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entityName
                                        inManagedObjectContext:_MOC]];
    
    // set predicate
    [fetchRequest setPredicate:nil];
    
    [fetchRequest setSortDescriptors:descriptors];
    
    // do fetch
    NSString *cacheName = [[NSString alloc] initWithFormat:@"%@Cache", entityName];
    
    // result should be released by caller, e.g., the method "segmentAction" of GuideNewsViewController
    self.frc = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                    managedObjectContext:_MOC
                                                      sectionNameKeyPath:nil
                                                               cacheName:cacheName] autorelease];
    
    [cacheName release];
    NSError *err = nil;
    
    if (![self.frc performFetch:&err]) {
        debugLog(@"Unhandled error performing fetch: %@", [err localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [err localizedDescription]);
    }
}

#pragma mark - image wall delegate

- (void)clickedImage {
//    BookImageList *bl = (BookImageList *)self.frc.fetchedObjects[_imageWallScrollView.currentPageIndex];
    //    DLog(@"%@ %@",bl.commendReason, bl.bookCategory);
//    BookCommendViewController *vc = [[[BookCommendViewController alloc] initWithMOC:_MOC parentVC:self url:bl.zipURL] autorelease];
//    [CommonMethod pushViewController:vc withAnimated:YES];
    if ([_imageWallScrollView subModule] == 1) {
        BookCommendViewController *vc = [[BookCommendViewController alloc] initWithMOC:_MOC parentVC:self bookID:[_imageWallScrollView targetID]];
        [CommonMethod pushViewController:vc withAnimated:YES];
        
    }else if ([_imageWallScrollView subModule] >= 2) {
        if (self.fetchedRC.fetchedObjects.count) {
            
            TrainingList *trainingList = (TrainingList *)self.fetchedRC.fetchedObjects[[_imageWallScrollView subModule] - 2];
            /*
             模块从1开始 需要-1 数组从0开始 再-1
             4/3/7 4代表根模块 培训版块 3 子模块 课程模块 7 目标id
             */
            
            NSArray *courses = [[trainingList.courseLists allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseID" ascending:YES]]];
            
            int targetId = [_imageWallScrollView targetID];
            
            for (CourseList * courseList in courses) {
                if (courseList.courseID.integerValue == targetId) {
                    CourseDetailViewController *vc = [[[CourseDetailViewController alloc] initWithMOC:_MOC parentVC:self courseList:courseList trainingList:trainingList] autorelease];
                    [CommonMethod pushViewController:vc withAnimated:YES];
                }
            }
            
//            CourseListViewController *vc = [[[CourseListViewController alloc] initWithMOC:_MOC parentVC:self trainingList:trainingList] autorelease];
//            [CommonMethod pushViewController:vc withAnimated:YES];
        }
    }
    // 2/2/1
}

#pragma mark - view action

- (void)openVideos:(id)sender {
    
    //todo
#if 0
    BookList *bl = (BookList *)self.frc.fetchedObjects[_imageWallContainer.currentPageIndex];
//    DLog(@"%@ %@",bl.commendReason, bl.bookCategory);
    BookCommendViewController *vc = [[[BookCommendViewController alloc] initWithMOC:_MOC parentVC:self url:bl.zipURL] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
#endif
}

- (void)clickedBlockView:(id)sender {
    SquareBlockView *v = (SquareBlockView *)sender;
    DLog(@"view tag %d",v.tag);
    
    TrainingList *trainingList = (TrainingList *)self.fetchedRC.fetchedObjects[v.tag - 1];
    
    
    CourseListViewController *vc = [[[CourseListViewController alloc] initWithMOC:_MOC parentVC:self trainingList:trainingList] autorelease];
    vc.delegate = self;
    [CommonMethod pushViewController:vc withAnimated:YES];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_COUNT;
}

- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *drawCellId = @"traning_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:drawCellId];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:drawCellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
        NSString *scrollImageWallBackground = @"";
#if APP_TYPE == APP_TYPE_BASE
        scrollImageWallBackground =@"goHigh_defaultLoadingImage.png";
#elif APP_TYPE == APP_TYPE_CIO
        scrollImageWallBackground =@"cio_defaultLoadingImage.png";
#elif APP_TYPE == APP_TYPE_IALUMNIUSA
        scrollImageWallBackground =@"usa_defaultLoadingImage.png";
#elif APP_TYPE == APP_TYPE_INEARBY
        scrollImageWallBackground =@"nearby_defaultLoadingImage.png";
#elif APP_TYPE == APP_TYPE_O2O
        scrollImageWallBackground =@"goHigh_defaultLoadingImage.png";
#endif
        
        _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2,self.view.frame.size.width - MARGIN * 4, VIDEO_35INCH_HEIGHT) backgroundImage:scrollImageWallBackground];
        
        _imageWallScrollView.delegate = self;
        [cell.contentView addSubview:_imageWallScrollView];
    }
    
//    if (_imageWallContainer) {
//        [_imageWallContainer removeFromSuperview];
//        //        _imageWallContainer = nil;
//        RELEASE_OBJ(_imageWallContainer);
//    }
    
//    [_imageWallContainer reloadData];
    
    
    return cell;
}

- (UITableViewCell *)drawOtherInfoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"otherInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
    }
    
    
    currentCount = 0;
    for (int i = 0; i < self.fetchedRC.fetchedObjects.count; i++) {
        
        TrainingList *tl = (TrainingList *)self.fetchedRC.fetchedObjects[i];
        
        CGFloat startX = (currentCount % 2) * (GRID_WIDTH + MARGIN * 2) + MARGIN * 2;
        CGFloat startY = (currentCount / 2) * (GRID_HEIGHT + MARGIN * 2) + MARGIN * 2;
        
        
        SquareBlockView *sbView = [[SquareBlockView alloc] initWithFrame:CGRectMake(startX,
                                                                                    startY,
                                                                                    GRID_WIDTH,
                                                                                    GRID_HEIGHT)
                                                                 viewTag:tl.trainingCategoryID.intValue
                                                         backgroundColor:self.backgroundColors[i % 5]
                                                                   title:tl.trainingCategoryName
                                                        numberLabelColor:self.numberLabelColors[i % 5]
                                                                  target:self
                                                                  action:@selector(clickedBlockView:)];
        [sbView updateNumber:tl.courseNumber.intValue];
        [cell.contentView addSubview:sbView];
        [sbView release];
        ++currentCount;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case VIDEO_CELL:
            return [self drawVideoCell:tableView atIndexPath:indexPath];
            
        case OTHER_INFO_CELL:
            return [self drawOtherInfoCell:tableView atIndexPath:indexPath];
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VIDEO_CELL:
            return VIDEO_35INCH_HEIGHT + MARGIN * 2;
            
        case OTHER_INFO_CELL:
            return [self numberOfRowsFromFRC] * (MARGIN * 2 + GRID_HEIGHT) + MARGIN * 4;
            
        default:
            return 0;
    }
}


- (NSInteger)numberOfRowsFromFRC {
    return self.fetchedRC.fetchedObjects.count / 2 + self.fetchedRC.fetchedObjects.count % 2;
}

@end
