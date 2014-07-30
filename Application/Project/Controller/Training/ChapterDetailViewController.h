//
//  ChapterDetailViewController.h
//  Project
//
//  Created by Yfeng__ on 13-11-13.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "WXWRootViewController.h"
#import "ChapterList.h"
#import "ChapterCell.h"

@interface ChapterDetailViewController : WXWRootViewController

- (id)initWithMOC:(NSManagedObjectContext *)MOC
          chapter:(ChapterList *)chapter
        localFile:(NSString *)localFile;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
          chapter:(ChapterList *)chapter
        localFile:(NSString *)localFile
      chapterCell:(ChapterCell *)cell;

@end
