//
//  CourseListViewController.m
//  Project
//
//  Created by Yfeng__ on 13-11-1.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CourseListViewController.h"
#import "ContentView.h"
#import "CourseListCell.h"
#import "CourseList.h"
#import "CommonHeader.h"
#import "PlainTabView.h"
#import "CourseDetailViewController.h"
#include "CustomeAlertView.h"
#import "CircleMarkegingApplyWindow.h"
#import "GoHighDBManager.h"

#define TAB_W  135.f
#define TAB_H  26.0f

#define FILTER_VIEW_WIDTH  149.f
#define FILTER_VIEW_HEIGHT 161.f

#define FILTER_CELL_HEIGHT 30.f

typedef enum {
    SortType_Default = 0,
    SortType_Chapter,
    SortType_VideoFirst,
    SortType_HtmlFirst
}SortType;

@interface CourseListViewController ()<TapSwitchDelegate, CircleMarkegingApplyWindowDelegate, CustomeAlertViewDelegate> {
    UIBarButtonItem *_rightBarButton;
    int currentIndex;
    int courseID;
    BOOL downloaded;
}

@property (nonatomic, assign) SortType sortType;
@property (nonatomic, retain) TrainingList *trainList;
@property (nonatomic, retain) PlainTabView *switchTabView;
@property (nonatomic, retain) NSArray *filterTitleArr;
@property (nonatomic, retain) UIImageView *filterView;
@property (nonatomic, retain) UIButton *currentButton;
@property (nonatomic, retain) NSArray *myCourses;
@property (nonatomic, retain) NSArray *courseLists;

@end

@implementation CourseListViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC parentVC:(WXWRootViewController *)PVC trainingList:(TrainingList *)trainingList {
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:NO
                   tableStyle:UITableViewStylePlain];
    
    if (self) {
        self.trainList = trainingList;
        self.parentVC = PVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
//    self.navigationItem.title = [NSString stringWithFormat:@"%@课程",self.trainList.trainingCategoryName];
    
//    [self updateDB];
    [self initNavButton];
    [self initData];
    [self addFilterView];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.hidden = NO;
    _tableView.alpha = 1.f;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:TRAINING_VIEW_CONTROLLER_REFRESH_COURSE_LIST];
    
}
-(void)trainingViewControllerRefreshCourseList:(NSNotification *)note
{   
    [self resetUIElementsForConnectDoneOrFailed];
    
//    [self refreshTable];
    [_tableView reloadData];
    
}

-(void)configureMOCFetchConditions
{
    
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    if (_delegate && [_delegate respondsToSelector:@selector(reloadCourseList:forNew:)]) {
        [_delegate reloadCourseList:triggerType forNew:forNew];
    }
}


- (void)updateDB:(int)isMyCourse {
    [[GoHighDBManager instance] upinsertCourses:self.trainList.courseLists.allObjects isMyCourse:isMyCourse categoryId:self.trainList.trainingCategoryID.integerValue];
}

- (void)initData {
    _filterTitleArr = [[NSArray alloc] initWithObjects:@"默认排序", @"章节排序", @"视频优先", @"文档优先", nil];
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
        if (i == 0) {
            _currentButton = btn;
            _currentButton.selected = YES;
        }
    }
    [self filterButtonClicked:_currentButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if (!_autoLoaded) {
//        [self.switchTabView selectButtonWithIndex:MY_COURSE_TY];
//    }
    [self addSwitchTabView];
    [self.switchTabView selectButtonWithIndex:ALL_COURSE_TY];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(trainingViewControllerRefreshCourseList:)
                                                 name:TRAINING_VIEW_CONTROLLER_REFRESH_COURSE_LIST
                                               object:nil];
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
    
    switch (sender.tag) {
        case 0: self.sortType = SortType_Default; break;
        case 1: self.sortType = SortType_Chapter; break;
        case 2: self.sortType = SortType_VideoFirst; break;
        case 3: self.sortType = SortType_HtmlFirst; break;
            
        default:
            break;
    }
    
    [self sortCourseList:self.sortType];
    
}

