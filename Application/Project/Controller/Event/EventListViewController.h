/*!
 @header EventListViewController.h
 @abstract 活动列表界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */
#import "BaseListViewController.h"

@interface EventListViewController : BaseListViewController {
  
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;

@end
