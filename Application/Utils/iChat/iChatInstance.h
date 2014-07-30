
/*!
 @header iChatInstance.h
 @abstract 聊天实例
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import <Foundation/Foundation.h>

@interface iChatInstance : NSObject

#define DELETE_GROUP_MESSAGE    @"EDDD8C6120890D04E044005056BE1CB0"

@property (nonatomic, assign) int index;

+ (iChatInstance *) instance;

- (void)imRelogin;
- (void)onLoginSuccess:(BOOL)isRelogin;

/*!
 @method
 @abstract 登录聊天服务器
 @discussion
 @param text userId
 @param error nil
 @result id
 */
- (void)dologin:(NSString *)userId;

/*!
 @method
 @abstract 退出聊天服务器
 @discussion
 @param text
 @param error nil
 @result id
 */
- (void)dologout;

/*!
 @method
 @abstract 注册到聊天服务器
 @discussion
 @param text listener
 @param error nil
 @result id
 */
- (void)registerListener:(id)listener;

/*!
 @method
 @abstract 注销到聊天服务器
 @discussion
 @param text listener
 @param error nil
 @result id
 */
- (void)unRegisterListener:(id)listener;

- (void)sendDeleteGroupMessage:(NSString *)groupId;

@end
