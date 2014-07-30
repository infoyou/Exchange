//
//  CommentList.h
//  Project
//
//  Created by Yfeng__ on 13-11-11.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CommentList : NSManagedObject

@property (nonatomic, retain) NSNumber * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * timestamp;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userImageUrl;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSNumber * commentType;

- (void)updateData:(NSDictionary *)dic commentType:(int)ctype;

@end
