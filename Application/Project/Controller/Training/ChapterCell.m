//
//  ChapterCell.m
//  Project
//
//  Created by Yfeng__ on 13-11-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ChapterCell.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "FTPDownloaderManager.h"
#import "GoHighDBManager.h"
#import "TextPool.h"

#define FLOAT_ZERO  0.00000

#define BG_WIDTH  304.f
#define BG_HEIGHT CHAPTER_CELL_HEIGHT

#define BUTTON_WIDTH  21.f
#define BUTTON_HEIGHT 21.f

#define PERCENT_WIDTH 40.f
#define PERCENT_HEIGHT 25.f

#define INDEX_WIDTH 25.f

CellMargin CHCM = {2.f, 8.f, 0.f, 8.f};

@interface ChapterCell() <KLFTPTransferDelegate>

@property (nonatomic, assign) NSTimer *downloadTimer;
@end

@implementation ChapterCell {
    int _index;
    UILabel *_percentageLabel;
    UIImageView *_downloadingimageView;
    BOOL _bottom;
    BOOL _isResetDownload;
    
}

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = TRANSPARENT_COLOR;
        [self initViews];
        _index = index;
        [[FTPDownloaderManager instance] registerListener:self];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier bottom:(BOOL)bottom
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _bottom = bottom;
        self.backgroundColor = TRANSPARENT_COLOR;
        [self initViews];
        
        [[FTPDownloaderManager instance] registerListener:self];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = TRANSPARENT_COLOR;
        [self initViews];
        
        [[FTPDownloaderManager instance] registerListener:self];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [[FTPDownloaderManager instance] unRegisterListener:self];
    [_transfer release];
    [super dealloc];
}

- (void)initViews {
    _bgView = [[UIImageView alloc] initWithFrame:CGRectMake(CHCM.left, CHCM.top, BG_WIDTH, CHAPTER_CELL_HEIGHT)];
//    self.bgView.image = ImageWithName(@"training_cell_bg_unselect.png");
    self.bgView.image = [CommonMethod createImageWithColor:[UIColor whiteColor]];
    self.bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgView];
    
    _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat buttonY = (BG_HEIGHT - BUTTON_HEIGHT) / 2.f;
    self.checkButton.frame = CGRectMake(self.contentView.frame.size.width - BUTTON_WIDTH - 20, buttonY, BUTTON_WIDTH, BUTTON_HEIGHT);
//    [self.checkButton setBackgroundImage:ImageWithName(@"training_check.png") forState:UIControlStateSelected];
//    [self.checkButton setImage:ImageWithName(@"training_icon_download.png") forState:UIControlStateNormal];
    [self.checkButton addTarget:self action:@selector(checkButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.checkButton.backgroundColor = TRANSPARENT_COLOR;
    [self.bgView addSubview:self.checkButton];
    
    
   _downloadingimageView =  [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.checkButton.frame.size.width, self.checkButton.frame.size.height)];
    [_downloadingimageView setImage:IMAGE_WITH_NAME(@"training_cell_download_status_1.png")];
    
//    [self.checkButton addSubview:_downloadingimageView];
    
    CGRect rect =  self.checkButton.frame;
    
    _percentageLabel = [[UILabel alloc] initWithFrame:CGRectMake(rect.origin.x - PERCENT_WIDTH - 5, (BG_HEIGHT - PERCENT_HEIGHT) / 2.0f, PERCENT_WIDTH, PERCENT_HEIGHT)];
    _percentageLabel.textColor = [UIColor colorWithHexString:@"0xe83e0b"];
    _percentageLabel.backgroundColor = TRANSPARENT_COLOR;
    _percentageLabel.font = FONT_SYSTEM_SIZE(12);
    _percentageLabel.textAlignment = UITextAlignmentRight;
    [self.bgView addSubview:_percentageLabel];
    
    
    //----
    _indexLabel =  [self initLabel:CGRectZero
                         textColor:[UIColor colorWithHexString:@"0xB3B3B3"]
                       shadowColor:TRANSPARENT_COLOR];
    self.indexLabel.font = FONT_SYSTEM_SIZE(14);
    self.indexLabel.textAlignment = UITextAlignmentRight;
    [self.bgView addSubview:self.indexLabel];
    
    _titleLabel = [self initLabel:CGRectZero
                        textColor:[UIColor colorWithHexString:@"0xB3B3B3"]
                      shadowColor:TRANSPARENT_COLOR];
    self.titleLabel.font = FONT_SYSTEM_SIZE(14);
    [self.bgView addSubview:self.titleLabel];
    
    
 
}

