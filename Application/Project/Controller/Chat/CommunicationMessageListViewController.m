//
//  MessageListViewController.m
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationMessageListViewController.h"
#import "MessageListCell.h"
#import "CommunicationFriendListViewController.h"
#import "NSDate+JITIOSLib.h"
#import "UIColor+expanded.h"
#import "CommunicationPersonalInfoViewController.h"
#import "ChatListViewController.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "PrivateUserListDataModal.h"
#import "WXWCoreDataUtils.h"
#import "GoHighDBManager.h"
#import "iChatInstance.h"
#import "ChatAddGroupViewController.h"
#import "OffLineDBCacheManager.h"

@interface CommunicationMessageListViewController ()<UITableViewDataSource, UITableViewDelegate,MessageListCellDelegate,CommunicatChatViewControllerDelegate>

@end

@implementation CommunicationMessageListViewController {
    
    UIBarButtonItem *_rightButton;
    int _lastUserId;
}


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {

    
    if (self =  [super initWithMOC:MOC
             needRefreshHeaderView:YES
             needRefreshFooterView:NO]) {
        
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
    self.navigationItem.title = @"私信";
    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    
    [self initNavButton];
    _tableView.alpha = 1.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"PrivateUserListDataModal", nil];
    [[GoHighDBManager instance] deleteEntity:array MOC:_MOC];
    
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [[iChatInstance instance] registerListener:self];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[iChatInstance instance] unRegisterListener:self];
    [super viewDidDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    for (int i = 0; i < self.fetchedRC.fetchedObjects.count; ++i) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
//        MessageListCell *cell =
//       (MessageListCell *) [self tableView:_tableView cellForRowAtIndexPath:indexPath];
        
        MessageListCell *cell = (MessageListCell *) [_tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            [cell setDeleteButtonHidden:YES];
        }
    }
}

- (void)initNavButton
{
    //---------------------------------
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 25,25);
    [rightButton addTarget: self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"communication_messageList_rightBarButton.png"] forState:UIControlStateNormal];
    
    _rightButton=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    [rightButton release];
    
    [_rightButton setStyle:UIBarButtonItemStyleDone];
    
    self.navigationItem.rightBarButtonItem = _rightButton;
    
}


- (void)rightNavButtonClicked:(id)sender
{
#if 1
    CommunicationFriendListViewController *friendListController = [[[CommunicationFriendListViewController alloc] initWithMOC:_MOC parentVC:self.parentVC] autorelease];
    [CommonMethod pushViewController:friendListController withAnimated:YES];
#elif 1
    ChatAddGroupViewController *addGroupVC = [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:nil userList:_groupMemberList groupInfo:_dataModal type:CHAT_GROUP_TYPE_FRIEND_LIST] autorelease];
    addGroupVC.delegate = self;
    [CommonMethod pushViewController:addGroupVC withAnimated:YES];
#endif
}

#pragma mark - uitableview delegate && datasource
#pragma mark - UITableViewDelegate, UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d", self.fetchedRC.fetchedObjects.count);
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (MessageListCell *)drawEventCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"reuse_cell_id";
    
    DLog(@"%d", indexPath.row);
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier imageDisplayerDelegate:self MOC:_MOC] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    PrivateUserListDataModal *dataModal = (PrivateUserListDataModal *)[self.fetchedRC.fetchedObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"displayIndex" ascending:YES]]][indexPath.row];
    [cell setDeleteButtonHidden:YES];
    
//    [cell updateData:dataModal];
    [cell updateItemInfo:dataModal withContext:_MOC];
    
    [cell updateMessageCount:[[GoHighDBManager instance] getPrivateNewMessageCount:[dataModal.userId stringValue] userId:[AppManager instance].userId]];
    
    return cell;

}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        
        return [self drawEventCell:tableView indexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return COMMUNICATION_GROUP_BRIEF_VIEW_HEIGHT_BK + COMMUNICATION_GROUP_BRIEF_VIEW_BOTTOM_HEIGHT;
}


#pragma mark --  MessageListCellDelegate
- (void)getMemberInfo:(PrivateUserListDataModal *)dataModal
{   
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:[dataModal.userId integerValue]  withDelegate:self isFromChatVC:FALSE];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

