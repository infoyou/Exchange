//
//  BizListViewController.m
//  Project
//
//  Created by XXX on 13-12-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BizListViewController.h"
#import "InformationListCell.h"
#import "TradeInformationContentViewController.h"
#import "CommonUtils.h"
#import "JSONParser.h"
#import "Post.h"
#import "JSONKit.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "OffLineDBCacheManager.h"
#import "GoHighDBManager.h"
#import "WXWLabel.h"
#import "BizListCell.h"
#import "PopupView.h"
#import "WXWNavigationController.h"
#import "BizComposerViewController.h"
#import "ECItemUploaderDelegate.h"
#import "UIUtils.h"
#import "SupplyDemandItemViewController.h"

#define SEARCH_VIEW_HEIGHT 48.f
#define SEARCH_BG_HEIGHT  30.f
#define SEARCH_TEXTFIELD_HEIGHT 30.f

#define MARGIN_LEFT  21.f
#define MARGIN_RIGHT 16.f

#define SEARCH_LOGO_WIDTH  16.f
#define SEARCH_LOGO_HEIGHT 17.f

#define SEARCHBAR_HEIGHT  40.0f
#define BOTTOM_TOOL_HEIGHT          45.0f

#define BIZ_CELL_HEIGHT         102.0f

enum {
    ALL_SD_TY = 0,
    S_TY = SUPPLY_POST_TY,
    D_TY = DEMAND_POST_TY,
    LIKED_SD_TY,
    MY_SD_TY,
};

@interface BizListViewController ()<UISearchBarDelegate, ECItemUploaderDelegate> {
    
    BOOL isSearched;
    NSInteger _filterType;
    BOOL _autoLoadAfterSent;
    BOOL _clearButtonClicked;
    UIView *_bottomToolbar;
    BOOL _needAdjustForiOS7;
    BOOL _returnFromComposer;
    BOOL _needRefresh;
    BOOL _selectedFeedBeDeleted;
}

@property (nonatomic, retain) UIView *searchbackgroundView;
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *keywords;

@end

@implementation BizListViewController {
    int _countBeforeSearch;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES];
    if (self) {
        
        self.parentVC = pVC;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectedFeedBeDeleted)
                                                     name:POST_DELETED_NOTIFY
                                                   object:nil];
    }
    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
#if APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY
    self.navigationItem.title = @"商机与合作";
#endif
    
    [self addRightBarButtonWithTitle:LocaleStringForKey(NSFilterTitle, nil)
                              target:self
                              action:@selector(doFilter:)];
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    [self initSearchBar];
    
    [self initBottomToolbar];
    
    _tableView.tableHeaderView = self.searchBar;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {

    self.searchbackgroundView = nil;
    self.keywords = nil;
    self.searchBar.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:POST_DELETED_NOTIFY
                                                  object:nil];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_autoLoaded) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    if (_needRefresh) {
        self.fetchedRC = nil;
        DELETE_OBJS_FROM_MOC(_MOC, @"Post", nil);
        [self refreshTable];
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    if (!_selectedFeedBeDeleted) {
        [self updateLastSelectedCell];
    } else {
        [self deleteLastSelectedCell];
    }
}

#pragma mark - lifecycle methods

- (void)initBottomToolbar {
    
    CGFloat y = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - BOTTOM_TOOL_HEIGHT;
    if ([CommonUtils screenHeightIs4Inch]) {
        y = self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - BOTTOM_TOOL_HEIGHT - SYS_STATUS_BAR_HEIGHT;
    }
    
    _bottomToolbar = [[[UIView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, BOTTOM_TOOL_HEIGHT)] autorelease];
    _bottomToolbar.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.7f];
    [self.view addSubview:_bottomToolbar];
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(sendSupplyDemand:)] autorelease];
    [_bottomToolbar addGestureRecognizer:tapGesture];
    
