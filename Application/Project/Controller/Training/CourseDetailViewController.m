//
//  CourseDetailViewController.m
//  Project
//
//  Created by Yfeng__ on 13-11-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "CommonUtils.h"
#import "GlobalConstants.h"
#import "ChapterCell.h"
#import "ContentView.h"
#import "WXWLabel.h"
#import "CourseDetailList.h"
#import "ChapterContentCell.h"
#import "ChapterTitleCell.h"
#import "CircleMarkegingApplyWindow.h"
#import "CustomeAlertView.h"
#import "WXWCoreDataUtils.h"
#import "GoHighDBManager.h"
#import "JSONKit.h"
#import "OffLineDBCacheManager.h"
#import "ChapterDetailViewController.h"
#import "FTPDownloaderManager.h"
#import "TrainingList.h"
#import "DirectionMPMoviePlayerViewController.h"

#define DESC_VIEW_HEIGHT  160.f

#define STUDY_COURSE_HEADER_HEIGHT 45.f

@interface CourseDetailViewController () <CustomeAlertViewDelegate, CircleMarkegingApplyWindowDelegate,ChapterCellDelegate>

@property (nonatomic, retain) TrainingList *trainingList;
@property (nonatomic, retain) ChapterCell *currentCell;

@property (nonatomic, assign) CourseList *cList;
@property (nonatomic, retain) ContentView *descView;
@property (nonatomic, retain) ContentView *listView;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *chapterLabel;
@property (nonatomic, retain) WXWLabel *learnedLabel;
@property (nonatomic, retain) WXWLabel *chapterDescLabel;
@property (nonatomic, retain) CourseDetailList *courseDetailList;


@end

@implementation CourseDetailViewController {
    ChapterContentCell *contentCell;
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
         parentVC:(WXWRootViewController *)PVC
       courseList:(CourseList *)list
     trainingList:(TrainingList *)trainingList {
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO
                   tableStyle:UITableViewStylePlain];
    if (self) {
        self.cList = list;
        self.parentVC = PVC;
        self.trainingList = trainingList;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"课程详情";
    
    _noNeedDisplayEmptyMsg = YES;
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alpha = 1.f;
    
    //清除数据
    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"CourseDetailList"];
    
    if (SUCCESS_CODE == [OffLineDBCacheManager handleCoureseChapterDB:[self.cList.courseID integerValue] MOC:_MOC]) {
        [self refreshTable];
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadCourseChapterData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    //    [self refreshTable];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    //    CircleMarkegingApplyWindow *alert = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
    //    alert.applyDelegate = self;
    //    [alert setMessage:@"该课程还没有添加到我的课程，确定添加吗？"
    //                title:@"温馨提示"];
    //    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else if (section == 1) {
        if (self.fetchedRC.fetchedObjects.count) {
            _courseDetailList = [self.fetchedRC.fetchedObjects objectAtIndex:0];
            DLog(@"%d", _courseDetailList.chapterLists.count);
            
            for (ChapterList *chapter in _courseDetailList.chapterLists) {
                DLog(@"%@", chapter.chapterTitle);
            }
            
            return _courseDetailList.chapterLists.count;
        }
        
    }
    return 0;
}

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 62.f;
        }else if(indexPath.row == 1){
            
//            ChapterContentCell *cell  = (ChapterContentCell *) [tableView cellForRowAtIndexPath:indexPath];
// return            contentCell.contentView.frame.size.height;
            return 100.f;
            return 123.f;
        }else{
            return 90.f;
        }
    }else {
        return CHAPTER_CELL_HEIGHT;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, STUDY_COURSE_HEADER_HEIGHT)] autorelease];
//        v.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        v.backgroundColor = [UIColor whiteColor];
        
        int height  = 25;
        int startY = (STUDY_COURSE_HEADER_HEIGHT - height) /2.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, startY, v.frame.size.width - 20, height)];
        label.text = @"课程学习";
        label.font = FONT_SYSTEM_SIZE(17);
        label.backgroundColor = TRANSPARENT_COLOR;
        [v addSubview:label];
        [label release];
        
        int startX = 13;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(startX, v.frame.size.height - 1, v.frame.size.width - 2*startX, 0.5)];
        //    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
        line.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
        [v addSubview:line];
        [line release];
        
        
        return v;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return STUDY_COURSE_HEADER_HEIGHT;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 15 ;
    }else if (section ==1) {
        return 5;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (section == 1)
    {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 5)] autorelease];
        
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        image.image = IMAGE_WITH_IMAGE_NAME(@"training_cell_bottom.png");
        
        [view addSubview:image];
