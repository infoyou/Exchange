
#import "MeViewController.h"
#import "MyMessageCell.h"
#import "CIOPersonalInfoCell.h"
#import "UserBaseInfo.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "GoHighDBManager.h"
#import "MyInfoViewController.h"
#import "CommunicationMessageListViewController.h"
#import "TextPool.h"
#import "WXApi.h"
#import "CommonUtils.h"
#import "BaseAppDelegate.h"
#import "HomepageContainerViewController.h"
#import "CircleMarkegingApplyWindow.h"
#import "FileUtils.h"
#import "ContactUsViewController.h"
#import "ProjectAPI.h"
#import "WXWLabel.h"
#import "WXWConstants.h"
#import "SDImageCache.h"

#define BUTTON_LOGOUT_WIDTH  246.5f
#define BUTTON_LOGOUT_HEIGHT 41.f

#define SECTION_COUNT       2

enum ALERT_TAG {
    ALERT_TAG_CLEAR_CACHE = 1,
    ALERT_TAG_UPDATE = 2,
};

enum ME_SECTION_TYPE {
    ME_SECTION_TYPE_HEADER,
    ME_SECTION_TYPE_OTHER,
    ME_SECTION_TYPE_MESSAGE,
};

//--私信section
enum ME_MESSAGE_CELL {
    ME_MESSAGE_CELL_PRIVATE,//私信
};

//--other section
enum ME_OTHER_CELL {
    ME_OTHER_CELL_CLEAR,
    ME_OTHER_CELL_VERSION,
    ME_OTHER_CELL_CONTACT,
    ME_OTHER_CELL_SHARE_INVITE,
    ME_OTHER_CELL_SYS_SETTING,
    ME_OTHER_CELL_COLLECTION,
};

enum {
    SHARE_AS_TY,
    TAKE_PHOTO_AS_TY,
};

enum {
	SHARE_SMS_AS_IDX,
	SHARE_WX_AS_IDX,
    SHARE_CANCEL_IDX,
};

@interface MeViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate, CircleMarkegingApplyWindowDelegate>
{
    BOOL needReLoad;
}
@end

@implementation MeViewController {
    
    NSInteger _asOwnerType;
}

- (id)initMeVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    if (self = [super initWithMOC:MOC]) {
        
        _noNeedDisplayEmptyMsg = YES;
        self.parentVC = pVC;
        
        needReLoad = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loadDataUserProfile)
                                                     name:CHANGE_USER_NOTIFY
                                                   object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"###### viewWillAppear #####");
    if (needReLoad) {
        [_tableView reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setAlpha:1.0f];
    
    [self addLogout];
}

