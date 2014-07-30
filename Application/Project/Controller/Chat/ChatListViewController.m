//
//  ChatListViewController.m
//  Project
//
//  Created by XXX on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChatListViewController.h"
#import "CommunicationListViewController.h"
#import "AppManager.h"
#import "QPlusProgressHud.h"
#import "QPlusAPI.h"
#import "QPlusDataBase.h"
#import "ChatListViewCell.h"
#import "CustomeAlertView.h"
#import "CommunicationPersonalInfoViewController.h"
#import "ChatGroupDataModal.h"
#import "CommunicatGroupMemberListViewController.h"
#import "CommonHeader.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "ECItemUploaderDelegate.h"
#import "WXWAsyncConnectorFacade.h"
#import "ChatListViewCell.h"
#import "BaseAppDelegate.h"
#import "HomepageContainerViewController.h"
#import "GoHighDBManager.h"
#import "ChatScrollViewController.h"
#import "ChatAddGroupViewController.h"
#import "iChatInstance.h"
#import "WXWCoreDataUtils.h"
#import "WXWDebugLogOutput.h"

#define TAG_DELSUCCESSFUL         0xEE
#define TAG_DELFAILURE                  0xEF

@interface ChatListViewController () <UITextFieldDelegate,QPlusProgressDelegate, UIScrollViewDelegate> {
    
    BOOL isInChat;
    ChatGroupDataModal *_chatGroupDataModal;
    UserBaseInfo *_userBaseInfo;
    UIView *_micView;
    UIImageView *_micStepImageView;
    NSTimer *_showStepMicTimer;//录音step
    NSTimer *_showStepPlayMicTimer;//播放step
    int _stepIndex;//录音stepIndex
    int _stepPlayIndex;//播放stepIndex
    
    enum CHAT_TYPE _chatType;
    
    int _marginX;
    int _bottomBarHeight ;
    
    UIView *_bottomChatView;
    
    UITextField *_chatContentTextField;
    
    BOOL _isRecording;
    BOOL _isPrivateFirstSend;
    
    double _lastMessageTime;
    BOOL isTakePic;
    
    int _lastTextCellClicked;
    
    BOOL keyboardIsShowing;
    CGFloat contentOffsetY;
    
    int _groupIsDeleted;
    
    BOOL _dataFromReload;
    
    NSInteger _sendingMessageCount;
}

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) int index;
//聊天界面异常退出,设定一个标识,只有返回按钮是不再登陆
- (void) notifierNetworkStatus:(NSNotification*)notification;
@end


static NSArray *whineOption;

@implementation ChatListViewController {
    
    UIBarButtonItem *_rightButton;
    BOOL _isFromCreate;
}

@synthesize delegate = _delegate;

- (id) initWithData:(ChatGroupDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC fromCreate:(BOOL)isFromCreate
{
    if ((self = [super initWithMOC:MOC needRefreshHeaderView:YES needRefreshFooterView:NO])) {
        
        _isFromCreate = isFromCreate;
        // Custom initialization
        membersList = [[NSMutableArray alloc] init];
        allMessages = [[NSMutableArray alloc] init];
        
        _chatGroupDataModal = [dataModal retain];
        _chatType = type;
        //        _groupID = _chatGroupDataModal.groupId;
        _groupID = [[NSString stringWithFormat:@"%@", _chatGroupDataModal.groupId] retain];
        [self getGroupInfo:[_groupID intValue]];
        self.navigationItem.title = _chatGroupDataModal.groupName;
    }
    
    return  self;
}

- (id) initWithData:(ChatGroupDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC
{
    if ((self = [super initWithMOC:MOC needRefreshHeaderView:YES needRefreshFooterView:NO])) {
        
        // Custom initialization
        membersList = [[NSMutableArray alloc] init];
        allMessages = [[NSMutableArray alloc] init];
        
        _chatGroupDataModal = [dataModal retain];
        _chatType = type;
        //        _groupID = _chatGroupDataModal.groupId;
        _groupID = [[NSString stringWithFormat:@"%@", _chatGroupDataModal.groupId] retain];
        
        self.navigationItem.title = dataModal.groupName;
    }
    
    return  self;
}


- (id)initWithPrivateData:(PrivateUserListDataModal *)dataModal withType:(enum CHAT_TYPE)type MOC:(NSManagedObjectContext *)MOC

{
    if ((self =  [super initWithMOC:MOC needRefreshHeaderView:YES needRefreshFooterView:NO])) {
        
        // Custom initialization
        membersList = [[NSMutableArray alloc] init];
        allMessages = [[NSMutableArray alloc] init];
        
        _userBaseInfo = [[GoHighDBManager instance] getUserInfoFromDB:[dataModal.userId integerValue]];
        _chatType = type;
        //        _groupID = _chatGroupDataModal.groupId;
        _friendID = [[NSString stringWithFormat:@"%d", _userBaseInfo.userID] retain];
        self.navigationItem.title = _userBaseInfo.chName;
    }
    
    return  self;
}

- (id)initWithPrivateDataWithUserBaseInfo:(UserBaseInfo *)dataModal
                                 withType:(enum CHAT_TYPE)type
                                      MOC:(NSManagedObjectContext *)MOC {
    
#if APP_TYPE == APP_TYPE_O2O
    if ((self =  [super initWithMOC:nil needRefreshHeaderView:NO needRefreshFooterView:NO])) {
        // Custom initialization
        membersList = [[NSMutableArray alloc] init];
        allMessages = [[NSMutableArray alloc] init];
        
        _userBaseInfo = dataModal;
        _chatType = type;
        //        _groupID = _chatGroupDataModal.groupId;
        _friendID = [[NSString stringWithFormat:@"%d", _userBaseInfo.userID] retain];
        self.navigationItem.title = _userBaseInfo.chName;
    }
#else
    if ((self =  [super initWithMOC:nil needRefreshHeaderView:YES needRefreshFooterView:NO])) {
        // Custom initialization
        membersList = [[NSMutableArray alloc] init];
        allMessages = [[NSMutableArray alloc] init];
        
        _userBaseInfo = dataModal;
        _chatType = type;
        //        _groupID = _chatGroupDataModal.groupId;
        _friendID = [[NSString stringWithFormat:@"%d", _userBaseInfo.userID] retain];
        self.navigationItem.title = _userBaseInfo.chName;
    }
#endif
    return  self;
}


- (id)initWithFriendID:(NSString *)friendID {
    
    if (self =  [super initWithMOC:nil needRefreshHeaderView:YES needRefreshFooterView:NO]) {
        [self initwhineOption];
        _friendID = [[NSString alloc]initWithString:friendID];
        allMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithGroupID:(NSString *)groupID {
    if (self =  [super initWithMOC:nil needRefreshHeaderView:YES needRefreshFooterView:NO]) {
        [self initwhineOption];
        _groupID = [[NSString alloc]initWithString:groupID];
        allMessages = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initwhineOption];
    }
    return self;
}

#pragma mark - load data from backend server

-(void)initwhineOption {
    _isTextMode = YES;
    _downloadingCell = [[NSMutableDictionary alloc] init];
}

-(void)initQPlusView {
    if (( [_chatGroupDataModal.canChat integerValue] == 0)
        && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED)  && [_chatGroupDataModal.groupType integerValue] != CHAT_GROUP_TYPE_PUBLIC) {
        [self initBottomAddGroupView:self.view];
    }else if ([_chatGroupDataModal.groupType integerValue] == CHAT_GROUP_TYPE_PUBLIC
              && [_chatGroupDataModal.canChat integerValue]) {
        [self successfulAddToGroup];
    }
    else {
        CGRect rect = _msgListView.frame;
        rect.size.height +=_bottomBarHeight - 2;
        _msgListView.frame = rect;
    }
    
}

-(void)showAddGroup {
    
    CGRect winSize = [[UIScreen mainScreen] bounds];
    
    _customToolbar.hidden = YES;
    
    UIImageView *addGroupTools = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_pic_bg_add_group.png"]] autorelease];
    addGroupTools.frame = CGRectMake(0, winSize.size.height - 106, winSize.size.width, 44);
    
    UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addGroupBtn addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    [addGroupBtn setImage:[UIImage imageNamed:@"add_group_bg.png"] forState:UIControlStateNormal];
    [addGroupBtn setTitle:LocaleStringForKey(NSICaddGroup, nil) forState:UIControlStateNormal];
    addGroupBtn.frame = CGRectMake( (winSize.size.width-100) / 2, winSize.size.height - 100, 100, 34);
    
    [self.view addSubview:addGroupTools];
    [self.view addSubview:addGroupBtn];
}

-(void)addGroup:(id)sender {
    
#if 0
    NSDictionary *paramDict = @{@"groupId":_group.groupId,
                                @"memberStatus": @"1",
                                @"userIds":[[AppManager instance] getUserIdFromLocal]};
    
    self.connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                  interactionContentType:ADD_GROUP_USER] autorelease];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppManager instance].hostUrl, AI_LIAO_USER_ADD_TO_GROUP];;
    
    [((WXWAsyncConnectorFacade *)self.connFacade) postCommonInfoDic:paramDict url:url];