//    UIView *topLine = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomToolbar.frame.size.width, 2.0f)] autorelease];
//    topLine.backgroundColor = [UIColor colorWithHexString:STYLE_BLUE_COLOR];
//    [_bottomToolbar addSubview:topLine];
    
    UIImageView *icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fabu.png"]] autorelease];
    icon.frame = CGRectMake(0, 0, _bottomToolbar.frame.size.width, BOTTOM_TOOL_HEIGHT);
    [_bottomToolbar addSubview:icon];
    
    /*
    WXWLabel *label = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                             textColor:[UIColor whiteColor]
                                           shadowColor:TRANSPARENT_COLOR
                                                  font:BOLD_FONT(15)] autorelease];
    [_bottomToolbar addSubview:label];
    
    label.text = LocaleStringForKey(NSPublishSupplyDemandTitle, nil);
    CGSize size = [label.text sizeWithFont:label.font];
    
    CGFloat width = icon.frame.size.width + MARGIN + size.width;
    
    icon.frame = CGRectMake((_bottomToolbar.frame.size.width - width)/2.0f, (_bottomToolbar.frame.size.height - icon.frame.size.height)/2.0f, icon.frame.size.width, icon.frame.size.height);
    label.frame = CGRectMake(icon.frame.origin.x + icon.frame.size.width + MARGIN, (_bottomToolbar.frame.size.height - size.height)/2.0f, size.width, size.height);
    */
    
    _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y,
                                  _tableView.frame.size.width, _tableView.frame.size.height - BOTTOM_TOOL_HEIGHT);
}

- (void)initSearchBar {
    
    self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectZero] autorelease];
    self.searchBar.delegate = self;
    //    [self.searchBar setBarStyle:UIBarStyleDefault];
    
    [self.searchBar setTintColor:[UIColor colorWithHexString:STYLE_BLUE_COLOR]];
    self.searchBar.placeholder = @"输入商机与合作标题或关键字";
    
    [self.searchBar setSearchFieldBackgroundImage:ImageWithName(@"information_list_searchbar_bg.png") forState:UIControlStateNormal];
    [self.searchBar setImage:ImageWithName(@"information_list_search_logo") forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    if ([CommonMethod is7System]) {
        [self.searchBar setBackgroundImage:ImageWithName(@"information_list_searchview_bg.png")
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    }else {
        [self.searchBar setBackgroundImage:ImageWithName(@"information_list_searchview_bg.png")];
        
    }
    
    [self.searchBar sizeToFit];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_BIZ_POST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self refreshTable];
                _autoLoaded = YES;
                
                if (_autoLoadAfterSent) {
                    _autoLoadAfterSent = NO;
                }
                
            } else {
                [UIUtils showNotificationOnTopWithMsg:(self.errorMsgDic)[url]
                                       alternativeMsg:LocaleStringForKey(NSLoadSupplyDemandFailedMsg, nil)
                                              msgType:ERROR_TY
                                   belowNavigationBar:YES];
            }
            
            [self resetUIElementsForConnectDoneOrFailed];
            
            if (_userFirstUseThisList) {
                _userFirstUseThisList = NO;
            }
            
            break;
        }
            
        default:
            break;
    }
    
    if (isSearched) {
        _noNeedDisplayEmptyMsg = YES;
        isSearched = YES;
    }else {
        _noNeedDisplayEmptyMsg = NO;
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

-(NSPredicate*) getPredicatePredicate
{
    if(_filterType == ALL_SD_TY) {
        return [NSPredicate predicateWithFormat:@"(groupId == %@)", [AppManager instance].supplyDemandGroupId];
    } else if(_filterType == MY_SD_TY) {
        return [NSPredicate predicateWithFormat:@"(groupId == %@) && (userId == %@)", [AppManager instance].supplyDemandGroupId, [AppManager instance].userId];
    } else if(_filterType == S_TY) {
        return [NSPredicate predicateWithFormat:@"(groupId == %@) && (postType == %d)", [AppManager instance].supplyDemandGroupId, S_TY];
    } else if(_filterType == D_TY) {
        return [NSPredicate predicateWithFormat:@"(groupId == %@) && (postType == %d)", [AppManager instance].supplyDemandGroupId, D_TY];
    } else if(_filterType == LIKED_SD_TY) {
        return [NSPredicate predicateWithFormat:@"(groupId == %@) && (attentionType == %d)", [AppManager instance].supplyDemandGroupId, 1];
    }
    
    return nil;
}

- (void)configureMOCFetchConditions {
    
    self.entityName = @"Post";
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] autorelease];
    [self.descriptors addObject:descriptor];
