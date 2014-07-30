//
//  InformationListCache.h
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "WXWStatement.h"
#import "WXWDBConnection.h"

@interface InformationListCache : NSObject<WXWConnectorDelegate>

- (void)upinsertInfomationInfo:(NSArray *)array timestamp:(double)timestamp;
-(double)getLatestInfomationTimestamp;
-(double)getOldestInfomationTimestamp;
-(void)deleteOldInfomationFromTimestamp:(NSString *)timestamp;
-(void)updateDataWithStmt:(WXWStatement *)stmt;


- (void)updateInformationCommentCount:(int)infoId count:(int)count;
-(void)updateInformationCommentReader:(int)infoId count:(int)count;

- (int)getInformationCommentCount:(int)infoId;
-(int)getInformationCommentReader:(int)infoId;
@end
