//
//  CircleMarketingEventCommitViewController.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingEventCommentViewController.h"
#import "CircleMarketingEventCommentViewCell.h"
#import "CommonHeader.h"
#import "CommonUtils.h"
#import "JSONParser.h"
#import "JSONKit.h"
#import "ProjectAPI.h"
#import "TextPool.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"
#import "CommentList.h"
#import "CircleMarkegingApplyWindow.h"
#import "CustomeAlertView.h"
#import "GCPlaceholderTextView.h"

#define kMaxCharacterCount 200

#define BOTTOM_HEIGHT 44.f

#define ICON_WIDTH  20.f
#define ICON_HEIGHT 20.f

@interface CircleMarketingEventCommentViewController ()<CircleMarkegingApplyWindowDelegate, CustomeAlertViewDelegate, UITextViewDelegate> {
    BOOL submited;
    CommentType commentType;
}

@property (nonatomic) NSInteger paramId;
@property (nonatomic, copy) NSString *content;

@end

@implementation CircleMarketingEventCommentViewController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pvc
      commentType:(CommentType)ctype
          paramId:(int)pid {
    self = [super initWithMOC:MOC
        needRefreshHeaderView:YES
        needRefreshFooterView:YES];
    if (self) {
        _paramId = pid;
        
        commentType = ctype;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"评论内容";
    
    _tableView.hidden = NO;
    _tableView.alpha = 1.f;
    _tableView.frame =CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - BOTTOM_HEIGHT);
    [self addCommentView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCommentView {
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT, self.view.frame.size.width, BOTTOM_HEIGHT)];
    bottom.backgroundColor = [UIColor colorWithPatternImage:IMAGE_WITH_NAME(@"bottomBg.png")];
    [self.view addSubview:bottom];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"发布评论";
    label.textColor = [UIColor blackColor];
    [bottom addSubview:label];
    
    CGSize size = [WXWCommonUtils sizeForText:label.text
                                         font:label.font
                            constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                lineBreakMode:NSLineBreakByCharWrapping
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName : label.font}];
    
    CGFloat iconY = (bottom.frame.size.height - ICON_HEIGHT) / 2.f;
    CGFloat iconX = (self.view.frame.size.width - (ICON_WIDTH + size.width)) / 2.f;
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, ICON_WIDTH, ICON_HEIGHT)];
    icon.image = ImageWithName(@"information_releaseComment.png");
    [bottom addSubview:icon];
    
    CGFloat labelY = iconY + (ICON_HEIGHT - size.height) / 2.f;
    label.frame = CGRectMake(icon.frame.origin.x + icon.frame.size.width, labelY, size.width, size.height);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(80, 0, 150, 44);
    [button addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    [bottom addSubview:button];
    
    [icon release];
    [label release];
    [bottom release];
}

#pragma mark - submit comment

- (void)submitComment:(UIButton *)sender {
    
    CircleMarkegingApplyWindow *customeAlertView = [[CircleMarkegingApplyWindow alloc] initWithType:AlertType_TextView];
    customeAlertView.applyDelegate = self;
    [customeAlertView resetContentView:@"发布评论"];
    [customeAlertView show];
}

- (UITextView *)commentView {
    
    GCPlaceholderTextView *textView = [[[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 0, 250, 120)] autorelease];
    textView.delegate = self;
    textView.showsHorizontalScrollIndicator = NO;
    textView.backgroundColor = TRANSPARENT_COLOR;
    textView.placeholder =[NSString stringWithFormat:@"请输入评论内容，不超过%d字。",kMaxCharacterCount];
    textView.font = FONT_SYSTEM_SIZE(14);
    textView.scrollEnabled = YES;
    //    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    return textView;
}

#pragma mark -- circle marketing delegate

- (void)circleMarkegingApplyWindowCancelDismiss:(CircleMarkegingApplyWindow *) alertView
{
    
    [alertView release];
}

- (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *) alertView applyList:(NSArray *)applyArray
{
    submited = YES;
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    [alertView release];
}

- (void)circleMarketingApplyWindow:(CircleMarkegingApplyWindow *)alertView didEndEditing:(NSString *)text {
    self.content = text;
}

#pragma mark --  customer alert delegate

-(void)CustomeAlertViewDismiss:(CustomeAlertView *) alertView
{
    [alertView release];
}

