//
//  CircleMarketingDetailViewController.m
//  Project
//
//  Created by XXX on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingDetailViewController.h"
#import "CommonHeader.h"
#import "ProjectAPI.h"
#import "AppManager.h"
#import "TextPool.h"
#import "WXWLabel.h"
#import "JSONParser.h"
#import "EventDetailList.h"
#import "EventApplyList.h"
#import "EventImageDetailList.h"
#import "CircleMarketingDetailViewCell.h"
#import "CircleMarketingDetailTitleCell.h"
#import "CircleMarketingMoreDetailViewController.h"
#import "CircleMarkegingApplyWindow.h"
#import "CircleMarketingMemberListViewController.h"
#import "CustomeAlertView.h"
#import "JSONKit.h"
#import "NSDate+Utils.h"
#import "WXWCoreDataUtils.h"
#import "CirleMarketingVoteViewController.h"
#import "CircleMarketingEventCommentViewController.h"
#import "ImageWallScrollView.h"
#import "MHFacebookImageViewer.h"
#import "CommonUtils.h"
#import "WXApi.h"
#import "GoHighDBManager.h"

#define BOTTOM_HEIGHT 44.f

#define MARGIN_LEFT   13.f
#define MARGIN_RIGHT  15.f

#define BUTTON_READ_COMMENT_WIDTH  29.f
#define BUTTON_READ_COMMENT_HEIGHT 25.f

#define BUTTON_SHARE_WIDTH  28.f
#define BUTTON_SHARE_HEIGHT 28.f

#define BUTTON_MORE_WIDTH  150.f
#define BUTTON_MORE_HEIGHT 30.f

#define VIDEO_35INCH_HEIGHT   150.0f
#define VIDEO_40INCH_HEIGHT   238.0f

#define LINE_HEIGHT 8.f

@interface CircleMarketingDetailViewController () <CircleMarketingDetailTitleCellDelegate,
CircleMarkegingApplyWindowDelegate,
CustomeAlertViewDelegate,
ImageWallDelegate,
MHFacebookImageViewerDatasource,
UIActionSheetDelegate, WXApiDelegate,CircleMarketingEventCommentViewControllerDelegate>
{
    int eventId;
    int type;
}

@property (nonatomic, assign) NSMutableArray * imageArray;
@end

