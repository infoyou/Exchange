//
//  MessageList.m
//  Project
//
//  Created by Yfeng__ on 13-12-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "MessageList.h"

#define NULL_VALUE  [NSNULL null]

@implementation MessageList

@dynamic messageId;
@dynamic vipId;
@dynamic text;
@dynamic imageUrl;
@dynamic videoUrl;
@dynamic voiceUrl;
@dynamic vipName;
@dynamic oriUrl;
@dynamic timestamp;
@dynamic createTime;
@dynamic lastUpdateTime;
@dynamic openId;
@dynamic weixinId;
@dynamic headImageUrl;
@dynamic materialTypeId;

- (void)updateData:(NSDictionary *)dic {
    self.messageId = ([NSNull null] == [dic objectForKey:@"MessageId"]) ? @"" : [dic objectForKey:@"MessageId"];
    self.vipId = ([NSNull null] == [dic objectForKey:@"VipId"]) ? @"" : [dic objectForKey:@"VipId"];
    self.vipName = ([NSNull null] == [dic objectForKey:@"VipName"]) ? @"" : [dic objectForKey:@"VipName"];
    self.text = ([NSNull null] == [dic objectForKey:@"Text"]) ? @"" : [dic objectForKey:@"Text"];
    self.headImageUrl = ([NSNull null] == [dic objectForKey:@"HeadImgUrl"]) ? @"" : [dic objectForKey:@"HeadImgUrl"];
    self.imageUrl = ([NSNull null] == [dic objectForKey:@"ImageUrl"]) ? @"" : [dic objectForKey:@"ImageUrl"];
    self.videoUrl = ([NSNull null] == [dic objectForKey:@"VideoUrl"]) ? @"" : [dic objectForKey:@"VideoUrl"];
    self.voiceUrl = ([NSNull null] == [dic objectForKey:@"VoiceUrl"]) ? @"" : [dic objectForKey:@"VoiceUrl"];
    self.oriUrl = ([NSNull null] == [dic objectForKey:@"OriUrl"]) ? @"" : [dic objectForKey:@"OriUrl"];
    self.createTime = ([NSNull null] == [dic objectForKey:@"CreateTime"]) ? @"" : [dic objectForKey:@"CreateTime"];
    self.lastUpdateTime = ([NSNull null] == [dic objectForKey:@"LastUpdateTime"]) ? @"" : [dic objectForKey:@"LastUpdateTime"];
    self.openId = ([NSNull null] == [dic objectForKey:@"OpenId"]) ? @"" : [dic objectForKey:@"OpenId"];
    self.weixinId = ([NSNull null] == [dic objectForKey:@"WeiXinId"]) ? @"" : [dic objectForKey:@"WeiXinId"];
    self.timestamp = ([NSNull null] == [dic objectForKey:@"timestamp"]) ? @"" : [dic objectForKey:@"timestamp"];
    self.materialTypeId = @([[dic objectForKey:@"MaterialTypeId"] integerValue]);
}

@end
