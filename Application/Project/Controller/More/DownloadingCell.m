//
//  DownLoadManageCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-7.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "DownloadingCell.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "CommonHeader.h"
#import "DDProgressView.h"
#import "FTPDownloaderManager.h"
#import "GoHighDBManager.h"

#define ICON_WIDTH  23.f
#define ICON_HEIGHT 23.f

#define BUTTON_WIDTH  50.f
#define BUTTON_HEIGHT 50.f

#define TITLE_LABEL_MAX_WIDTH 248.f

#define CHECK_BUTTON_WIDTH  19.f
#define CHECK_BUTTON_HEIGHT 18.f

#define PROGRESS_VIEW_HEIGHT 6.f

#define TITLE_FONT    FONT_SYSTEM_SIZE(15)
#define PROGRESS_FONT FONT_SYSTEM_SIZE(14)

#define TITLE_TEXT_COLOR     [UIColor colorWithHexString:@"0X666666"]
#define PROGRESS_TEXT_COLOR  [UIColor colorWithHexString:@"0Xe83e0b"]

CellMargin DLCM = {16.f, 16.f, 10.f, 15.f};

@interface DownloadingCell()

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) UIButton *statButton;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) WXWLabel *progressLabel;
@property (nonatomic, retain) DDProgressView *progressView;
@property (nonatomic, retain) UIImageView *iconStatus;

@end

@implementation DownloadingCell {
    ChapterList *_chapter;
    enum DOWNLOADED_CELL_MODE _mode;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
          indexPath:(NSIndexPath *)indexPath {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewsWithIndexPath:indexPath];
        
        [[FTPDownloaderManager instance] registerListener:self];
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    [[FTPDownloaderManager instance] unRegisterListener:self];
    [_iconStatus release];
    [super dealloc];
}

- (void)initViewsWithIndexPath:(NSIndexPath *)indexPath {
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:TITLE_TEXT_COLOR
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = TITLE_FONT;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    _statButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.statButton.backgroundColor = TRANSPARENT_COLOR;
    self.statButton.tag = indexPath.row;
    [self.statButton addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.statButton];
    
    _iconStatus = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconStatus.backgroundColor = TRANSPARENT_COLOR;
    [self.contentView addSubview:self.iconStatus];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.backgroundColor = TRANSPARENT_COLOR;
    self.checkButton.tag = indexPath.row;
    [self.checkButton addTarget:self action:@selector(checkButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton setImage:ImageWithName(@"check_no.png") forState:UIControlStateNormal];
    [self.checkButton setImage:ImageWithName(@"check_yes.png") forState:UIControlStateSelected];
    [self.contentView addSubview:self.checkButton];
    self.checkButton.hidden = YES;
    
    _progressLabel = [self initLabel:CGRectZero
                           textColor:PROGRESS_TEXT_COLOR
                         shadowColor:TRANSPARENT_COLOR];
    self.progressLabel.font = PROGRESS_FONT;
    [self.contentView addSubview:self.progressLabel];
    
    _progressView = [[DDProgressView alloc] initWithFrame:CGRectZero];
    [self.progressView setInnerColor:[UIColor colorWithHexString:@"0xe83e0b"]];
    [self.progressView setOuterColor:[UIColor clearColor]];
    [self.progressView setEmptyColor:[UIColor colorWithHexString:@"0x6d6e76"]];
    [self.contentView addSubview:self.progressView];
}

- (void)drawDownloadingCell:(ChapterList *)downloadInfo courseDetailList:(CourseDetailList *)courseDetailList {
    
    _chapter = downloadInfo;
    
    //checkbutton
    
    self.checkButton.frame = CGRectMake(DLCM.left, DLCM.top + 1, CHECK_BUTTON_WIDTH, CHECK_BUTTON_HEIGHT);
    self.checkButton.selected = NO;
    
    //title label
    self.titleLabel.text = downloadInfo.chapterTitle;
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                 constrainedToSize:CGSizeMake(TITLE_LABEL_MAX_WIDTH, MAXFLOAT)
                                     lineBreakMode:NSLineBreakByCharWrapping
                                           options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(DLCM.left,// + CHECK_BUTTON_WIDTH,
                                       DLCM.top,
                                       TITLE_LABEL_MAX_WIDTH,
                                       titleSize.height);
    
    self.iconStatus.frame = CGRectMake(self.frame.size.width - ICON_WIDTH - 20,
                                       self.titleLabel.frame.origin.y,
                                       ICON_WIDTH,
                                       ICON_HEIGHT);
    self.iconStatus.image = ImageWithName(@"training_button_download.png");
    
    //status button
    self.statButton.frame = CGRectMake(self.frame.size.width - BUTTON_HEIGHT - 4,
                                       0,
                                       BUTTON_WIDTH,
                                       BUTTON_HEIGHT);
    
    //progress label
//    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(downloadInfo.chapterList.percentage.floatValue * 100)];
    
    CGSize progressSize = [WXWCommonUtils sizeForText:self.progressLabel.text
                                                 font:self.progressLabel.font
                                    constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByCharWrapping
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:@{NSFontAttributeName : self.progressLabel.font}];
    
    self.progressLabel.frame = CGRectMake(self.frame.size.width - DLCM.left - progressSize.width - 2,
                                          self.statButton.frame.origin.y + self.statButton.frame.size.height - 8,
                                          progressSize.width,
                                          progressSize.height);
    
    //progress view
    self.progressView.frame = CGRectMake(DLCM.left,
                                         self.progressLabel.frame.origin.y + self.progressLabel.frame.size.height + 5,
                                         self.frame.size.width - DLCM.left * 2,
                                         PROGRESS_VIEW_HEIGHT);
//    [self.progressView setProgress:downloadInfo.percentage.floatValue];
    
    self.localFileName = [CommonMethod getChapterFilePath:_chapter];
    self.courseDetail = courseDetailList;
    self.transfer = [self getTransferInfo];
    
    [self updateStauts:self.transfer.transferItem];
}

-(void)updateMode:(enum DOWNLOADED_CELL_MODE)mode
{
    _mode = mode;
    [self adjustContrlPos:mode];
}

- (void)adjustContrlPos:(enum DOWNLOADED_CELL_MODE)mode
{
    if (mode == DOWNLOADED_CELL_MODE_EDIT) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.titleLabel.frame = CGRectMake(DLCM.left + CHECK_BUTTON_WIDTH, self.titleLabel.frame.origin.y, TITLE_LABEL_MAX_WIDTH, self.titleLabel.frame.size.height);
                             
                             self.checkButton.hidden = NO;
            
        } completion:^(BOOL completion){
            
        }];
    }else if (mode == DOWNLOADED_CELL_MODE_NORMAL) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.titleLabel.frame = CGRectMake(DLCM.left, self.titleLabel.frame.origin.y, TITLE_LABEL_MAX_WIDTH, self.titleLabel.frame.size.height);
                             self.checkButton.hidden = YES;
        } completion:^(BOOL completion){
            
        }];
    }
}

