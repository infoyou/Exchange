//
//  CommunicationFriendListViewController.m
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationFriendListViewController.h"
#import "FriendListCell.h"
#import "CommunicationPersonalInfoViewController.h"
#import "GlobalConstants.h"
#import "CommonMethod.h"
#import "CommonHeader.h"
#import "MessageListCell.h"
#import "ChatListViewController.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "GlobalConstants.h"
#import "FirendUserListDataModal.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "GoHighDBManager.h"
#import "MJNIndexView.h"
#import "PYMethod.h"
#import "iChatInstance.h"

@interface CommunicationFriendListViewController ()<UITableViewDataSource, UITableViewDelegate, FriendListCellDelegate,MessageListCellDelegate,CommunicatChatViewControllerDelegate,MJNIndexViewDataSource>
{
    NSMutableDictionary *dataDic;
    NSArray *keys;
    NSMutableArray *_indexKeys;
}

@property (nonatomic, retain) UITableView *mainTable;
//UITableView索引搜索工具类
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

@property (nonatomic, retain) MJNIndexView *indexView;
@property (nonatomic, retain) NSMutableArray *allKeys;
@property (nonatomic, retain) NSMutableArray *keys;

@end

@implementation CommunicationFriendListViewController {
    
    UIBarButtonItem *_rightButton;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    
    if (self =  [super initWithMOC:MOC
             needRefreshHeaderView:YES
             needRefreshFooterView:YES]) {
        
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
    self.navigationItem.title = @"好友列表";
    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CGRect f = self.view.bounds;
    f.origin.y = ITEM_BASE_TOP_VIEW_HEIGHT ;
    f.size.height = _screenSize.height - SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT - 40;
    
//    _tableView.frame=f;
    
    
        _allKeys = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    _indexKeys = [[NSMutableArray alloc] init];
    _keys = [[NSMutableArray alloc] init];
    
    // initialise MJNIndexView
    _indexView = [[MJNIndexView alloc]initWithFrame:f];
    self.indexView.dataSource = self;
    [self firstAttributesForMJNIndexView];
    //    [self readAttributes];
    [self.view addSubview:self.indexView];
    [self.indexView refreshIndexItems];
    
//    [self initNavButton];
    
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [[iChatInstance instance] registerListener:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[iChatInstance instance] unRegisterListener:self];
}

- (void)dealloc {
    [_indexView release];
    [_allKeys release];
    [_indexKeys release];
    [_keys release];
    [_rightButton release];
//    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
      NSInteger sections = _tableView.numberOfSections;
    
    for (int i = 0; i < sections; ++i) {
         NSInteger rows =  [_tableView numberOfRowsInSection:i];
        
        for (int j = 0; j < rows; ++j) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            
            MessageListCell *cell = (MessageListCell *)[_tableView cellForRowAtIndexPath:indexPath];
            
            if (cell) {
                [cell setDeleteButtonHidden:YES];
            }
        }
    }
}

-(void)hiddenOtherCellDeleteButton
{
    [self viewTapped:nil];
}

- (void)firstAttributesForMJNIndexView
{
    
    self.indexView.getSelectedItemsAfterPanGestureIsFinished = YES;
    self.indexView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
    self.indexView.selectedItemFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
    self.indexView.backgroundColor = [UIColor clearColor];
    self.indexView.curtainColor = nil;
    self.indexView.curtainFade = 0.0;
    self.indexView.curtainStays = NO;
    self.indexView.curtainMoves = YES;
    self.indexView.curtainMargins = NO;
    self.indexView.ergonomicHeight = NO;
    self.indexView.upperMargin = 12.0;
    self.indexView.lowerMargin = 12.0;
    self.indexView.rightMargin = 8.0;
    self.indexView.itemsAligment = NSTextAlignmentCenter;
    self.indexView.maxItemDeflection = 0.0;
    self.indexView.rangeOfDeflection = 3;
    self.indexView.fontColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
    self.indexView.selectedItemFontColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    self.indexView.darkening = NO;
    self.indexView.fading = YES;
    
}


