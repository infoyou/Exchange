//
//  BusinessImageList.h
//  Project
//
//  Created by Yfeng__ on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"


@interface BusinessImageList : NSManagedObject

@property (nonatomic, retain) NSNumber * imageID;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * projectId;

- (void)updateData:(NSDictionary *)dic projectId:(int)pid;
-(void)updateDataWithStmt:(WXWStatement *)stmt;

@end
