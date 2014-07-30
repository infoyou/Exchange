//
//  DownloadManageViewController.m
//  Project
//
//  Created by user on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "DownloadManageViewController.h"
#import "CommonHeader.h"
#import "SwitchTabBar.h"
#import "DownloadingCell.h"
#import "DownloadedCell.h"
#import "GoHighDBManager.h"
#import "FTPDownloaderManager.h"
#import "ChapterDetailViewController.h"
#import "DirectionMPMoviePlayerViewController.h"


#define TABBAR_HEIGHT  40.f

#define BUTTON_WIDTH   80.f
#define BUTTON_HEIGHT  30.f

enum DOWNLOAD_TYPE {
    DOWNLOAD_TYPE_DOWNLOADING = 0,
    DOWNLOAD_TYPE_DOWNLOADED = 1,
    };

enum EDIT_STATUS {
    EDIT_STATUS_NO = 1,
    EDIT_STATUS_EDITING = 2,
    };

@interface DownloadManageViewController () <SwitchTabBarDelegate, DownloadingCellDelegate,KLFTPTransferDelegate,DownloadedCellDelegate> {
    UIBarButtonItem *_rightBarButton;
    int currentIdex;
    KLFTPTransfer *transfar;
}

@property (nonatomic, retain) SwitchTabBar *tabBar;
@property (nonatomic, retain) UIView *deleteView;
@property (nonatomic, retain) NSMutableArray *downloadingInfos;
@property (nonatomic, retain) NSMutableArray *downloadedInfos;
@property (nonatomic, retain) NSMutableArray *chapters;

@end

