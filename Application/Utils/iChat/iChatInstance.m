//
//  iChatInstance.m
//  Project
//
//  Created by XXX on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "iChatInstance.h"
#import "QPlusAPI.h"
#import "QPlusDataBase.h"
#import "QPlusProgressHud.h"
#import "GlobalConstants.h"
#import "WXWUIUtils.h"
#import "WXWCommonUtils.h"
#import "TextPool.h"
#import "WXWTextPool.h"
#import "GoHighDBManager.h"
#import "CommunicationListViewController.h"
#import "ChatListViewController.h"
#import "CommunicationMessageListViewController.h"
#import "CommunicationFriendListViewController.h"
#import "WXWDebugLogOutput.h"
#import "AppManager.h"

@interface iChatInstance ()<QPlusGeneralDelegate, QPlusSingleChatDelegate, QPlusProgressDelegate, QPlusPlaybackDelegate, QPlusGroupDelegate>

@property (nonatomic, assign) NSMutableArray *listenerArray;

@end

@implementation iChatInstance {
    NSString *_loginUserId;
    BOOL isInChat;
}

@synthesize listenerArray = _listenerArray;

static iChatInstance *instance = nil;

+ (iChatInstance *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
            [instance initData];
            [instance initQplusApi];
        }
    }
    
    return instance;
}

- (void)initData
{
    _listenerArray = [[NSMutableArray alloc] init];
    
    self.index = 0;
}

//---------
//init api
-(void)initQplusApi {
    
    @try {
        /*
         // Old Version
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:kKeyLoginServerValue forKey:kKeyLoginServer];
        [defaults setInteger:kKeyLoginPortValue forKey:kKeyLoginPort];
        [defaults synchronize];
        */
        
        // New Version
        [QPlusAPI setLoginServer:@"mo.fosun.com" port:8888];
        
        [QPlusAPI initWithAppKey:APP_KEY];
        
    } @catch (NSException *exception) {
        DLog(@"%@", exception);
    } @finally {
    }
}

-(void)dologin:(NSString *)userId {
    
    _loginUserId = userId;
    [self initQplusApi];
    [QPlusDataBase initialize];
    [QPlusDataBase clearDatabase];
    [QPlusAPI removeAllListeners];
    
    [QPlusAPI addSingleChatListener:self];
    [QPlusAPI addGroupListener:self];
    [QPlusAPI addGeneralListener:self];
    [QPlusAPI loginWithUserID:userId];
}

- (void)dologout
{
    [QPlusAPI removeAllListeners];
    [QPlusAPI stopPlayVoice];
    [QPlusAPI logout];
    
    isInChat = FALSE;
}

- (void)onGetFriendList:(NSArray *)friendList {
    if (friendList != nil) {
        [QPlusDataBase initFriendList:friendList];
        //        [self refreshList];
    }
}

- (void)onLoginSuccess:(BOOL)isRelogin {
    
    [AppManager instance].connectionStatus = NetworkConnectionStatusOn;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NetworkConnectionStatusDone], @"status", nil]];
    
    if(isInChat) {
        return ;
    }
    
    isInChat = YES;
    
    [QPlusAPI setAutoRelogin:YES];
    
    [QPlusProgressHud hideLoading];
    [QPlusDataBase setLoginUserID:_loginUserId];
}

- (void)onLoginCanceled {
    [QPlusProgressHud hideLoading];
    if(isInChat) {
        return ;
    }
}

- (void)onLoginFailed:(QPlusLoginError)error {
    [QPlusProgressHud hideLoading];
    
    [AppManager instance].connectionStatus = NetworkConnectionStatusDoing;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETWORK_STATUS
                                                        object:nil
                                                      userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NetworkConnectionStatusDoing], @"status", nil]];
    
    if(isInChat) {
        return ;
    }
    
    [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatLoginFail, nil)
                                     msgType:INFO_TY
                          belowNavigationBar:YES];
}

- (void)imRelogin
{
    [QPlusAPI logout];
    [QPlusAPI loginWithUserID:_loginUserId];
}

- (void)onLogout:(QPlusLoginError)error {
    
    if(isInChat) {
        [self imRelogin];
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

#pragma mark -- receive message
-(void)onGetHistoryMessageList:(NSArray *)msgList targetType:(QplusChatTargetType)type targetID:(NSString *)tarID
{
    
    if (msgList.count) {
        
        for (int i = 0; i < msgList.count; ++i) {
            QPlusMessage *message = [msgList objectAtIndex:i];
            
//            if (message.type == VOICE)
                [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
        }
        
        for (id lis in self.listenerArray) {
            if ([lis isKindOfClass:[ChatListViewController class]]) {
                ChatListViewController *vc = (ChatListViewController *)lis;
                [vc onGetHistoryMessageList:msgList targetType:type targetID:tarID];
                
            }
        }
    }
}

- (void)onPlayStart
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onPlayStart];
        }
    }
}

