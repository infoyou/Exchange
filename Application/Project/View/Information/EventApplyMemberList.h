//
//  EventApplyMemberList.h
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventApplyMemberList : NSManagedObject

@property (nonatomic, retain) NSNumber * displayIndex;
@property (nonatomic, retain) NSNumber * eventId;
@property (nonatomic, retain) NSNumber * userId;
@property (nonatomic, retain) NSString * userImageURL;
@property (nonatomic, retain) NSString * userName;

- (void)updateData:(NSDictionary *)dic;

@end