- (void)sortCourseList:(SortType)stype {
    switch (stype) {
        case SortType_Default:
            self.courseLists = [[self.trainList.courseLists allObjects]
                                sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseID" ascending:YES]]];
            break;
        case SortType_Chapter:
            self.courseLists = [[self.trainList.courseLists allObjects]
                                sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"chapterNumber" ascending:YES]]];
            break;
        case SortType_VideoFirst:
            self.courseLists = [[self.trainList.courseLists allObjects]
                                sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseType" ascending:NO]]];
            break;
        case SortType_HtmlFirst:
            self.courseLists = [[self.trainList.courseLists allObjects]
                                sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"courseType" ascending:YES]]];
            break;
            
        default:
            break;
    }
    [_tableView reloadData];
}

- (void)addSwitchTabView {
    if (!_switchTabView) {
        _switchTabView = [[PlainTabView alloc] initWithFrame:CGRectMake(0, 0, TAB_W, TAB_H)
                                                buttonTitles:@[@"我的课程", @"所有课程"]
                                           tapSwitchDelegate:self];
        self.navigationItem.titleView = self.switchTabView;
    }else {
        self.navigationItem.titleView = self.switchTabView;
    }
    
//    [self.switchTabView selectButtonWithIndex:MY_COURSE_TY];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tab delegate

- (void)selectTapByIndex:(NSInteger)index {
    currentIndex = index;
    [_tableView reloadData];
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

- (void)rightBarButtonClicked:(id)sender {
    self.filterView.hidden = !self.filterView.hidden;
//    [UIView animateWithDuration:.2 delay:.05 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.filterView.alpha = self.filterView.hidden ? 1.f : 0.f;
//    } completion:^(BOOL completion){
//        self.filterView.hidden = !self.filterView.hidden;
//    }];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSInteger rowCount = self.trainList.courseLists.count;
    if (currentIndex == MY_COURSE_TY) {
        DLog(@"%d", [[GoHighDBManager instance] getMyCourseListInMOC:_MOC
                                                          categoryId:self.trainList.trainingCategoryID.integerValue].count);
        return [[GoHighDBManager instance] getMyCourseListInMOC:_MOC
                                                     categoryId:self.trainList.trainingCategoryID.integerValue].count;
    }else {
        return self.courseLists.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *coureseID = @"course_cell_id";
    CourseListCell *cell = [tableView dequeueReusableCellWithIdentifier:coureseID];
    if (!cell) {
        cell = [[[CourseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:coureseID] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor whiteColor];
    }
    if (currentIndex == MY_COURSE_TY) {
        
        CourseList *courseList = (CourseList *)[[GoHighDBManager instance] getMyCourseListInMOC:_MOC
                                                                                     categoryId:self.trainList.trainingCategoryID.integerValue][indexPath.row];
        [cell drawCourseCell:courseList];
        
    }else {
        CourseList *clist = (CourseList *)self.courseLists[indexPath.row];
        [cell drawCourseCell:clist];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COURSE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.filterView.hidden == NO) {
        self.filterView.hidden = YES;
        return;
    }
    
    CourseList *clist = (CourseList *)self.courseLists[indexPath.row];
    courseID = clist.courseID.integerValue;
    
    if (currentIndex == MY_COURSE_TY) {
        CourseDetailViewController *vc = [[[CourseDetailViewController alloc] initWithMOC:_MOC
                                                                                 parentVC:self
                                                                               courseList:clist
                                                                             trainingList:self.trainList] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
    }else {
        CourseDetailViewController *vc = [[[CourseDetailViewController alloc] initWithMOC:_MOC
                                                                                 parentVC:self
                                                                               courseList:clist
                                                                             trainingList:self.trainList] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
//        if (![[GoHighDBManager instance] isMyCourseByCourseId:clist.courseID.integerValue categoryId:self.trainList.trainingCategoryID.integerValue]) {
//            CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
//            [customeAlertView setMessage:@"该课程还未下载，下载完成后即可进行学习，您确定现在下载吗？"
//                                   title:@"温馨提示"];
//            customeAlertView.applyDelegate = self;
//            [customeAlertView show];
//            
//        }else {
//            
//            CourseDetailViewController *vc = [[[CourseDetailViewController alloc] initWithMOC:_MOC
//                                                                                     parentVC:self
//                                                                                   courseList:clist
//                                                                               courseCategory:self.trainList.trainingCategoryName] autorelease];
//            [CommonMethod pushViewController:vc withAnimated:YES];
//        }
    }
    
}

#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView {
    
    [alertView release];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    [[GoHighDBManager instance] updateCourse:courseID
                                  categoryId:self.trainList.trainingCategoryID.integerValue];
    
    [alertView release];
}

#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView {
    [alertView release];
}


@end