@implementation CircleMarketingDetailViewController {
    
    ImageWallScrollView *_imageWallScrollView;
    EventDetailList *_eventDetailList;
    EventList *_eventList;
    
    NSArray *eventImages;
    NSArray *eventTitles;
    
    UILabel *_commentLabel;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
      withEventId:(int)eventId
       detailType:(int)type {
    if (self = [super initWithMOC:MOC]) {
        self.parentVC = pVC;
       eventId = eventId;
        type = type;
        
        
        [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withEventList:(EventList *)eventList
       detailType:(int)type
{
    if (self = [super initWithMOC:MOC]) {
        self.parentVC = pVC;
        _eventList = eventList;
        eventId = [eventList.eventId integerValue];
        type = type;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = @"活动详情";
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    //    [self initImageWall];
    [self initData];
    
    _tableView.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, self.view.frame.size.height - BOTTOM_HEIGHT);
    _tableView.backgroundColor = TRANSPARENT_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self addBottomView];
    
    [_tableView setAlpha:1.0f];
    
}

- (void)initData {
    _imageArray = [[NSMutableArray alloc] init];
    eventImages = [[NSArray alloc] initWithObjects:@"circleMarketing_eventDetail_eventTheme", @"circleMarketing_eventDetail_eventTime", @"circleMarketing_eventDetail_eventLocation", @"circleMarketing_eventDetail_eventComment", @"circleMarketing_eventDetail_eventContact", nil];
    eventTitles = [[NSArray alloc] initWithObjects:@"活动主题", @"活动时间", @"活动地点", @"活动目的", @"参加人员", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_autoLoaded) {
        [self reloadViewData];
    }
    
    [self updateLastSelectedCell];
}

- (void)reloadViewData {
    [WXWCoreDataUtils unLoadObject:_MOC predicate:nil entityName:@"EventDetailList"];
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)dealloc
{
    [eventImages release];
    [eventTitles release];
    [_imageArray release];
    
    //    if (_imageWallContainer) {
    //        [_imageWallContainer removeFromSuperview];
    //        //        _imageWallContainer = nil;
    //        RELEASE_OBJ(_imageWallContainer);
    //    }
    
    
    [super dealloc];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addBottomView {
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, [GlobalInfo getDeviceSize].height - BOTTOM_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottom.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"bottomBg.png")];
    [self.view addSubview:bottom];
    
    CGFloat readOriginY = (BOTTOM_HEIGHT - BUTTON_READ_COMMENT_HEIGHT) / 2.f;
    
    UIImageView *readImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT, readOriginY, 25.f, 20.f)];
    readImageView.image = IMAGE_WITH_NAME(@"information_vote.png");
    [bottom addSubview:readImageView];
    
    UILabel *readLabel = [[UILabel alloc] initWithFrame:CGRectMake(readImageView.frame.size.width + readImageView.frame.origin.x+8, readOriginY, 90, BUTTON_READ_COMMENT_HEIGHT)];
    readLabel.backgroundColor = TRANSPARENT_COLOR;
    readLabel.font = FONT_SYSTEM_SIZE(14);
    readLabel.text = @"投票";
    readLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:readLabel];
    
    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    readButton.frame = CGRectMake(readImageView.frame.origin.x, readOriginY, readImageView.frame.size.width + readLabel.frame.size.width, BUTTON_READ_COMMENT_HEIGHT);
    //    [readButton setBackgroundImage:ImageWithName(@"read.png") forState:UIControlStateNormal];
    [readButton addTarget:self action:@selector(vote:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:readButton];
    
    [readLabel release];
    [readImageView release];
    
    CGFloat commentOriginY = (BOTTOM_HEIGHT - BUTTON_READ_COMMENT_HEIGHT) / 2.f;
    
    UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN_LEFT + BUTTON_READ_COMMENT_WIDTH + 90, commentOriginY, 25.f, 25.f)];
    commentImageView.image = IMAGE_WITH_NAME(@"information_comment.png");
    [bottom addSubview:commentImageView];
    
    _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentImageView.frame.size.width + commentImageView.frame.origin.x+8, commentOriginY, 90, BUTTON_READ_COMMENT_HEIGHT)];
    _commentLabel.backgroundColor = TRANSPARENT_COLOR;
    _commentLabel.font = FONT_SYSTEM_SIZE(14);
    _commentLabel.text = @"讨论";
    _commentLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:_commentLabel];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(commentImageView.frame.origin.x, commentOriginY, commentImageView.frame.size.width + _commentLabel.frame.size.width, BUTTON_READ_COMMENT_HEIGHT);
    //    [commentButton setBackgroundImage:ImageWithName(@"comment.png") forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:commentButton];
    
    [_commentLabel release];
    [commentImageView release];
    
    CGFloat shareOriginY = (BOTTOM_HEIGHT - BUTTON_SHARE_HEIGHT) / 2.f;
    CGSize shareLabelSize = [CommonMethod sizeWithText:@"分享" font:FONT_SYSTEM_SIZE(14)];
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - MARGIN_RIGHT - shareLabelSize.width, shareOriginY, shareLabelSize.width, BUTTON_READ_COMMENT_HEIGHT)];
    shareLabel.backgroundColor = TRANSPARENT_COLOR;
    shareLabel.font = FONT_SYSTEM_SIZE(14);
    shareLabel.text = @"分享";
    shareLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    [bottom addSubview:shareLabel];
    
    
    UIImageView *shareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(shareLabel.frame.origin.x - BUTTON_SHARE_WIDTH, shareOriginY, 20.f, 29.f)];
    shareImageView.image = IMAGE_WITH_IMAGE_NAME(@"information_share.png");
    [bottom addSubview:shareImageView];
    
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(shareImageView.frame.origin.x, 0, shareLabelSize.width + BUTTON_SHARE_WIDTH, BOTTOM_HEIGHT);
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:shareButton];
    
    [shareImageView release];
    [shareLabel release];
    
    [bottom release];
}

#pragma mark - button action

