//
//  InformationViewController.m
//  Project
//
//  Created by XXX on 13-9-2.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "InformationViewController.h"
#import "TradeInformationView.h"
#import "CircleMarketingView.h"
#import "AloneMarketingViewController.h"
#import "TradeInformationViewController.h"
#import "TradeInformationContentViewController.h"
#import "EventViewController.h"
#import "CommunicationUserSearchViewController.h"
#import "CommonMethod.h"
#import "UIColor+expanded.h"
#import "UIWebViewController.h"
#import "HomeCellView.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "ProjectAPI.h"
#import "JSONKit.h"
#import "AppManager.h"
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"
#import "CommonUtils.h"
#import "HomepageContainerViewController.h"
#import "BusinessItemDetailViewController.h"
#import "ImageList.h"
#import "WXWCoreDataUtils.h"
#import "CircleMarketingDetailViewController.h"
#import "GoHighDBManager.h"
#import "ImageWallScrollView.h"
#import "OffLineDBCacheManager.h"
#import "CircleMarkegingApplyWindow.h"
#import "FoundViewController.h"
#import "WXWNavigationController.h"
#import "BizListViewController.h"
#import "UserListViewController.h"

#define VIDEO_35INCH_HEIGHT   150.0f
#define VIDEO_40INCH_HEIGHT   238.0f

#define GRID_WIDTH            145.0f

#define CELL_SECTION_COUNT            2

#define CELL_VIEW_HEIGHT                    105
#define CELL_VIEW_HEIGHT_SMALL        69

#if APP_TYPE == APP_TYPE_INEARBY
#define COMMON_STUFF_CELL_HEIGHT  340.f
#elif APP_TYPE == APP_TYPE_IALUMNIUSA
#define COMMON_STUFF_CELL_HEIGHT  380.f
#else
#define COMMON_STUFF_CELL_HEIGHT  275.0f
#endif

enum {
    VIDEO_CELL,
    OTHER_INFO_CELL,
};

@interface InformationViewController ()<TradeInformationViewDelegate, ImageWallDelegate,CircleMarkegingApplyWindowDelegate> {
    BOOL _isLoadImage;
    BOOL _isReloadWithSepcifiedID;
    TradeInformationView *_tradeInformation;
}

@end

@implementation InformationViewController {
    ImageWallScrollView *_imageWallScrollView;
    BOOL _isShowNewVersion;
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
       viewHeight:(CGFloat)viewHeight
  homeContainerVC:(WXWRootViewController *)homeContainerVC {
    
    self = [super initNoNeedDisplayEmptyMessageTableWithMOC:MOC
                                      needRefreshHeaderView:YES
                                      needRefreshFooterView:NO
                                                 tableStyle:UITableViewStylePlain];
    if (self) {
        self.parentVC = homeContainerVC;
        
        _viewHeight = viewHeight;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchInfoListContentFromMOC];
    [self refreshTable];
    [self updateLastSelectedCell];
    
    
#if APP_TYPE == APP_TYPE_BASE
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"gohigh_nav_top_background.png"]  forNavigationController:self.parentVC.navigationController];
#elif APP_TYPE == APP_TYPE_CIO
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"cio_nav_bg.png"]  forNavigationController:self.parentVC.navigationController];
#elif APP_TYPE == APP_TYPE_O2O
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"nav_top_background.png"]  forNavigationController:self.parentVC.navigationController];
#endif
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"gohigh_nav_top_background.png"] forNavigationController:self.parentVC.navigationController];
    [super viewWillDisappear:animated];
}

-(void)showNewVersion
{
    if (!_isShowNewVersion) {
       if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
           CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
           [customeAlertView setMessage:@"有新版本发布， 需要更新吗？"
                                  title:@"温馨提示"];
           customeAlertView.applyDelegate = self;
           [customeAlertView show];
    }
    
    _isShowNewVersion = TRUE;
    }
}

- (void)openVideos:(id)sender {
    
    //    DLog(@"_imageWallContainer.informationID: %d",_imageWallContainer.informationID);
    
    //    NSInteger index = 0;
    //    NSString *number = [NSString stringWithFormat:@"%d",[_imageWallContainer informationID]];
    //    if ([informationIDs containsObject:number]) {
    //        index = [informationIDs indexOfObject:number];
    //    }
    //--todo
    
#if 0
    switch ([_imageWallScrollView informationType]) {
        case 20://圈层营销
        {
            CircleMarketingDetailViewController *vc = [[[CircleMarketingDetailViewController alloc]
                                                        initWithMOC:_MOC
                                                        parentVC:self
                                                        withEventId:[_imageWallScrollView informationID]
                                                        detailType:0] autorelease];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
            break;
        }
            
        case 3: {//业务详情
            BusinessItemDetailViewController *vc = [[[BusinessItemDetailViewController alloc] initWithMOC:_MOC projectID:[_imageWallScrollView informationID]] autorelease];
            //            [vc updateInfoWithId:[NSString stringWithFormat:@"%d",[_imageWallContainer informationID]]];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
            break;
        }
            
        case 1:{
            //资讯内容
            _isReloadWithSepcifiedID = YES;
//            [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
            [self loadSpecifieldIDInfo:TRIGGERED_BY_AUTOLOAD forNew:YES];
            break;
        }
            
        default:
            break;
    }
#endif
}