#endif
}

-(void)exitGroup:(id)sender {
#if 0
    NSDictionary *paramDict = @{@"groupId":_group.groupId,
                                @"memberStatus": @"0",
                                @"userIds":[[AppManager instance] getUserIdFromLocal]};
    
    self.connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                  interactionContentType:EXIT_GROUP_USER] autorelease];
    NSString *url = [NSString stringWithFormat:@"%@%@", [AppManager instance].hostUrl, AI_LIAO_USER_EXIT_GROUP];;
    
    [((WXWAsyncConnectorFacade *)self.connFacade) postCommonInfoDic:paramDict url:url];
#endif
}


- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView
{
    [alertView release];
    
    if (( [_chatGroupDataModal.canChat integerValue] == 0 || [_chatGroupDataModal.groupType integerValue ] == CHAT_GROUP_TYPE_OPEN )
        && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED)) {
        [self initBottomAddGroupView:self.view];
    }
}

-(void)dochat {

    self.newMessageCount += 20;
    DLog(@"%d", self.newMessageCount);
    
    if ([self isPrivateChat]) {
        
        [self successfulAddToGroup];
        
        [QPlusAPI reqHistoryMessagesByTargetID:_friendID targetType:Friend lastMessage:nil count:self.newMessageCount];
        
    } else if ([self isGroupChat]) {
        if ([_chatGroupDataModal.canChat integerValue]
            && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED))
            [self successfulAddToGroup];
        else
            [self initQPlusView];
        
        if ([_chatGroupDataModal.canViewLog integerValue]
            && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED)) {
            int req = [QPlusAPI reqHistoryMessagesByTargetID:_groupID targetType:Group lastMessage:nil count:self.newMessageCount];
            DLog(@"%d", req);
        }
        
        
        if ([_chatGroupDataModal.canChat integerValue] == 0
            && ( [_chatGroupDataModal.userStatus integerValue] == USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] == USER_STATUS_REFUSED)) {
            
            [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"请加入群组查看聊天内容", nil)
                                             msgType:INFO_TY
                                  belowNavigationBar:YES];
            
        }
    }
}


- (void)onLoginSuccess:(BOOL)isRelogin {
    
    if(isInChat) {
        return ;
    }
    
    isInChat = YES;
    
    [QPlusProgressHud hideLoading];
    [QPlusDataBase setLoginUserID:_selfId];
    
    [self dochat];
}

- (void)onLoginCanceled {
    [QPlusProgressHud hideLoading];
    if(isInChat) {
        return ;
    }
}

- (void)onLoginFailed:(QPlusLoginError)error {
    [QPlusProgressHud hideLoading];
    
    if(isInChat) {
        return ;
    }
    
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatLoginFail, nil)
                                     msgType:INFO_TY
                          belowNavigationBar:YES];
}

- (void)onLogout:(QPlusLoginError)error {
    
    if(isInChat) {
        [QPlusAPI loginWithUserID:_selfId];
    } else {
        if (error != 0) {
            [QPlusAPI removeAllListeners];
            
            //ICchatLogoutFail
            [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatLogoutFail, nil)
                                             msgType:INFO_TY
                                  belowNavigationBar:YES];
        }
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    DLog(@"%d", self.newMessageCount);
    
    isInChat = NO;
    self.index = 0;
    
    [QPlusDataBase clearDatabase];
    
    self.view.backgroundColor = [UIColor clearColor];//DEFAULT_VIEW_COLOR;
    _marginX = 0;
    _bottomBarHeight = 44;
    _sendingMessageCount = 0;
    
    [self initLisentingKeyboard];
    self.view.userInteractionEnabled = YES;
    [CommonMethod viewAddGuestureRecognizer:self.view withTarget:self withSEL:@selector(viewTapped:)];
    
    [self initMessageListView:self.view];
    
    [self initRightNavButton];
    [self initMicView];
    
    
    //设置爱聊
    [self loadJoinILiao:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    _groupIsDeleted = [[GoHighDBManager instance] getGroupIsDeleted:_groupID];
    
    debugLog(@"chat view viewDidLoad");
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifierNetworkStatus:) name:NOTIFY_NETWORK_STATUS object:nil];
}

-(void)getGroupInfo:(int)groupId
{
    self.entityName = @"ChatGroupDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = [NSPredicate predicateWithFormat:@"groupId == %d",groupId];
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (self.fetchedRC.fetchedObjects.count) {
        _chatGroupDataModal = [self.fetchedRC.fetchedObjects objectAtIndex:0];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isPrivateFirstSend = FALSE;
    
    _lastMessageTime = 0;
    
    if (_chatType == CHAT_TYPE_GROUP) {
        
        [self getGroupInfo:[_groupID integerValue]];
        self.navigationItem.title = _chatGroupDataModal.groupName;
    }
    if (!isTakePic) {
        [[iChatInstance instance] registerListener:self];
        
        [self dochat];
    }
    
    [self refreshMsgList:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    _isPrivateFirstSend = FALSE;
    if ([self isPrivateChat]) {
        DLog(@"%@", _friendID);
        [self loadSubmitPrivateLetter:TRIGGERED_BY_AUTOLOAD forNew:YES type:FRIEND_TYPE_UPDATE];
        
        
        [[GoHighDBManager instance] setPrivateMessageReaded:_friendID];
        
    } else if ([self isGroupChat]) {
        
        [[GoHighDBManager instance] setGroupMessageReaded:[_chatGroupDataModal.groupId stringValue]];
    }
    
    if (!isTakePic) {
        [[iChatInstance instance] unRegisterListener:self];
    }
    
    if (_sendingMessageCount > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_REFRESH_CHAT_GROUP object:nil userInfo:nil];
    }
    
    [self onPlayStop];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [allMessages removeAllObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [membersList release];
    [allMessages release];
    [_rightButton release];
    [_downloadingCell release];
    [_msgListView release];
    [_micView release];
    [_micStepImageView release];
    [_chatContentTextField release];
    
    [super dealloc];
}

- (void)initRightNavButton
{
    //---------------------------------
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightButton.frame = CGRectMake(0, 0, 24,20);
    [rightButton addTarget: self action: @selector(rightNavButtonClicked:) forControlEvents: UIControlEventTouchUpInside];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"communication_bar_detail.png"] forState:UIControlStateNormal];
    
    _rightButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    [_rightButton setStyle:UIBarButtonItemStyleDone];
    if (!_isWXMessage) {
        self.navigationItem.rightBarButtonItem = _rightButton;
    }
}

- (BOOL)showMessageTime:(QPlusMessage *)message dist:(long)timeDist
{
    if ( abs(message.date - _lastMessageTime) > timeDist  ) {
        _lastMessageTime = message.date;
        return YES;
    }
    return NO;
}

- (void) notifierNetworkStatus:(NSNotification *)notification {
    
    if (notification.userInfo != nil) {
        static NetworkConnectionStatus oldStatus = NetworkConnectionStatusOn;
        NetworkConnectionStatus status = [[notification.userInfo objectForKey:@"status"] integerValue];
        
        
        NSString* string = self.navigationItem.title;
        switch (status) {
            case NetworkConnectionStatusOff:
                string = @"未连接";
                break;
            case NetworkConnectionStatusLoading:
            case NetworkConnectionStatusDoing:
                string = @"正在连接...";
                break;
            case NetworkConnectionStatusOn:
            case NetworkConnectionStatusDone:
                string = _chatGroupDataModal.groupName;
                break;
            default:
                break;
        }
        oldStatus = status;

        self.navigationItem.title = [NSString stringWithFormat:@"%@", string];
    }
    
}

