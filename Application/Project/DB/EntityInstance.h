//
//  EntityInstance.h
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseDetailList.h"
#import "ChapterList.h"
#import "CourseList.h"

@interface EntityInstance : NSObject

+ (EntityInstance *)instance;

+ (CourseList *)getCourseEntity:(NSManagedObjectContext *)MOC;
+ (CourseDetailList *)getCourseDetailEntity:(NSManagedObjectContext *)MOC;
+ (ChapterList *)getChapterListEntity:(NSManagedObjectContext *)MOC;

@end
