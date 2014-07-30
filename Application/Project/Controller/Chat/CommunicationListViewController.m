//
//  CommunicationListViewController.m
//  Project
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013å¹´ com.jit. All rights reserved.
//

#import "CommunicationListViewController.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "JSONKit.h"
#import "CommunicationListViewCell.h"
#import "CommunicatGroupMemberListViewController.h"
#import "ChatListViewController.h"
#import "CommonHeader.h"
#import "JSONParser.h"
#import "ChatAddGroupViewController.h"
#import "CommunicationUserSearchViewController.h"
#import "CommunicationMessageListViewController.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "GoHighDBManager.h"
#import "iChatInstance.h"
#import "CommonMethod.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "OffLineDBCacheManager.h"
#import "WXWDebugLogOutput.h"
#import "BaseAppDelegate.h"

@interface CommunicationListViewController () <CommunicatGroupBriefViewCellDelegate, UITableViewDataSource, UITableViewDelegate, CommunicatChatViewControllerDelegate, CommunicatGroupMemberListViewControllerDelegate,CommunicatAddGroupViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic, assign) NSMutableArray *groupInfoArray;

- (void) timerRefreshGroupList:(NSTimer*)timer;
- (void) notifierRefreshGroupList:(NSNotification*) notification;
@end

@implementation CommunicationListViewController {
    
    int _marginX;
    UIBarButtonItem *_leftButton;
    UIBarButtonItem *_rightButton;
    UIBarButtonItem *_privateButton;
    
    BOOL _isFirstLoad;
    NSMutableDictionary *_tableViewIsRefreshed;
    BOOL _searchResult;
    
    NSTimer* _timerRefreshGroupList;
}


@synthesize groupInfoArray = _groupInfoArray;


- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_timerRefreshGroupList invalidate];
    _timerRefreshGroupList = nil;
    
    [super dealloc];
}
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES];
    
    if (self) {
        
        self.parentVC = pVC;
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    _marginX = 0;
    
    _groupInfoArray = [[NSMutableArray alloc] init];
    _tableViewIsRefreshed = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    if ([WXWCommonUtils currentOSVersion] < IOS7)
    {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
#if APP_TYPE == APP_TYPE_O2O
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
#else
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
#endif
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - HOMEPAGE_TAB_HEIGHT/* - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT*/);
    
    if (SUCCESS_CODE == [OffLineDBCacheManager handleCommunicateGroupListDB:[AppManager instance].userId MOC:_MOC]) {
        [self refreshTable];
        [_tableView setAlpha:1.0f];
    }
    _isFirstLoad = YES;
    _tableView.tableHeaderView = [self searchBar];
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    //#endif
    
    if (_timerRefreshGroupList == nil) {
        _timerRefreshGroupList = [NSTimer scheduledTimerWithTimeInterval:[AppManager instance].checkInterval target:self selector:@selector(timerRefreshGroupList:) userInfo:nil repeats:YES];
    }
    [_timerRefreshGroupList fire];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteSuccessfulGroupFromNewCreate:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(quiteSuccessfulGroupFromNewCreate:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_QUIT_CHAT_GROUP
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifierRefreshGroupList:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP
                                               object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    if ([AppManager instance].isFromLogout) {
        
        _isFirstLoad = YES;
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
        
        [AppManager instance].isFromLogout = NO;
    }
    [[iChatInstance instance] registerListener:self];
    
    [self initNavButton];
    
    [self refreshTable];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hiddenNavButton];
    
    [[iChatInstance instance] unRegisterListener:self];
}

