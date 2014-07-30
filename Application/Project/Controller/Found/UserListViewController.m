//
//  UserListViewController.m
//  Project
//
//  Created by XXX on 13-12-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UserListViewController.h"
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
#import "UserListCell.h"
#import "UserProfile.h"

#define SEARCH_VIEW_HEIGHT 48.f
#define SEARCH_BG_HEIGHT  30.f
#define SEARCH_TEXTFIELD_HEIGHT 30.f

#define MARGIN_LEFT  21.f
#define MARGIN_RIGHT 16.f

#define SEARCH_LOGO_WIDTH  16.f
#define SEARCH_LOGO_HEIGHT 17.f

@interface UserListViewController ()<UISearchBarDelegate> {
    BOOL isSearched;

}

@end

@implementation UserListViewController {
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

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
#if APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA
    self.navigationItem.title = @"附近校友";
#elif APP_TYPE == APP_TYPE_INEARBY
    self.navigationItem.title = @"附近";
#endif
    
    if ([WXWCommonUtils currentOSVersion] < IOS7) {
        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
    }
    
    if ([WXWCommonUtils currentOSVersion] >= IOS7) {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([OffLineDBCacheManager handleInformationListDB:0 count:200 MOC:_MOC]) {
        [self fetchContentFromMOC];
        _tableView.alpha = 1.0f;
    }
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!_autoLoaded) {
        //        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    
    [self updateLastSelectedCell];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_USER_LIST_TY:
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
    self.connectionErrorMsg = @"";
    [super connectFailed:error url:url contentType:contentType];
}

- (void)configureMOCFetchConditions {
    
    self.entityName = @"Alumni";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"userName"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    
    self.predicate = nil;
}

#pragma mark - tableview delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d", self.fetchedRC.fetchedObjects.count);
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SEARCH_RESULT_CELL_HEIGHT;
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
        
        static NSString *identifier = @"NearbyUserList";
        
        UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[[UserListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        Alumni *aAlumni = (Alumni *)[self.fetchedRC objectAtIndexPath:indexPath];
        [cell updateCell:aAlumni];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
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
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
//    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
//    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
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
    
    [specialDict setObject:@"1"  forKey:@"distanceScope"];
    [specialDict setObject:@"1"  forKey:@"nearbyTimeScope"];
    [specialDict setObject:@"1"  forKey:@"nearbyOrderType"];
    [specialDict setObject:@"1"  forKey:@"longitude"];
    [specialDict setObject:@"1"  forKey:@"latitude"];
    [specialDict setObject:@"1"  forKey:@"locationType"];
    [specialDict setObject:@"0"  forKey:@"page"];
    [specialDict setObject:@"20"  forKey:@"pageSize"];
    
    _currentType = LOAD_USER_LIST_TY;
    NSString *url = [CommonUtils geneJSONUrl:specialDict itemType:_currentType];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

@end