- (void)changeStatus:(UIButton *)sender {
    
    KLFTPTransferItem *item = self.transfer.transferItem;
    
    switch (item.transferState) {
        case KLFTPTransferStatePaused:
        {
            [self.transfer start];
//            self.iconStatus.image = ImageWithName(@"training_button_pause.png");
            
        } break;
            
        case KLFTPTransferStateDownloading:
        {
            [self.transfer pause];
//            self.iconStatus.image = ImageWithName(@"training_button_download.png");
        } break;
            
        case KLFTPTransferStateStopped:
        {
            [self.transfer start];
//            self.iconStatus.image = ImageWithName(@"training_button_pause.png");
            
        } break;
            
        default:
            [self.transfer start];
            break;
    }
    [self updateStauts:item];
}

- (void)updateStauts:(KLFTPTransferItem *)item
{
    switch (item.transferState) {
        case KLFTPTransferStateDownloading:
            self.iconStatus.image = ImageWithName(@"training_button_pause.png");
            break;
        case KLFTPTransferStatePaused:
            self.iconStatus.image = ImageWithName(@"training_button_download.png");
            break;
        case KLFTPTransferStateStopped:
            self.iconStatus.image = ImageWithName(@"training_button_download.png");
            break;
        case KLFTPTransferStateFinished:
            
            break;
            
        default:
            break;
    }
}

- (void)checkButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(downloadingCell:checkButtonTapped:chapter:)]) {
        [_delegate downloadingCell:self checkButtonTapped:sender chapter:_chapter];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}


- (KLFTPTransfer *)getTransferInfo
{
    DownloadInfo *info = [[[DownloadInfo alloc] init] autorelease];
    info.userName = @"anonymous";
    info.password = @"";
    info.downloadPath = _chapter.chapterFileURL;// @"ftp://222.73.180.224/gohighfund/ios_test/gohighfund.ipa";//self.chapterList.chapterFileURL;
    info.localPath = self.localFileName;
    info.uniqueKey = self.localFileName;
    info.chapterList = _chapter;
    info.courseDetail = self.courseDetail;
    
    return [[FTPDownloaderManager instance] getTransferByDownloadInfo:info];
}

//当传输状态发生改变时(开始，暂停，停止，完成...)的代理方法
- (void)klFTPTransfer:(KLFTPTransfer *)transfer transferStateDidChangedForItem:(KLFTPTransferItem *)item error:(NSError *)error
{
    NSString *str = [item.srcURL absoluteString];
    if ([str isEqualToString:_chapter.chapterFileURL]) {
        DLog(@"downloading cell status:%d", item.transferState);
        if (item.transferState == KLFTPTransferStateFinished) {
            [[GoHighDBManager instance] updateChapterDownloaded:_chapter.courseID.intValue withChapterId:_chapter.chapterID.intValue isDownloaded:1];
            
            if (_delegate && [_delegate respondsToSelector:@selector(downloaded)]) {
                [_delegate downloaded];
            }
        }
    }
}

//传输进度发生改变时的回调
- (void)klFTPTransfer:(KLFTPTransfer *)transfer progressChangedForItem:(KLFTPTransferItem *)item
{
    NSString *str = [item.srcURL absoluteString];
    if ([str isEqualToString:_chapter.chapterFileURL]) {
        DLog(@"%.2f",item.finishedSize*1.0f *100 / item.fileSize);
        [self.progressView setProgress:item.finishedSize*1.0f / item.fileSize];
        [[GoHighDBManager instance] updateChapterPercentage:_chapter.courseID.integerValue
                                              withChapterId:_chapter.chapterID.integerValue
                                                 percentage:item.finishedSize*1.0f / item.fileSize
                                         fileDownloadedSize:item.finishedSize
                                                   fileSize:item.fileSize];
    }
}

@end