- (void)vote:(UIButton *)sender {
    CirleMarketingVoteViewController *vc = [[[CirleMarketingVoteViewController alloc] initWithMOC:_MOC parentVC:self eventID:1] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)comment:(UIButton *)sender {
    CircleMarketingEventCommentViewController *vc = [[[CircleMarketingEventCommentViewController alloc] initWithMOC:_MOC parentVC:self commentType:CommentType_Event paramId:eventId] autorelease];
    vc.delegate = self;
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}

- (void)updateCommentCount:(int)count
{
}

- (void)share:(UIButton *)sender {
    
    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    
    /*
     NSString *file = [[NSBundle mainBundle] pathForResource:@"newsTipDownload" ofType:@"html"];
     
     [WXWCommonUtils openLocalWebView:[CommonMethod getInstance].navigationRootViewController.navigationController
     title:@"分享到微信"
     url:file
     needCloseButton:NO
     needNavigation:NO
     needHomeButton:NO];
     */
    
    /*
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到:"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"微信", nil];
//otherButtonTitles:@"聊天界面", @"朋友圈", @"收藏", nil];
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES];
     */
}

#pragma mark - actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet cancelButtonIndex]) {
        //        [actionSheet dismissWithClickedButtonIndex:[actionSheet cancelButtonIndex] animated:YES];
    }else {
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            BOOL reult = [CommonUtils shareByWeChat:buttonIndex
                                              title:_eventList.eventTitle
                                              image:[CommonMethod getAppIcon]
                                        description:_eventList.eventTheme
                                                url:_eventList.eventUrl];
            if (reult) {
                DLog(@"share sucessfully");
            }
        }else {
            UIAlertView *alView = [[UIAlertView alloc] initWithTitle:@""
                                                             message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"免费下载微信", nil];
            [alView show];
            [alView release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        NSString *weiXinLink = @"itms-apps://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weiXinLink]];
    }
}

#pragma mark -- weixin delegate

- (void)onResp:(BaseResp *)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
}

#pragma mark -- load data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    if (type == 0)
        _currentType = LOAD_EVENT_DETAIL_PRE_TY;
    else
        _currentType = LOAD_EVENT_DETAIL_REV_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(eventId) forKey:KEY_API_PARAM_EVENT_ID];
    //    [specialDict setObject:NUMBER(2) forKey:KEY_API_PARAM_LEVEL];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_EVENT withApiName:API_NAME_GET_EVENT_DETAIL withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}


- (void)loadSubmitApplyData:(LoadTriggerType)triggerType forNew:(BOOL)forNew withApplyList:(NSArray *)applyList {
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(eventId) forKey:KEY_API_PARAM_EVENT_ID];
    
    NSMutableArray *applyArray = [NSMutableArray array];
    
    for (EventApplyList * apply in applyList) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:apply.applyId forKey:KEY_API_PARAM_APPLY_ID];
        [dict setObject:apply.applyResult forKey:KEY_API_PARAM_APPLY_RESULT];
        [dict setObject:apply.applyTitle forKey:KEY_PAI_PARAM_APPLY_TITLE];
        
        [applyArray addObject:dict];
    }
    
    [specialDict setObject:applyArray forKey:KEY_API_PARAM_APPLY_LIST];
    
    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_EVENT,API_NAME_SUBMIT_EVENT_APPLY_INFO];
    
    
    _currentType = SUBMIT_APPLY_TY;
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
}

- (void)configureMOCFetchConditions {
    self.entityName = @"EventDetailList";
    //    DLog(@"detail: %d",eventId);
    self.predicate = [NSPredicate predicateWithFormat:@"eventId == %d",eventId];
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"eventId"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
    
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_EVENT_DETAIL_PRE_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self refreshTable];
             
#if 1
                NSArray *eventListArray = self.fetchedRC.fetchedObjects;
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                //                [[GoHighDBManager instance] upinsertCircleMarketing:eventListArray timestamp:[timestamp doubleValue]];
                
                if (eventListArray && eventListArray.count) {
                    for (EventDetailList * event  in eventListArray) {
                        if ([event.eventId integerValue] == eventId) {
                            _eventDetailList = event;
                            
                            _eventList = event;
                            [self refreshTable];
                        }
                    }
                    
                    
                    DLog(@"%d:%d", [_eventDetailList.eventId integerValue], _eventDetailList.eventApplyList.count);
                    [self.imageArray removeAllObjects];
                    for (EventImageDetailList *apply in _eventDetailList.eventImageDetailList) {
                        [self.imageArray addObject:apply];
                        DLog(@"%@", apply.imageUrl);
                    }
                    
                    //                    [_imageWallContainer loadImagesDataWith:self.imageArray type:ListType_Image];
                    
                    [_imageWallScrollView updateImageListArray:self.imageArray];
                    
                }
                _autoLoaded = YES;