- (void)startToChat:(MessageListCell *)cell withDataModal:(PrivateUserListDataModal *)dataModal newMessageCount:(int)newMessageCount
//- (void)startToChat:(PrivateUserListDataModal *)dataModal
{
    ChatListViewController *vc = [[[ChatListViewController alloc] initWithPrivateData:dataModal withType:CHAT_TYPE_PRIVATE MOC:_MOC] autorelease];
    vc.delegate = self;
    vc.newMessageCount = newMessageCount;
    [cell updateMessageCount:0];
//    [[GoHighDBManager instance] setGroupMessageReaded:[dataModal.groupId stringValue]];
    [[GoHighDBManager instance] setPrivateMessageReaded:[dataModal.userId stringValue]];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

//- (void)onReceiveMessage:(QPlusMessage *)message
//{
//    //群消息
//    if (!message.isPrivate) {
//        [_tableView reloadData];
//        
//    }
//}

#pragma mark -- data
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_PRIVATE_LETTER_USER_LIST_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    _currentType = GET_PRIVATE_LETTER_USER_LIST_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(0) forKey:KEY_API_PARAM_TYPE];
    
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_GET_PRIVATE_LETTER_USER_LIST withCommon:  commonDict withSpecial:specialDict];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];

}

#pragma mark -- data delegate
-(void)removePrivateUserFromEntityWithUserId:(int)userId
{
    NSString *entityName = @"PrivateUserListDataModal";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId =%d", userId ];
    
    [WXWCoreDataUtils deleteEntitiesFromMOC:_MOC entityName:entityName predicate:predicate];
    
    [self refreshTable];
}

-(void)isShowEmptyBackground
{
    if (!self.fetchedRC.fetchedObjects.count) {
       [self displayEmptyMessage];
    }
}

#pragma mark - ECConnectorDelegate methods


- (void)configureMOCFetchConditions {
    self.entityName = @"PrivateUserListDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = nil;
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
}


- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case GET_PRIVATE_LETTER_USER_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self refreshTable];
            }
            break;
        }
            
        case SUBMIT_PRIVETE_LETTER_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:[CommonMethod getInstance].MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self removePrivateUserFromEntityWithUserId:_lastUserId];
                [self isShowEmptyBackground];
                _lastUserId = 0;
                [WXWUIUtils showNotificationOnTopWithMsg:@"操作成功"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            //            [self back:nil];
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


- (void)loadSubmitPrivateLetter:(LoadTriggerType)triggerType forNew:(BOOL)forNew type:(enum FRIEND_TYPE)type userId:(int)userId
{
    _currentType = SUBMIT_PRIVETE_LETTER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(userId) forKey:KEY_API_PARAM_USERID];
    [specialDict setObject:NUMBER(type) forKey:KEY_API_PARAM_TYPE];
    
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_SUBMIT_PRIVATE_LETTER];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
    
}



#pragma mark -- MessageListCellDelegate
- (void)deleteUserInfo:(PrivateUserListDataModal *)dataModal
{
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(userId = %d)", [dataModal.userId integerValue]];    
//    [WXWCoreDataUtils unLoadObject:_MOC predicate:predicate entityName:@"PrivateUserListDataModal"];
    
    
    _lastUserId =[dataModal.userId integerValue];
    [self loadSubmitPrivateLetter:TRIGGERED_BY_AUTOLOAD forNew:YES type:FRIEND_TYPE_PRIVATE_DELETE userId:_lastUserId];

}


-(void)hiddenOtherCellDeleteButton
{
    [self viewTapped:nil];
}

#pragma mark -- 

- (void)onReceiveMessage:(QPlusMessage *)message
{
    BOOL bFoundGroup = FALSE;

    for (int i = 0; i < self.fetchedRC.fetchedObjects.count; ++i) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        MessageListCell *cell = (MessageListCell *)[_tableView cellForRowAtIndexPath:indexPath];
        
        if (cell) {
            PrivateUserListDataModal *privateUserData = [cell getPrivateUserListDataModal];
            
            if (privateUserData) {
                if (privateUserData.userId.integerValue == message.senderID.integerValue) {
                    
                    bFoundGroup = TRUE;
                    break;
                }
            }
        }else{
            PrivateUserListDataModal *privateUserData = [cell getPrivateUserListDataModal];
            
            if (privateUserData) {
                
                if (privateUserData.userId.integerValue == message.senderID.integerValue) {
                    bFoundGroup = TRUE;
                    break;
                }
            }
        
        }
    }
    
    if (!bFoundGroup) {
        [OffLineDBCacheManager handlePrivateUserListDataModal:message.senderID MOC:_MOC] ;
//        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
        _noNeedDisplayEmptyMsg = YES;
        [self refreshTable];
        _tableView.alpha = 1.0f;
        
        [self clearEmptyMessage];
        
    }else{
        [_tableView reloadData];
    }
}



-(void)onDeleteGroupMesssage:(QPlusMessage *)message
{
    
}
@end
