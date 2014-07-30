//
//  BookImageList.h
//  Project
//
//  Created by Yfeng__ on 13-11-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookImageList : NSManagedObject

@property (nonatomic, retain) NSNumber * bookID;
@property (nonatomic, retain) NSString * bookTitle;
@property (nonatomic, retain) NSString * bookImage;
@property (nonatomic, retain) NSString * target;
@property (nonatomic, retain) NSNumber * sortOrder;

- (void)updateData:(NSDictionary *)dic;

@end
