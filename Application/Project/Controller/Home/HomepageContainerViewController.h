/*!
 @header HomepageContainerViewController.h
 @abstract 主界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "WXWRootViewController.h"
#import "TabBarView.h"

@interface HomepageContainerViewController : WXWRootViewController<TabDelegate> {
@private
    CGFloat _tabbarOriginalY;
}

@property (nonatomic, retain) WXWRootViewController* currentVC;

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (id)initHomepageWithMOC:(NSManagedObjectContext *)MOC;

- (void)selectHomepage;
- (void)showHomeView;

/*!
 @method
 @abstract 清理页面内存
 @discussion
 @param text
 @param error
 @result void
 */
- (void)clearAllViewController;

/*!
 @method
 @abstract 进入OA界面
 @discussion
 @param text
 @param error
 @result void
 */
- (void)selectOADetail;

@end