- (void)resetViews {
    self.indexLabel.text = NULL_PARAM_VALUE;
    self.titleLabel.text = NULL_PARAM_VALUE;
    self.isDownloaded = NO;
}

- (void)drawChapter:(ChapterList *)chapterList withCourseDetailList:(id)course courseType:(int)courseType  index:(int)index{
    [self resetViews];
    
    self.chapterList = chapterList;
    self.courseDetail = course;
    self.courseType = courseType;
    
    //-------
    
    DLog(@"%@",[CommonMethod getLocalTrainingDownloadFolder]);
    DLog(@"%@",[CommonMethod convertURLToLocal:self.chapterList.chapterFileURL withId:[self.chapterList.chapterID stringValue]]);
    
    if ([[[self.chapterList.chapterFileURL lastPathComponent] pathExtension] isEqualToString:@"mp4"]) {
        self.localFileName = [CommonMethod getChapterFilePath:self.chapterList];
    }else {
        self.localFileName = [CommonMethod getChapterZipFilePath:self.chapterList];
    }
    
        
    DLog(@"%@ %@",chapterList.chapterFileURL, self.localFileName);
    
   self.transfer = [self getTransferInfo];
    
//    self.checkButton.selected = YES;
    DLog(@"%@",chapterList.chapterTitle);
    CGFloat disX = 12.f;
    
    
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.text =[NSString stringWithFormat:@"%@",chapterList.chapterTitle];
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    CGFloat titleY = (self.bgView.frame.size.height - titleSize.height*2) / 2.f;
    self.titleLabel.frame = CGRectMake(12 + INDEX_WIDTH, titleY, self.bgView.frame.size.width - disX * 3 - BUTTON_WIDTH - PERCENT_WIDTH, titleSize.height*2);
    [self.titleLabel sizeToFit];
    
    
    self.indexLabel.text = [NSString stringWithFormat:@"%d.",index+1];
    self.indexLabel.frame = CGRectMake(12, titleY, INDEX_WIDTH, titleSize.height);
    
    self.titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _percentageLabel.backgroundColor = TRANSPARENT_COLOR;
    self.indexLabel.backgroundColor = TRANSPARENT_COLOR;
    DLog(@"%d", self.titleLabel.numberOfLines);
    [self updateUI:chapterList];
//    [self updateStauts:self.transfer.transferItem];
    
    
//    if (_bottom)
    {
        

    int startX = 0;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(startX, CHAPTER_CELL_HEIGHT- 0.5, 320 - 2*startX, 0.5)];
    //    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
    line.backgroundColor = [UIColor colorWithHexString:@"0x666666"];
    [self addSubview:line];
    [line release];
        }
}

