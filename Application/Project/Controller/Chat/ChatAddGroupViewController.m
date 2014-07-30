//
//  ChatAddGroupViewController.m
//  Project
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChatAddGroupViewController.h"
#import "AddGroupFriendListCell.h"
#import "AddGroupSelectedFriendListCell.h"
#import "ProjectAPI.h"
#import "pinyin.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "HomepageContainerViewController.h"
#import "AppManager.h"
#import "PYMethod.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "TextPool.h"
#import "CustomeAlertView.h"
#import "ChatListViewController.h"
#import "MJNIndexView.h"
#import "GoHighDBManager.h"
#import "WXWCoreDataUtils.h"
#import "WXWDebugLogOutput.h"


#define SEARCH_VIEW_HEIGHT      40.f
#define NAVIGATION_TITLE        @"人员列表"

@interface ChatAddGroupViewController ()<UITableViewDataSource, UITableViewDelegate, AddGroupFriendListCellDelegate, AddGroupSelectedFriendListCellDelegate,WXWImageDisplayerDelegate,UISearchBarDelegate, MJNIndexViewDataSource, UITextFieldDelegate>
{
    NSMutableDictionary *dataDic;
    NSMutableArray *_indexKeys;
    HomepageContainerViewController *_parentVC;
    
    NSInteger _indexOfSearchPage;
    NSInteger _countPerSearchPage;
}

//UITableView索引搜索工具类
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

// MJNIndexView
@property (nonatomic, retain) MJNIndexView *indexView;
@property (nonatomic, retain) NSMutableArray *allKeys;

@property (nonatomic, retain) NSArray *allUsers;
@property (nonatomic, retain) NSArray *memberList;
@property (nonatomic, retain) NSMutableArray *keys;
@property (nonatomic, assign) NSMutableArray *selectedUserArray;
@property (nonatomic, assign) NSMutableArray *selectedUserCellArray;
@property (nonatomic, retain) NSMutableArray* arraySearchResult;

//@property (nonatomic, copy) NSString *keywords;


@end

@implementation ChatAddGroupViewController {
    UITableView *_selectedUserTableView;
    NSArray *_userList;
    UIButton *_selectedButton;
    UITextField *_searchField1, *_searchField2;
    UIButton *_searchButton;
    
    ChatGroupDataModal *_dataModal;
    enum CHAT_GROUP_TYPE_INFO _type;
    
    UISearchBar *_searchBar;
    NSInteger _groupId;
    NSInteger _oldUserCount;
    BOOL _selfUserInfoIsNull;
}

@synthesize memberList = _memberList;
@synthesize keys = _keys;
@synthesize selectedUserArray = _selectedUserArray;
@synthesize selectedUserCellArray = _selectedUserCellArray;
@synthesize delegate = _delegate;


- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
             type:(enum CHAT_GROUP_TYPE_INFO)type
{
    if (self = [super initWithMOC:MOC]) {
        _type = type;
    }
    
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
         userList:(NSArray *)userLis
        groupInfo:(ChatGroupDataModal *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type
{
    if (self = [self
                initWithMOC:MOC parentVC:pVC type:type]) {
        
        _type = type;
        self.parentVC = pVC;
        
        _userList = [userLis retain];
        _dataModal = [dataModal retain];
        _groupId = [dataModal.groupId integerValue];
        
    }
    return  self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
        groupInfo:(ChatGroupDataModal *)dataModal
             type:(enum CHAT_GROUP_TYPE_INFO)type
{
    if (self =[super initWithMOC:MOC
           needRefreshHeaderView:NO
           needRefreshFooterView:YES])
    {
        _selfUserInfoIsNull = TRUE;
        _type = type;
        self.parentVC = pVC;
        _dataModal = [dataModal retain];
        _groupId = [dataModal.groupId integerValue];
        
//        [self loadDataUserProfile:0];
//        [self loadDataUserProfile];
    }
    return  self;
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    
    _indexOfSearchPage++;
    [self loadDataUserProfileWithCriteria:_searchBar.text];
}

- (void)loadDataUserProfile:(NSTimeInterval )timerInterval
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_ALLUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:timerInterval / 1000] forKey:KEY_API_PARAM_START_TIME];
    //    [specialDict setObject:[CommonMethod convertLongTimeToString:0 forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    
    [connFacade fetchGets:url];
}


