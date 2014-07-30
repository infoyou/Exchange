//
//  BaseListViewController.m
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "BaseListViewController.h"
#import "WXWDebugLogOutput.h"
#import "VerticalLayoutItemInfoCell.h"
#import "ConfigurableTextCell.h"
#import "WithTitleImageCell.h"
#import "EmptyMessageView.h"
#import "WXWCoreDataUtils.h"

@interface BaseListViewController()
@property (nonatomic, retain) EmptyMessageView *emptyMessageView;
@end


@implementation BaseListViewController
@synthesize lastSelectedIndexPath = _lastSelectedIndexPath;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView {
    
    self = [super initWithMOC:MOC];
    
    if (self) {
        
        _needRefreshHeaderView = needRefreshHeaderView;
        _needRefreshFooterView = needRefreshFooterView;
        _tableStyle = UITableViewStylePlain;
        
        _currentStartIndex = 0;
    }
    
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView
       tableStyle:(UITableViewStyle)tableStyle {
    
    self = [self initWithMOC:MOC
       needRefreshHeaderView:needRefreshHeaderView
       needRefreshFooterView:needRefreshFooterView];
    
    if (self) {
        _tableStyle = tableStyle;
    }
    
    return self;
}

- (id)initNoNeedDisplayEmptyMessageTableWithMOC:(NSManagedObjectContext *)MOC
                          needRefreshHeaderView:(BOOL)needRefreshHeaderView
                          needRefreshFooterView:(BOOL)needRefreshFooterView
                                     tableStyle:(UITableViewStyle)tableStyle {
    self = [self initWithMOC:MOC
       needRefreshHeaderView:needRefreshHeaderView
       needRefreshFooterView:needRefreshFooterView
                  tableStyle:tableStyle];
    
    if (self) {
        _noNeedDisplayEmptyMsg = YES;
    }
    
    return self;
}


- (void)initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                                              style:_tableStyle];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = TRANSPARENT_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    if (CURRENT_OS_VERSION >= IOS7) {
        _tableView.separatorInset = ZERO_EDGE;
    }
    
    if (_needRefreshHeaderView) {
        _headerRefreshView = [[WXWPullRefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableView.bounds.size.height, self.view.bounds.size.width, _tableView.frame.size.height)];
//        _headerRefreshView.backgroundColor = COLOR(226, 231, 237);
        _headerRefreshView.backgroundColor = TRANSPARENT_COLOR;
        [_tableView addSubview:_headerRefreshView];
        [_headerRefreshView setCurrentDate];
    }
    
    if (_needRefreshFooterView) {
        _footerRefreshView = [[WXWPullRefreshTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        _footerRefreshView.backgroundColor = TRANSPARENT_COLOR;
    }
    
    if (!_noNeedDisplayEmptyMsg) {
        _tableView.alpha = 0.0f;
    }
    
    [self.view addSubview:_tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.parentVC) {
        self.parentVC.navigationItem.titleView = nil;
    }
    
    [self initTableView];
}

- (void)dealloc {
    
    RELEASE_OBJ(_footerRefreshView);
    RELEASE_OBJ(_headerRefreshView);
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    RELEASE_OBJ(_tableView);
    
    self.lastSelectedIndexPath = nil;
    
    self.emptyMessageView = nil;
    
    [super dealloc];
}

#pragma mark - load data from backend server
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    _currentLoadTriggerType = triggerType;
    
    _loadForNewItem = forNew;
    
    // implemented by sub class
}

#pragma mark - load items from MOC