-(void)updatePercentageStatus:(int) status{
    /*
     KLFTPTransferStateUnknown     = 1 << 0,
     KLFTPTransferStateReady       = 1 << 1,
     KLFTPTransferStatePending     = 1 << 2,
     KLFTPTransferStateUploading   = 1 << 3,
     KLFTPTransferStateDownloading = 1 << 4,
     KLFTPTransferStatePaused      = 1 << 5,
     KLFTPTransferStateStopped     = 1 << 6,
     KLFTPTransferStateFailed      = 1 << 7,
     KLFTPTransferStateFinished    = 1 << 8
     */
    switch (status) {
            case KLFTPTransferStatePending:
        {
            [_percentageLabel setText:LocaleStringForKey(NSDownloadStatusPending, nil)];
            _percentageLabel.textColor = [UIColor colorWithHexString:@"0x59c16c"];
            [self updateStauts:status];
        }
            break;
        case KLFTPTransferStatePaused: {
            [_percentageLabel setText:LocaleStringForKey(NSDownloadStatusPause, nil)];
            _percentageLabel.textColor = [UIColor colorWithHexString:@"e83e0b"];
        }
            break;
        case KLFTPTransferStateDownloading: {
            
            _percentageLabel.textColor = [UIColor colorWithHexString:@"e83e0b"];
        }
            break;
            
        case KLFTPTransferStateFinished:
        {
//            [_percentageLabel setText:LocaleStringForKey(NSDownloadStatusFinished, nil)];
            [_percentageLabel setText:@""];
            _percentageLabel.textColor = [UIColor colorWithHexString:@"0x59c16c"];
            [self updateStauts:status];
        }
            break;
            case KLFTPTransferStateFailed:
        {
            if (_isResetDownload) {
                _isResetDownload = FALSE;
             [self.transfer start];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)updateUI:(ChapterList *)chapterList {
    
    if ([[GoHighDBManager instance] isDownloaded:chapterList.courseID.integerValue withChapterId:chapterList.chapterID.integerValue]) self.isDownloaded = YES;
    
    if (self.isDownloaded) {
        if (chapterList.chapterCompletion.intValue == 1) {
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_finished.png") forState:UIControlStateNormal];
//            self.bgView.image = ImageWithName(@"training_cell_bg_selected.png");
        }else {
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_finished.png") forState:UIControlStateNormal];
            
//            self.bgView.image = ImageWithName(@"training_cell_bg_unselect.png");
        }
        
        [self updatePercentageStatus:KLFTPTransferStateFinished];
        
    }else {
        if (chapterList.percentage.floatValue < 1.0 && chapterList.percentage.floatValue > FLOAT_ZERO) {
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_pause.png") forState:UIControlStateNormal];
//            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
        }else if (chapterList.percentage.floatValue == FLOAT_ZERO) {
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_1.png") forState:UIControlStateNormal];
//            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
        }
    }
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    _percentageLabel.text = @"";
    _percentageLabel = nil;
    _downloadingimageView = nil;
    self.checkButton = nil;
    
}

- (void)startDownloadChapter {
    [self checkButtonClicked:self.checkButton];
}

-(void)downloadingStatus:(int)status
{
    CGRect rect = self.checkButton.frame;
    rect.origin.y -= rect.size.height;
    _downloadingimageView.frame = rect;
    
    static int index = 0;
    float alphaBefore = 0;
    float alphaAfter;
    if (index++ %2) {
        alphaBefore = 1.0f;
        alphaAfter = 0.2f;
    }else{
        alphaBefore = 0.2f;
        alphaAfter = 1.0f;
    }
    
    self.checkButton.alpha = alphaBefore;
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.checkButton.alpha = alphaAfter;
        
    } completion:^(BOOL completion){
    }];
    
    
}

-(void)clearDownloadTimer
{
    self.checkButton.alpha = 1.0f;
    [self.downloadTimer invalidate];
    self.downloadTimer = nil;
}

-(void)startStudy
{
    if (_delegate && [_delegate respondsToSelector:@selector(startStudy:chapterList:fileName:)]) {
        [_delegate startStudy:self chapterList:_chapterList fileName:self.localFileName];
    }
}

- (void)checkButtonClicked:(UIButton *)sender {
    KLFTPTransferItem *item = self.transfer.transferItem;
    DLog(@"%d", item.transferState);
    switch (item.transferState) {
        case KLFTPTransferStateDownloading:
            [self.transfer pause];
            break;
        case KLFTPTransferStatePaused: {
            [self.transfer start];
            
        }
            break;
        case KLFTPTransferStateStopped:
            break;
        case KLFTPTransferStateFinished:            
        {
            [self startStudy];
        }
            break;
            
        default:
            if ( [[GoHighDBManager instance] isDownloaded:[_chapterList.courseID integerValue] withChapterId:[_chapterList.chapterID integerValue]]) {
                [self startStudy];
            }else{
                
                [self.transfer start];
            }
            break;
    }
    
    [self updateStauts:item.transferState];
    [self updateUI:self.chapterList];
}

- (void)updateStauts:(int)status
{
    switch (status) {
            case KLFTPTransferStatePending:
        {
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_1.png") forState:UIControlStateNormal];
            //            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
            
            if (!self.downloadTimer) {
                self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(downloadingStatus:) userInfo:[NSNumber numberWithInt:status] repeats:YES];
                
                [self.downloadTimer fire];
            }
        }
            break;
        case KLFTPTransferStateDownloading:
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_1.png") forState:UIControlStateNormal];
//            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
            
            if (!self.downloadTimer) {
                self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(downloadingStatus:) userInfo:[NSNumber numberWithInt:status] repeats:YES];
                
                [self.downloadTimer fire];
            }
            
            break;
        case KLFTPTransferStatePaused:
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_pause.png") forState:UIControlStateNormal];
//            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
            [self clearDownloadTimer];
            break;
        case KLFTPTransferStateStopped:
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_1.png") forState:UIControlStateNormal];
            //            self.bgView.image = ImageWithName(@"training_cell_bg_gray.png");
            [self clearDownloadTimer];
            break;
        case KLFTPTransferStateFinished:
            [self.checkButton setImage:ImageWithName(@"training_cell_download_status_finished.png") forState:UIControlStateNormal];
            //            self.bgView.image = ImageWithName(@"training_cell_bg_unselect.png");
            [self clearDownloadTimer];
            break;
            
        default:
            break;
    }
}