- (void)initNavButton
{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    leftButton.frame = CGRectMake(0, 0, 30, 30);
    [leftButton addTarget:self action: @selector(leftNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [leftButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_search.png"] forState:UIControlStateNormal];
    
    _leftButton=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    [leftButton release];
    
    [_leftButton setStyle:UIBarButtonItemStyleDone];
    
#if APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_FOSUN
#else
    self.parentVC.navigationItem.leftBarButtonItem = _leftButton;
#endif
    
    //---------------------------------
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 24, 24);
    [rightButton addTarget:self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_add.png"] forState:UIControlStateNormal];
    
    _rightButton = [[[UIBarButtonItem alloc] initWithCustomView:rightButton] autorelease];
    [_rightButton setStyle:UIBarButtonItemStyleDone];
    
    //---------------------------------
    UIButton *rightPrivateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightPrivateButton.frame = CGRectMake(0, 0, 27, 27);
    [rightPrivateButton addTarget:self action:@selector(rightMessageNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightPrivateButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_message.png"] forState:UIControlStateNormal];
    
    _privateButton=[[UIBarButtonItem alloc]initWithCustomView:rightPrivateButton];
    [rightPrivateButton release];
    
    [_privateButton setStyle:UIBarButtonItemStyleDone];
    //---------------------------
    //	self.parentVC.navigationItem.leftBarButtonItem = _leftButton;
    
#if APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_FOSUN
    self.parentVC.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:_rightButton,nil];
#else
    self.parentVC.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects: _rightButton, _privateButton, nil];
#endif
}

- (void)hiddenNavButton
{
    self.parentVC.navigationItem.leftBarButtonItem = nil;
    self.parentVC.navigationItem.rightBarButtonItems = nil;
}

- (void)configureMOCFetchConditions {
    self.entityName = @"ChatGroupDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = nil;
    
    NSSortDescriptor *dateDesc1 = [[[NSSortDescriptor alloc] initWithKey:@"groupType" ascending:NO] autorelease];
    NSSortDescriptor *dateDesc2 = [[[NSSortDescriptor alloc] initWithKey:@"lastMessageTime" ascending:NO] autorelease];
    NSSortDescriptor *dateDesc3 = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    
    
    [self.descriptors addObject:dateDesc1];
    [self.descriptors addObject:dateDesc2];
    [self.descriptors addObject:dateDesc3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) timerRefreshGroupList:(NSTimer *)timer {
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void) notifierRefreshGroupList:(NSNotification *)notification {
    if (_timerRefreshGroupList != nil) {
        [_timerRefreshGroupList fire];
    }
}

#define VALUE_API_CONTENT  @"%@/%@/%@?ReqContent=%@"
#define KEY_API_CONTENT  @"keyApiPrefix"


#pragma mark - load data
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [self loadListData:triggerType forNew:forNew criteria:nil];
}

- (void)loadListData:(LoadTriggerType)triggerType
              forNew:(BOOL)forNew
            criteria:(NSString *) criteria
{
    _searchResult = criteria != nil;
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = LOAD_COMMUNICATE_GROUP_LIST_TY;
    
    _reloading = NO;
    if (!forNew) {
        return;
    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    //    [dict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [dict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setValue:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setValue:@"2" forKey:KEY_API_PARAM_GROUP_TPE];
    if(criteria)
        [specialDict setValue:criteria forKey:@"keyword"];
    
    if (_isFirstLoad)
        [specialDict setObject:[CommonMethod convertLongTimeToString:0 ]  forKey:KEY_API_PARAM_START_TIME];
    else
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestCommunicateGroupListTime] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/chatgroupService/GetChatGroup?ReqContent=%@",VALUE_API_PREFIX, [dict JSONString]];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}


-(void)delayRefreshTableView
{
    [self refreshTable];
    
    debugLog(@"create message");
    QPlusMessage *message = [[[QPlusMessage alloc] init] autorelease];
    message.receiverID = @"-100";
    [self onReceiveMessage:message];
    
    [_tableView setAlpha:1.0f];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
//    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
    
    [AppManager instance].connectionStatus = NetworkConnectionStatusLoading;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NetworkConnectionStatusLoading], @"status", nil]];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_COMMUNICATE_GROUP_LIST_TY:
        {
            if(_searchResult) {
                self.entityName = @"ChatGroupDataModal";
                [WXWCoreDataUtils deleteEntitiesFromMOC:_MOC entityName:self.entityName predicate:nil];
                 [[GoHighDBManager instance] deleteAllGroupListData];
            }
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                //                _noNeedDisplayEmptyMsg = YES;
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                NSDictionary *content =OBJ_FROM_DIC(resultDic, @"content");
                if (_isFirstLoad){
                    [[GoHighDBManager instance] deleteAllGroupListData];
                }
                else{
                }
                [self refreshTable];
                
                [[GoHighDBManager instance] upinsertCommunicateGroupList:[AppManager instance].userId array:self.fetchedRC.fetchedObjects timestamp:timestamp MOC:_MOC];
                
                _isFirstLoad = NO;
                
                [self performSelector:@selector(delayRefreshTableView) withObject:nil afterDelay:0.1f];
                
                [AppManager instance].connectionStatus = NetworkConnectionStatusOn;
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NetworkConnectionStatusOn], @"status", nil]];
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
    
    [AppManager instance].connectionStatus = NetworkConnectionStatusOff;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"status", nil]];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [AppManager instance].connectionStatus = NetworkConnectionStatusOff;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"status", nil]];
    
    [super connectFailed:error url:url contentType:contentType];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return self.fetchedRC.fetchedObjects.count;
}

