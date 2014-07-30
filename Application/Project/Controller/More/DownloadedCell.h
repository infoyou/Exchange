//
//  DownloadedCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-12.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "DownloadInfo.h"
#import "GlobalConstants.h"
#import "QCheckBox.h"

#define DOWNLOADED_CELL_HEIGHT 40.f


@protocol DownloadedCellDelegate;
@interface DownloadedCell : BaseTextBoardCell


@property (nonatomic, retain) UIImageView *accessoryImage;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) QCheckBox *checkBox;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, assign) id<DownloadedCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          indexPath:(NSIndexPath *)indexPath;

- (void)drawDownloadedCell:(ChapterList *)chapter;
- (void)updateMode:(enum DOWNLOADED_CELL_MODE)mode;
- (void)checkButtonTapped:(UIButton *)sender;
-(BOOL)checked;

@end


@protocol DownloadedCellDelegate <NSObject>

- (void)studyCourse:(DownloadedCell *)cell chapter:(ChapterList *)chapter;
- (void)downloadedCell:(DownloadedCell *)cell checkButtonTapped:(UIButton *)button chapter:(ChapterList *)chapter;

@end