#pragma mark -- receive message
- (void)onReceiveMessage:(QPlusMessage *)message
{
    if ([self isGroupChat]) {
        [QPlusDataBase addGroupMsg:message inGroup:message.receiverID];
    }
    else if ([self isPrivateChat]) {
        if (message.senderID.intValue == _friendID.intValue)
            [QPlusDataBase addFriendMsg:message withFriend:_friendID];
        else
            return;
    }
    
    [self refreshMsgList:YES];
    
    
    if (![message.receiverID  isEqualToString:_groupID]) {
        if (_delegate && [_delegate respondsToSelector:@selector(updateGroupMessageInfo:)]) {
            [_delegate  updateGroupMessageInfo:message];
        }
    }
    //
    //    _chatGroupDataModal.lastMessageTime = [CommonMethod convertLongTimeToString:message.date];
}


-(void)onDeleteGroupMesssage:(QPlusMessage *)message
{
    //    message.text = LocaleStringForKey(NSGroupDeleted, nil);
    [self onReceiveMessage:message];
    
    _groupIsDeleted = 1;
}

- (void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString *)tarID
{
    
    @try {
        
    
    [QPlusDataBase clearDatabase];
    
    [super connectDone:nil url:nil contentType:-1 closeAsyncLoadingView:YES];
    
    if(msgList == nil)
    {
        return;
    }
    
    for(QPlusMessage *message in msgList)
    {
        if(type==Group)
        {
            [QPlusDataBase addGroupMsg:message inGroup: tarID];
            //            [[GoHighDBManager instance] insertChatIntoDB:message groupId:tarID];
        }
        else
        {
            [QPlusDataBase addToFriendList: tarID];
            [QPlusDataBase addFriendMsg:message withFriend: tarID];
            
            //            [[GoHighDBManager instance] insertChatIntoDB:message groupId:_friendID];
        }
    }
    
    [self refreshMsgList:NO];
    
    [_msgListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_msgListView numberOfRowsInSection:0] - 1
                                                            inSection:0]
                        atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    
    if (!_dataFromReload)
    {
        NSUInteger count = [_msgListView numberOfRowsInSection:0];
        if(count==0)
        {
            return;
        }
        
        [_msgListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1
                                                                inSection:0]
                            atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%d:%d:%d:%@",msgList.count,[_msgListView numberOfSections],[_msgListView numberOfRowsInSection:0], exception);
    }
    @finally {
        
    }
}

- (void)onStartVoice:(QPlusMessage *)voiceMessage {
    if ([self isGroupChat]) {
        [QPlusDataBase addGroupMsg:voiceMessage inGroup:_groupID];
        [allMessages removeAllObjects];
        [self refreshMsgList:YES];
    }
    else if ([self isPrivateChat]) {
        
        [self privateSubmitPrivateLetter];
        
        [QPlusDataBase addFriendMsg:voiceMessage withFriend:_friendID];
        [allMessages removeAllObjects];
        [self refreshMsgList:YES];
    }
}

- (void)onRecording:(QPlusMessage *)voiceMessage size:(int)dataSize duration:(long)duration {
    //    NSArray *msgArray = [self getMsgArray];
    if (allMessages != nil) {
        [_msgListView reloadData];
    }
}

- (void)onRecordError:(QPlusRecordError)error {
    //
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatRecordFail, nil)
                                     msgType:INFO_TY
                          belowNavigationBar:YES];
    
    [[iChatInstance instance] imRelogin];
}

- (void)onStopVoice:(QPlusMessage *)voiceMessage {
}

- (void)onSendMessage:(QPlusMessage *)message result:(BOOL)isSuccessful {
}

- (void)onAddFriend:(NSString *)friendID result:(BOOL)isSuccessful {
}

- (void)onDeleteFriend:(NSString *)friendID result:(BOOL)isSuccessful {
}

- (void)onGetRes:(QPlusMessage *)message result:(BOOL)isSuccessful {
    //    [_downloadingCell removeObjectForKey:message.uuid];
    //    [_msgListView reloadData];
    if (isSuccessful) {
        
        if (message.type == BIG_IMAGE) {
            QPlusImageObject *imageObject = message.mediaObject;
            
            ChatListViewCell *cell = _downloadingCell[imageObject.resURL];
            if (cell != nil) {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *resFilePath = [paths objectAtIndex:0];
                NSString *savePath = @"";//[resFilePath stringByAppendingPathComponent:message.uuid];
                
                if (imageObject.resURL !=nil && ![imageObject.resURL isEqual:[NSNull null]] && imageObject.resURL.length > 0) {
                    
                    savePath = [resFilePath stringByAppendingPathComponent:[CommonMethod convertURLToLocal:imageObject.resURL]];
                }else{
                    
                    savePath = [resFilePath stringByAppendingPathComponent:message.uuid];
                }
                
                
                [_downloadingCell removeObjectForKey:imageObject.resURL];
                [_msgListView reloadData];
                
                
                UIImage *image = [[[UIImage alloc]initWithContentsOfFile:savePath] autorelease];
                
                [self openImage:image];
            }
            
        }
        
    }
    
    
}

- (void)onProgressUpdate:(QPlusMessage *)msgObejct percent:(float)percent {
    //    ChatListViewCell *cell = _downloadingCell[msgObejct.uuid];
    //    if (cell != nil) {
    //        int percentage = percent * 100;
    //        cell.secbubbleLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
    //        if (percentage >= 100) {
    //            [_downloadingCell removeObjectForKey:msgObejct.uuid];
    //            [_msgListView reloadData];
    //
    //
    //            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //            NSString *resFilePath = [paths objectAtIndex:0];
    //            NSString *savePath = [resFilePath stringByAppendingPathComponent:msgObejct.uuid];
    //
    //            UIImage *  image = [[[UIImage alloc]initWithContentsOfFile:savePath] autorelease];
    //
    //            [self openImage:image];
    //        }
    //    }
    
    if (msgObejct.type == BIG_IMAGE)
    {
        
        QPlusImageObject *imageObject = msgObejct.mediaObject;
        
        ChatListViewCell *cell = _downloadingCell[imageObject.resURL];
        if (cell != nil) {
            int percentage = percent * 100;
            cell.secbubbleLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
        }
    }else if (msgObejct.type == VOICE) {
        QPlusVoiceObject *voiceObject = msgObejct.mediaObject;
        
        ChatListViewCell *cell = _downloadingCell[voiceObject.resID];
        if (cell != nil) {
            int percentage = percent * 100;
            cell.secbubbleLabel.text = [NSString stringWithFormat:@"%d%%", percentage];
        }
    }
    
    
}


#pragma mark -- qplusplaybackdelegate

- (void)startShowPlayMicStepViewTimerCallback:(NSTimer *)callBackTimer
{
    NSString *imageName = @"";
    
    ChatListViewCell *cell = [callBackTimer userInfo];
    DLog(@"%@", cell.userNameLabel.text);
    if (cell.isSelf)
        imageName = [NSString stringWithFormat:@"voice_right%d.png", _stepPlayIndex++ % 3 + 1];
    else
        imageName = [NSString stringWithFormat:@"voice_left%d.png", _stepPlayIndex++ % 3 + 1];
    
    [cell updateBubbleVoiceImage:IMAGE_WITH_IMAGE_NAME(imageName)];
}

- (void)startShowPlayMicView:(ChatListViewCell *)cell
{
    [cell setPlayedIcon];
    _stepPlayIndex = 0;
    [self stopShowPlayMicView:cell];
    cell.voiceIconTimer= [NSTimer scheduledTimerWithTimeInterval:0.2
                                                          target:self
                                                        selector:@selector(startShowPlayMicStepViewTimerCallback:)
                                                        userInfo:cell
                                                         repeats:YES];
}

- (void)stopShowPlayMicView:(ChatListViewCell *)cell
{
    [cell.voiceIconTimer invalidate];
    cell.voiceIconTimer = nil;
    
    if (cell.isSelf)
        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right3.png"];
    else
        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left3.png"];
    
}