- (void)openPay:(id)sender {
    UIWebViewController *webVC = [[[UIWebViewController alloc] init] autorelease];
    WXWNavigationController *webViewNav = [[[WXWNavigationController alloc] initWithRootViewController:webVC] autorelease];
    webViewNav.navigationBar.tintColor = TITLESTYLE_COLOR;
    webVC.strUrl = @"http://112.124.68.147:5036/Module/Property/propertyfee.html";
    webVC.strTitle = @"便利付";
    
    [self.parentVC presentModalViewController:webViewNav
                                     animated:YES];
}

- (void)openEdu:(id)sender {}
- (void)openProperty:(id)sender {}
- (void)openHousekeeping:(id)sender {}
- (void)openCarsPets:(id)sender {}
- (void)openCallService:(id)sender {}
- (void)openHealth:(id)sender {}

- (void)openWeChat:(id)sender {
    
    UIWebViewController *webVC = [[[UIWebViewController alloc] init] autorelease];
    WXWNavigationController *webViewNav = [[[WXWNavigationController alloc] initWithRootViewController:webVC] autorelease];
    webViewNav.navigationBar.tintColor = TITLESTYLE_COLOR;
    webVC.strUrl = @"http://112.124.68.147:5020/mobile/reg/followus.html";
    webVC.strTitle = @"关注微信";
    
    [self.parentVC presentModalViewController:webViewNav
                                     animated:YES];

}

