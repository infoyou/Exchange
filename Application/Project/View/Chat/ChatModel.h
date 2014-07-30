//
//  ChatModel.h
//  Project
//
//  Created by XXX on 13-10-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChatModel : NSObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSNumber * isPrivate;
@property (nonatomic, retain) NSNumber * isRoomMsg;
@property (nonatomic, retain) NSString * receiverID;
@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * uuid;

@end