- (void)onPlayStart {
    _playingIndex = _currentClickIndex;
    
    if (_playingIndex >= 0) {
        
        QPlusMessage *msg = nil;
        if (allMessages && allMessages.count > _playingIndex) {
            msg = [allMessages objectAtIndex:_playingIndex];
        }
        if (!msg) {
            return;
        }
        
        ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0]];
        
        
        QPlusVoiceObject *voiceObject = msg.mediaObject;
        if (cell.isSelf) {
            cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right3.png"];
        }
        else {
            if (![msg.senderID isEqualToString:[[AppManager instance] userId]])
                [[GoHighDBManager instance] setVoiceMessageListened:msg];
            cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left3.png"];
        }
        
        cell.secbubbleLabel.text = [NSString stringWithFormat:@"%ld''", voiceObject.duration/1000];
        [self startShowPlayMicView:cell];
    }
}

- (void)onPlaying:(float)duration {
    if (_playingIndex >= 0) {
        ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0]];
        int second = duration / 1000;
        
        cell.secbubbleLabel.text = [NSString stringWithFormat:@"%d''", second];
    }else{
        
    }
}

- (void)onPlayStop {
    if (_playingIndex >= 0) {
        
        //        QPlusMessage *msg = [self getMsgArray][_playingIndex];
        
        QPlusMessage *msg = nil;
        
        if (allMessages && allMessages.count > _playingIndex) {
            msg = [allMessages objectAtIndex:_playingIndex];
        }
        if (!msg) {
            return;
        }
        ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0]];
        
        [self stopShowPlayMicView:cell];
        
        QPlusVoiceObject *voiceObject = msg.mediaObject;
        if (cell.isSelf)
            cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right3.png"];
        else
            cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left3.png"];
        cell.secbubbleLabel.text = [NSString stringWithFormat:@"%ld''", voiceObject.duration/1000];
        _playingIndex = -1;
        [_msgListView reloadData];
        
    }
    
}

- (void)onError {
    if (_playingIndex >= 0) {
        
        //        QPlusMessage *msg = [self getMsgArray][_playingIndex];
        QPlusMessage *msg = nil;
        
        if (allMessages && allMessages.count > _playingIndex) {
            msg = [allMessages objectAtIndex:_playingIndex];
        }
        if (!msg) {
            return;
        }
        
        ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0]];
        QPlusVoiceObject *voiceObject = msg.mediaObject;
        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"playBtn"];
        
        cell.secbubbleLabel.text = [NSString stringWithFormat:@"%ld''", voiceObject.duration/1000];
        _playingIndex = -1;
        [_msgListView reloadData];
    }
}
#pragma mark -- add group button click
- (void)addGroupButtonClicked:(id)sender
{
    [self loadJoinChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

#pragma mark -- nav bar  clicked
- (void)rightNavButtonClicked:(id)sender
{
    if ([self isPrivateChat]) {
        CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:_userBaseInfo.userID withDelegate:self  isFromChatVC:TRUE];
        //    [vc initWithUserId:_userProfile.userID withDelegate:nil];
        [CommonMethod pushViewController:vc withAnimated:YES];
        
    } else if ([self isGroupChat]) {
        
        [self getGroupInfo:[_groupID integerValue]];
        
        CommunicatGroupMemberListViewController *vc = [[[CommunicatGroupMemberListViewController alloc] initWithMOC:_MOC parentVC:self.parentVC withDataModal:_chatGroupDataModal] autorelease];
        for (UIViewController* viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[HomepageContainerViewController class]]) {
                
                HomepageContainerViewController* homeController = (HomepageContainerViewController*)viewController;
                if ([homeController.currentVC isKindOfClass:[CommunicationListViewController class]]) {
                    vc.delegate = (id)homeController.currentVC;
                }
                break;
            }
        }
        
        [CommonMethod pushViewController:vc withAnimated:YES];
    }
    
}

#pragma mark - table view data source -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *msgArray = [self getMsgArray];
    DLog(@"allMessages Count:%d",msgArray.count);
    return [msgArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    @try {
    if (indexPath.row == [allMessages count]) {
        return [self drawFooterCell];
    } else {
        
        int row = indexPath.row;
        QPlusMessage *msg = allMessages[row];
        NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier_%d", row];
        
        DLog(@"sendUser:%@", msg.senderID);
        
        Alumni *alumni = nil;
        
        ChatListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UserBaseInfo *userBaseInfo =  [[GoHighDBManager instance] getUserInfoFromDB:[msg.senderID integerValue]];
        
        if (cell == nil) {
            
            cell = [[[ChatListViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     message:msg
                                             reuseIdentifier:CellIdentifier
                                      imageClickableDelegate:self
                                                      alumni:alumni
                                                      selfId:msg.senderID
                                                         row:row
                                                    userInfo:userBaseInfo
                                                    showTime:NO /* row == 0 ? YES : [self showMessageTime:msg dist:DEFAULT_TIME_DIST]*/] autorelease];
            cell.backgroundColor = TRANSPARENT_COLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.parentView = self.view;
            
            if (msg.type == VOICE) {
                if([[GoHighDBManager instance] getVoiceMessageListened:msg])
                    [cell setPlayedIcon];
            }
        }
        
        [cell updateUserBaseInfo:userBaseInfo message:msg];

        if (row == 0) {
            [cell drawChat:msg row:row showTime:YES];
        } else {
            [cell drawChat:msg row:row showTime:[self showMessageTime:msg dist:DEFAULT_TIME_DIST]];
        }
        
        if (_isRecording && row == [allMessages count] - 1) {
            [cell updateTimer:msg];
        }
        return cell;
    }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        
    }
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSArray *msgArray = [self getMsgArray];
    if (indexPath.row >= [allMessages count] ) {
        return 50;
    }
    
    int row = indexPath.row;
    CGFloat height = [ChatListViewCell calculateHeightForMsg:allMessages[row]];
    return height+25;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
    //        NSUInteger count = [_msgListView numberOfRowsInSection:0];
    //        if (count > 0) {
    //            [_msgListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1
    //                                                                    inSection:0]
    //                                atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    //        }
    //
    //    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)switchMode:(id)sender{
    
    if (_isTextMode) {
        _customToolbar.items = _voiceModeItems;
        ((UIBarButtonItem *)_customToolbar.items[0]).title = LocaleStringForKey(NSICchatTextMode, nil);
    } else {
        _customToolbar.items = _textModeItems;
        ((UIBarButtonItem *)_customToolbar.items[0]).title = LocaleStringForKey(NSICchatRecordMode, nil);
    }
    
    _isTextMode = !_isTextMode;
}

- (void)pictureBtnClicked:(id)sender {
    
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    }else{
        
        debugLog(@"pictureBtnClicked:sender:%@", [AppManager instance].userId);
        
        UIActionSheet *sheet = [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:LocaleStringForKey(NSCancelTitle, nil) destructiveButtonTitle:nil otherButtonTitles:LocaleStringForKey(NSTakePhotoTitle, nil), LocaleStringForKey(NSChooseExistingPhotoTitle, nil), nil] autorelease];
        sheet.tag = 1;
        [sheet showInView:self.view];
    }
}

- (void)backgroundCtrlClicked:(id)sender {
    [_textField resignFirstResponder];
}

- (void)whineOptionClicked:(id)sender {
    UIActionSheet *sheet = [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"原声", @"圣诞老人", @"擎天柱", @"海豚音", @"娃娃音", @"低音炮", nil] autorelease];
    sheet.tag = 2;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)sendBtnClicked:(id)sender {
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    }else{
        NSString *text = _chatContentTextField.text;
        if (text.length > 0) {
            if ([self sendTextMsg:text]) {
                _chatContentTextField.text = @"";
            }
        }
    }
}

- (void)manageFriendBtnClicked:(id)sender {
    if ([QPlusDataBase isFriend:_friendID]) {
        [self deleteFriend:_friendID];
    } else {
        [self addFriend:_friendID];
    }
}

- (void)voiceButtonDown:(id)sender {
    
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    }else{
        
        debugLog(@"voiceButtonDown:sender:%@", [AppManager instance].userId);
        
        [self startShowMicView];
        _isRecording = TRUE;
        if ([self isGroupChat]) {
            [QPlusAPI startVoiceInGroup:_groupID whineMode:_currentMode];
        } else if ([self isPrivateChat]) {
            [QPlusAPI startVoiceToUser:_friendID whineMode:_currentMode];
        }
    }
}