@implementation DownloadManageViewController {
    enum DOWNLOADED_CELL_MODE _downloadingEditStauts;
    enum DOWNLOADED_CELL_MODE _downloadedEditStatus;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
       viewHeight:(int)viewHeight
{
    self = [super initWithMOC:MOC];
    if (self) {
        _MOC = MOC;
        
        _downloadingEditStauts = DOWNLOADED_CELL_MODE_NORMAL;
        _downloadedEditStatus = DOWNLOADED_CELL_MODE_NORMAL;
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    [_deleteView release];
    [_tabBar release];
    [_chapters release];
    [_downloadedInfos release];
    [_downloadingInfos release];
    [super dealloc];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor =DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"下载管理";
    
    [self initNavButton];
    [self addTopTabBar];
    [self initData];
    
    _tableView.frame = CGRectMake(0,
                                  TABBAR_HEIGHT,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height - TABBAR_HEIGHT);
    _tableView.alpha = 1.f;
//    _tableView.backgroundColor =  [UIColor colorWithPatternImage:ImageWithName(@"background.png")];
    
    [self tabBarSelectedAtIndex:0];
    [self addDeleteView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [[FTPDownloaderManager instance] registerListener:self];
    [self loadData];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [[FTPDownloaderManager instance] unRegisterListener:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIDeviceOrientationIsLandscape(interfaceOrientation);
    //    return YES;
}

- (void)loadData {
    
    [self.downloadedInfos removeAllObjects];
    [self.downloadingInfos removeAllObjects];
    
    NSArray *downloadingArr = [[GoHighDBManager instance] getAllDownloadingCourseDetail:_MOC];
    
    for (int i = 0; i < downloadingArr.count; i++) {
        CourseDetailList *cdl = (CourseDetailList *)[downloadingArr[i] retain];
        
        if (nil != cdl.chapterLists && cdl.chapterLists.count) {
            for (ChapterList *cl in [cdl.chapterLists.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterID" ascending:YES]]]) {
                if (![[GoHighDBManager instance] isDownloading:cl.courseID.integerValue withChapterId:cl.chapterID.integerValue]) {
                    [cdl removeChapterListsObject:cl];
                }
            }
            [self.downloadingInfos addObject:cdl];
            [cdl release];
        }
    }
    
    
    //--------------------------------------------
    
    self.downloadedInfos = [[GoHighDBManager instance] getAllDownloadedCourseDetail:_MOC];
    
//    NSArray *downloadedArr = [[GoHighDBManager instance] getAllDownloadedCourseDetail:_MOC];
//    
//    for (int i = 0; i < downloadedArr.count; i++) {
//        CourseDetailList *cdl = (CourseDetailList *)downloadedArr[i];
//        if (nil != cdl.chapterLists && cdl.chapterLists.count) {
//            for (ChapterList *cl in [cdl.chapterLists.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterID" ascending:YES]]]) {
//                if (![[GoHighDBManager instance] isDownloaded:cl.courseID.integerValue withChapterId:cl.chapterID.integerValue]) {
//                    [cdl removeChapterListsObject:cl];
//                }
//            }
//            [self.downloadedInfos addObject:cdl];
//        }
//    }
}

- (void)initData {
    _downloadingInfos = [[NSMutableArray alloc] init];
    _downloadedInfos = [[NSMutableArray alloc] init];
    _chapters = [[NSMutableArray alloc] init];
    //--------------------------------------------
}

- (void)addTopTabBar {
    SwitchTabBar *tabBar = [[SwitchTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TABBAR_HEIGHT)
                                                    titleArray:@[@"下载中", @"已下载"]
                                              hasSeparatorLine:YES];
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
}

- (void)addDeleteView {
    _deleteView = [[UIView alloc] initWithFrame:CGRectMake(0, _screenSize.height, self.view.frame.size.width, 50.f)];
    self.deleteView.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(60.f, 5, BUTTON_WIDTH, BUTTON_HEIGHT);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView addSubview:cancelButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(180.f, 5, BUTTON_WIDTH, BUTTON_HEIGHT);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor colorWithHexString:@"0xe83e0b"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteView addSubview:deleteButton];
    
    [self.view addSubview:self.deleteView];
//    [self.view bringSubviewToFront:self.deleteView];
}

#pragma mark - tabBar delegate

- (void)tabBarSelectedAtIndex:(int)index {
    currentIdex = index;
    [self hideDeleteView];
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        _downloadedEditStatus = DOWNLOADED_CELL_MODE_NORMAL;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        _downloadingEditStauts = DOWNLOADED_CELL_MODE_NORMAL;
    }
    [_tableView reloadData];
}

- (void)initNavButton {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 25, 25);
    [rightButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"write.png"] forState:UIControlStateNormal];
    
    _rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton release];
    
    [_rightBarButton setStyle:UIBarButtonItemStyleBordered];
    self.navigationItem.rightBarButtonItem = _rightBarButton;
}

- (void)rightBarButtonClicked:(id)sender {
 
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        _downloadingEditStauts =_downloadingEditStauts == DOWNLOADED_CELL_MODE_EDIT ? DOWNLOADED_CELL_MODE_NORMAL:DOWNLOADED_CELL_MODE_EDIT ;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED){
        _downloadedEditStatus =_downloadedEditStatus == DOWNLOADED_CELL_MODE_EDIT ? DOWNLOADED_CELL_MODE_NORMAL:DOWNLOADED_CELL_MODE_EDIT ;
    }
    
    if (_downloadedEditStatus == DOWNLOADED_CELL_MODE_EDIT || _downloadingEditStauts == DOWNLOADED_CELL_MODE_EDIT) {
        [self showDeleteView];
    }else {
        [self hideDeleteView];
    }
    
    [_tableView reloadData];
}

#pragma mark - button action

- (void)cancelButtonTapped:(UIButton *)sender {
    [self hideDeleteView];
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        _downloadedEditStatus = DOWNLOADED_CELL_MODE_NORMAL;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        _downloadingEditStauts = DOWNLOADED_CELL_MODE_NORMAL;
    }
    [self.chapters removeAllObjects];
    [_tableView reloadData];
}

- (void)deleteButtonTapped:(UIButton *)sender {
    [self deleteChapter:self.chapters];
    
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        _downloadedEditStatus = DOWNLOADED_CELL_MODE_NORMAL;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        _downloadingEditStauts = DOWNLOADED_CELL_MODE_NORMAL;
    }
    
    [self loadData];
    [_tableView reloadData];
    [self hideDeleteView];
}

