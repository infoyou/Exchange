//
//  DownloadInfo.h
//  Project
//
//  Created by XXX on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChapterList.h"
#import "CourseDetailList.h"

@interface DownloadInfo : NSObject

@property (nonatomic, retain) CourseDetailList *courseDetail;
@property (nonatomic, retain) ChapterList *chapterList;
@property (nonatomic, copy) NSString *uniqueKey;
@property (nonatomic, copy) NSString *downloadPath;
@property (nonatomic, copy) NSString *localPath;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@end
