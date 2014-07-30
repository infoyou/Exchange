/*!
 @header CommunicationListViewController.h
 @abstract 聊天列表界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"
#import "QPlusAPI.h"

#define EVENT_LIST_CELL_HEIGHT          96.f

@interface CommunicationListViewController : BaseListViewController{
    
    CGFloat _viewHeight;
}

/*!
 @method
 @abstract 初始化
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC;

/*!
 @method
 @abstract 得到历史记录
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
-(void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString *)tarID;

/*!
 @method
 @abstract 接收消息
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
- (void)onReceiveMessage:(QPlusMessage *)message;

/*!
 @method
 @abstract 删除群组
 @discussion
 @param text MOC
 @param error nil
 @result id
 */
-(void)onDeleteGroupMesssage:(QPlusMessage *)message;

@end
