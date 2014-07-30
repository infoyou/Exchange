//
//  InformationList.h
//  Project
//
//  Created by XXX on 13-11-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "WXWStatement.h"


@interface InformationList : NSManagedObject

@property (nonatomic, retain) NSNumber * clientID;
@property (nonatomic, retain) NSNumber * comment;
@property (nonatomic, retain) NSNumber * informationID;
@property (nonatomic, retain) NSNumber * informationType;
@property (nonatomic, retain) NSString * lastUpdateTime;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * linkType;
@property (nonatomic, retain) NSNumber * reader;
@property (nonatomic, retain) NSNumber * sortOrder;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * zipURL;
@property (nonatomic, retain) NSString * htmlURL;
@property (nonatomic, retain) NSNumber * isDelete;

- (void)updateData:(NSDictionary *)dic;
- (void)updateObj:(InformationList *)info;
-(void)updateDataWithStmt:(WXWStatement *)stmt;
@end