#endif
            }
            break;
        }
        case LOAD_EVENT_DETAIL_REV_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                [self refreshTable];
#if 0
                NSArray *eventListArray = self.fetchedRC.fetchedObjects;
                
                if (eventListArray && eventListArray.count) {
                    for (EventDetailList * event  in eventListArray) {
                        if ([event.eventId integerValue] == eventId) {
                            _eventDetailList = event;
                            [self refreshTable];
                        }
                    }
                    DLog(@"%d:%d", [_eventDetailList.eventId integerValue], _eventDetailList.eventApplyList.count);
                    [self.imageArray removeAllObjects];
                    for (EventImageDetailList *apply in _eventDetailList.eventImageDetailList) {
                        if (apply.eventDetailList.eventId.intValue == _eventDetailList.eventId.intValue) {
                            [self.imageArray addObject:apply];
                            DLog(@"%@", apply.imageUrl);
                        }
                        
                    }
                    
                    [_imageWallScrollView updateImageListArray:self.imageArray];
                }
                _autoLoaded = YES;
#endif
            }
            
            
            break;
        }
            
        case SUBMIT_APPLY_TY: {
            
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                _noNeedDisplayEmptyMsg = YES;
                [self popupSuccessAlertView];
                _autoLoaded = YES;
                
                [self reloadViewData];
            }
        }
            break;
        default:
            break;
    }
    
    //    _noNeedDisplayEmptyMsg = YES;
    _autoLoaded = YES;
    [super connectDone:result
                   url:url
           contentType:contentType];
}
- (void)connectCancelled:(NSString *)url
contentType:(NSInteger)contentType {
    
    [super connectCancelled:url contentType:contentType];
}

- (void)connectFailed:(NSError *)error
url:(NSString *)url
contentType:(NSInteger)contentType {
    
    if ([self connectionMessageIsEmpty:error]) {
        self.connectionErrorMsg = LocaleStringForKey(NSActionFaildMsg, nil);
    }
    
    [super connectFailed:error url:url contentType:contentType];
}



//- (void)openVideos:(id)sender {
//
//}


#pragma mark - image wall delegate

- (void)clickedImageWithImage:(UIImageView *)imageView {
    
    [imageView setupImageViewerWithDatasource:self initialIndex:_imageWallScrollView.currentPageIndex onOpen:^{
        
    } onClose:^{
        
    }];
}


#pragma mark - MHFacebookImageViewerDatasource

- (NSInteger)numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer {
    return self.imageArray.count;
}

