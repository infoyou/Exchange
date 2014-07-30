//
//  ImageList.h
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"


@interface ImageList : NSManagedObject

@property (nonatomic, retain) NSNumber * imageID;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * isDelete;

- (void)updateData:(NSDictionary *)dic;
-(void)updateDataWithStmt:(WXWStatement *)stmt;
@end