-(void)stopRecordVoice:(id)sender
{
    [self stopShowMicView];
    _isRecording=FALSE;
    [QPlusAPI stopVoice];
}

- (void)voiceButtonUp:(id)sender {
    //多录制2秒
    debugLog(@"voiceButtonUp:sender:%@", [AppManager instance].userId);
    [self performSelector:@selector(stopRecordVoice:) withObject:nil afterDelay:0.8f];
}

- (void)headBtnClicked:(id)sender {
    
}

- (void)imageButtonClicked:(id)sender {
    UIButton *btn = (id)sender;
    
    if (btn.tag < allMessages.count) {
        
        QPlusMessage *msg = allMessages[btn.tag];
        if (msg != nil) {
            
            QPlusImageObject *imageObject = msg.mediaObject;
            
            if (_downloadingCell[imageObject.resURL]) {
                return;
            }
            
            if (msg.type == BIG_IMAGE && imageObject.resPath.length == 0) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *resFilePath = [paths objectAtIndex:0];
                NSString *savePath =@"";
                
                //            [resFilePath stringByAppendingPathComponent:msg.uuid];
                
                if (imageObject.resURL !=nil && ![imageObject.resURL isEqual:[NSNull null]] && imageObject.resURL.length > 0) {
                    
                    savePath = [resFilePath stringByAppendingPathComponent:[CommonMethod convertURLToLocal:imageObject.resURL]];
                } else {
                    
                    savePath=[resFilePath stringByAppendingPathComponent:msg.uuid];
                }
                
                if ([CommonMethod isExist:savePath]) {
                    UIImage *image = [[[UIImage alloc]initWithContentsOfFile:savePath] autorelease];
                    
                    [self openImage:image];
                } else {
                    [QPlusAPI downloadRes:msg saveTo:savePath progressDelegate:self];
                    ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
                    
                    [_downloadingCell setObject:cell forKey:imageObject.resURL];
                }
            } else if (msg.type == SMALL_IMAGE){
                [self openImage:[[[UIImage alloc]initWithData:imageObject.thumbData] autorelease]];
            } else {
                [self openImage:[UIImage imageWithContentsOfFile:imageObject.resPath]];
            }
        }
    } else {
        debugLog(@"array overflow: tag:%d count:%d", btn.tag, allMessages.count);
    }
}

- (void)voiceBtnClicked:(id)sender {
    
    UIButton *btn = (id)sender;
    if (btn.tag < allMessages.count) {
        QPlusMessage *msg = allMessages[btn.tag];
        
        if (msg != nil) {
            
            QPlusVoiceObject *voiceObject = msg.mediaObject;
            
            if (_downloadingCell[voiceObject.resID]) {
                return;
            }
            
            ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
            if (msg.type == VOICE && voiceObject.resPath.length == 0) {
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *resFilePath = [paths objectAtIndex:0];
                NSString *savePath = [resFilePath stringByAppendingPathComponent:msg.uuid];
                [QPlusAPI downloadRes:msg saveTo:savePath progressDelegate:self];
                
                cell.secbubbleLabel.hidden = NO;
                cell.secbubbleLabel.text = @"0%";
                [_downloadingCell setObject:cell forKey:voiceObject.resID];
            } else if (msg.type == VOICE) {
                _currentClickIndex = btn.tag;
                if (_playingIndex == btn.tag) {
                    [QPlusAPI stopPlayVoice];
                    if (cell.isSelf)
                        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right3.png"];
                    else
                        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left3.png"];
                    
                    cell.secbubbleLabel.text = [NSString stringWithFormat:@"%ld''", voiceObject.duration/1000];
                    _playingIndex = -1;
                    [self stopShowPlayMicView:cell];
                    
                } else {
                    
                    if (_playingIndex >= 0) {
                        QPlusMessage *oldMsg = allMessages[_playingIndex];
                        
                        QPlusVoiceObject *oldVoiceObject = oldMsg.mediaObject;
                        ChatListViewCell *oldCell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_playingIndex inSection:0]];
                        if (oldCell.isSelf)
                            oldCell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right1.png"];
                        else
                            oldCell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left1.png"];
                        oldCell.secbubbleLabel.text = [NSString stringWithFormat:@"%ld''", oldVoiceObject.duration/1000];
                        [self stopShowPlayMicView:oldCell];
                        
                    }
                    [QPlusAPI startPlayVoice:voiceObject.resPath playbackDelegate:self];
                    if (cell.isSelf)
                        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_right3.png"];
                    else
                        cell.bubbleVoiceImage.image = [UIImage imageNamed:@"voice_left3.png"];
                    cell.secbubbleLabel.text = @"0''";
                    
                }
            }
        }
    } else {
        debugLog(@"voice btn overflow count:%d tag:%d",allMessages.count, btn.tag);
    }
}

-(void)copyBtnClicked:(id)sender
{
    UIButton *btn = (id)sender;
    //        ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    
    _lastTextCellClicked = btn.tag;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    isTakePic = TRUE;
    switch (actionSheet.tag) {
        case 1:
            switch (buttonIndex) {
                case 0:
                    [self showCamera];
                    break;
                case 1:
                    [self showGallery];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            if (buttonIndex < [whineOption count]) {
                _currentMode = buttonIndex;
                ((UIBarButtonItem *)[_customToolbar.items lastObject]).title = whineOption[_currentMode];
            }
            break;
        case 3:
            switch (buttonIndex) {
                case 0:
                    [self showPrivateDialogTo:_currentClickUserID];
                    break;
                    //                case 1:
                    //                    [self showSingleChatView:_currentClickUserID];
                    //                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch (buttonIndex) {
                case 0:
                    [self addFriend:_currentClickUserID];
                    break;
                case 1:
                    [self showPrivateDialogTo:_currentClickUserID];
                    break;
                    //                case 2:
                    //                    [self showSingleChatView:_currentClickUserID];
                    //                    break;
                default:
                    break;
            }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
        }
    }
    else
        if(alertView.tag == TAG_DELSUCCESSFUL)
        {
            [QPlusDataBase removeFromFriendList:_friendID];
            [self back:nil];
        }
}

- (void)showPrivateDialogTo:(NSString *)userID {
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发送私聊给:%@",userID] message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
    //    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //    alert.tag = 1;
    //    [alert show];
}

- (void)addFriend:(NSString *)userID {
    [QPlusProgressHud showLoading];
    [QPlusAPI reqAddFriendWithID:userID];
}

- (void)deleteFriend:(NSString *)userID {
    [QPlusProgressHud showLoading];
    [QPlusAPI reqDeleteFriendWithID:userID];
}

- (void)showSingleChatView:(NSString *)userID {
#if 0
    IChatViewViewController *chatView = [[IChatViewViewController alloc]initWithFriendID:userID];
    [self.navigationController pushViewController:chatView animated:YES];
#endif
}

- (void)showGallery {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = NO;
    
    [self presentModalViewController:imagePicker animated:YES];
    [imagePicker release];
}

- (void)showCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = NO;
        
        [self presentModalViewController:imagePicker animated:YES];
        [imagePicker release];
    } else {
        [self showGallery];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if( ! [self sendPicMsg:image] ) {
        [self popSendFailed];
    }
}

- (void)back:(id)sender
{
    isInChat = NO;
    
    [QPlusAPI stopPlayVoice];
    
    if (!_isFromCreate) {
        [self backToMainView];
    }else{
        [self backToListView];
    }
}

-(void)backToMainView
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToListView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- keyboard
- (void)initLisentingKeyboard
{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHideNotify:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
//    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
//    if (version >= 5.0) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShowNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    }
#endif
}

- (NSArray *)getMsgArray {
    
    NSArray *msgArray = nil;
    if ([self isGroupChat]) {
        msgArray = [QPlusDataBase getGroupMsgList:_groupID];
    }
    else if ([self isPrivateChat]) {
        msgArray = [QPlusDataBase getFriendMsgList:_friendID];
    }
    
    for (int i = msgArray.count - 1; i >= 0; i--) {
        QPlusMessage *obj = (QPlusMessage *)msgArray[i];
        if (![allMessages containsObject:obj]) {
//            [allMessages insertObject:obj atIndex:0];
            
            if (allMessages.count > 0) {
                QPlusMessage *firstObj = [allMessages objectAtIndex:0];
                QPlusMessage *lastObj = [allMessages objectAtIndex:allMessages.count - 1];
                if (obj.date > lastObj.date) {
                    
                    [allMessages insertObject:obj atIndex:allMessages.count];
                    
                    
                }else if(obj.date < firstObj.date) {
                    [allMessages insertObject:obj atIndex:0];
                }
                
            }else{
                [allMessages addObject:obj];
            }
        }
    }
    
    return allMessages;
}

