//
//  Tag.h
//  Project
//
//  Created by XXX on 13-12-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSNumber * groupId;
@property (nonatomic, retain) NSNumber * highlight;
@property (nonatomic, retain) NSString * mark;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * part;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSNumber * tagId;
@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * typeId;
@property (nonatomic, retain) NSNumber * changed;

@end
