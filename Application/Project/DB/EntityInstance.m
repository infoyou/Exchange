//
//  EntityInstance.m
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "EntityInstance.h"

@implementation EntityInstance

static EntityInstance *instance = nil;

+ (EntityInstance *)instance {
    
    @synchronized(self) {
        if(instance == nil) {
            instance = [[super allocWithZone:NULL] init];
        }
    }
    
    return instance;
}

+ (CourseList *)getCourseEntity:(NSManagedObjectContext *)MOC {
    return  [NSEntityDescription insertNewObjectForEntityForName:@"CourseList" inManagedObjectContext:MOC];
}

+ (CourseDetailList *)getCourseDetailEntity:(NSManagedObjectContext *)MOC
{
    return  [NSEntityDescription insertNewObjectForEntityForName:@"CourseDetailList" inManagedObjectContext:MOC];
}

+ (ChapterList *)getChapterListEntity:(NSManagedObjectContext *)MOC
{
    return [NSEntityDescription insertNewObjectForEntityForName:@"ChapterList" inManagedObjectContext:MOC];
}
@end