- (BOOL)sendTextMsg:(NSString *)text {
    
    debugLog(@"sendTextMsg:index:%d, sender:%@, %@", ++self.index,[AppManager instance].userId, text);
    if ([self isGroupChat]) {
        QPlusMessage *msg = [QPlusAPI sendText:text inGroup:_groupID];
        if (msg != nil) {
            msg.isRoomMsg = TRUE;
            [[GoHighDBManager instance] insertChatIntoDB:msg groupId:_groupID isRead:1];
            [QPlusDataBase addGroupMsg:msg inGroup:_groupID];
//            [allMessages removeAllObjects];
            [self refreshMsgList:YES];
            
            _sendingMessageCount++;
            return YES;
            
        }
        return NO;
    } else if ([self isPrivateChat]) {
        QPlusMessage *msg = [QPlusAPI sendText:text toUser:_friendID];
        if (msg != nil) {
            [[GoHighDBManager instance] insertChatIntoDB:msg groupId:_friendID isRead:1];
            [QPlusDataBase addFriendMsg:msg withFriend:_friendID];
//            [allMessages removeAllObjects];
            [self refreshMsgList:YES];
            
            [self privateSubmitPrivateLetter];
            
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

- (BOOL)sendPicMsg:(UIImage *)image {
    
    isTakePic = FALSE;
    if ([self isGroupChat]) {
        QPlusMessage *msg = [QPlusAPI sendPic:image inGroup:_groupID];
        if (msg != nil) {
            [QPlusDataBase addGroupMsg:msg inGroup:_groupID];
//            [allMessages removeAllObjects];
            [self refreshMsgList:YES];
            return YES;
        } else {
            return NO;
        }
    }
    else if ([self isPrivateChat]) {
        QPlusMessage *msg = [QPlusAPI sendPic:image toUser:_friendID];
        if (msg != nil) {
            [QPlusDataBase addFriendMsg:msg withFriend:_friendID];
//            [allMessages removeAllObjects];
            [self refreshMsgList:YES];
            
            [self privateSubmitPrivateLetter];
            
            return YES;
        } else {
            return NO;
        }
    }
    
    return NO;
}

- (void)refreshMsgList:(BOOL)scrollToEnd {
    _currentClickIndex = -2;
    _playingIndex = -1;
    [_downloadingCell removeAllObjects];
    
    //    [allMessages removeAllObjects];
    [_msgListView reloadData];
    if (scrollToEnd) {
        NSUInteger count = [_msgListView numberOfRowsInSection:0];
        if(count==0)
        {
            return;
        }
        
        [_msgListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count - 1
                                                                inSection:0]
                            atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

- (void)onGetFriendList:(NSArray *)friendList {
    if (friendList != nil) {
        [QPlusDataBase initFriendList:friendList];
        [self refreshList];
    }
}

-(void)refreshList
{
    [self dochat];
}

-(void)onGetNoticeList:(NSArray *)noticeList
{
    if(noticeList!=nil)
    {
        for(QPlusMessage *msg in noticeList)
            [QPlusDataBase addFriendMsg:msg withFriend:NICKNAME_NOTICE];
        
        //[self refreshList];
    }
}

- (void)backToHomepage:(id)sender {
    [super backToHomepage:sender];
}

- (void)openProfile:(NSString*)userId userType:(NSString*)userType
{
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:[userId integerValue]  withDelegate:self  isFromChatVC:FALSE];
    //    [vc initWithUserId:_userProfile.userID withDelegate:nil];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
#if APP_TYPE != APP_TYPE_O2O
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
#endif
    [super connectStarted:url contentType:contentType];
}


- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType ) {
        case -1:
        {
            _noNeedDisplayEmptyMsg = YES;
            [super connectDone:result
                           url:url
                   contentType:contentType];
            //            [super connectDone:result url:url contentType:contentType closeAsyncLoadingView:YES];
            return;
        }
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
        {
            NSInteger ret = [JSONParser parserResponseJsonData:result
                                                          type:contentType
                                                           MOC:_MOC
                                             connectorDelegate:self
                                                           url:url
                                                       paramID:0];
            
            if(ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"您已申请加入该群组", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
            }
            else if(ret == GROUP_REJECT_JOIN) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep1Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            else if(ret == GROUP_APPLY_JOINED) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep2Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }else {
                
                [WXWUIUtils showNotificationOnTopWithMsg:[NSString stringWithFormat:@"错误代码:%d", ret]
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            
            [super connectDone:result url:url contentType:contentType closeAsyncLoadingView:YES];
        }
            
            return;
            
        default:
            break;
    }
    
    [super connectDone:result
                   url:url
           contentType:contentType];
}

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url
          contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
    
    [super connectDone:nil url:url contentType:contentType closeAsyncLoadingView:YES];
}


#pragma mark --

-(NSString *)getVoiceCachePath:(QPlusMessage *)msg{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *resFilePath = [paths objectAtIndex:0];
    NSString *savePath = [resFilePath stringByAppendingPathComponent:msg.uuid];
    return savePath;
}

-(void)getGroupMemberList:(id)sender {
#if 0
    [membersList removeAllObjects];
    
    NSDictionary *paramDict = @{
                                @"groupId":_groupID,
                                @"page":@"0",
                                @"pageSize":@"10",
                                @"keywords":@""};
    
    NSString *url = [CommonUtils geneJSONUrl:paramDict itemType:GET_GROUP_MEMBERS_TY];
    ECAsyncConnectorFacade *connFacade = [[[ECAsyncConnectorFacade alloc] initWithDelegate:self
                                                                    interactionContentType:GET_GROUP_MEMBERS_TY] autorelease];
    [connFacade fetchGets:url];
#endif
}

- (void)getMemberListValueArray {
#if 0
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    self.descriptors = [NSMutableArray array];
    
    NSSortDescriptor *orderDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:orderDesc];
    
    self.entityName = @"GroupMemberInfo";
    
    NSError *error = nil;
    BOOL res = [[super prepareFetchRC] performFetch:&error];
    if (!res) {
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    NSArray *eventCitys = [CommonUtils objectsInMOC:_MOC
                                         entityName:self.entityName
                                       sortDescKeys:self.descriptors
                                          predicate:nil];
    
    int size = [eventCitys count];
    
    for (NSUInteger i=0; i<size; i++) {
        GroupMemberInfo *mEventCity = (GroupMemberInfo*)eventCitys[i];
        
        [membersList addObject:mEventCity];
    }
#endif
}



#pragma mark -- all


- (void)initMessageListView:(UIView *)parentView
{
    int width = _screenSize.width - 2*_marginX;
    int height = _screenSize.height - HOMEPAGE_TAB_HEIGHT - ALONE_MARKETING_TAB_HEIGHT - SYS_STATUS_BAR_HEIGHT + 8;
    DLog(@"%.2f",self.view.frame.size.height );
    
    _msgListView = [[UITableView alloc] initWithFrame:CGRectMake(_marginX, 0, width, height) style:UITableViewStylePlain];
    _msgListView.dataSource = self;
    _msgListView.delegate = self;
    _msgListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _msgListView.userInteractionEnabled = YES;
    //    _msgListView.backgroundColor = [UIColor clearColor];
    _msgListView.backgroundColor = [UIColor whiteColor];//DEFAULT_VIEW_COLOR;
    
    [CommonMethod viewAddGuestureRecognizer:_msgListView withTarget:self withSEL:@selector(messageListViewTapped:)];
    
    [parentView addSubview:_msgListView];
}

#pragma mark -- cell delegate

- (void)openImage:(UIImage *)image
{
    ChatScrollViewController *vc = [[[ChatScrollViewController alloc] initWithMOC:_MOC parentVC:self.parentVC withImages:[NSArray arrayWithObject:image]] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

#pragma mark -- chat type
- (BOOL)isGroupChat
{
    return (_chatType == CHAT_TYPE_GROUP && _groupID);
}

- (BOOL)isPrivateChat
{
    return (_chatType == CHAT_TYPE_PRIVATE && _friendID);
}
- (void)successfulAddToGroup
{
    
    _bottomChatView = [self initBottomChatView:self.view];
}


- (UIImage *)adjustImage:(CGSize )size withBigImage:(UIImage *)bigImage withSmallImage:(UIImage *)smallImage
{
    UIGraphicsBeginImageContext(size);
    
    [bigImage  drawInRect:CGRectMake(0,0,size.width, size.height)];
    [smallImage  drawInRect:CGRectMake(size.width*0.3,(size.height - smallImage.size.height) / 2.0f,smallImage.size.width, smallImage.size.height)];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
}


- (UIView *)initBottomAddGroupView:(UIView *)parentView
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _bottomBarHeight , _screenSize.width, _bottomBarHeight)] autorelease];
    view.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_bottom_background.png");
    
    
    UIButton *addGroupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addGroupButton setBackgroundImage:[self adjustImage:CGSizeMake( view.frame.size.width, view.frame.size.height) withBigImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group.png") withSmallImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group_icon.png")]  forState:UIControlStateNormal];
    addGroupButton.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    [addGroupButton setTitle:@"加入群组" forState:UIControlStateNormal];
    [addGroupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addGroupButton addTarget:self action:@selector(addGroupButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:addGroupButton];
    
    //------------------
    UIImage *image = IMAGE_WITH_IMAGE_NAME(@"communication_bottom_add_to_group.png");
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(addGroupButton.frame.origin.x / 2 - image.size.width, 0, image.size.width, image.size.height)];
    icon.image = image;
    
    [addGroupButton addSubview:icon];
    [icon release];
    //------------
    [parentView addSubview:view];
    
    return view;
}