- (void)initUsers:(NSArray *)userArray;
{
    
    [_indexKeys removeAllObjects];
    [_keys removeAllObjects];
    
//    NSMutableArray *userArray = [[GoHighDBManager instance] getAllUserInfoFromDB];
    for (PrivateUserListDataModal *userList in userArray) {
        UserBaseInfo *baseInfo = [[GoHighDBManager instance] getUserInfoFromDB:[userList.userId integerValue] ];
        NSString * userName = baseInfo.chName;
        NSString *indexChar = [[PYMethod firstCharOfNamePinyin:userName] substringWithRange:NSMakeRange(0,1)];
        
        
        BOOL bFound = FALSE;
        if (indexChar)
        for (int j = 0; j < _keys.count; ++j) {
            NSMutableDictionary *dict = [_keys objectAtIndex:j];
            
            if ([[dict objectForKey:@"indexChar"] isEqualToString:indexChar]) {
                bFound = TRUE;
                DLog(@"%@:%@", [dict objectForKey:@"indexChar"], [dict objectForKey:@"valueList"]);
                
                if (baseInfo.userID != [[AppManager instance].userId integerValue]) {
                    NSMutableArray *valueList =[NSMutableArray arrayWithArray:[dict objectForKey:@"valueList"]];
                    
                    [valueList addObject:baseInfo];
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:indexChar forKey:@"indexChar"];
                    [dict setObject:valueList forKey:@"valueList"];
                    
                    
                    [_keys removeObjectAtIndex:j];
                    
                    [_keys addObject:dict];
                    [dict release];
                }
                
                break;
            }
        }
        
        if (!bFound && indexChar) {
            
            if (baseInfo.userID != [[AppManager instance].userId integerValue]) {
                NSMutableArray *valueList = [[NSMutableArray alloc] init];
                [valueList addObject:baseInfo];
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:indexChar forKey:@"indexChar"];
                [dict setObject:valueList forKey:@"valueList"];
                [valueList release];
                
                [_keys addObject:dict];
                [dict release];
            }
        }
        
    }
    
    //排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"indexChar" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [_keys sortUsingDescriptors:sortDescriptors];
    [sortDescriptor release];
    [sortDescriptors release];
    
    for (NSDictionary *dic in _keys) {
        NSString *key = [dic objectForKey:@"indexChar"];
        [_indexKeys addObject:key];
    }
    
}

- (void)initNavButton
{
    //---------------------------------
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 24,20);
    [rightButton addTarget: self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_detail.png"] forState:UIControlStateNormal];
    
    _rightButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    [rightButton release];
    
    [_rightButton setStyle:UIBarButtonItemStyleDone];
    
    self.navigationItem.rightBarButtonItem = _rightButton;
    
}


- (void)rightNavButtonClicked:(id)sender
{
//    CommunicationFriendListViewController *friendListController = [[[CommunicationFriendListViewController alloc] initWithMOC:_MOC] autorelease];
//    [CommonMethod pushViewController:friendListController withAnimated:YES];
}

#pragma mark MJMIndexForTableView datasource methods
- (NSArray *)sectionIndexTitlesForMJNIndexView:(MJNIndexView *)indexView
{
    //    [_allKeys insertObject:UITableViewIndexSearch atIndex:0];//等价于[arr addObject:UITableViewIndexSearch];
    return _allKeys;
}

- (void)sectionForSectionMJNIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([_indexKeys containsObject:_allKeys[index]]) {
        int i = [_indexKeys indexOfObject:_allKeys[index]];
        
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i] atScrollPosition: UITableViewScrollPositionTop animated:self.indexView.getSelectedItemsAfterPanGestureIsFinished];
    }
}
#pragma mark - uitableview delegate && datasource
#pragma mark - UITableViewDelegate, UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

        return _keys.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSArray *array = [dict objectForKey:@"valueList"];
        return [array count];

}

//- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
//    
//    return self.fetchedRC.fetchedObjects.count + 1;
//}