//    if(self.keywords != nil && self.keywords.length>0){
//        self.predicate = [NSPredicate predicateWithFormat:@"(content like '%@') || (tagNames like '%@')", self.keywords, self.keywords];
//    } else {
        self.predicate = nil;
//    }
}

#pragma mark - tableview delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d", self.fetchedRC.fetchedObjects.count);
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return BIZ_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        
        static NSString *infoIdentifier = @"BizCell";
        
        BizListCell *cell = (BizListCell *)[tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        
        if (!cell) {
            cell = [[[BizListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoIdentifier] autorelease];
            cell.backgroundColor = TRANSPARENT_COLOR;
        }
        
        Post *post = (Post *)[self.fetchedRC objectAtIndexPath:indexPath];
        [cell updateCell:post];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    /*
    Post *item = self.fetchedRC.fetchedObjects[indexPath.row];
    SupplyDemandItemViewController *supplyDemandItemVC = [[[SupplyDemandItemViewController alloc] initMOC:_MOC
                                                                                                     item:item
                                                                                                   target:self
                                                                                    triggerRrefreshAction:@selector(setRefreshFlag)] autorelease];
    [self.navigationController pushViewController:supplyDemandItemVC animated:YES];
     */
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    if (_clearButtonClicked) {
        
        // user click the clear button, the clear the search bar text and reload
        // list for all supply and demand items
        
        _clearButtonClicked = NO;
        [_searchBar resignFirstResponder];
        
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
        return;
    }
    
    self.searchbackgroundView = [[[UIView alloc] initWithFrame:CGRectMake(0, SEARCHBAR_HEIGHT + 4, self.view.frame.size.width, self.view.frame.size.height - SEARCHBAR_HEIGHT)] autorelease];
    self.searchbackgroundView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    
//    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                  action:@selector(doCancelSearch:)] autorelease];
//    [self.searchbackgroundView addGestureRecognizer:tapGesture];
    
    [self.view addSubview:self.searchbackgroundView];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.searchbackgroundView.alpha = 0.8f;
                     }];
    
    [_searchBar setShowsCancelButton:YES animated:YES];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.keywords = searchText;
    
    if (self.keywords.length == 0) {
        self.keywords = nil;
        _filterType = ALL_SD_TY;
        [self searchWithKeywords];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self disableSearchStatus];
    self.keywords = nil;
    _filterType = ALL_SD_TY;
    [self searchWithKeywords];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self disableSearchStatus];
    
    [self searchWithKeywords];
}

#pragma mark - load data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    [super loadListData:triggerType forNew:forNew];
    
    NSString* displayIndexLast = nil;
    NSString* timeStamp = nil;
    
    if(_fetchedRC.fetchedObjects.count>0 && forNew == NO)
    {
        Post *post = [_fetchedRC objectAtIndexPath:[NSIndexPath indexPathForRow:_fetchedRC.fetchedObjects.count-1 inSection:0]];
        displayIndexLast = [NSString stringWithFormat:@"%d", post.order.intValue];
        timeStamp = post.timestamp;
    } else {
        displayIndexLast = @"";
        timeStamp = @"0";
    }

   _currentType = LOAD_BIZ_POST_TY;
    
    [AppManager instance].supplyDemandGroupId = @"";
    
    NSMutableDictionary *paramDict = [[[NSMutableDictionary alloc] initWithDictionary:
                                       @{@"page":@"0",
                                         @"pageSize":@"10",
                                         @"groupId":[AppManager instance].supplyDemandGroupId,
//                                         @"userId":[AppManager instance].userId,
                                         @"orderType":@"1",
                                         @"timestamp":timeStamp,
                                         @"displayIndexLast":displayIndexLast}] autorelease];
    
    if(_filterType == S_TY) {
        [paramDict setObject:SEND_POST_SUPPLY forKey:@"postType"];
    } else if(_filterType == D_TY) {
        [paramDict setObject:SEND_POST_DEMAND forKey:@"postType"];
    } else if(_filterType == LIKED_SD_TY) {
//        [paramDict setObject:@"1" forKey:@"attentionType"];
        [paramDict setObject:[AppManager instance].userId forKey:@"userId"];
    }
    
    if(self.keywords != nil) {
        [paramDict setObject:self.keywords forKey:@"keywords"];
    }

    NSString *url = [CommonUtils geneJSONUrl:paramDict itemType:_currentType];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
     _needRefresh = NO;
}

