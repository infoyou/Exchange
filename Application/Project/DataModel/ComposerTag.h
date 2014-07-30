//
//  ComposerTag.h
//  Project
//
//  Created by XXX on 13-12-18.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ComposerTag : NSManagedObject

@property (nonatomic, retain) NSNumber * highlight;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSNumber * tagId;
@property (nonatomic, retain) NSString * tagName;
@property (nonatomic, retain) NSNumber * type;

@end
