
/*!
 @header OALoginViewController.h
 @abstract OA登录界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "WXWRootViewController.h"

@interface OALoginViewController : WXWRootViewController

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC RootViewController
 @param error nil
 @result id
 */
- (id)initOALoginVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;

@end