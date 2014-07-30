//
//  BaseListViewController.h
//  Project
//
//  Created by XXX on 11-11-10.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWRootViewController.h"
#import "WXWPullRefreshTableHeaderView.h"
#import "WXWPullRefreshTableFooterView.h"

@class VerticalLayoutItemInfoCell;
@class ConfigurableTextCell;

@interface BaseListViewController : WXWRootViewController <UITableViewDataSource, UITableViewDelegate> {
  
  WXWPullRefreshTableFooterView *_footerRefreshView;
  WXWPullRefreshTableHeaderView *_headerRefreshView;
  
  BOOL _needRefreshHeaderView;
  BOOL _needRefreshFooterView;
  BOOL _userBeginDrag;
  
  NSIndexPath *_lastSelectedIndexPath;
  
  BOOL _userFirstUseThisList;
  
  NSInteger _currentStartIndex;
  
  BOOL _showNewLoadedItemCount;
  BOOL _shouldTriggerLoadLatestItems;
  BOOL _shouldTriggerLoadOlderItems;
  
  BOOL _noNeedDisplayEmptyMsg;
  
  BOOL _loadForNewItem;
  LoadTriggerType _currentLoadTriggerType;
  BOOL _autoLoaded;
  BOOL _reloading;
  NSTimer *timer;
    
@private
  UITableViewStyle _tableStyle;
}

@property (nonatomic, retain) NSIndexPath *lastSelectedIndexPath;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
needRefreshHeaderView:(BOOL)needRefreshHeaderView
needRefreshFooterView:(BOOL)needRefreshFooterView
       tableStyle:(UITableViewStyle)tableStyle;

- (id)initNoNeedDisplayEmptyMessageTableWithMOC:(NSManagedObjectContext *)MOC
                          needRefreshHeaderView:(BOOL)needRefreshHeaderView
                          needRefreshFooterView:(BOOL)needRefreshFooterView
                                     tableStyle:(UITableViewStyle)tableStyle;

#pragma mark - load data from backend server
- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew;

#pragma mark - load items from MOC
- (void)refreshTable;
- (NSFetchedResultsController *)performFetchByFetchedRC:(NSFetchedResultsController *)fetchedRC;

#pragma mark - draw grouped cell
- (VerticalLayoutItemInfoCell *)drawNoShadowVerticalInfoCell:(NSString *)title
                                                    subTitle:(NSString *)subTitle
                                                     content:(NSString *)content
                                              cellIdentifier:(NSString *)cellIdentifier
                                                   clickable:(BOOL)clickable;

- (VerticalLayoutItemInfoCell *)drawShadowVerticalInfoCell:(NSString *)title
                                                  subTitle:(NSString *)subTitle
                                                   content:(NSString *)content
                                            cellIdentifier:(NSString *)cellIdentifier
                                                    height:(CGFloat)height
                                                 clickable:(BOOL)clickable;

#pragma mark - draw configurable text cell

- (CGFloat)calculateCommonCellHeightWithTitle:(NSString *)title
                                      content:(NSString *)content
                                    indexPath:(NSIndexPath *)indexPath
                                    clickable:(BOOL)clickable;

- (CGFloat)calculateHeaderCellHeightWithTitle:(NSString *)title
                                      content:(NSString *)content
                                    indexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)configureCommonGroupedCell:(NSString *)cellIdentifier
                             title:(NSString *)title
                        badgeCount:(NSInteger)badgeCount
                           content:(NSString *)content
                         indexPath:(NSIndexPath *)indexPath
                         clickable:(BOOL)clickable
                        dropShadow:(BOOL)dropShadow
                      cornerRadius:(CGFloat)cornerRadius;

- (ConfigurableTextCell *)configurePlainCell:(NSString *)cellIdentifier
                                       title:(NSString *)title
                                  badgeCount:(NSInteger)badgeCount
                                     content:(NSString *)content
                                   indexPath:(NSIndexPath *)indexPath
                                   clickable:(BOOL)clickable
                              selectionStyle:(UITableViewCellSelectionStyle)selectionStyle;

- (UITableViewCell *)configureHeaderCell:(NSString *)cellIdentifier
                                   title:(NSString *)title
                              badgeCount:(NSInteger)badgeCount
                                 content:(NSString *)content
                               indexPath:(NSIndexPath *)indexPath
                              dropShadow:(BOOL)dropShadow
                            cornerRadius:(CGFloat)cornerRadius;

- (UITableViewCell *)configureWithTitleImageCell:(NSString *)cellIdentifier
                                           title:(NSString *)title
                                      badgeCount:(NSInteger)badgeCount
                                         content:(NSString *)content
                                           image:(UIImage *)image
                                       indexPath:(NSIndexPath *)indexPath
                                       clickable:(BOOL)clickable
                                      dropShadow:(BOOL)dropShadow
                                    cornerRadius:(CGFloat)cornerRadius;

#pragma mark - draw footer cell
- (UITableViewCell *)drawFooterCell;

#pragma mark - table view utility methods
- (BOOL)currentCellIsFooter:(NSIndexPath *)indexPath;

#pragma mark - handle empty list
- (BOOL)listIsEmpty;
- (void)checkListWhetherEmpty;
- (void)removeEmptyMessageIfNeeded;

#pragma mark - load latest or old items
- (void)resetUIElementsForConnectDoneOrFailed;
- (void)resetHeaderRefreshViewStatus;
- (void)resetFooterRefreshViewStatus;
- (void)setFooterRefreshViewStatus:(PullFooterRefreshState)status;
- (PullFooterRefreshState) getFooterRefreshViewStatus;

#pragma mark - clear last selected indexPath
- (void)clearLastSelectedIndexPath;

#pragma mark - update last selected cell
- (void)updateLastSelectedCell;

#pragma mark - delete last selected cell
- (void)deleteLastSelectedCell;

- (void)displayEmptyMessage;
@end