- (void)onPlaying:(float)duration
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onPlaying:duration];
        }
    }
}

- (void)onPlayStop
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onPlayStop];
        }
    }
}

- (void)onError
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onError];
        }
    }
}

//--------------------
- (void)onStartVoice:(QPlusMessage *)voiceMessage
{
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationListViewController class]]) {
            CommunicationListViewController *vc = (CommunicationListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onStartVoice:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicationMessageListViewController class]]) {
            
            CommunicationMessageListViewController *vc = (CommunicationMessageListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[CommunicationFriendListViewController class]]) {
            
            CommunicationFriendListViewController *vc = (CommunicationFriendListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
    }
}

- (void)onRecording:(QPlusMessage *)voiceMessage size:(int)dataSize duration:(long)duration
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationListViewController class]]) {
            CommunicationListViewController *vc = (CommunicationListViewController *)lis;
            [vc onReceiveMessage:voiceMessage];
        }
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onRecording:voiceMessage size:dataSize duration:duration];
        }   
    }
}

- (void)onRecordError:(QPlusRecordError)error
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onRecordError:error];
        }
    }
}

- (void)onStopVoice:(QPlusMessage *)voiceMessage
{
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onStopVoice:voiceMessage];
        }
    }
}

- (void)onSendMessage:(QPlusMessage *)message result:(BOOL)isSuccessful
{
    if (message.type == TEXT) {
        debugLog(@"onSendMessage:index:%d, type:%d:text:%@", ++self.index, message.type, message.text);
        if ([message.text isEqualToString:DELETE_GROUP_MESSAGE]) {
//            int a  =0;
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:message.receiverID, @"groupId", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO object:nil userInfo:dict];
            
            return;
        }
    }
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onSendMessage:message result:isSuccessful];
        }
    }
}

- (void)onReceiveMessage:(QPlusMessage *)message
{
    debugLog(@"onReceiveMessage:sender:%@, type:%d text:%@",message.senderID, message.type,message.text);
    
    if (message.type == TEXT) {
        
        if ([message.text isEqualToString:DELETE_GROUP_MESSAGE]) {
            
            for (id lis in self.listenerArray) {
                if ([lis isKindOfClass:[CommunicationListViewController class]]) {
                    CommunicationListViewController *vc = (CommunicationListViewController *)lis;
                    [vc onDeleteGroupMesssage:message];
                }
                if ([lis isKindOfClass:[ChatListViewController class]]) {
                    
                    ChatListViewController *vc = (ChatListViewController *)lis;
                    [vc onDeleteGroupMesssage:message];
                }
            }
            
            [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
            
            [[GoHighDBManager instance] deleteGroup:[message.receiverID intValue]];
            return;
        }
        
        
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
    } else if ( message.type == VOICE) {
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:0];
    } else {
        [[GoHighDBManager instance] insertChatIntoDB:message groupId:message.receiverID isRead:1];
    }
    
    for (id lis in self.listenerArray) {
        if ([lis isKindOfClass:[CommunicationListViewController class]]) {
            CommunicationListViewController *vc = (CommunicationListViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[CommunicationMessageListViewController class]]) {
            
            CommunicationMessageListViewController *vc = (CommunicationMessageListViewController *)lis;
            [vc onReceiveMessage:message];
        }
        if ([lis isKindOfClass:[CommunicationFriendListViewController class]]) {
            
            CommunicationFriendListViewController *vc = (CommunicationFriendListViewController *)lis;
            [vc onReceiveMessage:message];
        }
    }
    
}

- (void)onGetRes:(QPlusMessage *)message result:(BOOL)isSuccessful {
    for (id lis in self.listenerArray) {
        
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onGetRes:message result:isSuccessful];
        }
        
    }
}

- (void)onProgressUpdate:(QPlusMessage *)msgObejct percent:(float)percent
{
    for (id lis in self.listenerArray) {
        
        if ([lis isKindOfClass:[ChatListViewController class]]) {
            
            ChatListViewController *vc = (ChatListViewController *)lis;
            [vc onProgressUpdate:msgObejct percent:percent];
        }
    }
}

- (void)sendDeleteGroupMessage:(NSString *)groupId
{
    debugLog(@"sendDeleteGroupMessage: groupID:%@", groupId);
    
    [QPlusAPI sendText:DELETE_GROUP_MESSAGE inGroup:groupId];
}

#pragma mark -- listener

- (void)registerListener:(id)listener
{
    for (id lis in self.listenerArray) {
        if (lis == listener) {
            return;
        }
    }
    
    [self.listenerArray addObject:listener];
}

- (void)unRegisterListener:(id)listener
{
    for (id lis in _listenerArray) {
        if (lis == listener) {
            [self.listenerArray removeObject:listener];
            break;
        }
    }
}

@end
