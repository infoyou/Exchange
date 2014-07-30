//
//  GoHighChatCache.h
//  Project
//
//  Created by XXX on 13-10-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXWImageFetcherDelegate.h"
#import "WXWConnectorDelegate.h"
#import "QPlusAPI.h"
#import "ChatModel.h"

@interface GoHighChatCache : NSObject <WXWConnectorDelegate>


- (void)insertChatIntoDB:(QPlusMessage *)message groupId:(NSString *)groupId isRead:(int)read;
-(ChatModel *)getGroupLastMessage:(NSString *)groupId;
-(ChatModel *)getPrivateLastMessage:(NSString *)friendId userId:(NSString *)userId;

-(int)getVoiceMessageListened:(QPlusMessage *)message;
-(int)getGroupNewMessageCount:(NSString *)groupId userId:(NSString *)userId;
-(int)getPrivateNewMessageCount:(NSString *)friendId userId:(NSString *)userId;


-(void)setVoiceMessageListened:(QPlusMessage *)messsage;
-(void)setGroupMessageReaded:(NSString *)groupId;
-(void)setPrivateMessageReaded:(NSString *)friendId;

@end
