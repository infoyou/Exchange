//
//  BusinessItemDetailViewController.m
//  Project
//
//  Created by XXX on 13-9-5.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "CommonHeader.h"
#import "BusinessItemDetailViewCell.h"
#import "BusinessItemDetailMoreViewCell.h"
#import "BaseAppDelegate.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "WXWCoreDataUtils.h"
#import "EventImageList.h"
#import "BusinessImageList.h"
#import "ImageWallScrollView.h"
#import "GoHighDBManager.h"
#import "OffLineDBCacheManager.h"
#import "MHFacebookImageViewer.h"
#import "UIDevice+Hardware.h"

enum BS_CELL_TYPE {
    BS_CELL_TYPE_HEADER_SCROLL = 0,
    BS_CELL_TYPE_CONTENT_BRIEF = 1,
    BS_CELL_TYPE_EXPAND=2,
};

#define VIDEO_35INCH_HEIGHT   150.0f
#define VIDEO_40INCH_HEIGHT   238.0f

@interface BusinessItemDetailViewController ()
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, ImageWallDelegate, MHFacebookImageViewerDatasource> {
    
    NSDictionary *_detailDict;
    NSArray *_detailArray;
    
    int expandRowCount;
}

//@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIScrollView *headerScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UITableView *itemTable;
@property (nonatomic, retain) UIButton *expandButton;

@property (nonatomic, retain) NSMutableArray *images;

@end

@implementation BusinessItemDetailViewController {
    
    ImageWallScrollView *_imageWallScrollView;
    int projectId;
    
}

@synthesize expandButton = _expandButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
        projectID:(int)pid {
    self = [super initWithMOC:MOC];
    if (self) {
        
        projectId = pid;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    self.navigationItem.title = [_detailDict objectForKey:@"param3"];
    
    [self addItemTableView];
    
    expandRowCount = 2;
    
    [self initEclipseExpandButton:20];
    
    _MOC = [CommonMethod getInstance].MOC;
    
    [self headerIsTapEvent:nil];
    _images = [[NSMutableArray alloc] init];
    
    if ((_detailArray =[[OffLineDBCacheManager handleBusinessDetailDB:projectId MOC:_MOC] retain])) {
        if (_detailArray.count) {
            NSDictionary *dict =[_detailArray objectAtIndex:0];
            self.navigationItem.title = [dict objectForKey:@"param10"];
            
            [self.itemTable reloadData];
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"BusinessImageList"];
    
    //    [self.itemTable reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadImage:TRIGGERED_BY_AUTOLOAD forNew:YES infoId:projectId];
    [self loadContent:TRIGGERED_BY_AUTOLOAD forNew:YES infoId:projectId];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    [self stopPlay];
    
}

- (void)dealloc {
    
    [_imageWallScrollView release];
    [_headerScrollView release];
    [_pageControl release];
    [_images release];
    [_itemTable release];
    //    [_headerView release];
    
    [super dealloc];
}

#pragma mark - play/stop video auto scroll
- (void)stopPlay {
    //    if (_imageWallContainer) {
    //        [_imageWallContainer stopPlay];
    //    }
}

#pragma mark - image wall delegate

- (void)clickedImageWithImage:(UIImageView *)imageView {
    
    [imageView setupImageViewerWithDatasource:self initialIndex:_imageWallScrollView.currentPageIndex onOpen:^{
        
    } onClose:^{
        
    }];
}


#pragma mark - MHFacebookImageViewerDatasource

- (NSInteger)numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return self.fetchedRC.fetchedObjects.count;
}

-  (NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    //    return [NSURL URLWithString:[NSString stringWithFormat:@"http://iamkel.net/projects/mhfacebookimageviewer/%i.png",index]];
    BusinessImageList *bl = (BusinessImageList *)self.fetchedRC.fetchedObjects[index];
    return [NSURL URLWithString:[bl.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    
    //    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
    return nil;
}

#if 0
- (UIView *)bottomView {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:ImageWithName(@"business_detail_cell_bg.png")];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 23, 100, 30)];
    moreLabel.text = @"更多";
    moreLabel.backgroundColor = TRANSPARENT_COLOR;
    moreLabel.font = FONT_SYSTEM_SIZE(15);
    moreLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [_bottomView addSubview:moreLabel];
    [moreLabel release];
    
    return _bottomView;
}
#else


