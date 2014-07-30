//
//  EventOptionList.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventOptionList : NSManagedObject

@property (nonatomic, retain) NSString * optionTitle;
@property (nonatomic, retain) NSNumber * optionId;

- (void)updateData:(NSDictionary *)dic;

@end