- (void)addLogout
{
    CGFloat buttonX = 10;
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.frame = CGRectMake(buttonX, 240, 300, BUTTON_LOGOUT_HEIGHT);
    [logout setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"oa_login.png") forState:UIControlStateNormal];
    [logout setTitle:@"切换帐号" forState:UIControlStateNormal];
    [logout.titleLabel setTextColor:[UIColor whiteColor]];
    [logout.titleLabel setFont:FONT_SYSTEM_SIZE(18)];
    [logout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableView addSubview:logout];
    
    // Version
    WXWLabel *versionLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(buttonX, 290, 300, BUTTON_LOGOUT_HEIGHT) textColor:[UIColor grayColor] shadowColor:TRANSPARENT_COLOR] autorelease];
    versionLabel.font = FONT(12);
    versionLabel.textAlignment = UITextAlignmentCenter;
    versionLabel.text = [NSString stringWithFormat:@"版本 V%@", VERSION];
     [_tableView addSubview:versionLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case ME_SECTION_TYPE_HEADER:
            return 1;
            break;
            
        case ME_SECTION_TYPE_MESSAGE:
            return 1;
            break;
            
        case ME_SECTION_TYPE_OTHER:
            return 2;
            break;
            
        default:
            return 0;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER:
        {
            return PERSONAL_INFO_CELL_HEIGHT;
            break;
        }
            
        case ME_SECTION_TYPE_MESSAGE:
        {
            return MORE_CELL_HEIGHT;
            break;
        }
            
        case ME_SECTION_TYPE_OTHER:
        {
            return MORE_CELL_HEIGHT;
            break;
        }
            
        default:
            break;
    }
    
    return MORE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case ME_SECTION_TYPE_HEADER:
            return 0;
        case ME_SECTION_TYPE_MESSAGE:
            return 0;
        case ME_SECTION_TYPE_OTHER:
            return 0;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER:
        {
            NSString *identifier = [NSString stringWithFormat:@"CIOPersonalInfoCell"];
            CIOPersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (needReLoad || !cell) {
                UserBaseInfo *baseInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
                cell = [[[CIOPersonalInfoCell alloc] initWithStyle:CellStyle_Header reId:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.accessoryView.backgroundColor = [UIColor blueColor];
                [cell.headerImage updateImage:baseInfo.portraitName withId:[AppManager instance].userId];
                //                cell.nameLabel.text =[NSString stringWithFormat:@"%@ %@", baseInfo.chName, baseInfo.enName];
                cell.nameLabel.text = baseInfo.chName;
                cell.titleLabel.text = @""; //baseInfo.position;
                cell.subTitLabel.text = baseInfo.company;
                needReLoad = NO;
            }
            
            return cell;
        }
            break;
            
        case ME_SECTION_TYPE_MESSAGE:
        {
            NSString *identifier = @"MyMessage";
            MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[[MyMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"communication_bar_message.png");
            cell.textLabel.text = @"私信";
            return cell;
        }
            
        case ME_SECTION_TYPE_OTHER:
        {
            NSString *identifier = @"MyMessageCell";
            MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[[MyMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            //            cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, 25, 31);
            
            switch (indexPath.row) {
                case ME_OTHER_CELL_CLEAR:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"release_cache.png");
                    cell.textLabel.text = @"清空缓存";
                    break;
                    
                case ME_OTHER_CELL_COLLECTION:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"me_collect.png");
                    cell.textLabel.text = @"收藏";
                    break;
                    
                case ME_OTHER_CELL_SHARE_INVITE:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"information_share.png");
                    cell.textLabel.text = @"分享与邀请";
                    break;
                    
                case ME_OTHER_CELL_VERSION:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"download_manager.png");
                    cell.textLabel.text = @"版本更新";
                    break;
                    
                case ME_OTHER_CELL_CONTACT:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"contact_us.png");
                    cell.textLabel.text = @"联系我们";
                    break;
                    
                case ME_OTHER_CELL_SYS_SETTING:
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"me_setting.png");
                    cell.textLabel.text = @"系统设置";
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ME_SECTION_TYPE_HEADER:
        {
            MyInfoViewController *myInfo = [[[MyInfoViewController alloc] initWithMOC:_MOC parentVC:nil viewHeight:0] autorelease];
            [CommonMethod pushViewController:myInfo withAnimated:YES];
        }
            break;
            
        case ME_SECTION_TYPE_MESSAGE:
        {
            CommunicationMessageListViewController *messageListController = [[CommunicationMessageListViewController alloc] initWithMOC:_MOC parentVC:self.parentVC];
            [CommonMethod pushViewController:messageListController withAnimated:YES];
        }
            break;
            
        case ME_SECTION_TYPE_OTHER:
        {
            switch (indexPath.row) {
                case ME_OTHER_CELL_CLEAR:
                {
                    CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                    [customeAlertView setMessage:@"您确定要清空所有缓存吗？"
                                           title:@"温馨提示"];
                    customeAlertView.tag = ALERT_TAG_CLEAR_CACHE;
                    customeAlertView.applyDelegate = self;
                    [customeAlertView show];
                }
                    break;
                    
                case ME_OTHER_CELL_VERSION:
                {
                    if ([AppManager instance].updateURL && ![[AppManager instance].updateURL isEqualToString:@""]) {
                        [CommonMethod update:[AppManager instance].updateURL];
                    } else {
                        [self loadVersion:TRIGGERED_BY_AUTOLOAD forNew:YES];
                    }
                    
                }
                    break;
                    
                case ME_OTHER_CELL_CONTACT:
                {
                    ContactUsViewController *contactUs = [[[ContactUsViewController alloc] init] autorelease];
                    [CommonMethod pushViewController:contactUs withAnimated:YES];
                }
                    break;
                    
                case ME_OTHER_CELL_COLLECTION:
                    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
                    break;
                    
                case ME_OTHER_CELL_SHARE_INVITE:
                    [self shareAndInvite];
                    break;
                    
                case ME_OTHER_CELL_SYS_SETTING:
                    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
                    
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}


- (void)shareAndInvite {
    UIActionSheet *as = [[[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil] autorelease];
    
    [as addButtonWithTitle:LocaleStringForKey(NSShareBySMSTitle, nil)];
    [as addButtonWithTitle:LocaleStringForKey(NSShareByWeixinTitle, nil)];
    [as addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
    as.cancelButtonIndex = [as numberOfButtons] - 1;
    
    [as showInView:self.view];
    
    
    _asOwnerType = SHARE_AS_TY;
}

#pragma mark - share app
- (void)shareBySMS {
    if (![MFMessageComposeViewController canSendText]) {
        ShowAlert(self,LocaleStringForKey(NSNoteTitle, nil), LocaleStringForKey(NSNoSupportTitle, nil), LocaleStringForKey(NSOKTitle, nil));
        return;
    }
    
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    controller.body = [AppManager instance].recommend;
    controller.recipients = @[NULL_PARAM_VALUE];
    controller.messageComposeDelegate = (id<MFMessageComposeViewControllerDelegate>)self;
    
    if (self.parentVC) {
        [self.parentVC.navigationController presentModalViewController:controller animated:YES];
    }
}

#pragma mark - action sheet delegate method
- (void)actionSheet:(UIActionSheet *)as clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (_asOwnerType) {
            
        case SHARE_AS_TY:
        {
            switch (buttonIndex) {
                case SHARE_SMS_AS_IDX:
                    [self shareBySMS];
                    break;
                    
                case SHARE_WX_AS_IDX:
                    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
                        
                        NSString *url = [NSString stringWithFormat:@"http://weixun.co/gohigh_test.html"];
                        
                        
                        BOOL reult = [CommonUtils shareByWeChat:WXSceneSession
                                                          title:LocaleStringForKey(NSAppRecommendTitle, nil)
                                                          image:[CommonMethod getAppIcon]
                                                    description:[AppManager instance].recommend
                                                            url:url];
                        
                        if (reult) {
                            DLog(@"share sucessfully");
                        }
                    } else {
                        UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@""
                                                                         message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"
                                                                        delegate:self
                                                               cancelButtonTitle:@"取消"
                                                               otherButtonTitles:@"免费下载微信", nil];
                        [alView show];
                        [alView release];
                    }
                    break;
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [self logout:nil];
}

- (void)logout:(UIButton *)sender {
    
    [[AppManager instance].userDefaults rememberUsername:[[AppManager instance].userDefaults usernameRemembered] andPassword:@""];
    
    // OA 登录
    [AppManager instance].OAUser = @"";
    [AppManager instance].OAPswd = @"";
    [[AppManager instance] saveOAUserInfoIntoLocal];
    
    [((BaseAppDelegate *)APP_DELEGATE) logout];
    
    // 重置 View Controller
    HomepageContainerViewController *homeVC = (HomepageContainerViewController *)self.parentVC;
    
#if APP_TYPE == APP_TYPE_FOSUN
    [homeVC showHomeView];
#else
    [homeVC selectHomepage];
#endif
    
    [homeVC clearAllViewController];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray {
    
    [alertView release];
    
    switch (alertView.tag) {
        case ALERT_TAG_CLEAR_CACHE:
            [self clearCache];
            break;
            
        case ALERT_TAG_UPDATE:
            [CommonMethod update:[AppManager instance].updateURL];
            break;
            
        default:
            break;
    }
}

- (void)clearCache {
    [self showAsyncLoadingView:@"正在清理..." blockCurrentView:YES];
    
    NSString *imagePath = [CommonMethod getLocalImageFolder];
    NSString *downloadPath = [CommonMethod getLocalDownloadFolder];
    
    if ([CommonMethod isExist:imagePath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:imagePath error:&err];
        [FileUtils  mkdir:[CommonMethod getLocalImageFolder]];
    }
    
    if ([CommonMethod isExist:downloadPath]) {
        NSError *err = nil;
        [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:&err];
        [FileUtils mkdir:[CommonMethod getLocalDownloadFolder]];
    }
    
    [[GoHighDBManager instance] dropTables:[CommonMethod tableNames]];
    
    // SDWebImageManager
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    [self closeAsyncLoadingView];
}

- (void)loadVersion:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_COMMON withApiName:API_NAME_GET_VERSION withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:LOAD_UPDATE_VERSION_TY];
    [connFacade fetchGets:url];
}

- (void)loadDataUserProfile
{
    NSLog(@"###### loadDataUserProfile #####");
    needReLoad = YES;
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    switch (contentType) {
            
        case LOAD_UPDATE_VERSION_TY:
        {
            
            NSDictionary *resultDic = [result objectFromJSONData];
            NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
            //            NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
            NSString *code = OBJ_FROM_DIC(resultDic, @"code");
            
            if ([code isEqualToString:@"200"]) {
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"目前已是最新版本!!"
                                       title:@"更新提示"];
                customeAlertView.tag=ALERT_TAG_UPDATE;
                customeAlertView.applyDelegate = self;
                [customeAlertView show];
            } else if ([code isEqualToString:@"220"]) {
                [AppManager instance].updateURL = OBJ_FROM_DIC(contentDic, @"updateUrl");
                
                CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_Default];
                [customeAlertView setMessage:@"有新版本发布， 需要更新吗？"
                                       title:@"温馨提示"];
                customeAlertView.applyDelegate = self;
                customeAlertView.tag=ALERT_TAG_UPDATE;
                [customeAlertView show];
            }
            
        }
            break;
            
        default:
            break;
    }
    
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

@end
