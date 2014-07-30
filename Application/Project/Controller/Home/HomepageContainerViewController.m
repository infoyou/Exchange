
/*!
 @class HomepageContainerViewController.m
 @abstract 主界面
 */

#import "HomepageContainerViewController.h"
#import "InformationViewController.h"
#import "TrainingViewController.h"
#import "BusinessViewController.h"
#import "CommunicationListViewController.h"
#import "EventViewController.h"
#import "MeViewController.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonHeader.h"
#import "CommunicationUserSearchViewController.h"
#import "UIWebViewController.h"
#import "AppManager.h"
#import "EventListViewController.h"

#import "OALoginViewController.h"
#import "OADetailViewController.h"

@interface HomepageContainerViewController ()

/*!
 @property
 @abstract TabBar View
 */
@property (nonatomic, retain) TabBarView *tabBar;
@property (nonatomic, retain) UIWindow *statusBarBackground;
@property (nonatomic, assign) InformationViewController *informationViewController;
@property (nonatomic, assign) BusinessViewController *businessViewController;
@property (nonatomic, assign) CommunicationListViewController *communicationViewController;
@property (nonatomic, assign) OALoginViewController *oaViewController;
@property (nonatomic, assign) OADetailViewController *oaDetailViewController;
@property (nonatomic, assign) UIWebViewController *shoppingViewController;
@property (nonatomic, assign) TrainingViewController *trainingViewController;
@property (nonatomic, assign) CommunicationUserSearchViewController *communicationUserSearchViewController;
@property (nonatomic, assign) MeViewController *meViewController;
@property (nonatomic, assign) EventViewController *circleMarketingViewController;

- (void) notifyNetworkStatus:(NSNotification*)notification;
- (void) updateNavigationTitleWithNetworkConnectionStatus:(NetworkConnectionStatus)status;
@end

@implementation HomepageContainerViewController


#pragma mark - init views

/*!
 @method initTabBar
 @abstract 初始化TabView
 @discussion 这里可以具体写写这个方法如何使用，注意点之类的。如果你是设计一个抽象类或者一个
 共通类给给其他类继承的话，建议在这里具体描述一下怎样使用这个方法。
 @param text
 @param error 错误参照
 @result void
 */
- (void)initTabBar {
    if (CURRENT_OS_VERSION >= IOS7) {
        _tabbarOriginalY = self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT;
    } else {
        _tabbarOriginalY = self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT - self.navigationController.navigationBar.frame.size.height;
    }
    
    self.tabBar = [[[TabBarView alloc] initWithFrame:CGRectMake(0, _tabbarOriginalY, self.view.frame.size.width, HOMEPAGE_TAB_HEIGHT) delegate:self] autorelease];
    [self.view addSubview:self.tabBar];
}

- (void)initNavigationBarTitle {
    self.navigationItem.title = LocaleStringForKey(NSAppTitle, nil);
}

- (CGFloat)contentHeight {
    return self.view.frame.size.height - HOMEPAGE_TAB_HEIGHT;
}

