
/*!
 @header OADetailViewController.h
 @abstract OA明细
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <UIKit/UIKit.h>
#import "WXWRootViewController.h"

@interface OADetailViewController : WXWRootViewController <UIWebViewDelegate,UIActionSheetDelegate>
{
}

@property (nonatomic, copy) NSString *strUrl;
@property (nonatomic, copy) NSString *strTitle;

/*!
 @method
 @abstract 初始化OA明细
 @discussion
 @param text userId
 @param error nil
 @result id
 */
- (id)initOADetailVC:(WXWRootViewController *)pVC;

@end