- (CommunicationListViewCell *)drawChatListCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    NSString *kEventCellIdentifier = @"CommunicationListViewCell";
    CommunicationListViewCell *cell = (CommunicationListViewCell *)[tableView dequeueReusableCellWithIdentifier:kEventCellIdentifier];
    
//    if (nil == cell) {
        cell = [[[CommunicationListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventCellIdentifier] autorelease];
        cell.delegate = self;
//}
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    ChatGroupDataModal *groupData = (ChatGroupDataModal *)[self.fetchedRC objectAtIndexPath:indexPath];
    [cell updateGroupName:groupData.groupName];
    [cell updateMessageCount:[[GoHighDBManager instance] getGroupNewMessageCount:[groupData.groupId stringValue] userId:[AppManager instance].userId]];
        DLog(@"groupId:%@", groupData.groupId);
        ChatModel *dataModel = [[GoHighDBManager instance] getGroupLastMessage:[NSString stringWithFormat:@"%d", [groupData.groupId integerValue]]];
        
        DLog(@"groupId:%@", dataModel.senderID);
        groupData.lastMessageTime = dataModel.date;
        
        [cell updateCellInfo:groupData chatModel:dataModel];
    
    return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        return [self drawChatListCell:tableView indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK + COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT);
}

- (void)getMemberList:(ChatGroupDataModal *)dataModal
{
    //    CommunicatGroupMemberListViewController *vc = [[[CommunicatGroupMemberListViewController alloc] initWithDataModal:dataModal] autorelease];
    CommunicatGroupMemberListViewController *vc = [[[CommunicatGroupMemberListViewController alloc] initWithMOC:_MOC parentVC:self.parentVC withDataModal:dataModal] autorelease];
    vc.delegate = self;
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

- (void)startToChat:(CommunicationListViewCell *)cell withDataModal:(ChatGroupDataModal *)dataModal newMessageCount:(int)newMessageCount
{
    ChatListViewController *vc = [[[ChatListViewController alloc] initWithData:dataModal withType:CHAT_TYPE_GROUP MOC:_MOC] autorelease];
    vc.delegate = self;
    vc.newMessageCount = newMessageCount;
    [cell updateMessageCount:0];
    [[GoHighDBManager instance] setGroupMessageReaded:[dataModal.groupId stringValue]];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

#pragma mark -- group message delegate

- (void)updateGroupMessageInfo:(QPlusMessage *)message
{
    
}

- (void) leftNavButtonClicked:(id)sender
{
    CommunicationUserSearchViewController *userSearchController = [[[CommunicationUserSearchViewController alloc] init] autorelease];
    [CommonMethod pushViewController:userSearchController withAnimated:YES];
}

- (void) rightNavButtonClicked:(id)sender
{
    
//    UserBaseInfo *userBaseInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
//    
//    if (userBaseInfo) {
//        ChatAddGroupViewController *addGroupVC =  [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:self.parentVC userList:[NSArray arrayWithObject:userBaseInfo] groupInfo:nil type:CHAT_GROUP_TYPE_INFO_CREATE] autorelease];
//        addGroupVC.delegate = self;
//        [CommonMethod pushViewController:addGroupVC withAnimated:YES];
//    } else {
        ChatAddGroupViewController *addGroupVC =  [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:self.parentVC groupInfo:nil type:CHAT_GROUP_TYPE_INFO_CREATE] autorelease];
        addGroupVC.delegate = self;
        [CommonMethod pushViewController:addGroupVC withAnimated:YES];
//    }
}

- (void) rightMessageNavButtonClicked:(id)sender
{
    
    CommunicationMessageListViewController *messageListController = [[CommunicationMessageListViewController alloc] initWithMOC:_MOC parentVC:self.parentVC];
    [CommonMethod pushViewController:messageListController withAnimated:YES];
    
}


#pragma mark -- ichat

- (void)onReceiveMessage:(QPlusMessage *)message
{
    //ç¾¤æ¶æ¯
    
    //    [_tableView reloadData];
    
    BOOL bFoundGroup = FALSE;
    
    for (int i = 0; i < self.fetchedRC.fetchedObjects.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CommunicationListViewCell *cell = (CommunicationListViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            ChatGroupDataModal *groupData = [cell getGroupDataModal];
            
            if (groupData) {
                
                ChatModel *dataModel = [[GoHighDBManager instance] getGroupLastMessage:[NSString stringWithFormat:@"%d", [groupData.groupId integerValue] ]];
                if (message.receiverID.integerValue == groupData.groupId.integerValue) {
                    
                    [cell updateMessageCount:[[GoHighDBManager instance] getGroupNewMessageCount:[groupData.groupId stringValue] userId:[AppManager instance].userId]];
                    groupData.lastMessageTime = dataModel.date;
                    bFoundGroup = TRUE;
                    break;
                }
            }
        }else{
            ChatGroupDataModal *groupData = [self.fetchedRC.fetchedObjects objectAtIndex:i];
            
            if (groupData) {
                if (groupData.groupId.integerValue == message.receiverID.integerValue) {
                    
                    ChatModel *dataModel = [[GoHighDBManager instance] getGroupLastMessage:[NSString stringWithFormat:@"%d", [groupData.groupId integerValue] ]];
                    if (message.receiverID.integerValue == groupData.groupId.integerValue) {
                        
                        cell =  (CommunicationListViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
                        
                        [cell updateMessageCount:[[GoHighDBManager instance] getGroupNewMessageCount:[groupData.groupId stringValue] userId:[AppManager instance].userId]];
                        groupData.lastMessageTime = dataModel.date;
                        bFoundGroup = TRUE;
                        break;
                    }
                }
            }
            
            
        }
        
    }
    
    if (!bFoundGroup && ![message.receiverID isEqualToString:@"-100"]) {
        [self refreshGroupList];
    }
    
    [self refreshTable];
    
}


-(void)onDeleteGroupMesssage:(QPlusMessage *)message
{
    //    message.text = LocaleStringForKey(NSGroupDeleted, nil);
    [self onReceiveMessage:message];
}
-(void)reloadGroupList
{
    self.entityName = @"ChatGroupDataModal";
    [WXWCoreDataUtils deleteEntitiesFromMOC:_MOC entityName:self.entityName predicate:nil];
    
    if (SUCCESS_CODE == [OffLineDBCacheManager handleCommunicateGroupListDB:[AppManager instance].userId MOC:_MOC]) {
        [self refreshTable];
        [_tableView setAlpha:1.0f];
    }
    
}

#pragma mark -- CommunicatGroupMemberListViewControllerDelegate
-(void)deleteSuccessfulGroupFromNewCreate:(NSNotification *)note
{
    
    NSNumber *groupId = [[note userInfo] objectForKey:@"groupId"];
    [[GoHighDBManager instance] deleteGroup:[groupId integerValue]];
    
    [self reloadGroupList];
}


-(void)quiteSuccessfulGroupFromNewCreate:(NSNotification *)note
{
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

-(void)deleteSuccessfulGroup:(int)groupId
{
    [[GoHighDBManager instance] deleteGroup:groupId];
    
    [self reloadGroupList];
    
    if (!self.fetchedRC.fetchedObjects.count) {
        [self displayEmptyMessage];
        
        _tableView.alpha = 1.0f;
    }
}

-(void)removeUserFromGroup:(ChatGroupDataModal *)dataModal userId:(int)userId
{
    
}

-(void)refreshGroupList
{
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

#pragma mark - searchBar delegate
- (UISearchBar *)searchBar {
    //    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectZero/*CGRectMake(0, 0, self.view.frame.size.width, SEARCH_VIEW_HEIGHT)*/] autorelease];
    UISearchBar * _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width - 20, 40)] autorelease];
    _searchBar.delegate = self;
    [_searchBar setBarStyle:UIBarStyleDefault];
    
    //    [_searchBar setBarTintColor:[UIColor clearColor]];
    if ([CommonMethod is7System])
        [_searchBar setTintColor:[UIColor colorWithHexString:@"0xe64125"]];
    _searchBar.placeholder = @"请输入群名称或群成员搜索";
    [_searchBar setSearchFieldBackgroundImage:ImageWithName(@"information_list_searchbar_bg.png") forState:UIControlStateNormal];
    [_searchBar setImage:ImageWithName(@"information_list_search_logo") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([CommonMethod is7System]) {
        [_searchBar setBackgroundImage:ImageWithName(@"information_list_searchview_bg.png")
                        forBarPosition:UIBarPositionAny
                            barMetrics:UIBarMetricsDefault];
    }else {
        [_searchBar setBackgroundImage:ImageWithName(@"information_list_searchview_bg.png")];
        
    }
    
    [_searchBar sizeToFit];
    
    return _searchBar;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = NO;
    [searchBar sizeToFit];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    if(searchBar.text.length > 0) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES criteria:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    if(_searchResult) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
}
@end
