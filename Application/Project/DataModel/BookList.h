//
//  BookList.h
//  Project
//
//  Created by XXX on 13-11-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"

@interface BookList : NSManagedObject

@property (nonatomic, retain) NSString * bookCategory;
@property (nonatomic, retain) NSNumber * bookID;
@property (nonatomic, retain) NSString * bookImage;
@property (nonatomic, retain) NSString * bookTitle;
@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSString * commendReason;
@property (nonatomic, retain) NSNumber * comment;
@property (nonatomic, retain) NSNumber * informationType;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * linkType;
@property (nonatomic, retain) NSNumber * reader;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * zipURL;
@property (nonatomic, retain) NSNumber * isDelete;

- (void)updateData:(NSDictionary *)dic;
-(void)updateDataByData:(WXWStatement *)stmt;
@end