- (void)loadDataUserProfileWithCriteria:(NSString *) criteria
{
    NSMutableDictionary *specialDict = [[NSMutableDictionary alloc]init];
    [specialDict setObject:NUMBER(INVOKETYPE_ALLUSERINFO) forKey:KEY_API_INVOKETYPE];
    
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    

    [specialDict setObject:[CommonMethod convertLongTimeToString:NSTimeIntervalSince1970 / 1000] forKey:KEY_API_PARAM_START_TIME];
    //    [specialDict setObject:[CommonMethod convertLongTimeToString:0 forKey:KEY_API_PARAM_START_TIME];
    
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    if (criteria) {
        [specialDict setValue:criteria forKey:@"keyword"];
        [specialDict setValue:[NSNumber numberWithInteger:_countPerSearchPage] forKey:@"pageSize"];
        [specialDict setValue:[NSNumber numberWithInteger:_indexOfSearchPage] forKey:@"pageNo"];
    }
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_USER withApiName:API_NAME_USER_PROFILE withCommon:[AppManager instance].common withSpecial:specialDict];
    [specialDict release];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:GET_USER_PROFILES];
    
    [connFacade fetchGets:url];
}

- (void)updateSelectedUserList:(NSArray *)userList
{
    _userList = userList;
    [_selectedUserArray removeAllObjects];
    
    _oldUserCount = [_userList count];
    
    //keys section
    for (int section = 0; section < _keys.count; ++section) {
        
        NSDictionary *dict = [_keys objectAtIndex:section];
        NSMutableArray *array = [dict objectForKey:@"valueList"];
        //
        for (int i = 0; i < array.count;  ++i) {
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            
            
            AddGroupFriendListCell *cell = (AddGroupFriendListCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            
            UserBaseInfo *profile = [cell getUserProfile];
            
            for (int j = 0; j < userList.count; ++j) {
                UserBaseInfo *selectedUser = (UserBaseInfo *)[userList objectAtIndex:j];
                
                if (profile.userID == selectedUser.userID) {
                    [self addGroupFriendListCell:cell withUserProfile:profile];
                    break;
                }
            }
        }
    }
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

    [_keys release];
    [_arraySearchResult release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = NAVIGATION_TITLE;
    _tableView.alpha = 1.0f;
    
    [self initSelectedTableView:self.view];
    
    _memberList =  [AppManager instance].userDM.userProfiles;
    [self initData];
    [self addTableView];
//    [self initUsers];
    [self addSearchView];
    
    BOOL existed = NO;
    UserBaseInfo* currentInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
    
    if (_userList) {
        for (UserProfile* profile in _userList) {
            if (currentInfo.userID == profile.userID) {
                existed = YES;
            }
            [_selectedUserArray addObject:[CommonMethod userBaseInfoWithDictUserProfile:profile]];
        }
    }
    
    if (!existed) {
        [_selectedUserArray insertObject:currentInfo atIndex:0];
    }
    
    [_tableView reloadData];
//    [self.indexView refreshIndexItems];
    
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), [_selectedUserArray count]]  forState:UIControlStateNormal];
    
    _indexOfSearchPage = 1;
    _countPerSearchPage = 20;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //[self updateSelectedUserList:_userList];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {

    _allKeys = [[NSMutableArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    _indexKeys = [[NSMutableArray alloc] init];
    _keys = [[NSMutableArray alloc] init];
    _selectedUserArray = [[NSMutableArray alloc] init];
    _selectedUserCellArray = [[NSMutableArray alloc] init];
    _arraySearchResult = [[NSMutableArray alloc] init];
}

- (void)initUsers
{
#if 0
    for (int i = 0; i < _memberList.count; ++i) {
        UserProfile *profile = [_memberList objectAtIndex:i];
        UserBaseInfo *baseInfo = [CommonMethod userBaseInfoWithUserProfile:profile];
        
        NSArray *userInfoArray = (NSArray *) baseInfo.groups;
        
        if (userInfoArray  && userInfoArray.count) {
            
            UserProperty *value =(UserProperty *) [userInfoArray objectAtIndex:0];
            
            NSArray *values = value.values;
            
            NSString * userName = values[1];
            
//            NSString *indexChar = [[PYMethod firstCharOfNamePinyin:userName] substringWithRange:NSMakeRange(0,1)];
            NSString *indexChar = baseInfo.firstChar;
            
            BOOL bFound = FALSE;
            for (int j = 0; j < _keys.count; ++j) {
                NSMutableDictionary *dict = [_keys objectAtIndex:j];
                
                if ([[dict objectForKey:@"indexChar"] isEqualToString:indexChar]) {
                    bFound = TRUE;
                    DLog(@"%@:%@", [dict objectForKey:@"indexChar"], [dict objectForKey:@"valueList"]);
                    
                    if (profile.userID != [[AppManager instance].userId integerValue]) {
                        NSMutableArray *valueList =[NSMutableArray arrayWithArray:[dict objectForKey:@"valueList"]];
                        
                        [valueList addObject:profile];
                        
                        
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:indexChar forKey:@"indexChar"];
                        [dict setObject:valueList forKey:@"valueList"];
                        
                        
                        [_keys removeObjectAtIndex:j];
                        
                        [_keys addObject:dict];
                    }
                    
                    break;
                }
            }
            
            if (!bFound) {
                
                if (profile.userID != [[AppManager instance].userId integerValue]) {
                    NSMutableArray *valueList = [[NSMutableArray alloc] init];
                    [valueList addObject:profile];
                    
                    
                    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                    [dict setObject:indexChar forKey:@"indexChar"];
                    [dict setObject:valueList forKey:@"valueList"];
                    [_keys addObject:dict];
                }
            }
        }
        
        //-------------------------对用户section 进行排序-------------------------
    }
    
    for (NSDictionary *dic in _keys) {
        NSString *key = [dic objectForKey:@"indexChar"];
        [_indexKeys addObject:key];
    }
    
#else
    
    self.allUsers = [[GoHighDBManager instance] getAllUserInfoFromDB];
    [self parserUserData:self.allUsers];
#endif
}