-  (NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer {
    //    return [NSURL URLWithString:[NSString stringWithFormat:@"http://iamkel.net/projects/mhfacebookimageviewer/%i.png",index]];
    EventImageDetailList *bl = (EventImageDetailList *)self.imageArray[index];
    return [NSURL URLWithString:[bl.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    
    //    return [UIImage imageNamed:[NSString stringWithFormat:@"%i_iphone",index]];
    return nil;
}

#pragma mark - play/stop video auto scroll
- (void)stopPlay {
    //    if (_imageWallContainer) {
    //        [_imageWallContainer stopPlay];
    //    }
}

#pragma mark - draw cell

- (UITableViewCell *)drawVideoCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"videoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        //        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
        //                                       reuseIdentifier:nil] autorelease];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kCellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
        cell.contentView.backgroundColor = TRANSPARENT_COLOR;
        
        NSString *scrollImageWallBackground =@"defaultLoadingImage.png";
        
        _imageWallScrollView = [[ImageWallScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                     10,
                                                                                     _tableView.frame.size.width,
                                                                                     VIDEO_35INCH_HEIGHT) backgroundImage:scrollImageWallBackground];
        
        _imageWallScrollView.delegate = self;
        [cell.contentView addSubview:_imageWallScrollView];
        
        if (_eventList.eventImageList.count) {
            [self.imageArray removeAllObjects];
            for (EventImageDetailList *apply in _eventList.eventImageList) {
                [self.imageArray addObject:apply];
            }
            
            [_imageWallScrollView updateImageListArray:self.imageArray];
        }
    }
    
    //    if (_imageWallContainer) {
    //        [_imageWallContainer removeFromSuperview];
    ////        _imageWallContainer = nil;
    //        RELEASE_OBJ(_imageWallContainer);
    //    }
    
    //    [_imageWallContainer reloadData];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, _imageWallScrollView.frame.origin.y + _imageWallScrollView.frame.size.height, _imageWallScrollView.frame.size.width, LINE_HEIGHT)];
    line.image = ImageWithName(@"event_detail_wave.png");
    [cell.contentView addSubview:line];
    [line release];
    
    return cell;
}

- (CircleMarketingDetailViewCell *)drawCirleMarketingDetailCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *cricleMarketing = @"CIRCLEMARKETING_CELL";
    CircleMarketingDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cricleMarketing];
    if (!cell) {
        
        cell = [[[CircleMarketingDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cricleMarketing] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //    CircleMarketingDetailViewCell *cell = [[[CircleMarketingDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.iconView.image = ImageWithName(eventImages[indexPath.row - 2]);
    cell.titleLabel.text = eventTitles[indexPath.row - 2];
    switch (indexPath.row) {
        case 2: cell.contentLabel.text = _eventList.eventTheme; break;
        case 3: {
            if (_eventList.startTimeStr && _eventList.endTimeStr) {
                NSString *start = [_eventList.startTimeStr componentsSeparatedByString:@" "][0];
                NSString *end =  [_eventList.endTimeStr componentsSeparatedByString:@" "][0];
                
                if ([start isEqualToString:end]){
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@", start];
                }
                else{
                    cell.contentLabel.text = [NSString stringWithFormat:@"%@~%@", start,end];
                }
            }
        }break;
        case 4: cell.contentLabel.text = _eventList.eventAddress; break;
        case 5: cell.contentLabel.text = _eventList.eventPurpose; break;
        case 6: cell.contentLabel.text = _eventList.partakes; break;
        default:
            break;
    }
    return cell;
    
}

- (CircleMarketingDetailTitleCell *)drawCircleMarketingDetailTitleCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *titleCellId = @"title_cell_id";
    
    CircleMarketingDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
    if (!cell) {
        cell = [[[CircleMarketingDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //    CircleMarketingDetailTitleCell *cell = [[[CircleMarketingDetailTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
    //    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    cell.titleLabel.text = _eventList.eventTitle;
    [cell.leftButton setTitle:[NSString stringWithFormat:@"已报名:%d人",[_eventList.applyCount intValue]] forState:UIControlStateNormal];
    if (_eventList.applyStatus.intValue == 0) {
        [cell.rightButton setTitle:@"报名参加" forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor colorWithHexString:@"0xe83e0b"]];
    }else if (_eventList.applyStatus.intValue == 1) {
        [cell.rightButton setTitle:@"已报名" forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor colorWithHexString:@"0x949494"]];
        cell.rightButton.userInteractionEnabled = NO;
    }else if (_eventList.applyStatus.intValue == 2) {
        [cell.rightButton setTitle:@"已审核" forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor colorWithHexString:@"0x949494"]];
        cell.rightButton.userInteractionEnabled = NO;
    }
    
    if ([[NSDate dateTimeByEndMiniuteFromString:_eventList.endTimeStr] compare:[NSDate date]] == NSOrderedAscending) {
        [cell.rightButton setTitle:@"已过期" forState:UIControlStateNormal];
        [cell.rightButton setBackgroundColor:[UIColor colorWithHexString:@"0x949494"]];
        cell.rightButton.userInteractionEnabled = NO;
        cell.rightButton.hidden = YES;
    }
    
    return cell;
}

- (UITableViewCell *)drawMoreCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"more_cell_id";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UIView *v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 60)] autorelease];
    v.backgroundColor = TRANSPARENT_COLOR;
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(70, 15, BUTTON_MORE_WIDTH, BUTTON_MORE_HEIGHT);
    moreButton.center = v.center;
    [moreButton setTitle:@"查看更多活动详情" forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor colorWithHexString:STYLE_BLUE_COLOR] forState:UIControlStateNormal];
    [moreButton.titleLabel setFont:FONT(18)];
    [moreButton addTarget:self action:@selector(lookMore:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:moreButton];
    [cell.contentView addSubview:v];
    return cell;
}

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            return VIDEO_35INCH_HEIGHT + 10 + LINE_HEIGHT;
        } break;
        case 1: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.eventTitle
                                                    font:FONT_SYSTEM_SIZE(16)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(16)}].height;
            return TITLE_CELL_HEIGHT + height / 2;
        } break;
            
        case 2: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.eventTheme
                                                    font:FONT_SYSTEM_SIZE(12)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height;
            return CELL_DETAIL_BASE_HEIGHT + height;
        } break;
        case 3: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.endTimeStr
                                                    font:FONT_SYSTEM_SIZE(12)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height;
            return CELL_DETAIL_BASE_HEIGHT + height;
        } break;
        case 4: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.eventAddress
                                                    font:FONT_SYSTEM_SIZE(12)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height;
            return CELL_DETAIL_BASE_HEIGHT + height;
        } break;
        case 5: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.eventPurpose
                                                    font:FONT_SYSTEM_SIZE(12)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height;
            return CELL_DETAIL_BASE_HEIGHT + height;
        } break;
        case 6: {
            CGFloat height = [WXWCommonUtils sizeForText:_eventList.partakes
                                                    font:FONT_SYSTEM_SIZE(12)
                                       constrainedToSize:CGSizeMake(270, MAXFLOAT)
                                           lineBreakMode:NSLineBreakByCharWrapping
                                                 options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                              attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(12)}].height;
            return CELL_DETAIL_BASE_HEIGHT + height;
        } break;
        case 7: {
            return 60.f;
        } break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark - uitableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self calculateCellHeight:tableView atIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [self drawVideoCell:tableView atIndexPath:indexPath];
    }else if (indexPath.row == 1) {
        return [self drawCircleMarketingDetailTitleCell:tableView atIndexPath:indexPath];
    }else if (indexPath.row == 7) {
        return [self drawMoreCell:tableView atIndexPath:indexPath];
    }else {
        return [self drawCirleMarketingDetailCell:tableView atIndexPath:indexPath];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _fetchedRC.fetchedObjects.count) {
        return;
    }
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - cell delegate