#pragma mark - life cycle methods
- (id)initHomepageWithMOC:(NSManagedObjectContext *)MOC
{
    self = [super initWithMOCWithoutBackButton:MOC];
    if (self) {
        [CommonMethod getInstance].navigationRootViewController = self;
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.tabBar = nil;
    
    self.currentVC = nil;
    
    self.statusBarBackground = nil;
    
    [_informationViewController release];
    [_businessViewController release];
    [_trainingViewController release];
    [_communicationUserSearchViewController release];
    [_meViewController release];
    [_circleMarketingViewController release];
    [_shoppingViewController release];
    [_oaDetailViewController release];
    [_communicationViewController release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNetworkStatus:) name:NOTIFY_NETWORK_STATUS object:nil];
    
    [self initTabBar];
    
    [self initNavigationBarTitle];
    
#if APP_TYPE == APP_TYPE_FOSUN
    [self showHomeView];
#else
    [self selectHomepage];
#endif

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.currentVC) {
        [WXWCommonUtils checkAndExecuteSelectorWithName:@"play" byTarget:self.currentVC];
        
        if (CURRENT_OS_VERSION >= IOS7) {
            if ([self.currentVC isKindOfClass:[InformationViewController class]]) {
                //                [self hideNavigationBarForiOS7];
                
                //                if (self.statusBarBackground == nil) {
                //                    self.statusBarBackground = [[[UIWindow alloc] initWithFrame: CGRectMake(0, 0, APP_WINDOW.frame.size.width, 20)] autorelease];
                //                    self.statusBarBackground.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gohigh_navigationBar_background"]];
                //                    [self.statusBarBackground setHidden:NO];
                //                }
            } else {
                self.statusBarBackground.backgroundColor = [UIColor blackColor];
                [self.statusBarBackground setHidden:NO];
            }
            
            self.tabBar.frame = CGRectMake(0, _tabbarOriginalY - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
        }
        
        [self.currentVC viewWillAppear:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.currentVC) {
        [WXWCommonUtils checkAndExecuteSelectorWithName:@"stopPlay" byTarget:self.currentVC];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)notifyNetworkStatus:(NSNotification *)notification {
    if (![self.currentVC isKindOfClass:[CommunicationListViewController class]]) {
        return;
    }
    
    if (notification.userInfo != nil) {
        NetworkConnectionStatus status = [[notification.userInfo objectForKey:@"status"] integerValue];
        [self updateNavigationTitleWithNetworkConnectionStatus:status];
    }
}

- (void)updateNavigationTitleWithNetworkConnectionStatus:(NetworkConnectionStatus)status {
    
    NSString* string = @"";
    switch (status) {
        case NetworkConnectionStatusOff:
            string = @"（未连接）";
            break;
        case NetworkConnectionStatusOn:
            string = @"";
            break;
        case NetworkConnectionStatusDoing:
            string = @"（正在连接...）";
            break;
        case NetworkConnectionStatusLoading:
            string = @"（正在加载...）";
            break;
        default:
            break;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"聊天%@", string];
}

#pragma mark - clear current vc
- (void)clearCurrentVC {
    [self.currentVC cancelConnectionAndImageLoading];
    [self.currentVC cancelLocation];
    
    if (self.currentVC.view) {
        [self.currentVC.view removeFromSuperview];
    }
    
    self.currentVC = nil;
}

#pragma mark - refresh tab items
- (void)refreshTabItems {
    [self.tabBar refreshItems];
}

#pragma mark - TabDelegate methods

- (void)removeCurrentView {
    
    [WXWCommonUtils checkAndExecuteSelectorWithName:@"stopPlay" byTarget:self.currentVC];
    
    [self clearCurrentVC];
}

- (void)arrangeCurrentVC:(WXWRootViewController *)vc {
    
    [self removeCurrentView];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.tabBar.frame = CGRectMake(0, _tabbarOriginalY, self.tabBar.frame.size.width, self.tabBar.frame.size.height);
    
    self.currentVC = vc;
    [self.view addSubview:self.currentVC.view];
    
    if ([WXWCommonUtils currentOSVersion] < IOS5) {
        [self.currentVC viewWillAppear:YES];
    }
    
    [self.view bringSubviewToFront:self.tabBar];
}

- (void)refreshBadges {
    [self.tabBar refreshBadges];
}

#pragma mark - do tab bar action
- (void)selectFirstTabBar
{
#if APP_TYPE == APP_TYPE_FOSUN
    [self selectCommunicate];
#else
    [self selectHomepage];
#endif
}

- (void)selectSecondTabBar
{
#if APP_TYPE == APP_TYPE_FOSUN
    [self selectOA];
#else
    [self selectCommunicate];
#endif
}

- (void)selectThirdTabBar
{
#if APP_TYPE == APP_TYPE_FOSUN
    [self selectMe];
#else
    [self selectEvent];
#endif
}

- (void)selectFourthTabBar
{
    [self selectMe];
}

- (void)selectFifthTabBar
{
    
}

#pragma mark - do logic detail
//过渡页面
- (void)showHomeView
{
    [self selectCommunicate];
}

//交流
- (void)selectCommunicate
{
    
    if ([self.currentVC isKindOfClass:[CommunicationListViewController class]]) {
        return;
    }
    
    [self clearNaviBarItem];
    
#if APP_TYPE == APP_TYPE_FOSUN
    [self updateNavigationTitleWithNetworkConnectionStatus:[AppManager instance].connectionStatus];
    [self.tabBar switchTabHighlightStatus:0];
#else
    self.navigationItem.title = LocaleStringForKey(@"群组列表", nil);
#endif
    
    if (!self.communicationViewController) {
        self.communicationViewController = [[CommunicationListViewController alloc] initWithMOC:_MOC
                                                                                  parentVC:self];
    }
    [self arrangeCurrentVC:self.communicationViewController];
    
    if (CURRENT_OS_VERSION >= IOS7) {
        
        self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                       self.view.frame.size.height - self.tabBar.frame.size.height,
                                       self.tabBar.frame.size.width,
                                       self.tabBar.frame.size.height);
    }
}

//我
- (void)selectMe
{
    if ([self.currentVC isKindOfClass:[MeViewController class]]) {
        return;
    }
    
    [self clearNaviBarItem];
    
    self.navigationItem.title = LocaleStringForKey(@"我", nil);
    
    if (!self.meViewController) {
        self.meViewController = [[MeViewController alloc] initMeVC:_MOC
                                                             parentVC:self];
    }
   
    [self arrangeCurrentVC:self.meViewController];
    
    if (CURRENT_OS_VERSION >= IOS7) {
        
        self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                       self.view.frame.size.height - self.tabBar.frame.size.height,
                                       self.tabBar.frame.size.width,
                                       self.tabBar.frame.size.height);
    }
}