- (void)parserUserData:(NSArray *)array {
    
    [_keys removeAllObjects];

    for (UserBaseInfo *baseInfo in array) {
        NSString * userName = baseInfo.chName;
//        NSString *indexChar = [[PYMethod firstCharOfNamePinyin:userName] substringWithRange:NSMakeRange(0,1)];
        NSString *indexChar = baseInfo.firstChar;
        
        BOOL bFound = FALSE;
        if (indexChar) {
            for (int j = 0; j < _keys.count; ++j) {
                NSMutableDictionary *dict = [_keys objectAtIndex:j];
                
                if ([[dict objectForKey:@"indexChar"] isEqualToString:indexChar]) {
                    bFound = TRUE;
                    //DLog(@"%@:%@", [dict objectForKey:@"indexChar"], [dict objectForKey:@"valueList"]);
                    
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
            
            if (!bFound) {
                
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

- (void)initSelectedTableView:(UIView *)parentView
{
    int buttonWidth = 60;
    int marginX = 5;
    
    int width = _screenSize.width;
    int height = 40;
    int startX = 0;
    int startY = _screenSize.height -  height - SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT;
    
    
    UIView *buttomView = [[[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)] autorelease];
    buttomView.backgroundColor = [UIColor colorWithHexString:@"0xdbdbdb"];
    
    
    [parentView addSubview:buttomView];
    
    _selectedUserTableView = [[UITableView alloc] initWithFrame:CGRectMake(-10, 0, height - 5, width - buttonWidth - 2*marginX - 10) style:UITableViewStylePlain];
    _selectedUserTableView.delegate = self;
    _selectedUserTableView.dataSource = self;
    
    _selectedUserTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _selectedUserTableView.transform =  CGAffineTransformMakeRotation(-M_PI / 2);
    _selectedUserTableView.showsVerticalScrollIndicator = NO;
    _selectedUserTableView.center = CGPointMake((buttomView.frame.size.width - buttonWidth - marginX) / 2.0f, buttomView.frame.size.height / 2);
    
    [buttomView addSubview:_selectedUserTableView];
    
    _selectedUserTableView.backgroundColor = TRANSPARENT_COLOR;
    
    //-----------------------------
    startX = _selectedUserTableView.frame.origin.x + _selectedUserTableView.frame.size.width + marginX;
    height -= 10;
    startY = (buttomView.frame.size.height - height) / 2.0f;
    _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectedButton.frame = CGRectMake(startX, startY, buttonWidth, height);
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), [_selectedUserArray count]]  forState:UIControlStateNormal];
    [_selectedButton.titleLabel setFont:FONT_SYSTEM_SIZE(12)];
    [_selectedButton setTitleColor:[UIColor colorWithHexString:@"0x585149"] forState:UIControlStateNormal];
    
    
    [_selectedButton setBackgroundImage:[CommonMethod drawImageToRect:IMAGE_WITH_IMAGE_NAME(@"communication_group_add_ok_button.png") withRegionRect:CGRectMake(0, 0, buttonWidth, height - 5)] forState:UIControlStateNormal];
    [_selectedButton addTarget:self action:@selector(submitJoinChatGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttomView addSubview:_selectedButton];
}


- (void)addTableView {
    
    CGRect f = self.view.bounds;
    f.origin.y = ITEM_BASE_TOP_VIEW_HEIGHT + SEARCH_VIEW_HEIGHT;
    f.size.height = _screenSize.height /*- SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT*/ - 40 - SEARCH_VIEW_HEIGHT;
    
    _tableView.frame = f;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.tableHeaderView = [self searchBar];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    // initialise MJNIndexView
//    f.size.height -= SYS_STATUS_BAR_HEIGHT + NAVIGATION_BAR_HEIGHT;
//    _indexView = [[MJNIndexView alloc] initWithFrame:f];
//    self.indexView.dataSource = self;
//    [self firstAttributesForMJNIndexView];
//    //    [self readAttributes];
//    [self.view addSubview:self.indexView];
//    [self.indexView refreshIndexItems];
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

#pragma mark - tableview delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_tableView == tableView) {
        return 1;
    }else if (_selectedUserTableView == tableView) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_tableView == tableView) {
        return [_arraySearchResult count] + (([_arraySearchResult count] == 0) ? 0 : 1);
    }else if (_selectedUserTableView == tableView) {
        return [_selectedUserArray count] + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tableView == tableView) {
        return ADD_GROUP_FRIEND_LIST_CELL_HEIGHT;
    } else if (_selectedUserTableView == tableView) {
        return 35;
    }
    
    return 0.0f;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (_tableView == tableView) {
//        
//        NSDictionary *dict = [_keys objectAtIndex:section];
//        return [dict objectForKey:@"indexChar"];
//    } else if (_selectedUserTableView == tableView) {
//        return @"";
//    }
//    
//    return @"";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (_tableView == tableView) {
//        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0,0 , tableView.frame.size.width, 20)] autorelease];
//        view.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
//        
//        NSDictionary *dict = [_keys objectAtIndex:section];
//        NSString *indexChar = [dict objectForKey:@"indexChar"];
//        
//        UILabel *indexCharLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 20)];
//        [indexCharLabel setText:indexChar];
//        [indexCharLabel setTextColor:[UIColor whiteColor]];
//        [indexCharLabel setBackgroundColor:TRANSPARENT_COLOR];
//        [indexCharLabel setFont:FONT_BOLD_SYSTEM_SIZE(14)];
//        
//        [view addSubview:indexCharLabel];
//        [indexCharLabel release];
//        
//        return view;
//    }
//    
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (_tableView == tableView) {
//        return 20.0f;
//    }
//    
//    return 0.0f;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
        if (_tableView == tableView) {
            
            if (indexPath.row == [_arraySearchResult count]) {
                return [self drawFooterCell];
            } else {
                
                NSString *identifier = [NSString stringWithFormat:@"AddGroupFriendListCell_%d_%d", indexPath.row, indexPath.section];
                AddGroupFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                
                if (!cell) {
                    
                    UserBaseInfo *userInfo = (UserBaseInfo *)[_arraySearchResult objectAtIndex:indexPath.row];
                    
                    BOOL isLastCell = ([_arraySearchResult count] - 1 == indexPath.row);
                    BOOL checked = FALSE;
                    BOOL enable = TRUE;
                    DLog(@"%d", _selectedUserCellArray.count);
                    
                    for (int i = 0; i < _selectedUserArray.count; ++i) {
                        UserBaseInfo *checkedUserProfile = (UserBaseInfo *)[_selectedUserArray objectAtIndex:i];
                        if (checkedUserProfile.userID == userInfo.userID) {
                            checked = YES;
                            break;
                        }
                    }
                    
                    cell = [[AddGroupFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withUserInfoArray:userInfo withIsLastCell:isLastCell withChecked:checked withEnable:enable  imageDisplayerDelegate:self MOC:_MOC];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.delegate = self;
                    
                    DLog(@"userCell:%@", cell);
                } else {
                    
                    for (UIView *view in [cell subviews]) {
                        [view removeFromSuperview];
                    }
                    [cell release];
                    cell = nil;
                
                UserBaseInfo *userInfo = (UserBaseInfo *)[_arraySearchResult objectAtIndex:indexPath.row];
                
                BOOL isLastCell = ([_arraySearchResult count] - 1 == indexPath.row);
                BOOL checked = FALSE;
                BOOL enable = TRUE;
                DLog(@"%d", _selectedUserCellArray.count);
                
                BOOL bFound = FALSE;
                for (int i = 0; i < _selectedUserArray.count; ++i) {
                    UserBaseInfo *checkedUserProfile = (UserBaseInfo *)[_selectedUserArray objectAtIndex:i];
                    
                    if (checkedUserProfile.userID == userInfo.userID) {
                        checked = YES;
                        break;
                    }
                }
                
                if (!bFound) {
                    enable = TRUE;
                }
                cell = [[AddGroupFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier withUserInfoArray:userInfo withIsLastCell:isLastCell withChecked:checked withEnable:enable  imageDisplayerDelegate:self MOC:_MOC];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
                return cell;
            }
            
            return nil;
    } else if (_selectedUserTableView == tableView) {
        static NSString *identifier = @"AddGroupSelectedFriendListCell";
        AddGroupSelectedFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        int index = indexPath.row;
        
        if (cell == nil) {
            cell = [[[AddGroupSelectedFriendListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier  withRect:CGRectMake(0, 0, 35, 35) imageDisplayerDelegate:self MOC:_MOC] autorelease];
            
            cell.transform = CGAffineTransformMakeRotation(M_PI / 2);;
            cell.delegate = self;
        }
        
        
        if (indexPath.row == _selectedUserArray.count){
            [cell updateUserProfile:nil withUserProfile:nil withDefault:TRUE] ;
        }
        else  {
//            UserBaseInfo *userProfile = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
            UserBaseInfo* userProfile = [_selectedUserArray objectAtIndex:index];
            [cell updateUserProfile:nil withUserProfile:userProfile withDefault:TRUE];
        }
        /*
        else{
            
            BOOL isChecked= FALSE;
            
            for (int i = 0; i < _userList.count; ++i) {
                
                UserBaseInfo *user=(UserBaseInfo *) [_selectedUserArray objectAtIndex:index - 1];
//                UserProfile *selectedUserProfile = (UserProfile *)[_userList objectAtIndex:i];
                UserBaseInfo *userBaseInfo = (UserBaseInfo *)[_userList objectAtIndex:i];
                if (user.userID == userBaseInfo.userID) {
                    isChecked = TRUE;
                }
            }
            
//            [cell updateUserProfile: [_selectedUserCellArray objectAtIndex:index - 1] withUserProfile: [_selectedUserArray objectAtIndex:index - 1] withDefault:isChecked];
        }
         */
        return cell;
    }
    
    return nil;
}


#pragma mark - cell delegate

- (void)addGroupFriendListCell:(AddGroupFriendListCell *)cell withUserProfile:(UserBaseInfo *)userProfile
{
    [_selectedUserArray addObject:userProfile];
    [_selectedUserCellArray addObject:cell];
    [_selectedUserTableView reloadData];
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), [_selectedUserArray count]] forState:UIControlStateNormal];
}

- (void)deleteGroupFriendListCell:(AddGroupFriendListCell *)cell withUserProfile:(UserBaseInfo *)userProfile
{
    
    for (int i = 0; i < _selectedUserArray.count; ++i) {
        UserBaseInfo *profile = [_selectedUserArray objectAtIndex:i];
        if (profile.userID == userProfile.userID) {
            [cell setChecked:NO];
            [_selectedUserArray removeObjectAtIndex:i];
//            [_selectedUserCellArray removeObjectAtIndex:i];
            
            break;
        }
    }
    
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@(%d)", LocaleStringForKey(NSSureTitle, nil), [_selectedUserArray count]]  forState:UIControlStateNormal];
    [_selectedUserTableView reloadData];
//    [_mainTable reloadData];
    [self.indexView refreshIndexItems];
}

- (void)avataTapped:(AddGroupFriendListCell *)friendListCell withUserProfile:(UserBaseInfo *)userProfile{
    [friendListCell setChecked:FALSE];
    [self deleteGroupFriendListCell:friendListCell withUserProfile:userProfile];
}

- (void)submitJoinChatGroupButtonClicked:(id)sender
{
    
    [self getGroupInfo:_groupId];
    if (_type == CHAT_GROUP_TYPE_INFO_MODIFY)
        [self loadJoinChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
    else if(_type == CHAT_GROUP_TYPE_INFO_CREATE)
        [self loadCreateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP object:nil userInfo:nil];
}

-(void)getGroupInfo:(int)groupId
{
    self.entityName = @"ChatGroupDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = [NSPredicate predicateWithFormat:@"groupId == %d",groupId];
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (self.fetchedRC.fetchedObjects.count) {
        _dataModal = [self.fetchedRC.fetchedObjects objectAtIndex:0];
    }
    
}

#pragma mark - load data
- (void)loadGroupFrieldList:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    _currentType = GET_CHAT_GROUP_LIST_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    
    [specialDict setValue:@"2" forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setValue:@"1" forKey:KEY_API_PARAM_PAGE_NO];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_GET_CHAT_GROUP_USER withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

- (void)loadJoinChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    NSMutableArray *selectedUserArray = [NSMutableArray array];
    for (int i = 0; i < _selectedUserArray.count; ++i) {
        UserProfile *user = [_selectedUserArray objectAtIndex:i];
        [selectedUserArray addObject:NUMBER(user.userID)];
    }
    
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[selectedUserArray componentsJoinedByString:@","] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_JOIN_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_JOING_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}


- (void)loadCreateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSMutableArray *selectedUserArray = [NSMutableArray array];
    NSMutableArray *selectedUserNameArray = [NSMutableArray array];
//
//    UserBaseInfo *selfInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
//    
//    [selectedUserArray addObject:NUMBER(selfInfo.userID)];
//    [selectedUserNameArray addObject:selfInfo.chName];
    
    
    for (int i = 0; i < _selectedUserArray.count; ++i) {
        UserBaseInfo *user = [_selectedUserArray objectAtIndex:i];
        [selectedUserArray addObject:NUMBER(user.userID)];
        [selectedUserNameArray addObject:user.chName];
    }
    
    NSString *groupName =[selectedUserNameArray componentsJoinedByString:@","];
    if (groupName.length > GROUP_PROPERTY_MAX_COUNT_NAME) {
        groupName = [groupName substringToIndex:GROUP_PROPERTY_MAX_COUNT_NAME];
    }
    
    [specialDict setObject:groupName forKey:KEY_API_PARAM_GROUP_NAME];
    [specialDict setObject:[selectedUserArray componentsJoinedByString:@","] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_CREATE_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_CREAT_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

- (void)CustomeAlertViewDismiss:(CustomeAlertView *)alertView {
    [alertView release];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(int)getChatGroupId:(NSDictionary *)dic
{
    NSDictionary *contentDic = OBJ_FROM_DIC(dic, @"content");
    NSLog(@"dic: %@", contentDic);
    
    NSArray *videos = OBJ_FROM_DIC(contentDic, @"groupList");
    for (NSDictionary *dic in videos) {
        return  INT_VALUE_FROM_DIC(dic, @"groupId");
    }
    
    return -1;
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
//    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [self startLoadingTitle];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    
    
    switch (contentType) {
            
        case GET_USER_PROFILES:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
           
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                
                if (contentDict != nil) {
                    
                    if (_indexOfSearchPage == 1) {
                        [_arraySearchResult removeAllObjects];
                    }
                    
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    if (![userListArr isEqual:[NSNull null]] && [userListArr count] > 0) {
                        [self removeEmptyMessageIfNeeded];
                        for (NSInteger i = 0; i < userListArr.count; i++) {
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];

                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParam:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            [_arraySearchResult addObject:[CommonMethod userBaseInfoWithDictUserProfile:userProfile]];
                        }
                    } else {
                        if ([_arraySearchResult count] == 0) {
                            [self displayEmptyMessage];
                        } else {
                            [self setFooterRefreshViewStatus:PULL_FOOTER_NO_RESULT];
                        }
                    }
                    
                }
                [_selectedUserTableView reloadData];
                [_tableView reloadData];
            }
            break;
        }
            
        case GET_CHAT_GROUP_LIST_TY:
        {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                //                self.entityName = @"InformationList";
                //                NSDictionary *resultDic = [result objectFromJSONData];
                //
                //                NSDictionary *contentDic = OBJ_FROM_DIC(resultDic, @"content");
                //
                //                NSArray *list = OBJ_FROM_DIC(contentDic, @"list1");
            }
            
            break;
        }
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep0Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                    [_delegate refreshGroupList];
//                    int a = 0;
                }
                
                NSInteger countUsers = [_userList count];
                NSInteger countSelected = [_selectedUserArray count];
                if (countSelected > countUsers) {
                    NSArray* array = [_selectedUserArray subarrayWithRange:NSMakeRange(countUsers, countSelected - countUsers)];
                    
                    NSMutableString* users = [[NSMutableString alloc] init];
                    for (UserBaseInfo* info in array) {
                        [users appendFormat:@"%@, ", info.chName];
                    }
                    
                    UserBaseInfo* currentInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
                    for (UIViewController* viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[ChatListViewController class]]) {
                            [((ChatListViewController*)viewController) sendTextMsg:MESSAGE_INVITED_GROUP(currentInfo.chName, users)];
                            break;
                        }
                    }
                    [users release];
                }
                
//                [self backToRootViewController:nil];
//                [self back:nil];
                
            }else if (ret == GROUP_NEED_AUDIT_JOIN) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep1Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }else if (ret == GROUP_APPLY_JOINED) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep2Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(userListChanged:)]) {
                [_delegate userListChanged:TRUE];
            }
            [self back:nil];
            break;
        }
            
        case SUBMIT_CREAT_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                ret = [JSONParser parserResponseJsonData:result
                                                    type:LOAD_COMMUNICATE_GROUP_LIST_TY
                                                     MOC:_MOC
                                       connectorDelegate:self
                                                     url:url
                                                 paramID:0];
                //创建群组成功
                if (ret == SUCCESS_CODE) {
                    [self fetchContentFromMOC];
                    
                    NSInteger chatGroupId = [self getChatGroupId:[result objectFromJSONData]];
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                        [_delegate refreshGroupList];
                        //                    int a = 0;
                    }
                    
                    for (ChatGroupDataModal *dataModal in self.fetchedRC.fetchedObjects) {
                        if ([dataModal.groupId integerValue] == chatGroupId) {
                            
                            ChatListViewController *vc = [[[ChatListViewController alloc] initWithData:dataModal  withType:CHAT_TYPE_GROUP MOC:_MOC fromCreate:YES] autorelease];
                            
                            [CommonMethod pushViewController:vc withAnimated:YES];

                            if ([_selectedUserArray count] > 1) {
                                UserBaseInfo* currentInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
                                [vc sendTextMsg:MESSAGE_CREATE_GROUP(currentInfo.chName)];
                            }
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP
                                                                                object:nil
                                                                              userInfo:nil];
                            
                            break;
                        }
                    }
                }
                
            } else  {
                [WXWUIUtils showNotificationOnTopWithMsg:[NSString stringWithFormat:@"%@%d", LocaleStringForKey(NSICcreateGroupFailedMsg, nil), ret]
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];                
            }
            break;
        }
            
        default:
            break;
    }
    
    _noNeedDisplayEmptyMsg = YES;
    
    [self resetTitle:NAVIGATION_TITLE];
    if ([self getFooterRefreshViewStatus] != PULL_FOOTER_NO_RESULT) {
        [super connectDone:result
                       url:url
               contentType:contentType];
    }
    
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [self resetTitle:NAVIGATION_TITLE];
    
    [super connectCancelled:url contentType:contentType];
    
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [self resetTitle:NAVIGATION_TITLE];
    
    [super connectFailed:error url:url contentType:contentType];
}