- (UIView *)bottomView
{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 80)];
    _bottomView.backgroundColor = [UIColor colorWithPatternImage:ImageWithName(@"business_detail_cell_bg.png")];
    
    return _bottomView;
}

#endif

- (void)addItemTableView {
    int heigh=0;
    if ([CommonMethod is7System]) {
        heigh = SYS_STATUS_BAR_HEIGHT;
    }
    _itemTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _headerScrollView.frame.origin.y + _headerScrollView.frame.size.height , self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - heigh)];
    self.itemTable.delegate = self;
    self.itemTable.dataSource = self;
    self.itemTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.itemTable.showsHorizontalScrollIndicator = NO;
    self.itemTable.showsVerticalScrollIndicator = NO;
    self.itemTable.backgroundColor = TRANSPARENT_COLOR;
    
    //    _itemTable.tableFooterView = self.bottomView;
    //    _itemTable.tableHeaderView = [self vid];;
    [self.view addSubview:self.itemTable];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button action

- (void)imageSelected:(UIButton *)sender {
    DLog(@"%d",sender.tag);
}

- (void)initEclipseExpandButton:(int)startY
{
    
    //--------------------
    int controlHeight = 12;
    self.expandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expandButton.frame = CGRectMake(_screenSize.width - 9 - controlHeight, startY, controlHeight, controlHeight);
    
    [self.expandButton setBackgroundImage:[UIImage imageNamed:@"business_more_eclapse.png"] forState:UIControlStateNormal];
    [self.expandButton setBackgroundImage:[UIImage imageNamed:@"business_more_expand.png"] forState:UIControlStateSelected];
    
    [self.expandButton addTarget:self action:@selector(expandButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - scrollview delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = floorf(scrollView.contentOffset.x / scrollView.frame.size.width);
    [_pageControl setCurrentPage:index];
}

#pragma mark - tableview delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == BS_CELL_TYPE_HEADER_SCROLL) {
        return 1;
    }
    if (section == BS_CELL_TYPE_CONTENT_BRIEF)
        return _detailArray.count - 2;
    else if (section == BS_CELL_TYPE_EXPAND)
        return expandRowCount;
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == BS_CELL_TYPE_HEADER_SCROLL) {
        UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)] autorelease];
        [sectionView setBackgroundColor:TRANSPARENT_COLOR];
        return sectionView;
    }
    else if (section == BS_CELL_TYPE_CONTENT_BRIEF) {
        UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)] autorelease];
        [sectionView setBackgroundColor:TRANSPARENT_COLOR];
        return sectionView;
    }
    else if (section == BS_CELL_TYPE_EXPAND) {
        
        
        int headerHeight = 35;
        int controlHeight = 26;
        int startY = 45 - headerHeight;
        int blankLabelWidth = 10;
        
        UILabel *fLabel = [[UILabel alloc] init];
        fLabel.frame = CGRectMake(0, startY, _screenSize.width, headerHeight);
        fLabel.backgroundColor=[UIColor whiteColor];
        
        // Create label with section title
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(blankLabelWidth, startY, 300, headerHeight);
        label.backgroundColor=[UIColor whiteColor];
        label.font = FONT_SYSTEM_SIZE(16);
        
        label.text=@"更多";
        
        
        // Create header view and add label as a subview
        int startX = 0;
        UIButton *sectionView = [UIButton buttonWithType:UIButtonTypeCustom];
        sectionView.frame = CGRectMake(startX, 0, tableView.bounds.size.width - startX*2, headerHeight);
        [sectionView setBackgroundColor: [UIColor colorWithPatternImage:[CommonMethod createImageWithColor:[UIColor clearColor] withRect:CGRectMake(startX, 0, tableView.bounds.size.width - startX, headerHeight)]]];
        
        [self.expandButton retain];
        [sectionView addSubview:fLabel];
        [sectionView addSubview:label];
        [sectionView addSubview:_expandButton];
        [sectionView addTarget:self action:@selector(headerIsTapEvent:) forControlEvents:UIControlEventTouchUpInside];
        [label release];
        [fLabel release];
        
        //------
        //        UILabel *bgLabel = [UILabel alloc] initWithFrame:CGRectMake(star, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);
        return sectionView;
        
    }
    return nil;
}

