//
//  TradeInformationViewController.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "TradeInformationViewController.h"
#import "InformationListCell.h"
#import "TradeInformationContentViewController.h"
#import "CommonUtils.h"
#import "JSONParser.h"
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


#define SEARCH_VIEW_HEIGHT 48.f
#define SEARCH_BG_HEIGHT  30.f
#define SEARCH_TEXTFIELD_HEIGHT 30.f

#define MARGIN_LEFT  21.f
#define MARGIN_RIGHT 16.f

#define SEARCH_LOGO_WIDTH  16.f
#define SEARCH_LOGO_HEIGHT 17.f

@interface TradeInformationViewController ()<UISearchBarDelegate> {
    BOOL isSearched;
    
}

@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *keywords;

@end

@implementation TradeInformationViewController {
    int _countBeforeSearch;
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


    return self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
#if APP_TYPE == APP_TYPE_BASE
    self.navigationItem.title = @"行业资讯";
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY
    self.navigationItem.title = @"每周话题";
#elif APP_TYPE == APP_TYPE_O2O
    self.navigationItem.title = @"行业资讯";
#endif

    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    [self initSearchBar];
    
    _tableView.tableHeaderView = self.searchBar;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));

    
    //清除数据
//    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"InformationList"];
    
    if ([OffLineDBCacheManager handleInformationListDB:0 count:200 MOC:_MOC]) {
        [self fetchContentFromMOC];
        _tableView.alpha = 1.0f;
    }
    
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_searchBar release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_autoLoaded) {
//        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    [self updateLastSelectedCell];
}

- (void)initSearchBar {
    
    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectZero] autorelease];
    self.searchBar.delegate = self;
//    [self.searchBar setBarStyle:UIBarStyleDefault];
    
    [self.searchBar setTintColor:[UIColor colorWithHexString:@"0xe64125"]];
    self.searchBar.placeholder = @"输入资讯标题或关键字";
    
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
            
        case LOAD_INFORMATION_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
//                _autoLoaded = YES;
                NSDictionary *resultDic = [result objectFromJSONData];
                
                NSDictionary *contentDic = [resultDic objectForKey:@"content"];
                if (contentDic) {
                    NSString *isAll = [contentDic objectForKey:@"param1"];
                    
                    NSArray *contentList = [contentDic objectForKey:@"list1"];
                    
                    //删除所有的历史记录比此次时间戳最小的记录
                    if ( [isAll isEqualToString:@"0"]) {
                        
                        if (![contentList isEqual:[NSNull null]] && contentList.count) {
                            NSDictionary *theOldInfo = [contentList lastObject];
                            NSString *lastUpdateTime = [theOldInfo objectForKey:@"param10"];
                            
                            NSString *entityName = @"InformationList";
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastUpdateTime < %@", lastUpdateTime ];
                            
                            [WXWCoreDataUtils deleteEntitiesFromMOC:_MOC entityName:entityName predicate:predicate];
                            
                            [[GoHighDBManager instance] deleteOldInfomationFromTimestamp:lastUpdateTime];
                            
                            [_tableView reloadData];
                        }
                    }
                }
                
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                [[GoHighDBManager instance] upinsertInfomationInfo:self.fetchedRC.fetchedObjects timestamp:[timestamp doubleValue]];
                [self refreshTable];
            }
            break;
        }
        case SEARCH_INFORMATION_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
//                _autoLoaded = YES;
                [self refreshTable];
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
    
    _autoLoaded = YES;
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
    self.entityName = @"InformationList";
    if (isSearched) {
        self.predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@ and isDelete == 0",self.keywords];
    }else{
        self.predicate = [NSPredicate predicateWithFormat:@"isDelete == 0 and informationID != 0"];
    }
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"lastUpdateTime"
                                                              ascending:NO] autorelease];
    [self.descriptors addObject:sortDesc];
}

#pragma mark - tableview delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d", self.fetchedRC.fetchedObjects.count);
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_H;
}

- (InformationListCell *)drawInformationListCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *infoIdentifier = @"information_cell";
    InformationListCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
    
    if (!cell) {
        cell = [[[InformationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoIdentifier] autorelease];
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = TRANSPARENT_COLOR;
    }
    
    InformationList *list = (InformationList *)[self.fetchedRC objectAtIndexPath:indexPath];
    [cell drawInformationList:list];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    } else {
        
        return [self drawInformationListCell:tableView atIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    InformationListCell *cell = (InformationListCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    TradeInformationContentViewController *tradeInformationContentController = [[[TradeInformationContentViewController alloc] initWithMOC:_MOC parentVC:self.parentVC url:cell.zipURL title:cell.titleLabel.text informationID:cell.informationID] autorelease];
    [CommonMethod pushViewController:tradeInformationContentController withAnimated:YES];
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    
    
    if ([OffLineDBCacheManager handleInformationListDB:0 count:_countBeforeSearch MOC:_MOC]) {
        isSearched = FALSE;
        [self fetchContentFromMOC];
        _tableView.alpha = 1.0f;
        DLog(@"%d", self.fetchedRC.fetchedObjects.count);
//        [self updateLastSelectedCell];
        [_tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    _countBeforeSearch = [self.fetchedRC.fetchedObjects count];
    [searchBar resignFirstResponder];
    isSearched = YES;
    self.keywords = searchBar.text;
//    DELETE_OBJS_FROM_MOC(_MOC, @"InformationList", nil);
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES withKeyword:searchBar.text];
}

#pragma mark - load data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    [self loadListData:triggerType forNew:forNew withKeyword:nil];
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew withKeyword:(NSString *)keyword {
    
    [super loadListData:triggerType forNew:forNew];
    
  
    if (nil != keyword && ![keyword isEqualToString:@""]) {
        _currentType = SEARCH_INFORMATION_LIST_TY;
    }else
        _currentType = LOAD_INFORMATION_LIST_TY;
    
    NSInteger index = 1;
//    if (!forNew)
//    {
//        index = ++_currentStartIndex;
//    }
    
    index = self.fetchedRC.fetchedObjects.count / 60 + 1;
    
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    [specialDict setObject:NUMBER(1) forKey:KEY_API_PARAM_INFORMATION_TYPE];
    [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestInfomationTimestamp] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
    
    if (forNew)
    {
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getLatestInfomationTimestamp] / 1000 ]  forKey:KEY_API_PARAM_START_TIME];
        [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    }else{
        [specialDict setObject:@"" forKey:KEY_API_PARAM_START_TIME];
        [specialDict setObject:[CommonMethod convertLongTimeToString:[[GoHighDBManager instance] getOldestInfomationTimestamp] / 1000 ]  forKey:KEY_API_PARAM_END_TIME];
    }
    
    
    if (nil != keyword) {
        [specialDict setObject:@""  forKey:KEY_API_PARAM_START_TIME];
        [specialDict setObject:keyword forKey:KEY_API_PARAM_KEYWORD];
    }
    
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


@end
