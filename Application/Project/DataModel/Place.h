//
//  Place.h
//  Project
//
//  Created by XXX on 13-12-19.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Place : NSManagedObject

@property (nonatomic, retain) NSNumber * centerItemId;
@property (nonatomic, retain) NSNumber * cityId;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * placeType;
@property (nonatomic, retain) NSNumber * selected;

@end