- (void)headerIsTapEvent:(id)sender
{
    [self expandButtonClicked:_expandButton];
}

- (void)expandButtonClicked:(UIButton *)sender
{
    
    expandRowCount = expandRowCount == 2 ? 0 : 2;
    [_itemTable reloadData];
    
    int distHeight =40;
    
    //    if (_screenSize.height > 480)
    //        distHeight = 90;
    //    else
    //        return VIDEO_35INCH_HEIGHT;
    
    
    sender.selected = !sender.selected;
    if (expandRowCount) {
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:(1) inSection:BS_CELL_TYPE_EXPAND];
        [_itemTable scrollToRowAtIndexPath:lastRow
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
        //        CGRect rect = _itemTable.frame;
        //        rect.size.height += distHeight;
        //        _itemTable.frame = rect;
        
        //        rect = self.view.frame;
        //        rect.size.height += distHeight;
        //        self.view.frame = rect;
    }else {
        //        [self performSelector:@selector(collepseButton:) withObject:sender afterDelay:0.0];
        
        //        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:(_detailArray.count - 2 - 1) inSection:0];
        //        [_itemTable scrollToRowAtIndexPath:lastRow
        //                          atScrollPosition:UITableViewScrollPositionBottom
        //                                  animated:YES];
        
        //        CGRect rect = _itemTable.frame;
        //        rect.size.height -= distHeight;
        //        _itemTable.frame = rect;
        
        //        rect = self.view.frame;
        //        rect.size.height -= distHeight;
        //        self.view.frame = rect;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BS_CELL_TYPE_HEADER_SCROLL) {
        
        if (_screenSize.height > 480)
            return HEADER_SCROLL_HEIGHT;
        else
            return VIDEO_35INCH_HEIGHT;
    }
    else if (indexPath.section == BS_CELL_TYPE_CONTENT_BRIEF)
        return BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT;
    else if (indexPath.section == BS_CELL_TYPE_EXPAND)
        return BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_EXPAND;
    return  0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == BS_CELL_TYPE_HEADER_SCROLL) {
        return 0;
    }
    else if (section == BS_CELL_TYPE_CONTENT_BRIEF) {
        return 0;
    }else if (section == BS_CELL_TYPE_EXPAND)
        return 45;
    
    return 0;
}


- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
#pragma mark -- imagewallscrollview
        
        NSString *scrollImageWallBackground = @"";
        
        
        
        if ([CommonUtils screenHeightIs4Inch]) {
            
            scrollImageWallBackground =@"defaultLoadingImage_heigh.png";
            _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:CGRectMake(0 * 2,
                                                                                         0 * 2,
                                                                                         self.view.frame.size.width - 0 * 4,
                                                                                         HEADER_SCROLL_HEIGHT- 0 * 4) backgroundImage:scrollImageWallBackground];
        } else {
            scrollImageWallBackground =@"defaultLoadingImage.png";
            _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                         self.view.frame.size.width , VIDEO_35INCH_HEIGHT) backgroundImage:scrollImageWallBackground];
        }
        
        _imageWallScrollView.delegate = self;
        
        [cell.contentView addSubview:_imageWallScrollView];
        
        //清除数据
        [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"BusinessImageList"];
        if ([OffLineDBCacheManager handleBusinessDetailImageDB:projectId MOC:_MOC]) {
            
            [self fetchContentFromMOC];
            if (self.fetchedRC.fetchedObjects.count)
            [_imageWallScrollView updateImageListArray:self.fetchedRC.fetchedObjects];
        }
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == BS_CELL_TYPE_HEADER_SCROLL) {
        
        return [self drawVideoCell:tableView atIndexPath:indexPath];
    }
    else if (indexPath.section == BS_CELL_TYPE_CONTENT_BRIEF) {
        static NSString *identifier = @"BusinessItemDetailViewCell";
        BusinessItemDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[[BusinessItemDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.backgroundColor = [UIColor whiteColor];
        }
        
        [cell updateInfo:[_detailArray objectAtIndex:indexPath.row]];
        
        return cell;
    }else if (indexPath.section == BS_CELL_TYPE_EXPAND) {
        static NSString *identifier = @"BusinessItemDetailMoreViewCell";
        BusinessItemDetailMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[[BusinessItemDetailMoreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withType:BUSINESS_DETAIL_CELL_TYPE_EXPAND] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_detailArray.count > 2)
            [cell updateInfo: [_detailArray objectAtIndex:_detailArray.count  - 2 + indexPath.row]];
        
        return cell;
    }
    
    return  nil;
}