#pragma mark - show or hide deleteView

- (void)showDeleteView {
    if (self.deleteView.frame.origin.y == _screenSize.height) {
        [UIView animateWithDuration:.3f delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.deleteView.frame = CGRectMake(self.deleteView.frame.origin.x,
                                               _screenSize.height - self.deleteView.frame.size.height - TABBAR_HEIGHT - 10,
                                               self.deleteView.frame.size.width,
                                               self.deleteView.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)hideDeleteView {
    if ((self.deleteView.frame.origin.y + self.deleteView.frame.size.height + TABBAR_HEIGHT + 10) == _screenSize.height) {
        [UIView animateWithDuration:.3f delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.deleteView.frame = CGRectMake(self.deleteView.frame.origin.x,
                                               _screenSize.height,
                                               self.deleteView.frame.size.width,
                                               self.deleteView.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
    }
}

#pragma mark - cell delegate

- (void)downloadingCell:(DownloadingCell *)cell
      checkButtonTapped:(UIButton *)button
                chapter:(ChapterList *)chapter {
    if (button.selected) {
        if (![self.chapters containsObject:[CommonMethod getChapterFilePath:chapter]]) {
            [self.chapters addObject:[CommonMethod getChapterFilePath:chapter]];
        }
    }else {
        if ([self.chapters containsObject:[CommonMethod getChapterFilePath:chapter]]) {
            [self.chapters removeObject:[CommonMethod getChapterFilePath:chapter]];
        }
    }
    DLog(@"%@",self.chapters);
}

- (void)downloaded {
    [self loadData];
    [_tableView reloadData];
}

- (void)downloadedCell:(DownloadedCell *)cell
     checkButtonTapped:(UIButton *)button
               chapter:(ChapterList *)chapter {
    if (button.selected) {
        if (![self.chapters containsObject:chapter]) {
            [self.chapters addObject:chapter];
        }
    }else {
        if ([self.chapters containsObject:chapter]) {
            [self.chapters removeObject:chapter];
        }
    }
    DLog(@"%@",self.chapters);
}

#pragma mark - delete chapters

- (void)deleteChapter:(NSArray *)chapters {
    for (ChapterList *cl in chapters) {
        if ([cl.chapterFileURL hasSuffix:@"zip"]) {
            if ([CommonMethod isExist:[CommonMethod getChapterZipFilePath:cl]]) {
                [[NSFileManager defaultManager] removeItemAtPath:[CommonMethod getChapterFilePath:cl] error:nil];
                [[GoHighDBManager instance] deleteChapterWithChapterId:cl.chapterID.integerValue courseId:cl.courseID.integerValue];
            }
        }else {
            if ([CommonMethod isExist:[CommonMethod getChapterFilePath:cl]]) {
                [[NSFileManager defaultManager] removeItemAtPath:[CommonMethod getChapterFilePath:cl] error:nil];
                [[GoHighDBManager instance] deleteChapterWithChapterId:cl.chapterID.integerValue courseId:cl.courseID.integerValue];
            }
        }
        
    }
    
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        return self.downloadingInfos.count;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        return _downloadedInfos.count;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        CourseDetailList *detail = (CourseDetailList *)self.downloadingInfos[section];
        return detail.chapterLists.count;
//        return self.downloadingInfos.count;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        CourseDetailList *detail = (CourseDetailList *)self.downloadedInfos[section];
        
        return detail.chapterLists.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 35)] autorelease];
    v.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 7, v.frame.size.width - 20, 25)];
    label.font = FONT_SYSTEM_SIZE(18);
    
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        CourseDetailList *detail = (CourseDetailList *)self.downloadingInfos[section];
        label.text = detail.trainingCourseTitle;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        CourseDetailList *detail = (CourseDetailList *)self.downloadedInfos[section];
        label.text = detail.trainingCourseTitle;
    }
    
    label.backgroundColor = TRANSPARENT_COLOR;
    [v addSubview:label];
    [label release];
    
    return v;
}

