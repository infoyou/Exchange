//
//  BusinessItemDetailModel.h
//  Project
//
//  Created by XXX on 13-10-23.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BusinessItemDetailModel : NSManagedObject

@property (nonatomic, retain) NSNumber * detailId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * brief;
@property (nonatomic, retain) NSString * detailURL;

@end