- (UIView *)initBottomChatView:(UIView *)parentView
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _bottomBarHeight, _screenSize.width, _bottomBarHeight)] autorelease];
    view.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_bottom_background.png");
    
    int marginX = 5;
    int distX = 5;
    float height = 38;
    int width = 38;
    //-----------------------------------------------------------------
    int startX =  distX;
    int startY = (view.frame.size.height - height ) / 2.0f + 2;
    
    UIButton *pictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [pictureButton setImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_camara_normal.png") forState:UIControlStateNormal];
    [pictureButton setImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_camara_highlighted.png") forState:UIControlStateHighlighted];
    pictureButton.frame = CGRectMake(startX, startY, width, height);
    [pictureButton addTarget:self action:@selector(pictureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:pictureButton];
    
    //-----------------------------------------------------------------
    width = view.frame.size.width -pictureButton.frame.origin.x - pictureButton.frame.size.width - marginX - 2*distX - width;
    height = view.frame.size.height * 0.7;
    _chatContentTextField = [[UITextField alloc] initWithFrame:CGRectMake(pictureButton.frame.origin.x + pictureButton.frame.size.width + distX , (view.frame.size.height - height ) / 2.0f, width, height)];
    _chatContentTextField.delegate = self;
    _chatContentTextField.backgroundColor = TRANSPARENT_COLOR;
    _chatContentTextField.borderStyle = UITextBorderStyleRoundedRect;
    _chatContentTextField.returnKeyType = UIReturnKeySend;
    _chatContentTextField.placeholder = @"请输入信息";
    _chatContentTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_chatContentTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    //    _chatContentTextField.textColor = [UIColor colorWithHexString:@"a2a2a2"];
    _chatContentTextField.textColor = [UIColor darkGrayColor];
    _chatContentTextField.layer.cornerRadius = 3.0f;
    //    [_chatContentTextField addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_chatContentTextField setFont:FONT_SYSTEM_SIZE(14)];
    if ([CommonMethod is7System])
        [_chatContentTextField setTintColor:[UIColor darkGrayColor]];
    
    //光标位置
    _chatContentTextField.leftView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)] autorelease];
    _chatContentTextField.leftView.userInteractionEnabled = NO;
    _chatContentTextField.leftViewMode = UITextFieldViewModeAlways;
    
    
//    [_chatContentTextField setBackground:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_text_normal.png")];
    [view addSubview:_chatContentTextField];
    
    //-------------------------------------
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceButton.frame =CGRectMake(pictureButton.frame.origin.x + pictureButton.frame.size.width + marginX , (view.frame.size.height - height ) / 2.0f, width, height);
    
    [_voiceButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_speak_normal.png") forState:UIControlStateNormal];
    [_voiceButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_speak_highlighted.png") forState:UIControlStateHighlighted];
    [_voiceButton setTitle:LocaleStringForKey(NSCommunicatHoldTo, nil) forState:UIControlStateNormal];
    [_voiceButton setTitle:LocaleStringForKey(NSCommunicateLoosenTheSendingVoice, nil) forState:UIControlStateHighlighted];
    [_voiceButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [_voiceButton setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateHighlighted];
    
    [_voiceButton addTarget:self action:@selector(voiceButtonDown:) forControlEvents:UIControlEventTouchDown];
    [_voiceButton addTarget:self action:@selector(voiceButtonUp:) forControlEvents:UIControlEventTouchUpInside];
    [_voiceButton addTarget:self action:@selector(voiceButtonUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    [view addSubview:_voiceButton];
    [_voiceButton setHidden:YES];
    
    
    //----------------------------------------------------
    _changeModeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_voice_normal.png") forState:UIControlStateNormal];
    [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_voice_highlighted.png") forState:UIControlStateHighlighted];
    _changeModeButton.frame = CGRectMake(_chatContentTextField.frame.origin.x + _chatContentTextField.frame.size.width + marginX, pictureButton.frame.origin.y, pictureButton.frame.size.width, pictureButton.frame.size.height);
    [_changeModeButton addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_changeModeButton];
    
    //-----------------------------------------------------------------
    [parentView addSubview:view];
    
    return view;
}

- (void)initMicView
{
    int height = 72;
    int width = 72;
    int startX = (_screenSize.width - width ) / 2.0f;
    int startY = (_screenSize.height - width) / 2.0f - 50;
    
    _micView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
    [_micView setBackgroundColor:COLOR_WITH_IMAGE_NAME(@"communication_mic_background.png")];
    
    
    _micStepImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_micView addSubview:_micStepImageView];
    
    [self.view addSubview:_micView];
    [_micView setHidden:YES];
}

- (void)startShowMicView
{
    _stepIndex = 0;
    _showStepMicTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                                         target: self
                                                       selector: @selector(startShowMicStepViewTimerCallback:)
                                                       userInfo: nil
                                                        repeats: YES];
    
    [_micView setHidden:NO];
}

- (void)stopShowMicView
{
    [_showStepMicTimer invalidate];
    _showStepMicTimer = nil;
    
    [_micView setHidden:YES];
}

//音量检测
- (void)startShowMicStepViewTimerCallback:(NSTimer *)timer
{
    NSString *imageName = [NSString stringWithFormat:@"communication_mic_%d.png", ++_stepIndex % 4];
    [_micStepImageView setImage:IMAGE_WITH_IMAGE_NAME(imageName)];
}

-(GroupMemberInfo *)getGroupUserImgUrl:(NSString *)userId {
    for(int i = 0; i < [membersList count]; i++) {
        GroupMemberInfo *mEventCity = (GroupMemberInfo*)[membersList objectAtIndex:i];
        if( [[mEventCity userId] isEqualToString:userId] ) {
            return mEventCity;
            break;
        }
    }
    return nil;
}

-(void)popSendFailed
{
    [WXWUIUtils showNotificationOnTopWithMsg:@"未能连接到服务器，发送失败！"
                                     msgType:SUCCESS_TY
                          belowNavigationBar:YES];
    
    [[iChatInstance instance] imRelogin];
}

#pragma mark -- send msg
- (void)sendButtonClicked:(id)sender
{
    if (_groupIsDeleted) {
        [self showGroupIsDeleted];
    }else{
        
        debugLog(@"sendButtonClicked:sender:%@", [AppManager instance].userId);
        
        NSString *text = _chatContentTextField.text;
        if (text.length > 0) {
            if ([self sendTextMsg:text]) {
                _chatContentTextField.text = @"";
            }else{
                [self popSendFailed];
                
            }
        }
    }
}



- (void)changeMode:(id)sender
{
    if ([_voiceButton isHidden]) {
        [_voiceButton setHidden:NO];
        [_chatContentTextField setHidden:YES];
        
        [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_keyboard_normal.png") forState:UIControlStateNormal];
        [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_keyboard_highlighted.png") forState:UIControlStateHighlighted];
        
        
    }else{
        [_voiceButton setHidden:YES];
        [_chatContentTextField setHidden:NO];
        
        [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_voice_normal.png") forState:UIControlStateNormal];
        [_changeModeButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_bottom_voice_highlighted.png") forState:UIControlStateHighlighted];
    }
}

#pragma mark -- gesture delegate
- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    [_chatContentTextField resignFirstResponder];
}

-(void)messageListViewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if ([_chatContentTextField isFirstResponder]) {
        [_chatContentTextField resignFirstResponder];
        return;
    }
    while ([[AppManager instance].visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = ([AppManager instance].visiblePopTipViews)[0];
        [[AppManager instance].visiblePopTipViews removeObjectAtIndex:0];
        [popTipView dismissAnimated:YES];
    }
    
    //    [_chatContentTextField resignFirstResponder];
}

#pragma mark TextField Delegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //    [self sendButtonClicked:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendButtonClicked:nil];
    return NO;
}

#pragma mark -- keyboard show or hidden
- (void)autoMovekeyBoard:(CGFloat)h withDuration:(NSTimeInterval)duration {
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        //        CGFloat hh = (h == 0 ? ITEM_BASE_BOTTOM_VIEW_HEIGHT : h);
        
        _bottomChatView.frame = CGRectMake(0.0f, (self.view.frame.size.height - h - _bottomBarHeight), _screenSize.width, _bottomBarHeight);
        
        //        _msgListView.frame = CGRectMake(0.0f, ITEM_BASE_TOP_VIEW_HEIGHT, _screenSize.width, (_screenSize.height - hh - _bottomBarHeight - ITEM_BASE_TOP_VIEW_HEIGHT - SYSTEM_STATUS_BAR_HEIGHT));
        
        if (h == 0.f) {
            _msgListView.frame = CGRectMake(0.f, h, _msgListView.frame.size.width, (_screenSize.height - ITEM_BASE_BOTTOM_VIEW_HEIGHT - SYS_STATUS_BAR_HEIGHT - _bottomBarHeight));
        }else {
            if ([self msgListViewCanScrollWithMatchHeight:h]) {
                _msgListView.frame = CGRectMake(0.f, -h, _msgListView.frame.size.width, (_screenSize.height - ITEM_BASE_BOTTOM_VIEW_HEIGHT - SYS_STATUS_BAR_HEIGHT - _bottomBarHeight));
            }
        }
        
        //        _msgListView.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_background.png");
        _msgListView.backgroundColor = [UIColor whiteColor];// DEFAULT_VIEW_COLOR;
        
    } completion:^(BOOL finished) {
        // stub
        int messageCount = [allMessages count];
        if (messageCount != 0) {
            [_msgListView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageCount - 1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:NO];
        }
    }];
}

#pragma mark Responding to keyboard events

- (void)keyboardShowNotify:(NSNotification *)notification {
    keyboardIsShowing = YES;
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height withDuration:animationDuration];
    
}


- (void)keyboardHideNotify:(NSNotification *)notification {
    keyboardIsShowing = NO;
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0.f withDuration:animationDuration];
}

- (void)hideKeyboard {
    
    //[self.inputToolbar.textView resignFirstResponder];
    //keyboardIsVisible = NO;
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:0.0];
}