- (DownloadingCell *)drawDownloadingCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *downloadCellID = @"download_cell_id";
    
    DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellID];
    if (!cell) {
        cell = [[[DownloadingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadCellID indexPath:indexPath] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    CourseDetailList *cl = self.downloadingInfos[indexPath.section];
    ChapterList *list = (ChapterList *)[[cl.chapterLists.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterID" ascending:YES]]] objectAtIndex:indexPath.row];
    
    [cell drawDownloadingCell:list courseDetailList:cl];
    [cell updateMode:_downloadingEditStauts];
    
    return cell;
}

- (DownloadedCell *)drawDownloadedCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *downloadCellID = @"downloaded_cell_id";
    
    DownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:downloadCellID];
    if (!cell) {
        cell = [[[DownloadedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downloadCellID indexPath:indexPath] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    CourseDetailList *cl = self.downloadedInfos[indexPath.section];
    ChapterList *list = (ChapterList *)[[cl.chapterLists.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterID" ascending:YES]]] objectAtIndex:indexPath.row];
    
    [cell drawDownloadedCell:list];
    [cell updateMode:_downloadedEditStatus];

    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        return [self drawDownloadingCell:tableView atIndexPath:indexPath];
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        return [self drawDownloadedCell:tableView atIndexPath:indexPath];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (currentIdex == DOWNLOAD_TYPE_DOWNLOADING) {
        return DOWNLOADING_CELL_HEIGHT;
    }else if (currentIdex == DOWNLOAD_TYPE_DOWNLOADED) {
        return DOWNLOADED_CELL_HEIGHT;
    }
    return 0;
}


- (void)klFTPTransfer:(KLFTPTransfer *)transfer transferStateDidChangedForItem:(KLFTPTransferItem *)item error:(NSError *)error
{
    if (item.transferState == KLFTPTransferStateFinished) {
        
        [self loadData];
        [_tableView reloadData];
    }
    
}

- (void)klFTPTransfer:(KLFTPTransfer *)transfer progressChangedForItem:(KLFTPTransferItem *)item
{
    static int progress = 0;
    if (progress++ %5 == 0)
        [self loadData];
        [_tableView reloadData];
}

#pragma mark -- DownloadedCellDelegate
- (void)studyCourse:(DownloadedCell *)cell chapter:(ChapterList *)chapter
{

    if ([[[chapter.chapterFileURL lastPathComponent] pathExtension] isEqualToString:@"zip"]) {
        ChapterDetailViewController *vc = [[[ChapterDetailViewController alloc] initWithMOC:_MOC chapter:chapter localFile:[CommonMethod getChapterZipFilePath:chapter]] autorelease];
        
        [CommonMethod pushViewController:vc withAnimated:YES];
    }else {
        [self playMovieAtURL:[NSURL fileURLWithPath:[CommonMethod getChapterFilePath:chapter]]];
//        NSString *mystr = @"http://180.153.88.235/hls/video/ceibs_ialumni/201304/bwl/index.m3u8";
//        NSURL *myURL = [[NSURL alloc] initWithString:mystr];
//        [self playMovieAtURL:myURL];
    }
    
}

#pragma mark - play movie

- (void)playMovieAtURL:(NSURL *)theURL
{
    DirectionMPMoviePlayerViewController *playerView = [[DirectionMPMoviePlayerViewController alloc] initWithContentURL:theURL];
    playerView.view.frame = self.view.frame;//全屏播放（全屏播放不可缺）
    playerView.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;//全屏播放（全屏播放不可缺）
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myMovieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:playerView];
    [playerView.moviePlayer play];
    [self presentMoviePlayerViewControllerAnimated:playerView];
    [playerView release];
    [self setWantsFullScreenLayout:YES];
    //    [CommonMethod pushViewController:playerView withAnimated:YES];
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

@end
