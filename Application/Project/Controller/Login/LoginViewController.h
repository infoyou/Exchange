
/*!
 @header LoginViewController.h
 @abstract 登录界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "WXWRootViewController.h"

@protocol UserLoginViewControllerDelegate;

@interface LoginViewController : WXWRootViewController
@property (nonatomic, assign) id<UserLoginViewControllerDelegate> delegate;

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC RootViewController
 @param error nil
 @result id
 */
- (id)initLoginVC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;


- (void)autoLogin;
- (void)bringToFront;

/*!
 @method
 @abstract 点击激活
 @discussion
 @param text sender
 @param error nil
 @result id
 */
- (void)registerButtonClicked:(id)sender;

/*!
 @method
 @abstract 点击登录
 @discussion
 @param text sender
 @param error nil
 @result id
 */
- (void)loginButtonClicked:(id)sender;

@end

@protocol UserLoginViewControllerDelegate <NSObject>

/*!
 @method
 @abstract 登录结果处理
 @discussion
 @param text LoginViewController
 @param error nil
 @result id
 */
- (BOOL)loginSuccessful:(LoginViewController *)vc;
- (void)closeSplash;

@end
