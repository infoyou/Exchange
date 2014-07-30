//
//  MessageList.h
//  Project
//
//  Created by Yfeng__ on 13-12-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MessageList : NSManagedObject

@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * vipId;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * videoUrl;
@property (nonatomic, retain) NSString * voiceUrl;
@property (nonatomic, retain) NSString * vipName;
@property (nonatomic, retain) NSString * oriUrl;
@property (nonatomic, retain) NSString * timestamp;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) NSString * openId;
@property (nonatomic, retain) NSString * weixinId;
@property (nonatomic, retain) NSString * headImageUrl;
@property (nonatomic, retain) NSNumber * materialTypeId;

- (void)updateData:(NSDictionary *)dic;

@end
