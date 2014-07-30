//
//  ChapterCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "ChapterList.h"
#import "CommonHeader.h"
#import "CourseDetailList.h"

#define CHAPTER_CELL_HEIGHT  50.f


@protocol ChapterCellDelegate;

@class KLFTPTransfer;
@interface ChapterCell : BaseTextBoardCell

@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) UIImageView *bgView;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *indexLabel;
@property (nonatomic, assign) ChapterList *chapterList;
@property (nonatomic, assign) CourseDetailList *courseDetail;
@property (nonatomic, assign) KLFTPTransfer *transfer;
@property (nonatomic, copy) NSString *localFileName;
@property (nonatomic, assign) BOOL isDownloaded;
@property (nonatomic) int courseType;

@property (nonatomic, assign) id<ChapterCellDelegate> delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bottom:(BOOL)bottom;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)drawChapter:(ChapterList *)chapterList withCourseDetailList:(CourseDetailList *)course courseType:(int)courseType index:(int)index;;
//- (void)updateCellWithDownloadStatus:(ManageStatus)status;
- (void)checkButtonClicked:(UIButton *)sender;
- (void)startDownloadChapter;
-(void)drawBottom;
-(void)resetDownloadStatus;
@end

@protocol ChapterCellDelegate <NSObject>

-(void)startStudy:(ChapterCell *)cell chapterList:(ChapterList *)chapterList fileName:(NSString *)fileName;


@end
