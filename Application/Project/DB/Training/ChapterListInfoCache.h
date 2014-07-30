//
//  ChapterListInfoCache.h
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "ChapterList.h"
#import "CourseDetailList.h"
#import "GlobalConstants.h"

@interface ChapterListInfoCache : NSObject <WXWConnectorDelegate>

- (void)upinsertChapterInfo:(ChapterList *)chapter;
- (void)updateChapterDownloaded:(int)courseId withChapterId:(int)chapterId isDownloaded:(int)downloaded;
- (void)updateChapterPercentage:(int)courseId withChapterId:(int)chapterId percentage:(double)percentage fileDownloadedSize:(double)fileDownloadedSize fileSize:(double)fileSize;

- (void)updateCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC;
- (void)updateDownloadingCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC;
- (void)updateDownloadedCourseChapters:(CourseDetailList *)detail MOC:(NSManagedObjectContext *)MOC;
- (NSArray *)getAllDownloadedChapters:(NSManagedObjectContext *)MOC;
- (NSArray *)getAllDownloadingCourseId;
- (NSArray *)getAllDownloadedCourseId;
- (void)deleteChapterWithChapter:(int)chapterId courseId:(int)courseId;

- (NSMutableArray *)getChapterDetailSetByCourseId:(int)courseId MOC:(NSManagedObjectContext *)MOC;
- (NSMutableArray *)getDownloadingChapterDetailsByCourseId:(int)courseId  MOC:(NSManagedObjectContext *)MOC;
- (NSMutableArray *)getDownloadedChapterDetailsByCourseId:(int)courseId  MOC:(NSManagedObjectContext *)MOC;

- (BOOL)isDownloading:(int)courseId withChapterId:(int)chapterId;
- (BOOL)isDownloaded:(int)courseId withChapterId:(int)chapterId;

-(void)resetDownloadInfo:(int)courseId withChapterId:(int)chapterId;

@end
