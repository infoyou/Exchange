/*!
 @header MeViewController.h
 @abstract 我
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"

@interface MeViewController : BaseListViewController

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC RootViewController
 @param error nil
 @result id
 */
- (id)initMeVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;

@end
