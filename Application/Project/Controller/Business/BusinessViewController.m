//
//  BusinessViewController.m
//  Project
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessItemViewCell.h"
#import "CommonHeader.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "JSONKit.h"
#import "JSONParser.h"
#import "BusinessItemDetailViewController.h"
#import "GoHighDBManager.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "OffLineDBCacheManager.h"

#define SEARCH_VIEW_HEIGHT  40.f

@interface BusinessViewController ()<UISearchBarDelegate> {
    
    UISearchBar *_searchBar;
    BusinessItemDetailViewController *_businessItemDetailViewController;
    NSArray *_categoryArray;
    NSMutableArray *_searchedCategoryArray;
    
    int _categoryCount;
}

@end

@implementation BusinessViewController

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = GET_BUSINESS_CATEGORY;
    
    NSInteger index = 0;
    if (!forNew) {
        index = ++_currentStartIndex;
    }
    _reloading= NO;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setObject:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setObject:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:[CommonMethod convertLongTimeToString:0 ]  forKey:KEY_API_PARAM_START_TIME];
    [specialDict setObject:@"" forKey:KEY_API_PARAM_END_TIME];
    
    [specialDict setValue:@"" forKey:@"specifiedID"];
    [specialDict setValue:@"" forKey:@"endTime"];
    [specialDict setValue:@"1" forKey:@"pageNo"];
    [specialDict setValue:@"" forKey:@"keyword"];
    [specialDict setValue:@"3" forKey:@"categoryType"];
    
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_INFORMATION withApiName:API_NAME_GET_INFORMATION_CATEGORY withCommon:commonDict withSpecial:specialDict];
    
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    
    
    self = [super initNoNeedDisplayEmptyMessageTableWithMOC:MOC
                                      needRefreshHeaderView:YES
                                      needRefreshFooterView:NO
                                                 tableStyle:UITableViewStylePlain];
    
    if (self) {
        _noNeedBackButton = YES;
        
        self.parentVC = pVC;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navigationItem.title = @"高和业务";

    
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tableHeaderView = [self searchBar];
    _tableView.contentOffset = CGPointMake(0, CGRectGetHeight(self.searchBar.bounds));
    
    //    [self initBusinessItemDetailViewController];
    
//    if ([WXWCommonUtils currentOSVersion] < IOS7) {
//        self.view.frame = CGRectOffset(self.view.frame, 0, -20);
//    }
    self.view.frame = CGRectMake(0, 0, _screenSize.width, _screenSize.height - NAVIGATION_BAR_HEIGHT - HOMEPAGE_TAB_HEIGHT - SYS_STATUS_BAR_HEIGHT);
    
    //    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    
    _searchedCategoryArray = [[NSMutableArray alloc] init];
    
    if ((_categoryArray =  [[OffLineDBCacheManager handleBusinessCategoryDB:_MOC] retain]) ) {
        
        [_searchedCategoryArray removeAllObjects];
        for (NSDictionary *dic in _categoryArray) {
            [_searchedCategoryArray addObject:dic];
        }
        
        _categoryCount = _searchedCategoryArray.count;
        
        [self refreshTable];
    }
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#if APP_TYPE == APP_TYPE_BASE
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"gh_nav_bg.png"]  forNavigationController:self.parentVC.navigationController];
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"cio_nav_bg.png"]  forNavigationController:self.parentVC.navigationController];
#elif APP_TYPE == APP_TYPE_O2O
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"cio_nav_bg.png"]  forNavigationController:self.parentVC.navigationController];
#endif
    
    
    if (![OffLineDBCacheManager handleBusinessCategoryDB:_MOC].count) {
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (animated) {
        [self.tableView flashScrollIndicators];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self adjustNavigationBarImage:[UIImage imageNamed:@"gohigh_nav_top_background.png"] forNavigationController:self.parentVC.navigationController];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - searchbar

- (UISearchBar *)searchBar {
    _searchBar = [[[UISearchBar alloc] initWithFrame:CGRectZero/*CGRectMake(0, 0, self.view.frame.size.width, SEARCH_VIEW_HEIGHT)*/] autorelease];
    _searchBar.delegate = self;
    [_searchBar setBarStyle:UIBarStyleDefault];
    
    //    [_searchBar setBarTintColor:[UIColor clearColor]];
    if ([CommonMethod is7System])
    [_searchBar setTintColor:[UIColor colorWithHexString:@"0xe64125"]];
    _searchBar.placeholder = @"搜索";
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

- (void)initBusinessItemDetailViewController
{
    _businessItemDetailViewController = [[BusinessItemDetailViewController alloc] init];
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
    //    [self searchWithText:@"搜索中..." keyword:searchBar.text];
    
    [_searchedCategoryArray removeAllObjects];
    
    
    for (NSDictionary *dict in _categoryArray) {
        NSRange range = [[dict objectForKey:@"param3"] rangeOfString:searchBar.text];
        
        if (range.length > 0) {
            DLog(@"%@",[dict objectForKey:@"param3"]);
            [_searchedCategoryArray addObject:dict];
            
        }
    }
    
    [_tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    [_searchedCategoryArray removeAllObjects];
    for (NSDictionary *dict in _categoryArray) {
        [_searchedCategoryArray addObject:dict];
    }
    
    [_tableView reloadData];
    
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    
}
#pragma mark -- table view delegate
//-------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.fetchedRC.fetchedObjects.count;
    return _searchedCategoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BUSINESS_ITEM_VIEW_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * tableIdentifier = @"BusinessItemViewCell";
    
    BusinessItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil)
    {
        cell = [[[BusinessItemViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier imageDisplayerDelegate:self MOC:_MOC] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BusinessItemModel *item = (BusinessItemModel *)[self.fetchedRC objectAtIndexPath:indexPath];
    
    [cell updateItemInfo:item withContext:_MOC withDataArray: _searchedCategoryArray.count > indexPath.row ? [_searchedCategoryArray objectAtIndex:indexPath.row] : nil];
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessItemViewCell *cell = (BusinessItemViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    BusinessItemDetailViewController *vc = [[[BusinessItemDetailViewController alloc] initWithMOC:_MOC projectID:cell.projectID] autorelease];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
}



#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case GET_BUSINESS_CATEGORY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                NSDictionary *resultDic = [result objectFromJSONData];
                
                //                NSString* aStr;
                //                aStr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                _categoryArray = [[contentDict objectForKey:@"list1"] retain];
                
                
                [[GoHighDBManager instance] upinsertBusinessCategories:_categoryArray timestamp:timestamp MOC:_MOC];
                
                [_searchedCategoryArray removeAllObjects];
                for (NSDictionary *dic in _categoryArray) {
                    [_searchedCategoryArray addObject:dic];
                }
                
                _categoryCount = _searchedCategoryArray.count;
                
                [self refreshTable];
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
- (void)configureMOCFetchConditions {
    self.entityName = @"BusinessItemModel";
    self.descriptors = [NSMutableArray array];
    self.predicate = nil;
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"businessId" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
}


#pragma mark -- view tapped
- (void)viewTapped:(UIGestureRecognizer *)gesture {
    BusinessItemDetailViewController *vc = [[[BusinessItemDetailViewController alloc] init] autorelease];
    //    [vc updateInfoWithId:];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

@end