//        view.backgroundColor = [UIColor greenColor];
        
        return view;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellHeight:tableView atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self drawTitleCell:tableView atIndexPath:indexPath];
        }else {
            return [self drawContentCell:tableView atIndexPath:indexPath];
        }
    }else if(indexPath.section == 1){
        return [self drawChapterCell:tableView atIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChapterCell *cell = (ChapterCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell isKindOfClass:[ChapterCell class]]) {
        KLFTPTransfer *transfer = (KLFTPTransfer *)[[FTPDownloaderManager instance].transferListDict objectForKey:cell.localFileName];
        if (transfer.transferItem.transferState == KLFTPTransferStateDownloading) {
            ShowAlert(self, @"温馨提示", @"请等待下载完成再继续！！", @"确定");
        }else {
            
            if ([cell isKindOfClass:[ChapterCell class]]) {
                [cell checkButtonClicked:cell.checkButton];
                
                [[GoHighDBManager instance] updateCourse:self.cList.courseID.integerValue
                                              categoryId:self.trainingList.trainingCategoryID.integerValue];
                
                if (cell.isDownloaded) {
                    
                    if ([[[cell.chapterList.chapterFileURL lastPathComponent] pathExtension] isEqualToString:@"zip"]) {
          
//                        [self startStudy:cell.chapterList fileName:cell.localFileName];
                    }else {
                        [self playMovieAtURL:[NSURL fileURLWithPath:cell.localFileName]];
//                        NSString *mystr = @"http://180.153.88.235/hls/video/ceibs_ialumni/201304/bwl/index.m3u8";
//                        NSURL *myURL = [[NSURL alloc] initWithString:mystr];
//                        [self playMovieAtURL:myURL];
//                        [myURL release];
                    }
                }
            }
        }
    }
    
}


-(void)startStudy:(ChapterCell*)cell chapterList:(ChapterList *)chapterList fileName:(NSString *)fileName
{
    ChapterDetailViewController *vc = [[[ChapterDetailViewController alloc] initWithMOC:_MOC chapter:chapterList localFile:fileName chapterCell:cell] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}



-(void)playMovieAtURL:(NSURL*)theURL
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

- (ChapterTitleCell *)drawTitleCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"title_cell_id";
    ChapterTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[[ChapterTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    cell.icon.image = ImageWithName((self.cList.courseType.intValue == 1) ? @"icon_html.png" : @"icon_video.png");
    cell.titleLabel.text = self.cList.courseName;
    return cell;
}

- (ChapterContentCell *)drawContentCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"content_cell_id";
    ChapterContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[[ChapterContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        cell.backgroundColor = [UIColor whiteColor];

    
    contentCell = cell;
    }
    [cell drawContentCell:self.courseDetailList courseCategory:self.trainingList.trainingCategoryName];
    return cell;
}

- (ChapterCell *)drawChapterCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *chapterCellIdentifier = @"chapter_cell";
    ChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterCellIdentifier];
    
    if (!cell) {
        DLog(@"%d:%d", indexPath.row, self.fetchedRC.fetchedObjects.count);
        cell = [[[ChapterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chapterCellIdentifier bottom:indexPath.row != self.fetchedRC.fetchedObjects.count - 1] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
        cell.delegate = self;
    
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    CourseDetailList *courseDetailList = (CourseDetailList *)[self.fetchedRC.fetchedObjects objectAtIndex:0];
    
    ChapterList *list = (ChapterList *)[[courseDetailList.chapterLists.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterID" ascending:YES]]] objectAtIndex:indexPath.row];
    [cell drawChapter:list withCourseDetailList:courseDetailList courseType:self.cList.courseType.integerValue index:indexPath.row];
    
    if (indexPath.row == courseDetailList.chapterLists.allObjects.count - 1) {
        [cell drawBottom];
    }
    //    [cell startDownloadChapter];
    //    ManageStatus ms = NSManageStatusSet(DownloadStatus_Paused, ChapterStatue_Learned);
    //    [cell updateCellWithDownloadStatus:ms];
    if (indexPath.row == 0) {
        self.currentCell = cell;
    }
    
    return cell;
}

#pragma mark - load course chapter data

- (void)loadCourseChapterData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    _currentType = GET_COURSE_CHAPTER_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:self.cList.courseID forKey:KEY_API_PARAM_COURSE_ID];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestCourseInfoTime:[self.cList.courseID integerValue]] / 1000.0f ]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_TRAINING withApiName:API_NAME_GET_TRAINING_COURSE_DETAIL withCommon:commonDict withSpecial:specialDict];
    
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
            
            
        case GET_COURSE_CHAPTER_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self refreshTable];
                [[GoHighDBManager instance] upinsertCourseDetail:self.fetchedRC.fetchedObjects isMyCourse:0];
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

- (void)configureMOCFetchConditions {
    self.entityName = @"CourseDetailList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"trainingCourseID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}

#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView
{
    [alertView release];
}

#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView
{
    
    [alertView release];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *) alertView applyList:(NSArray *)applyArray
{
    [alertView release];
    
    [[GoHighDBManager instance] updateCourse:self.cList.courseID.integerValue
                                  categoryId:self.trainingList.trainingCategoryID.integerValue];
}

@end