//- (void) leftNavButtonClicked:(id)sender
//{
//    [CommonMethod popViewController:self];
//    [CommonMethod pushViewController:[CommonMethod getInstance].navigationController withAnimated:NO];
//}
//
//- (void) rightNavButtonClicked:(id)sender
//{
//
//}

#pragma mark --
- (void)updateInfo:(NSDictionary *)detailDict
{
    _detailDict = detailDict ;
    _detailArray = [detailDict objectForKey:@"list1"];
    [self.itemTable reloadData];
}

#pragma mark -- load image

- (void)loadImage:(LoadTriggerType)triggerType forNew:(BOOL)forNew infoId:(int)infoId {
    
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc] init];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setValue:@IMAGETYPE_PROJECT_ORIGINAL forKey:KEY_API_PARAM_IMAGE_TYPE];
    [specialDict setValue:@(infoId) forKey:KEY_API_PARAM_OBJECT_ID];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestBusinessDetailImageTime:projectId] / 1000.0f ]  forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_SIDEIMAGE withCommon:commonDict withSpecial:specialDict];
    [specialDict release];
    
    _currentType = LOAD_BUSINESS_IMAGE_LIST_TY;
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

- (void)loadContent:(LoadTriggerType)triggerType forNew:(BOOL)forNew infoId:(int)infoId {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setValue:@"" forKey:KEY_API_PARAM_START_TIME];
    [specialDict setValue:@"" forKey:KEY_API_PARAM_END_TIME];
    [specialDict setValue:@(infoId) forKey:KEY_API_PARAM_SPECIAL_CATEGORY_ID];
    [specialDict setValue:NUMBER(2) forKey:KEY_API_PARAM_LEVEL];
    [specialDict setValue:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setValue:@"" forKey:KEY_API_PARAM_KEYWORD];
    [specialDict setValue:NUMBER(3) forKey:KEY_API_PARAM_CATEGORY_TYPE];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestBusinessDetailInfoTime:projectId] / 1000.0f]  forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_CATEGORY withCommon:commonDict withSpecial:specialDict];
    
    _currentType = GET_DETAIL_PAGE_1_TY;
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_DETAIL_PAGE_1_TY];
    [connFacade fetchGets:url];
    
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:NO];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case LOAD_BUSINESS_IMAGE_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:[CommonMethod getInstance].MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:projectId];
            
            if (ret == SUCCESS_CODE) {
                [self fetchContentFromMOC];
                [_imageWallScrollView updateImageListArray:self.fetchedRC.fetchedObjects];
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                if (self.fetchedRC.fetchedObjects.count) {
                    [[GoHighDBManager instance] upinsertBusinessDetailImages:self.fetchedRC.fetchedObjects timestamp:timestamp  MOC:_MOC];
                }
            }
            break;
        }
            
        case GET_DETAIL_PAGE_1_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:[CommonMethod getInstance].MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:projectId];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                NSArray *reqConetentObjects = [[[url componentsSeparatedByString:@"?"] objectAtIndex:1] componentsSeparatedByString:@"="];
                NSString *params = [reqConetentObjects objectAtIndex:1];
                NSDictionary *reqContent = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                
                NSDictionary *special  = [reqContent objectForKey:@"special"];
                
                NSArray *array = [OBJ_FROM_DIC(contentDic, @"list1") retain];
                
                if (![array isEqual:[NSNull null]] && array.count) {
                    
                    _detailArray = array;
                    [self.itemTable reloadData];
                    
                    
                    //-----------------------
                    NSDictionary *dict =[_detailArray objectAtIndex:0];
                    self.navigationItem.title = [dict objectForKey:@"param10"];
                    
                    [[GoHighDBManager instance] upinsertBusinessDetails:contentDic timestamp:timestamp categoryID:[[special objectForKey:KEY_API_PARAM_SPECIAL_CATEGORY_ID] integerValue] MOC:_MOC];
                }
                
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
    
    self.entityName = @"BusinessImageList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"imageID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    self.predicate = [NSPredicate predicateWithFormat:@"projectId == %d",projectId];
}

@end
