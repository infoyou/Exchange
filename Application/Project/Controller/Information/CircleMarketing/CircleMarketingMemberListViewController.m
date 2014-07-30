//
//  CircleMarketingMemberListViewController.m
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingMemberListViewController.h"

#import "ProjectAPI.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "TextPool.h"
#import "JSONParser.h"
#import "CircleMarketingMemberBriefView.h"
#import "CommunicationPersonalInfoViewController.h"

@interface CircleMarketingMemberListViewController () <CircleMarketingMemberBriefViewDelegate>

@property (nonatomic, assign) int lastY;
@property (nonatomic, assign) int marginX;

@end

@implementation CircleMarketingMemberListViewController {
    int _eventId;
    UIScrollView *_itemBaseScrollView;
}

@synthesize lastY = _lastY;
@synthesize marginX = _marginX;

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
          eventId:(int)eventId {
    
    self = [super initWithMOC:MOC];
    
    if (self) {
        _eventId = eventId;
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
    
    _marginX = 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview: [self initScrollView]];
    
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //    _tableView.transform =  CGAffineTransformMakeRotation(-M_PI / 2);
    //    _tableView.showsVerticalScrollIndicator = NO;
    
//    [_tableView setHidden:YES];
    
    self.navigationItem.title = @"已报名成员列表";
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    
    [specialDict setValue:NUMBER(_eventId) forKey:KEY_API_PARAM_EVENT_ID];
    [specialDict setValue:NUMBER(1) forKey:KEY_API_PARAM_PAGE_NO];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_EVENT withApiName:API_NAME_GET_EVENT_APPLY_USER_LIST withCommon:commonDict withSpecial:specialDict];
    
    _currentType = GET_APPLY_MEMBER_LIST_TY;
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case GET_APPLY_MEMBER_LIST_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [self fetchContentFromMOC];
                NSArray *userArray = self.fetchedRC.fetchedObjects;
                DLog(@"%d", userArray.count);
                
                
                UIView *memberListView = [self initMemberList:userArray withCount:userArray.count];
                [_itemBaseScrollView addSubview:memberListView];
                _itemBaseScrollView.contentSize = CGSizeMake(_itemBaseScrollView.frame.size.width, memberListView.frame.size.height);
                
            }
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
    
    self.entityName = @"EventApplyMemberList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}

#pragma mark -- member view

- (UIView *)initMemberList:(NSArray *)array withCount:(int)count
{
    int marginX = 0;
    int marginY = 5;
    int distX = (_screenSize.width - 2*_marginX - 4*COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH ) / (COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT - 1);
    int distY = 5;
    
    int startX;
    int startY;
    int width = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
    int height = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT;
    
    UIView *view = [[[UIView alloc] init] autorelease];
    int i=0;
    //-------------------------------------------------------
    for ( i = 0; i < array.count; ++i) {
        
        startX =marginX + i % COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(width + distX);
        startY =marginY + i / COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(height + distY);
        
        CircleMarketingMemberBriefView *headerBriefView = [[[CircleMarketingMemberBriefView alloc] initWithFrame:CGRectMake(startX, startY, width, height)  withUserProfile:[array objectAtIndex:i]] autorelease];
        headerBriefView.delegate = self;
        [view addSubview:headerBriefView];
    }
    
    //-------------------------------------------------------
    view.frame = CGRectMake(0, 0, _screenSize.width - 2*self.marginX, startY + height + marginY);
    
    view.backgroundColor = TRANSPARENT_COLOR;
    //-------------------------------------------------------
    
    self.lastY += view.frame.size.height;
    return view;
}

- (UIScrollView *)initScrollView:(CGRect)rect withContentSize:(CGSize)contentSize
{
    UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:rect] autorelease];
    
    scrollView.pagingEnabled = YES;
    scrollView.alwaysBounceVertical = NO;
    //    [scrollView setDelegate:self];
    scrollView.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    
    if (contentSize.height != 0 && contentSize.width != 0)
        [scrollView setContentSize:contentSize];
    
//    [self.view addSubview:scrollView];
    return scrollView;
}

- (UIScrollView *)initScrollView
{
    int width = _screenSize.width - 2*_marginX;
    int height = _screenSize.height - ITEM_BASE_TOP_VIEW_HEIGHT -   - SYSTEM_STATUS_BAR_HEIGHT - 44;
    _itemBaseScrollView  = [self initScrollView:CGRectMake(_marginX, ITEM_BASE_TOP_VIEW_HEIGHT , width, height) withContentSize:CGSizeMake(0,0)];
    _itemBaseScrollView.pagingEnabled = NO;
    
    _itemBaseScrollView.backgroundColor = TRANSPARENT_COLOR;
    
    return _itemBaseScrollView;
}

#pragma mark -- 
- (void)memberHeaderBriefViewClicked:(CircleMarketingMemberBriefView *)view withUserID:(int)userID
{
    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:userID withDelegate:self isFromChatVC:FALSE];
    //    [vc initWithUserId:_userProfile.userID withDelegate:nil];
    [CommonMethod pushViewController:vc withAnimated:YES];
    
}
@end