- (void)circleMarketingDetailTitleCell:(CircleMarketingDetailTitleCell *)cell leftButtonClicked:(UIButton *)leftButton {
    CircleMarketingMemberListViewController *vc = [[[CircleMarketingMemberListViewController alloc] initWithMOC:_MOC parentVC:self eventId:eventId] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)circleMarketingDetailTitleCell:(CircleMarketingDetailTitleCell *)cell rightButtonClicked:(UIButton *)rightButton {
    
//    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"报名成功" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
    
    CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_TableView];
    customeAlertView.applyDelegate = self;
    [customeAlertView updateInfo:_eventList];
    
    [customeAlertView show];
}

- (void)lookMore:(UIButton *)sender {
    CircleMarketingMoreDetailViewController *vc = [[[CircleMarketingMoreDetailViewController alloc] initWithMOC:_MOC content:_eventList.eventDescription] autorelease];
    DLog(@"%@",_eventList.eventDescription);
    [CommonMethod pushViewController:vc withAnimated:YES];
}


#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView
{
    
    [alertView release];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *) alertView applyList:(NSArray *)applyArray
{
    [alertView release];
    [self loadSubmitApplyData:TRIGGERED_BY_AUTOLOAD forNew:FALSE withApplyList:applyArray];
}

- (void)circleMarketingApplyWindow:(CircleMarkegingApplyWindow *)alertView didEndEditing:(NSString *)text {
    
}

#pragma mark --  customer alert delegate

- (void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView
{
    [alertView release];
}

#pragma mark -- pop up alert view
- (void)popupSuccessAlertView
{
    CustomeAlertView *customeAlertView = [[CustomeAlertView alloc]init];
    customeAlertView.delegate = self;
    
    NSString *title =@"报名成功";
    NSMutableArray * tips = [NSMutableArray array];
    NSDictionary * t1 = [NSDictionary dictionaryWithObjectsAndKeys:@"您的报名已成功,",CUSTOMIZED_TIP, @"0x979797", CUSTOMIZED_COLOR, nil];
    NSDictionary * t2 = [NSDictionary dictionaryWithObjectsAndKeys:@"请等待管理员审核",CUSTOMIZED_TIP, @"0xe83e0b", CUSTOMIZED_COLOR, nil];
    NSDictionary * t3 = [NSDictionary dictionaryWithObjectsAndKeys:@"，审核通过后，我们会通过私信的方式通知您！",CUSTOMIZED_TIP, @"0x979797", CUSTOMIZED_COLOR, nil];
    
    [tips addObject:t1];
    [tips addObject:t2];
    [tips addObject:t3];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:title,CUSTOMIZED_TITLE,tips,CUSTOMIZED_TIP_ARRAY,  nil];
    
    [customeAlertView updateInfoWithColor:dict];
    
    [customeAlertView show];
}


@end