- (void)fetchContentFromMOCForFetchedRC:(NSFetchedResultsController **)fetchedRC
                             entityName:(NSString *)entityName
                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                        sortDescriptors:(NSMutableArray *)sortDescriptors
                              predicate:(NSPredicate *)predicate {
    (*fetchedRC) = nil;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    [self configureMOCFetchConditions];
    
    
    (*fetchedRC) = [WXWCoreDataUtils fetchObject:_MOC
                        fetchedResultsController:(*fetchedRC)
                                      entityName:entityName
                              sectionNameKeyPath:sectionNameKeyPath
                                 sortDescriptors:sortDescriptors
                                       predicate:predicate];
    
    NSError *error = nil;
    if (![*fetchedRC performFetch:&error]) {
        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
		NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
}

- (void)refreshTable {
    
    [self fetchContentFromMOC];
    
    [_tableView reloadData];
    
}

- (NSFetchedResultsController *)performFetchByFetchedRC:(NSFetchedResultsController *)fetchedRC {
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    fetchedRC = nil;
    
    fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                     fetchedResultsController:fetchedRC
                                   entityName:self.entityName
                           sectionNameKeyPath:self.sectionNameKeyPath
                              sortDescriptors:self.descriptors
                                    predicate:self.predicate];
    NSError *error = nil;
    if (![fetchedRC performFetch:&error]) {
        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
		NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    return fetchedRC;
}

#pragma mark - clear last selected indexPath
- (void)clearLastSelectedIndexPath {
    self.lastSelectedIndexPath = nil;
}

#pragma mark - update last selected cell
- (void)updateLastSelectedCell {
    
    if (self.lastSelectedIndexPath) {
        if (self.lastSelectedIndexPath.row <= _fetchedRC.fetchedObjects.count) {
            [_tableView beginUpdates];
            [_tableView reloadRowsAtIndexPaths:@[self.lastSelectedIndexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        }
    }
}

#pragma mark - delete last selected cell
- (void)deleteLastSelectedCell {
    
    [self fetchContentFromMOC];
    
    if (self.lastSelectedIndexPath) {
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[self.lastSelectedIndexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
    }
}

#pragma mark - draw grouped cell
- (VerticalLayoutItemInfoCell *)drawNoShadowVerticalInfoCell:(NSString *)title
                                                    subTitle:(NSString *)subTitle
                                                     content:(NSString *)content
                                              cellIdentifier:(NSString *)cellIdentifier
                                                   clickable:(BOOL)clickable {
    VerticalLayoutItemInfoCell *cell = (VerticalLayoutItemInfoCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[[VerticalLayoutItemInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell drawNoShadowInfoCell:title
                      subTitle:subTitle
                       content:content
                     clickable:clickable];
    return cell;
}

- (VerticalLayoutItemInfoCell *)drawShadowVerticalInfoCell:(NSString *)title
                                                  subTitle:(NSString *)subTitle
                                                   content:(NSString *)content
                                            cellIdentifier:(NSString *)cellIdentifier
                                                    height:(CGFloat)height
                                                 clickable:(BOOL)clickable {
    
    VerticalLayoutItemInfoCell *cell = (VerticalLayoutItemInfoCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[[VerticalLayoutItemInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:cellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell drawShadowInfoCell:title
                    subTitle:subTitle
                     content:content
                  cellHeight:height
                   clickable:clickable];
    return cell;
}

#pragma mark - draw configurable text cell

- (CGFloat)calculateCellHeightWithTitle:(NSString *)title
                              titleFont:(UIFont *)titleFont
                                content:(NSString *)content
                            contentFont:(UIFont *)contentFont
                              indexPath:(NSIndexPath *)indexPath
                              clickable:(BOOL)clickable
                              minHeight:(CGFloat)minHeight {
    CGFloat limitedWidth = 0;
    if (clickable) {
        if (_tableStyle == UITableViewStyleGrouped) {
            limitedWidth = GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH;
        } else {
            limitedWidth = PLAIN_TABLE_NO_TITLE_IMAGE_ACCESS_DISCLOSUR_WIDTH;
        }
    } else {
        if (_tableStyle == UITableViewStyleGrouped) {
            limitedWidth = GROUPED_TABLE_NO_TITLE_IMAGE_ACCESS_NONE_WIDTH;
        } else {
            limitedWidth = PLAIN_TABLE_NO_IMAGE_ACCESS_NONE_WIDTH;
        }
    }
    
    CGSize size = [title sizeWithFont:titleFont
                    constrainedToSize:CGSizeMake(limitedWidth, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MARGIN * 2 + size.height;
    
    if (content.length > 0) {
        size = [content sizeWithFont:contentFont
                   constrainedToSize:CGSizeMake(limitedWidth, CGFLOAT_MAX)
                       lineBreakMode:NSLineBreakByWordWrapping];
        height += MARGIN * 2 + size.height;
    }
    
    height += MARGIN * 2;
    
    if (height < minHeight) {
        height = minHeight;
    }
    return (height + [ConfigurableTextCell tableView:_tableView
                            neededHeightForIndexPath:indexPath]);
}

- (CGFloat)calculateCommonCellHeightWithTitle:(NSString *)title
                                      content:(NSString *)content
                                    indexPath:(NSIndexPath *)indexPath
                                    clickable:(BOOL)clickable {
    
    return [self calculateCellHeightWithTitle:title
                                    titleFont:COMMON_CELL_TITLE_FONT
                                      content:content
                                  contentFont:COMMON_CELL_CONTENT_FONT
                                    indexPath:indexPath
                                    clickable:clickable
                                    minHeight:DEFAULT_CELL_HEIGHT];
}

- (CGFloat)calculateHeaderCellHeightWithTitle:(NSString *)title
                                      content:(NSString *)content
                                    indexPath:(NSIndexPath *)indexPath {
    
    return [self calculateCellHeightWithTitle:title
                                    titleFont:HEADER_CELL_TITLE_FONT
                                      content:content
                                  contentFont:COMMON_CELL_CONTENT_FONT
                                    indexPath:indexPath
                                    clickable:NO
                                    minHeight:DEFAULT_HEADER_CELL_HEIGHT];
}

- (ConfigurableTextCell *)prepareCommonCell:(NSString *)cellIdentifier
                                  indexPath:(NSIndexPath *)indexPath
                                 badgeCount:(NSInteger)badgeCount
                                 dropShadow:(BOOL)dropShadow
                               cornerRadius:(CGFloat)cornerRadius {
    ConfigurableTextCell *cell = (ConfigurableTextCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[[ConfigurableTextCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:cellIdentifier] autorelease];
        cell.dropsShadow = dropShadow;
        cell.cornerRadius = cornerRadius;
    }
    
    [cell prepareForTableView:_tableView indexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)configureCommonGroupedCell:(NSString *)cellIdentifier
                                          title:(NSString *)title
                                     badgeCount:(NSInteger)badgeCount
                                        content:(NSString *)content
                                      indexPath:(NSIndexPath *)indexPath
                                      clickable:(BOOL)clickable
                                     dropShadow:(BOOL)dropShadow
                                   cornerRadius:(CGFloat)cornerRadius {
    
    
    ConfigurableTextCell *cell = [self prepareCommonCell:cellIdentifier
                                               indexPath:indexPath
                                              badgeCount:badgeCount
                                              dropShadow:dropShadow
                                            cornerRadius:cornerRadius];
    NSString *countStr = nil;
    if (badgeCount > 0) {
        countStr = [NSString stringWithFormat:@"%d", badgeCount];
    }
    
    [cell drawCommonCellWithTitle:title
                         subTitle:countStr
                          content:content
             contentLineBreakMode:NSLineBreakByWordWrapping
                       cellHeight:[self tableView:_tableView
                          heightForRowAtIndexPath:indexPath]
                        clickable:clickable];
    
    return cell;
}

- (ConfigurableTextCell *)configurePlainCell:(NSString *)cellIdentifier
                                       title:(NSString *)title
                                  badgeCount:(NSInteger)badgeCount
                                     content:(NSString *)content
                                   indexPath:(NSIndexPath *)indexPath
                                   clickable:(BOOL)clickable
                              selectionStyle:(UITableViewCellSelectionStyle)selectionStyle {
    
    ConfigurableTextCell *cell = (ConfigurableTextCell *)[self configureCommonGroupedCell:cellIdentifier
                                                                                    title:title
                                                                               badgeCount:badgeCount
                                                                                  content:content
                                                                                indexPath:indexPath
                                                                                clickable:clickable
                                                                               dropShadow:NO
                                                                             cornerRadius:0.0f];
    
    cell.selectionStyle = selectionStyle;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.borderColor = TRANSPARENT_COLOR;
    cell.customSeparatorColor = TRANSPARENT_COLOR;
    
    return cell;
}


- (UITableViewCell *)configureHeaderCell:(NSString *)cellIdentifier
                                   title:(NSString *)title
                              badgeCount:(NSInteger)badgeCount
                                 content:(NSString *)content
                               indexPath:(NSIndexPath *)indexPath
                              dropShadow:(BOOL)dropShadow
                            cornerRadius:(CGFloat)cornerRadius {
    
    ConfigurableTextCell *cell = [self prepareCommonCell:cellIdentifier
                                               indexPath:indexPath
                                              badgeCount:badgeCount
                                              dropShadow:dropShadow
                                            cornerRadius:cornerRadius];
    NSString *countStr = nil;
    if (badgeCount > 0) {
        countStr = [NSString stringWithFormat:@"%d", badgeCount];
    }
    
    [cell drawHeaderCellWithTitle:title
                         subTitle:countStr
                          content:content
                       cellHeight:[self tableView:_tableView
                          heightForRowAtIndexPath:indexPath]];
    
    return cell;
}

- (UITableViewCell *)configureWithTitleImageCell:(NSString *)cellIdentifier
                                           title:(NSString *)title
                                      badgeCount:(NSInteger)badgeCount
                                         content:(NSString *)content
                                           image:(UIImage *)image
                                       indexPath:(NSIndexPath *)indexPath
                                       clickable:(BOOL)clickable
                                      dropShadow:(BOOL)dropShadow
                                    cornerRadius:(CGFloat)cornerRadius {
    WithTitleImageCell *cell = (WithTitleImageCell *)[_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[[WithTitleImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier] autorelease];
        cell.dropsShadow = dropShadow;
        cell.cornerRadius = cornerRadius;
    }
    
    [cell prepareForTableView:_tableView indexPath:indexPath];
    
    NSString *countStr = nil;
    if (badgeCount > 0) {
        countStr = [NSString stringWithFormat:@"%d", badgeCount];
    }
    
    [cell drawWithTitleImageCellWithTitle:title
                                 subTitle:countStr
                                  content:content
                                    image:image
                     contentLineBreakMode:NSLineBreakByWordWrapping
                               cellHeight:[self tableView:_tableView
                                  heightForRowAtIndexPath:indexPath]
                                clickable:clickable];
    
    return cell;
}

#pragma mark - table view utility methods
// NOTE!!!
// this method does not support multi-section table if the section
// is not provided by self.fetchedRC, e.g., the numberOfSectionsInTableView:
// provided by customized way
- (BOOL)currentCellIsFooter:(NSIndexPath *)indexPath {
    
    if (self.fetchedRC.sections.count == 0) {
        return YES;
    }
    
    if (indexPath.section == self.fetchedRC.sections.count - 1) {
        
        id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedRC.sections objectAtIndex:indexPath.section];
        
        if (indexPath.row == sectionInfo.numberOfObjects) {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - UITableViewDataSource, UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSIndexPath*)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    SEL hidelabelShadowSelector = sel_registerName("hideLabelShadow");
    if ([cell respondsToSelector:hidelabelShadowSelector]) {
        [cell performSelector:hidelabelShadowSelector];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lastSelectedIndexPath = indexPath;
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_CELL_HEIGHT;
}

#pragma mark - draw footer cell
- (UITableViewCell *)drawFooterCell {
    static NSString *kFooterCellIdentifier = @"footerCell";
    UITableViewCell *footerCell = [_tableView dequeueReusableCellWithIdentifier:kFooterCellIdentifier];
    if (nil == footerCell) {
        footerCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:kFooterCellIdentifier] autorelease];
        
        footerCell.backgroundColor = TRANSPARENT_COLOR;
        footerCell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
        if (_footerRefreshView) {
            [_footerRefreshView removeFromSuperview];
        }
        [footerCell.contentView addSubview:_footerRefreshView];
        footerCell.accessoryType = UITableViewCellAccessoryNone;
        footerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return footerCell;
}

#pragma mark - reset refresh header/footer view status
- (void)resetHeaderRefreshViewStatus {
    _reloading = NO;
    [WXWUIUtils dataSourceDidFinishLoadingNewData:_tableView
                                       headerView:_headerRefreshView];
}

- (void)resetFooterRefreshViewStatus {
    
    _reloading = NO;
    [WXWUIUtils dataSourceDidFinishLoadingOldData:_tableView
                                       footerView:_footerRefreshView];
    
}

- (void)resetHeaderOrFooterViewStatus {
    
    if (_loadForNewItem) {
        [self resetHeaderRefreshViewStatus];
    } else {
        [self resetFooterRefreshViewStatus];
    }
}

- (void) setFooterRefreshViewStatus:(PullFooterRefreshState)status {
    [_footerRefreshView setState:status];
}

- (PullFooterRefreshState) getFooterRefreshViewStatus {
    return _footerRefreshView.state;
}

- (void)resetUIElementsForConnectDoneOrFailed {
    switch (_currentLoadTriggerType) {
        case TRIGGERED_BY_AUTOLOAD:
        case TRIGGERED_BY_SORT:
            _autoLoaded = YES;
            break;
            
        case TRIGGERED_BY_SCROLL:
            [self resetHeaderOrFooterViewStatus];
            break;
            
        default:
            break;
    }
}

#pragma mark - handle empty list

- (BOOL)listIsEmpty {
    if (0 == self.fetchedRC.sections.count) {
        return YES;
    } else if (1 == self.fetchedRC.sections.count) {
        if (0 == self.fetchedRC.fetchedObjects.count) {
            return YES;
        }
    }
    return NO;
}

- (void)displayEmptyMessage {
    
    _tableView.alpha = 0.0f;
    
    if (nil == self.emptyMessageView) {
        self.emptyMessageView = [[[EmptyMessageView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height)] autorelease];
        
        [self.view addSubview:self.emptyMessageView];
        
        [self.view sendSubviewToBack:self.emptyMessageView];
    }
}

- (void)checkListWhetherEmpty {
    
    if ([self listIsEmpty]) {
        
        [self displayEmptyMessage];
        
    } else {
        [UIView animateWithDuration:0.1f
                         animations:^{
                             
                             if (self.emptyMessageView) {
                                 self.emptyMessageView.alpha = 0.0f;
                             }
                             
                             _tableView.alpha = 1.0f;
                         }
                         completion:^(BOOL finished){
                             [self clearEmptyMessage];
                         }];
    }
}

- (void)clearEmptyMessage {
    if (self.emptyMessageView) {
        [self.emptyMessageView removeFromSuperview];
        self.emptyMessageView = nil;
    }
}

- (void)removeEmptyMessageIfNeeded {
    
    [self clearEmptyMessage];
    _tableView.alpha = 1.0f;
}

#pragma mark - scrolling overrides

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    _userBeginDrag = YES;
    
    if (_needRefreshHeaderView) {
        // for loading latest items
        if ([WXWUIUtils shouldLoadNewItems:scrollView
                                headerView:_headerRefreshView
                                 reloading:_reloading]) {
            
            _shouldTriggerLoadLatestItems = YES;
            
        }
    }
    
    if (_needRefreshFooterView) {
        // for loading older items
        if ([WXWUIUtils shouldLoadOlderItems:scrollView
                             tableViewHeight:_tableView.contentSize.height
                                  footerView:_footerRefreshView
                                   reloading:_reloading]) {
            
            _reloading = YES;
            
            [self loadListData:TRIGGERED_BY_SCROLL forNew:NO];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    
    if (_needRefreshHeaderView && scrollView.contentOffset.y <= -(HEADER_TRIGGER_OFFSET) && !_reloading) {
        
        _reloading = YES;
        
        [self loadListData:TRIGGERED_BY_SCROLL forNew:YES];
        
        [WXWUIUtils animationForScrollViewDidEndDragging:scrollView
                                               tableView:_tableView
                                              headerView:_headerRefreshView];
    }
    
    _userBeginDrag = NO;
    
}

#pragma mark - ECConnectorDelegate methods

- (void)connectDone:(NSData *)result
                url:(NSString *)url
        contentType:(NSInteger)contentType {
    
    [self resetUIElementsForConnectDoneOrFailed];
    
    if (!_noNeedDisplayEmptyMsg) {
        [self checkListWhetherEmpty];
    }
    
    [super connectDone:result url:url contentType:contentType closeAsyncLoadingView:YES];
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    
    [self resetUIElementsForConnectDoneOrFailed];
    
    if (!_noNeedDisplayEmptyMsg) {
        [self checkListWhetherEmpty];
    }
    
    [super connectFailed:error url:url contentType:contentType];
}

@end
