
/*!
 @header ChatListViewController.h
 @abstract 聊天界面
 @author Adam
 @version 1.00 2014/03/12 Creation
 */

#import "BaseListViewController.h"
#import "ChatGroupDataModal.h"
#import "ECClickableElementDelegate.h"
#import "QPlusAPI.h"
#import "QPlusGroupDelegate.h"
#import "ECItemUploaderDelegate.h"
#import "PrivateUserListDataModal.h"
#import "UserBaseInfo.h"

//聊天的类型
enum CHAT_TYPE {
    CHAT_TYPE_UNKNOWN = 0,
    CHAT_TYPE_GROUP = 1,
    CHAT_TYPE_PRIVATE,
};

//默认时间间隔
#define DEFAULT_TIME_DIST   10 //(60*10)

@protocol CommunicatChatViewControllerDelegate;

@interface ChatListViewController : BaseListViewController<ECClickableElementDelegate, ECItemUploaderDelegate,  UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, QPlusGeneralDelegate, QPlusSingleChatDelegate, QPlusProgressDelegate, QPlusPlaybackDelegate, QPlusGroupDelegate>
{
    UIToolbar *_customToolbar;
    UIBarButtonItem *_switchBarButtinItem;
    UITableView *_msgListView;
    UIButton *_backgroundCtrl;
    UITextField *_textField;
    
    UIButton *_voiceButton;
    UIButton *_changeModeButton;
    UIBarButtonItem *_voiceBarButtonItem;
    UIBarButtonItem *_whineModeBarButtonItem;
    
    NSString *_friendID, *_groupID, *_selfId;
    BOOL _isTextMode;
    QPlusWhineMode _currentMode;
    NSArray *_voiceModeItems;
    NSArray *_textModeItems;
    
    NSMutableDictionary *_downloadingCell;
    NSString *_currentClickUserID;
    int _playingIndex;
    int _currentClickIndex;
    
    NSMutableArray *ufriendList;
    BOOL _isJoin;
    
    //查询group member
    NSMutableArray *membersList;
    //
    NSMutableArray *allMessages;
}

@property (nonatomic, assign) id<CommunicatChatViewControllerDelegate> delegate;
@property (nonatomic) int newMessageCount;
@property (nonatomic) BOOL isWXMessage;

- (id)initWithFriendID:(NSString *)friendID;
- (id)initWithGroupID:(NSString *)groupID;

- (id) initWithData:(ChatGroupDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC fromCreate:(BOOL)isFromCreate;

/*!
 @method
 @abstract 初始化
 @discussion
 @param text ChatGroupDataModal RootViewController MOC
 @param error nil
 @result id
 */
- (id)initWithData:(ChatGroupDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC;

- (id)initWithPrivateData:(PrivateUserListDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC;

- (id)initWithPrivateDataWithUserBaseInfo:(UserBaseInfo *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC;

- (void)openProfile:(NSString*)authorId userType:(NSString*)userType;
- (void)successfulAddToGroup;

- (void)onReceiveMessage:(QPlusMessage *)message;
- (void)onDeleteGroupMesssage:(QPlusMessage *)message;
- (void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString *)tarID;

- (BOOL)showMessageTime:(QPlusMessage *)message dist:(long)timeDist;
- (BOOL)sendTextMsg:(NSString *)text;

@end

@protocol CommunicatChatViewControllerDelegate <NSObject>

@optional
- (void)updateGroupMessageInfo:(QPlusMessage *)message;

@end
