//
//  CommentList.m
//  Project
//
//  Created by Yfeng__ on 13-11-11.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommentList.h"


@implementation CommentList

@dynamic commentId;
@dynamic content;
@dynamic createTime;
@dynamic timestamp;
@dynamic userId;
@dynamic userImageUrl;
@dynamic userName;
@dynamic commentType;

- (void)updateData:(NSDictionary *)dic commentType:(int)ctype {
    
    self.commentType = @(ctype);
    self.commentId = [dic objectForKey:@"commentId"];
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [[dic objectForKey:@"userName"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userName"];
    self.userImageUrl = [[dic objectForKey:@"userImageUrl"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"userImageUrl"];;
    self.content = [[dic objectForKey:@"content"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"content"];
    self.createTime = [[dic objectForKey:@"createTime"] isEqual:[NSNull null]] ? @"" : [dic objectForKey:@"createTime"];
    self.timestamp = [dic objectForKey:@"timestamp"];
}

@end