- (void)openBiz:(id)sender {
    BizListViewController *bizVC = [[[BizListViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
    [CommonMethod pushViewController:bizVC withAnimated:YES];
}

- (void)openNearby:(id)sender {
    UserListViewController *userVC = [[[UserListViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
    [CommonMethod pushViewController:userVC withAnimated:YES];
}

- (void)openNotify:(id)sender {
    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
}

- (void)openSearchUser:(id)sender {
    
#if APP_TYPE == APP_TYPE_BASE || APP_TYPE == APP_TYPE_O2O
    AloneMarketingViewController *aloneMarketingController = [[[AloneMarketingViewController alloc] init] autorelease];
    [CommonMethod pushViewController:aloneMarketingController withAnimated:YES];
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA
    CommunicationUserSearchViewController *vc = [[[CommunicationUserSearchViewController alloc] init] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
#endif
}

- (void)openFound:(id)sender {
#if APP_TYPE == APP_TYPE_BASE || APP_TYPE == APP_TYPE_O2O
    EventViewController *vc = [[[EventViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY
    FoundViewController *foundVC = [[FoundViewController alloc] initWithMOC:_MOC
                                 parentVC:self];
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:foundVC animated:YES];
    }

#endif
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}


- (void)tradeInformationViewDidTapped {
    
    TradeInformationViewController *vc = [[[TradeInformationViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
    
    //    [CommonMethod pushViewController:vc withAnimated:YES];
    
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:vc animated:YES];
    }
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}

- (void)tradeInformationViewTappedWithInformationList:(InformationList *)list {
    
    TradeInformationContentViewController *contentController = [[[TradeInformationContentViewController alloc] initWithMOC:_MOC parentVC:self url:list.zipURL information:list] autorelease];
    
    if (self.parentVC) {
        [self.parentVC.navigationController pushViewController:contentController animated:YES];
    }
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.parentVC.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark - play/stop video auto scroll
- (void)stopPlay {
    //    if (_imageWallContainer) {
    //        [_imageWallContainer stopPlay];
    //    }
}

- (void)dealloc {
    _isLoadImage = NO;
    
    [_imageWallScrollView release];
    
    //    if (_imageWallContainer) {
    //        [_imageWallContainer removeFromSuperview];
    //        //        _imageWallContainer = nil;
    //        RELEASE_OBJ(_imageWallContainer);
    //    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    self.view.frame = CGRectMake(0,
    //                                 0,
    //                                 self.view.frame.size.width,
    //                                 _viewHeight);
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT );
    
    //    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //-------------------
    
    //    [self initScrollView:self.view];
    
    _isLoadImage = NO;
    if (!_autoLoaded) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
        [self loadImage:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    [self performSelector:@selector(showNewVersion) withObject:nil afterDelay:15.0f + arc4random() % 15];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)initScrollView:(UIView *)parentView
{
    
#pragma mark -- imagewallscrollview
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
    
    _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2,
                                                                                 self.view.frame.size.width -
                                                                                 MARGIN * 4, VIDEO_35INCH_HEIGHT) backgroundImage:scrollImageWallBackground];
    
    _imageWallScrollView.delegate = self;
    [parentView addSubview:_imageWallScrollView];
    
    //清除数据
    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"ImageList"];
    if ([OffLineDBCacheManager handleInformationImageWallDB:_MOC]) {
        _isLoadImage = YES;
        [self fetchContentFromMOC];
        if (self.fetchedRC.fetchedObjects.count)
            [_imageWallScrollView updateImageListArray:[self.fetchedRC.fetchedObjects retain]];
    }
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_SECTION_COUNT;
}

- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"image_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
#pragma mark -- mscrollview
        
        [self initScrollView:cell.contentView];
    }
    
    return cell;
}


- (UITableViewCell *)drawOtherInfoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"otherInfoCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (nil == cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
#define TITLE_LABEL_WIDTH  146.f
#define TITLE_LABEL_HEIGHT 32.f
        
#if APP_TYPE == APP_TYPE_INEARBY
        // Line 1
        HomeCellView *payCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, 129, CELL_VIEW_HEIGHT) target:self action:@selector(openPay:) backColor:@"0x368ff4" logoFrame:CGRectMake((129 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"pay.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"便利付" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:payCell];
        
        HomeCellView *eduCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(144, MARGIN * 2, 80, CELL_VIEW_HEIGHT) target:self action:@selector(openEdu:) backColor:@"0x747ae8" logoFrame:CGRectMake((80 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"edu.png" labelFrame:CGRectMake(0, MARGIN, 80, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 10.f, 0.f, 0.f) labelText:@"教育培训" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:eduCell];
        
        HomeCellView *propertyCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(228, MARGIN * 2, 80, CELL_VIEW_HEIGHT) target:self action:@selector(openProperty:) backColor:@"0x9556f3" logoFrame:CGRectMake((80 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"property.png" labelFrame:CGRectMake(0, MARGIN, 80, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 10.f, 0.f, 0.f) labelText:@"物业服务" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:propertyCell];

        // Line 2
        HomeCellView *housekeepingCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 3 + CELL_VIEW_HEIGHT, 174, CELL_VIEW_HEIGHT) target:self action:@selector(openHousekeeping:) backColor:@"0x0fc4d9" logoFrame:CGRectMake((174 - 46.0f)/2.0f+25.f, MARGIN * 7, 46.0f, 46.0f) logoImg:@"houseKeep.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"家政服务" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:housekeepingCell];
        
        HomeCellView *carsPetsCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(189, MARGIN * 3 + CELL_VIEW_HEIGHT, 121, CELL_VIEW_HEIGHT) target:self action:@selector(openCarsPets:) backColor:@"0xff6779" logoFrame:CGRectMake((121 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"carPet.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"汽车宠物" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:carsPetsCell];
        
        // Line 3
        HomeCellView *callServiceCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 4 + CELL_VIEW_HEIGHT*2, 138, CELL_VIEW_HEIGHT) target:self action:@selector(openCallService:) backColor:@"0x84d018" logoFrame:CGRectMake((138 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"callService.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"呼叫服务" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:callServiceCell];
        
        HomeCellView *healthCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(153, MARGIN * 4+ CELL_VIEW_HEIGHT*2, 157, CELL_VIEW_HEIGHT) target:self action:@selector(openHealth:) backColor:@"0xf3b613" logoFrame:CGRectMake((157 - 58.0f)/2.0f, MARGIN * 7, 58.0f, 58.0f) logoImg:@"health.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"健身健康" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:healthCell];
        
        // Line 4
        _tradeInformation = [[TradeInformationView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 7 + CELL_VIEW_HEIGHT*3, 300, 140) MOC:_MOC];
        _tradeInformation.delegate = self;
        [cell.contentView addSubview:_tradeInformation];
        
#elif  APP_TYPE == APP_TYPE_IALUMNIUSA
        // Line 1
        HomeCellView *searchCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 2, 175.f, CELL_VIEW_HEIGHT+1) target:self action:@selector(openSearchUser:) backColor:@"0x368ff5" logoFrame:CGRectMake((175.f - 73.0f)/2.0f, MARGIN * 7, 73.0f, 67.0f) logoImg:@"contactsCell.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"通讯录" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:searchCell];
        
        HomeCellView *nearbyCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(190.f, MARGIN * 2, 119.f, CELL_VIEW_HEIGHT_SMALL) target:self action:@selector(openNearby:) backColor:@"0x9656f3" logoFrame:CGRectMake((119.f - 73.0f)/2.0f, MARGIN * 6 + 3, 73.0f, 33.0f) logoImg:@"nearbyCell.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"附近" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:nearbyCell];
        
        HomeCellView *followChatCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(190.f, MARGIN * 3+CELL_VIEW_HEIGHT_SMALL, 119.f, CELL_VIEW_HEIGHT_SMALL) target:self action:@selector(openWeChat:) backColor:@"0x747ae8" logoFrame:CGRectMake((119.f - 73.0f)/2.0f, MARGIN * 6 + 3, 73.0f, 33.0f) logoImg:@"followChatCell.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"关注微信" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:followChatCell];
        
        HomeCellView *bizCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(190.f, MARGIN * 4+CELL_VIEW_HEIGHT_SMALL*2, 119.f, CELL_VIEW_HEIGHT_SMALL) target:self action:@selector(openBiz:) backColor:@"0x0fc4d9" logoFrame:CGRectMake((119.f - 73.0f)/2.0f, MARGIN * 6 + 3, 73.0f, 33.0f) logoImg:@"bizCell.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"资源整合" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:bizCell];
        
        HomeCellView *notifyCell = [[[HomeCellView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 3+CELL_VIEW_HEIGHT +1, 175.f, CELL_VIEW_HEIGHT+1) target:self action:@selector(openNotify:) backColor:@"0xff6779" logoFrame:CGRectMake((175.f - 73.0f)/2.0f, MARGIN * 7, 73.0f, 67.0f) logoImg:@"notifyCell.png" labelFrame:CGRectMake(0, MARGIN, TITLE_LABEL_WIDTH, TITLE_LABEL_HEIGHT) labelEdge:UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f) labelText:@"通知" labelColor:@"0xffffff"] autorelease];
        [cell.contentView addSubview:notifyCell];
        
        // Line 2
        _tradeInformation = [[TradeInformationView alloc] initWithFrame:CGRectMake(MARGIN * 2, MARGIN * 4 +3+ CELL_VIEW_HEIGHT * 2, 300, 140) MOC:_MOC];
        _tradeInformation.delegate = self;
        [cell.contentView addSubview:_tradeInformation];
        
#endif
        
        if ([OffLineDBCacheManager handleInformationListDB:0 count:3 MOC:_MOC]) {
            _isLoadImage = NO;
            [self fetchContentFromMOC];
            
            [_tradeInformation loadInformation];
        }
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
            return COMMON_STUFF_CELL_HEIGHT;
            
        default:
            return 0;
    }
}

#pragma mark - imageWallDelegate

- (void)clickedImage {
    switch ([_imageWallScrollView rootModule]) {
        case 20://圈层营销
        {
            CircleMarketingDetailViewController *vc = [[[CircleMarketingDetailViewController alloc]
                                                        initWithMOC:_MOC
                                                        parentVC:self
                                                        withEventId:[_imageWallScrollView targetID]
                                                        detailType:0] autorelease];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
        } break;
        case 3: {//业务详情
            BusinessItemDetailViewController *vc = [[[BusinessItemDetailViewController alloc] initWithMOC:_MOC projectID:[_imageWallScrollView targetID]] autorelease];
            //            [vc updateInfoWithId:[NSString stringWithFormat:@"%d",[_imageWallContainer informationID]]];
            
            [CommonMethod pushViewController:vc withAnimated:YES];
            
        } break;
        case 1:{//资讯内容
            
            _isReloadWithSepcifiedID = YES;
//            [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
            
            [self loadSpecifieldIDInfo:TRIGGERED_BY_AUTOLOAD forNew:YES];
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - load data

-(void)loadSpecifieldIDInfo:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    if (_isReloadWithSepcifiedID)
    {
        _currentType = LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY;
        
        NSInteger index = 0;
        if (!forNew) {
            index = ++_currentStartIndex;
        }
        
        NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
        [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
        [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
        
        [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
        [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_INFORMATION_TYPE];
        [specialDict setObject:@"" forKey:KEY_API_PARAM_START_TIME];
        [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
        //todo--_imageWallContainer
        [specialDict setObject:NUMBER(_imageWallScrollView.targetID) forKey:KEY_API_PARAM_SPECIFIED_ID];
        
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
}

-(void)loadInfoList:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    _currentType = LOAD_INFORMATION_LIST_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_INFORMATION_TYPE];
    
    if ([[GoHighDBManager instance] getLatestInfomationTimestamp] == 0) {
        [specialDict setObject:@""  forKey:KEY_API_PARAM_START_TIME];
    }else{
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestInfomationTimestamp] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
    }
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
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
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    _reloading = NO;
    
    [self loadInfoList:triggerType forNew:forNew];
    [self loadImage:triggerType forNew:forNew];
}

- (void)loadImage:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    //    DELETE_OBJS_FROM_MOC(_MOC, @"ImageList", nil);
    
    _isLoadImage = YES;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [specialDict setValue:@IMAGETYPE_INFORMATION forKey:KEY_API_PARAM_IMAGE_TYPE];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestInfoImageWallTime] / 1000.0f ]  forKey:KEY_API_PARAM_START_TIME];
    
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
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:LOAD_IMAGE_LIST_TY];
    [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
        
        case LOAD_INFORMATION_LIST_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                NSDictionary *content = OBJ_FROM_DIC(resultDic, @"content");
                
                NSString *shareURL = [content objectForKey:@"param2"];
                
                
                _isLoadImage = NO;
                _autoLoaded = YES;                
                [self refreshTable];
                
                [[GoHighDBManager instance] upinsertInfomationInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
                if (![shareURL isEqual:[NSNull null]])
                [[GoHighDBManager instance] upinsertCommonTable:INFORMATION_SHARE_WEIXIN_KEY value:shareURL];
                [[GoHighDBManager instance] upinsertInfomationInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                
                
                [_tradeInformation loadInformation];
                [_tableView reloadData];
            }
            
            break;
        }
            
        case LOAD_IMAGE_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _isLoadImage = TRUE;
                _autoLoaded = YES;
                [self fetchContentFromMOC];
                [_imageWallScrollView updateImageListArray:self.fetchedRC.fetchedObjects];
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                [[GoHighDBManager instance] upinsertInfomationImageWall:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
            }
            
            break;
        }
            
        case LOAD_INFORMATION_LIST_WITH_SPECIFIEDID_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                _isReloadWithSepcifiedID = NO;
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                
                NSArray *arr = OBJ_FROM_DIC(contentDic, @"list1");
                
                if (arr && arr.count) {
                    
                NSString *url = @"";
                int informationID = 0;
                
                for (NSDictionary *dict in arr) {
                    url = [dict objectForKey:@"param8"];
                    informationID = [[dict objectForKey:@"param1"] integerValue];
                }
                
                
                TradeInformationContentViewController *vc = [[[TradeInformationContentViewController alloc]
                                                              initWithMOC:_MOC
                                                              parentVC:self
                                                              url:url
                                                              informationID:informationID] autorelease];
                [CommonMethod pushViewController:vc withAnimated:YES];
                
                _autoLoaded = YES;
                    
                }else{
                    
                    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"内容已删除", nil)
                                                     msgType:INFO_TY
                                          belowNavigationBar:YES];
                }
            }
        }
            break;
            
            
        default:
            break;
    }
    
    _autoLoaded = YES;
    
    [super connectDone:result
                   url:url
           contentType:contentType];
    
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

-(void)fetchInfoListContentFromMOC
{
    self.fetchedRC = nil;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
//    self.entityName =  @"InformationList";
//    self.predicate = [NSPredicate predicateWithFormat:@"isDelete == 0 and informationID != 0"];
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"informationID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:@"InformationList"
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate: [NSPredicate predicateWithFormat:@"isDelete == 0 and informationID != 0"]];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
//        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (_tradeInformation) {
        [_tradeInformation loadInformation];
    }
}

- (void)configureMOCFetchConditions {
    self.entityName = _isLoadImage ? @"ImageList" : @"InformationList";
    
    if (!_isLoadImage) {
        self.predicate = [NSPredicate predicateWithFormat:@"isDelete == 0"];
    }
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:_isLoadImage ? @"imageID" : @"informationID"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}


- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray
{
}

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *)alertView
{
     [alertView release];
}

- (void)circleMarketingApplyWindow:(CircleMarkegingApplyWindow *)alertView didEndEditing:(NSString *)text
{
     [alertView release];
    
    NSURL *url = [NSURL URLWithString:[AppManager instance].updateURL];
    
    if ([[url scheme] hasPrefix:@"http"]) {
        
        if (![[UIApplication sharedApplication] openURL:url]){
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
    
    [CommonMethod update:[AppManager instance].updateURL];
}
@end
