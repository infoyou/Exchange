//
//  Distance.h
//  Project
//
//  Created by XXX on 13-12-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Distance : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSNumber * valueFloat;
@property (nonatomic, retain) NSString * valueString;

@end