- (MessageListCell *)drawEventCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"reuse_cell_id";
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier imageDisplayerDelegate:self MOC:_MOC] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    NSDictionary *dict = [_keys objectAtIndex:indexPath.section];
    NSArray *array = [dict objectForKey:@"valueList"];
    UserBaseInfo *userInfo = (UserBaseInfo *)[array objectAtIndex:indexPath.row];
    
    for (PrivateUserListDataModal *dataModal in self.fetchedRC.fetchedObjects) {
        if ([dataModal.userId isEqualToNumber:NUMBER(userInfo.userID)]) {
            
            [cell updateItemInfo:dataModal withContext:_MOC];
            break;
        }
    }
    
//    PrivateUserListDataModal *dataModal = (PrivateUserListDataModal *)self.fetchedRC.fetchedObjects[indexPath.row];
    
    cell.delegate = self;
    //    [cell updateData:dataModal];
    
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

        
        NSDictionary *dict = [_keys objectAtIndex:section];
        return [dict objectForKey:@"indexChar"];

    
    return @"";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0,0 , tableView.frame.size.width, 20)] autorelease];
        view.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
        
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSString *indexChar = [dict objectForKey:@"indexChar"];
        
        UILabel *indexCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
        [indexCharLabel setText:indexChar];
        [indexCharLabel setTextColor:[UIColor whiteColor]];
        [indexCharLabel setBackgroundColor:TRANSPARENT_COLOR];
        [indexCharLabel setFont:FONT_BOLD_SYSTEM_SIZE(14)];
        
        [view addSubview:indexCharLabel];
        [indexCharLabel release];
    
        return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 20.0f;
}

//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

#pragma mark --  MessageListCellDelegate
- (void)getMemberInfo:(PrivateUserListDataModal *)dataModal
{
    
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:[dataModal.userId integerValue]  withDelegate:self  isFromChatVC:FALSE];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}


- (void)startToChat:(MessageListCell *)cell withDataModal:(PrivateUserListDataModal *)dataModal newMessageCount:(int)newMessageCount
//- (void)startToChat:(PrivateUserListDataModal *)dataModal
{
    ChatListViewController *vc = [[[ChatListViewController alloc] initWithPrivateData:dataModal  withType:CHAT_TYPE_PRIVATE MOC:_MOC] autorelease];
    vc.delegate = self;
    vc.newMessageCount = newMessageCount;
    [cell updateMessageCount:0];
    //    [[GoHighDBManager instance] setGroupMessageReaded:[dataModal.groupId stringValue]];
    [[GoHighDBManager instance] setPrivateMessageReaded:[dataModal.userId stringValue]];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

- (void)onReceiveMessage:(QPlusMessage *)message
{
    //群消息
    if (!message.isPrivate) {
        [_tableView reloadData];
        
    }
}


-(void)onDeleteGroupMesssage:(QPlusMessage *)message
{
    
}
#pragma mark --- delegate

- (void)deleteFriendUser:(int)userId
{
    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"FirendUserListDataModal"];
}


#pragma mark -- data
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_FRIEND_LETTER_USER_LIST_TY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    
    _currentType = GET_FRIEND_LETTER_USER_LIST_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_TYPE];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_GET_PRIVATE_LETTER_USER_LIST withCommon:  commonDict withSpecial:specialDict];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

#pragma mark -- data delegate

#pragma mark - ECConnectorDelegate methods


- (void)configureMOCFetchConditions {
    self.entityName = @"FirendUserListDataModal";
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
            
        case GET_FRIEND_LETTER_USER_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self fetchContentFromMOC];
                DLog(@"count:%d", self.fetchedRC.fetchedObjects.count);
                
                [self initUsers:self.fetchedRC.fetchedObjects];
                
                [[GoHighDBManager instance] updateIsFriend:self.fetchedRC.fetchedObjects];
                
                [_tableView reloadData];
                
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

#pragma mark -- delegate

- (void)deleteUserInfo:(PrivateUserListDataModal *)dataModal
{
    [self deleteFriendUser:[dataModal.userId integerValue]];
}

@end