- (void)selectEvent {
    
    if ([self.currentVC isKindOfClass:[EventListViewController class]]) {
        return;
    }
    
    self.navigationItem.title = LocaleStringForKey(NSEventTitle, nil);
    
    EventListViewController *eventListVC = [[[EventListViewController alloc] initWithMOC:_MOC
                                                                                parentVC:self] autorelease];
    [self arrangeCurrentVC:eventListVC];
    
}

//资讯
- (void)selectHomepage {
    if ([self.currentVC isKindOfClass:[InformationViewController class]]) {
        return;
    }
    
#if APP_TYPE == APP_TYPE_BASE
    self.navigationItem.title = LocaleStringForKey(@"资讯", nil);
#elif APP_TYPE == APP_TYPE_CIO
    self.navigationItem.title = LocaleStringForKey(@"CIO联盟", nil);
#elif APP_TYPE == APP_TYPE_IALUMNIUSA
    self.navigationItem.title = LocaleStringForKey(@"美国校友会", nil);
#elif APP_TYPE == APP_TYPE_FOSUN
    [self updateNavigationTitleWithNetworkConnectionStatus:[AppManager instance].connectionStatus];
#elif APP_TYPE == APP_TYPE_INEARBY
    self.navigationItem.title = LocaleStringForKey(@"微邻家", nil);
#elif APP_TYPE == APP_TYPE_O2O
    self.navigationItem.title = LocaleStringForKey(@"O2O云商户", nil);
#endif
    
    if (!self.informationViewController)
        self.informationViewController= [[InformationViewController alloc] initWithMOC:self.MOC
                                                                            viewHeight:self.view.frame.size.height - self.tabBar.frame.size.height
                                                                       homeContainerVC:self];
    [self arrangeCurrentVC:self.informationViewController];
    CGRect rect = self.informationViewController.view.frame;
    DLog(@"%f %f", rect.origin.y, rect.size.height);
    
    [self.tabBar switchTabHighlightStatus:0];
    if (CURRENT_OS_VERSION >= IOS7) {
        self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                       self.view.frame.size.height - self.tabBar.frame.size.height,
                                       self.tabBar.frame.size.width,
                                       self.tabBar.frame.size.height);
    }
}

//培训
- (void)selectTraining {
    
    if ([self.currentVC isKindOfClass:[TrainingViewController class]]) {
        return;
    }
    
    self.navigationItem.title = LocaleStringForKey(@"学习培训", nil);
    
    if (!self.trainingViewController)
        self.trainingViewController = [[TrainingViewController alloc] initWithMOC:_MOC
                                                                         parentVC:self];
    [self arrangeCurrentVC:self.trainingViewController];
    
    if (CURRENT_OS_VERSION >= IOS7) {
        
        self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                       self.view.frame.size.height - self.tabBar.frame.size.height,
                                       self.tabBar.frame.size.width,
                                       self.tabBar.frame.size.height);
    }
}

- (void)selectOA
{
    
    [[AppManager instance] getOAUserInfoFromLocal];
    if([AppManager instance].OAPswd != nil && ![[AppManager instance].OAPswd isEqualToString:@""]){
        
        [self selectOADetail];
    } else {
        
        if ([self.currentVC isKindOfClass:[OALoginViewController class]]) {
            return;
        }
        
        self.navigationItem.title = LocaleStringForKey(@"办公", nil);
        
        if (!self.oaViewController) {
            self.oaViewController = nil;
        }
        
        self.oaViewController = [[OALoginViewController alloc] initOALoginVC:_MOC
                                                                    parentVC:self];
        [self arrangeCurrentVC:self.oaViewController];
        
        if (CURRENT_OS_VERSION >= IOS7) {
            
            self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                           self.view.frame.size.height - self.tabBar.frame.size.height,
                                           self.tabBar.frame.size.width,
                                           self.tabBar.frame.size.height);
        }
    }
}

- (void)selectOADetail
{
    if ([self.currentVC isKindOfClass:[OADetailViewController class]]) {
        return;
    }
    
    self.navigationItem.title = LocaleStringForKey(@"办公", nil);
    
    if (!self.oaDetailViewController) {
        self.oaDetailViewController = nil;
    }
    self.oaDetailViewController= [[OADetailViewController alloc] initOADetailVC:self];
    self.oaDetailViewController.strTitle = @"办公";
    [self arrangeCurrentVC:self.oaDetailViewController];
    
    if (CURRENT_OS_VERSION >= IOS7) {
        self.tabBar.frame = CGRectMake(self.tabBar.frame.origin.x,
                                       self.view.frame.size.height - self.tabBar.frame.size.height,
                                       self.tabBar.frame.size.width,
                                       self.tabBar.frame.size.height);
    }
}

- (void)clearAllViewController {
#if APP_TYPE != APP_TYPE_FOSUN
    self.communicationViewController = nil;
#endif
    self.meViewController = nil;
}

- (void)clearNaviBarItem {
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

@end
