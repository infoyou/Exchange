//
//  DownLoadManageCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "DownloadInfo.h"
#import "ChapterList.h"
#import "GlobalConstants.h"
#import "KLFTPTransfer.h"

#define DOWNLOADING_CELL_HEIGHT 90.f

@class DownloadingCell;
@protocol DownloadingCellDelegate <NSObject>

- (void)downloadingCell:(DownloadingCell *)cell checkButtonTapped:(UIButton *)button chapter:(ChapterList *)chapter;
- (void)downloaded;

@end

@interface DownloadingCell : ECImageConsumerCell

@property (nonatomic, assign) id<DownloadingCellDelegate> delegate;
@property (nonatomic, assign) KLFTPTransfer *transfer;
@property (nonatomic, copy) NSString *localFileName;
@property (nonatomic, assign) CourseDetailList *courseDetail;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          indexPath:(NSIndexPath *)indexPath;

- (void)drawDownloadingCell:(ChapterList *)downloadInfo courseDetailList:(CourseDetailList *)courseDetailList;
-(void)updateMode:(enum DOWNLOADED_CELL_MODE)mode;

@end