#pragma mark - arrange search bar
- (void)disableSearchStatus {
    
    if (self.searchbackgroundView.alpha > 0.0f && _searchBar.isFirstResponder) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             self.searchbackgroundView.alpha = 0.0f;
                         }
                         completion:^(BOOL finished){
                             [self.searchbackgroundView removeFromSuperview];
                         }];
        
        [_searchBar resignFirstResponder];
        
        [_searchBar setShowsCancelButton:NO animated:YES];
    }  
}

#pragma mark - filter
- (void)resetKeywordSearchElements {
    _searchBar.text = nil;
    self.keywords = NULL_PARAM_VALUE;
}

- (void)selectFilter:(NSNumber *)filterType {
    _filterType = filterType.intValue;
    
    [self resetKeywordSearchElements];
    
    DELETE_OBJS_FROM_MOC(_MOC, @"Post", nil);
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)doFilter:(id)sender {
    
    [self disableSearchStatus];
    
    PopupView *popupView = [[[PopupView alloc] initWithDelegate:self
                                                selectionAction:@selector(selectFilter:)] autorelease];
    
    NSDictionary *dic = @{@(ALL_SD_TY):LocaleStringForKey(NSAllTitle, nil),
                          @(S_TY):LocaleStringForKey(NSSupplyLongTitle, nil),
                          @(D_TY):LocaleStringForKey(NSDemandLongTitle, nil),
                          @(LIKED_SD_TY):LocaleStringForKey(NSFollowedTitle, nil),
                          @(MY_SD_TY):LocaleStringForKey(NSMySupplyDemandTitle, nil)};
    [popupView presentFromFrame:CGRectMake(SCREEN_WIDTH - 50, 20, 50, 44)
                      optionDic:dic
           currentSelectedIndex:_filterType];
}

- (void)clearSupplyDemandItems {
    DELETE_OBJS_FROM_MOC(_MOC, @"Post", nil);
}

#pragma mark - keyword search
- (void)searchWithKeywords {
    
    [self clearSupplyDemandItems];
    
    [self refreshTable];
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)sendSupplyDemand:(UITapGestureRecognizer *)tapGesture {
    
//    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    
    BizComposerViewController *composerVC = [[[BizComposerViewController alloc] initWithMOC:_MOC uploadDelegate:self] autorelease];
    composerVC.title = LocaleStringForKey(NSPublishSupplyDemandTitle, nil);
    
    WXWNavigationController *nav = [[[WXWNavigationController alloc] initWithRootViewController:composerVC] autorelease];
    
    nav.title = LocaleStringForKey(NSPublishSupplyDemandTitle, nil);
    
    [self.navigationController presentModalViewController:nav animated:YES];
    
    _autoLoaded = NO;
    _filterType = ALL_SD_TY;
}

#pragma mark - ECItemUploaderDelegate methods
- (void)afterUploadFinishAction:(WebItemType)actionType {
    
    _autoLoadAfterSent = YES;
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)selectedFeedBeDeleted {
    _selectedFeedBeDeleted = YES;
}

- (void)setRefreshFlag {
    _needRefresh = YES;
}

@end