-(void)updatePercentage:(double)fileSize finishedSize:(double)finishedSize
{
    [_percentageLabel setText:[NSString stringWithFormat:@"%.0f%%", 100*finishedSize / fileSize]];
    [self updatePercentageStatus:KLFTPTransferStateDownloading];
}

- (KLFTPTransfer *)getTransferInfo
{
    DownloadInfo *info = [[[DownloadInfo alloc] init] autorelease];
    info.userName = @"anonymous";
    info.password = @"";
    info.downloadPath = [self.chapterList.chapterFileURL stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];// @"ftp://222.73.180.224/gohighfund/ios_test/gohighfund.ipa";//self.chapterList.chapterFileURL;
    info.localPath = self.localFileName;
    info.uniqueKey = self.localFileName;
    info.chapterList = self.chapterList;
    info.courseDetail = self.courseDetail;
    
    return [[FTPDownloaderManager instance] getTransferByDownloadInfo:info];
}

- (void)klFTPTransfer:(KLFTPTransfer *)transfer transferStateDidChangedForItem:(KLFTPTransferItem *)item error:(NSError *)error
{
    DLog(@"%@=%@", [item.destURL absoluteString].lastPathComponent, self.localFileName.lastPathComponent);
    if ([[item.destURL absoluteString].lastPathComponent isEqualToString:self.localFileName.lastPathComponent]) {
        
    if ([item.itemID isEqualToString:self.transfer.transferItem.itemID]) {
        
        [self updateStauts:item.transferState];
        if (item.transferState == KLFTPTransferStateFinished) {
            [[GoHighDBManager instance] updateChapterDownloaded:self.chapterList.courseID.integerValue
                                                  withChapterId:self.chapterList.chapterID.integerValue
                                                   isDownloaded:1];
            self.isDownloaded = YES;
            
        }
        
        [self updatePercentageStatus:item.transferState];
        
    }
    }
}

- (void)klFTPTransfer:(KLFTPTransfer *)transfer progressChangedForItem:(KLFTPTransferItem *)item
{
//    CGFloat percent = item.finishedSize/(CGFloat)item.fileSize;
    
    DLog(@"%@=%@", [item.destURL absoluteString].lastPathComponent, self.localFileName.lastPathComponent);
    if ([[item.destURL absoluteString].lastPathComponent isEqualToString:self.localFileName.lastPathComponent]) {
        
    if ([item.itemID isEqualToString:self.transfer.transferItem.itemID]) {
        DLog(@"%.2f",item.finishedSize/(CGFloat)item.fileSize);
        
        [[GoHighDBManager instance] updateChapterPercentage:self.chapterList.courseID.integerValue
                                              withChapterId:self.chapterList.chapterID.integerValue
                                                 percentage:item.finishedSize/(CGFloat)item.fileSize
                                         fileDownloadedSize:item.finishedSize
                                                   fileSize:item.fileSize];
        
        [self updatePercentage:item.fileSize finishedSize:item.finishedSize];
    }
    }

}


-(void)drawBottom
{
    int height = 10;
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CHAPTER_CELL_HEIGHT - 6, self.frame.size.width, height)];
    //    line.backgroundColor = [UIColor colorWithWhite:.8 alpha:1.f];
//    line.backgroundColor = COLOR_WITH_IMAGE_NAME(@"training_cell_bottom.png");
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
    [line release];
}

-(void)resetDownloadStatus
{
    _isResetDownload = TRUE;
    self.transfer.transferItem.transferState = KLFTPTransferTypeUnknown;
    [self updateStauts:KLFTPTransferStateStopped];
}

@end