#pragma mark - load list data

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    [super loadListData:triggerType forNew:forNew];
    
    if (submited) {
        int pid = 0;
        
        if (commentType == CommentType_Informtaion) {
            _currentType = SUBMIT_INFORMATION_COMMENT_TY;
            pid = 2;
        }else if (commentType == CommentType_Event) {
            _currentType = SUBMIT_EVENT_COMMENT_TY;
            pid = 1;
        }
        
        NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
        [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
        
        [specialDict setObject:self.content forKey:KEY_API_PARAM_CONTENT];
        [specialDict setObject:NUMBER(_paramId) forKey:KEY_API_PARAM_EVENT_ID];
        [specialDict setObject:@(commentType) forKey:KEY_API_PARAM_COMMENTTYPE];
        //        [specialDict setObject:@(_paramId) forKey:KEY_API_PARAM_EVENT_ID];
        
        NSDictionary *commonDict = [AppManager instance].common;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (commonDict) {
            [dict setObject:commonDict forKey:@"common"];
        }
        if (specialDict) {
            [dict setObject:specialDict forKey:@"special"];
        }
        
        NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [requestDict setObject:[AppManager instance].common forKey:@"common"];
        [requestDict setObject:specialDict forKey:@"special"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_EVENT,API_NAME_SUBMIT_EVENT_COMMENT];
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                                  contentType:_currentType];
        [connFacade post:urlString data:[requestDict JSONData]];
        
    }else {
        
        int pid = 0;
        
        if (commentType == CommentType_Informtaion) {
            _currentType = LOAD_INFORMATION_COMMENT_TY;
            pid = 2;
        }else if (commentType == CommentType_Event) {
            _currentType = LOAD_EVENT_COMMENT_TY;
            pid = 1;
        }
        NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
        
        [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
        [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
        
        [specialDict setObject:@(_paramId) forKey:KEY_API_PARAM_EVENT_ID];
        //        [specialDict setObject:@1 forKey:KEY_API_PARAM_EVENT_ID];
        [specialDict setObject:@"" forKey:KEY_API_PARAM_DISPLAY_INDEX_LAST];
        [specialDict setObject:@"" forKey:KEY_API_PARAM_TIME_STAMP];
        [specialDict setObject:@(commentType) forKey:KEY_API_PARAM_COMMENTTYPE];
        
        NSDictionary *commonDict = [AppManager instance].common;
        
        NSString *url = [ProjectAPI getRequestURL:API_SERVICE_EVENT withApiName:API_NAME_GET_EVENT_COMMENT_LIST withCommon:  commonDict withSpecial:specialDict];
        
        WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                                  contentType:_currentType];
        [connFacade fetchGets:url];
    }
}

#pragma mark - cell height

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    CommentList *cl = (CommentList *)[self.fetchedRC objectAtIndexPath:indexPath];
    
    return COMMENT_CELL_DEFAULT_HEIGHT + [WXWCommonUtils sizeForText:cl.content
                                                                font:FONT_SYSTEM_SIZE(13)
                                                   constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT)
                                                       lineBreakMode:NSLineBreakByCharWrapping
                                                             options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                                          attributes:@{NSFontAttributeName : FONT_SYSTEM_SIZE(13)}].height;
    
}

#pragma mark - uitableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedRC.fetchedObjects.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.fetchedRC.fetchedObjects.count) {
        return [self calculateCellHeight:tableView atIndexPath:indexPath];
    }
    return 40.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
        return [self drawFooterCell];
    }else {
        static NSString *commentCellId = @"comment_cell";
        
        CircleMarketingEventCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellId];
        if (!cell) {
            cell = [[CircleMarketingEventCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellId imageDisplayerDelegate:self MOC:_MOC];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.userInteractionEnabled = NO;
        }
        
        CommentList *cl = (CommentList *)[self.fetchedRC objectAtIndexPath:indexPath];
        [cell drawEventCommit:cl];
        
        return cell;
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
////    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    _noNeedDisplayEmptyMsg = YES;
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_EVENT_COMMENT_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self refreshTable];
            }
            break;
        }
        case LOAD_INFORMATION_COMMENT_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self refreshTable];
            }
            break;
        }
            
        case SUBMIT_EVENT_COMMENT_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:@"提交成功！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES
                                          animationEnded:^{
                                              submited = NO;
                                              [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
                                          }];
                if (_delegate && [_delegate respondsToSelector:@selector(updateCommentCount:)]) {
                    
                    NSDictionary *resultDic = [result objectFromJSONData];
                    int commentCount = INT_VALUE_FROM_DIC(resultDic, @"commentCount");
                    
                    [_delegate updateCommentCount:commentCount];
                }
            }else {
                [WXWUIUtils showNotificationOnTopWithMsg:@"提交失败！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES animationEnded:^{
                                          
                                      }];
                submited = NO;
                
            }
            submited = NO;
            
            break;
        }
        case SUBMIT_INFORMATION_COMMENT_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:@"提交成功！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES
                                          animationEnded:^{
                                              submited = NO;
                                              [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
                                          }];
                
                if (_delegate && [_delegate respondsToSelector:@selector(updateCommentCount:)]) {
                    
                    NSDictionary *resultDic = [result objectFromJSONData];
                    int commentCount = INT_VALUE_FROM_DIC(resultDic, @"commentCount");
                    
                    [_delegate updateCommentCount:commentCount];
                }
                
            }else {
                [WXWUIUtils showNotificationOnTopWithMsg:@"提交失败！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES animationEnded:^{
                                          
                                      }];
                submited = NO;
                
            }
            submited = NO;
            
            break;
        }
            
        default:
            break;
    }
    
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

- (void)configureMOCFetchConditions {
    
    self.entityName = @"CommentList";
    self.predicate = [NSPredicate predicateWithFormat:@"commentType == %d",commentType];
    
    
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"commentId"
                                                              ascending:NO] autorelease];
    [self.descriptors addObject:sortDesc];
}

@end