#pragma mark -- load data

- (void)loadJoinChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:[_chatGroupDataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[NSString stringWithFormat:@"%@", [AppManager instance].userId ] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_JOIN_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_JOING_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

- (void)loadJoinILiao:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    if ([[AppManager instance].isLoginLicall isEqualToString:@"0"]) {
        NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
        [dict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
        [dict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
        
        NSString *url = [ProjectAPI getRequestURL:API_SERVICE_CHAT_GROUP withApiName:API_NAME_SET_USER_LOGIN_LICALL withCommon:[AppManager instance].common withSpecial:dict];
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                  contentType:SET_USER_LOGIN_LICALL];
        [connFacade fetchGets:url];
        
    }
}

//单聊时第一次发送 更新
- (void)privateSubmitPrivateLetter
{
#if 0
    if([self isPrivateChat]) {
        if (!_isPrivateFirstSend) {
            [self loadSubmitPrivateLetter:TRIGGERED_BY_AUTOLOAD forNew:YES type:FRIEND_TYPE_UPDATE];
        }
        _isPrivateFirstSend = TRUE;
    }
#endif
}

- (void)loadSubmitPrivateLetter:(LoadTriggerType)triggerType forNew:(BOOL)forNew type:(enum FRIEND_TYPE)type
{
    _currentType = SUBMIT_PRIVETE_LETTER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:_friendID forKey:KEY_API_PARAM_USERID];
    [specialDict setObject:NUMBER(type) forKey:KEY_API_PARAM_TYPE];
    
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_SUBMIT_PRIVATE_LETTER];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
    
}


#pragma mark -- load more messsge

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    //    self.newMessageCount += 10;
    //    [QPlusAPI reqHistoryMessagesByTargetID:_groupID targetType:Group lastMessage:nil count:self.newMessageCount];
    //
    //    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:@"http://www.ds"
    //                                                              contentType:-1];
    //
    //    [connFacade post:@"http://www.ds" data:nil];
    
    
    _dataFromReload = YES;
    _reloading= NO;
    
    //    return;
    
    QPlusMessage *oldMessage = nil;
    
    //    NSArray *array = [self getMsgArray];
    if (allMessages && allMessages.count) {
        oldMessage = [allMessages objectAtIndex:0];
    }
    
    self.newMessageCount = 20;
    
    if ([self isPrivateChat]) {
        
        [self successfulAddToGroup];
        
        [QPlusAPI reqHistoryMessagesByTargetID:_friendID targetType:Friend lastMessage:oldMessage count:self.newMessageCount];
        
    }else if ([self isGroupChat]) {
        if ([_chatGroupDataModal.canChat integerValue]
            && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED))
            [self successfulAddToGroup];
        else
            [self initQPlusView];
        
        if ([_chatGroupDataModal.canViewLog integerValue]
            && ( [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] != USER_STATUS_REFUSED)) {
            int req = [QPlusAPI reqHistoryMessagesByTargetID:_groupID targetType:Group lastMessage:oldMessage count:self.newMessageCount];
            DLog(@"%d", req);
        }
        
        
        if ([_chatGroupDataModal.canChat integerValue] == 0
            && ( [_chatGroupDataModal.userStatus integerValue] == USER_STATUS_NO_AUDIT ||  [_chatGroupDataModal.userStatus integerValue] == USER_STATUS_REFUSED)) {
            
            [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"请加入群组查看聊天内容", nil)
                                             msgType:INFO_TY
                                  belowNavigationBar:YES];
            
        }
    }
    
    
}

- (void)configureMOCFetchConditions {
    //    self.entityName = @"ChatGroupDataModal";
    //    self.descriptors = [NSMutableArray array];
    //    self.predicate = nil;
    //
    //    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    //    [self.descriptors addObject:dateDesc];
}

- (void)hideKeyboardWhenResponding {
    [_chatContentTextField resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView*)scrollView {
    contentOffsetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    DLog(@"%f",contentOffsetY);
    if ((contentOffsetY - scrollView.contentOffset.y) > 5.0f && contentOffsetY != 1286.f) {   // 向下拖拽
        if (keyboardIsShowing) {
            [self hideKeyboardWhenResponding];
        }
    }
}

-(void)showGroupIsDeleted {
    [[[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"群组已删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] autorelease] show];
}

#pragma mark - msgListView can scroll

- (BOOL)msgListViewCanScrollWithMatchHeight:(CGFloat)height {
    
    if (allMessages.count > 0) {
        
        CGFloat minScrollHeight = 0.f;
        
        for (int i = 0; i < allMessages.count; i++) {
            ChatListViewCell *cell = (ChatListViewCell *)[_msgListView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            minScrollHeight += cell.frame.size.height;
        }
        
        if (minScrollHeight > (self.view.frame.size.height - height)) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - ECItemUploaderDelegate methods
- (void)afterUploadFinishAction:(WebItemType)actionType {
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

@end