- (void)configureMOCFetchConditions {
    self.entityName = @"ChatGroupDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = nil;
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
}

- (void)saveDisplayedImage:(UIImage *)image
{
    
}

- (void)registerImageUrl:(NSString *)url
{
    
}

#pragma mark - searchbar

- (UISearchBar *)searchBar {
    //    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectZero/*CGRectMake(0, 0, self.view.frame.size.width, SEARCH_VIEW_HEIGHT)*/] autorelease];
    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, _screenSize.width - 20, SEARCH_VIEW_HEIGHT)] autorelease];
    _searchBar.delegate = self;
    [_searchBar setBarStyle:UIBarStyleDefault];
    
    //    [_searchBar setBarTintColor:[UIColor clearColor]];
     if ([CommonMethod is7System])
    [_searchBar setTintColor:[UIColor colorWithHexString:@"0xe64125"]];
    _searchBar.placeholder = @"请输入姓名、部门或职位查找人";
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


#pragma mark - Search Delegate

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    
    
    return YES;
}

#pragma mark - searchBar delegate

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
        _indexOfSearchPage = 1;
        [self loadDataUserProfileWithCriteria:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    //    [_searchedCategoryArray removeAllObjects];
    //    for (NSDictionary *dict in _categoryArray) {
    //        [_searchedCategoryArray addObject:dict];
    //    }
    //
    //    [_tableView reloadData];
    
}

- (void) addSearchView
{
    /*UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SEARCH_VIEW_HEIGHT)];
    _searchField1 = [[[UITextField alloc] initWithFrame:CGRectMake(10, 25, 120, 30)] autorelease];
    _searchField2 = [[[UITextField alloc] initWithFrame:CGRectMake(140, 25, 120, 30)] autorelease];
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(270, 25, 40, 30);
    [_searchButton addTarget:self action:@selector(handleSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    _searchField1.placeholder = @"姓名";
    _searchField2.placeholder = @"职位或部门";
    _searchField1.backgroundColor = COLOR(240, 240, 240);//[UIColor col];
    _searchField2.backgroundColor = COLOR(240, 240, 240);
    _searchField1.delegate = self;
    _searchField2.delegate = self;
    _searchField1.returnKeyType = UIReturnKeyDone;
    _searchField2.returnKeyType = UIReturnKeyDone;
    [searchView addSubview:_searchField1];
    [searchView addSubview:_searchField2];
    [searchView addSubview:_searchButton];
    [self.view addSubview:searchView];*/
    UISearchBar *searchView = [self searchBar];
    [self.view addSubview:searchView];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void) handleSearchAction:(id) sender
{
}
@end
