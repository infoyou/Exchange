//
//  CirleMarketingVoteViewController.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CirleMarketingVoteViewController.h"
#import "CircleMarketingVoteViewCell.h"
#import "CircleMarketingVoteCommitViewController.h"
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

#define REFRESH_BUTTON_WIDTH  280.f
#define REFRESH_BUTTON_HEIGHT 44.f

@interface CirleMarketingVoteViewController ()<CircleMarketingVoteViewCellDelegate> {
    int eventID;
}

@end

@implementation CirleMarketingVoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
          eventID:(int)eid {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    if (self) {
        eventID = eid;
        self.parentVC = pVC;
    }
    return self;
    
}

- (void)dealloc {
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"活动投票";
    
    _tableView.backgroundColor = TRANSPARENT_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [self updateLastSelectedCell];
    
}

- (void)refresh:(UIButton *)sender {
    [self loadListData:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)calculateCellHeight:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    
    EventVoteList *evList = (EventVoteList *)[self.fetchedRC objectAtIndexPath:indexPath];
    
    CGFloat height = [WXWCommonUtils sizeForText:evList.voteTitle
                                            font:FONT(15)
                               constrainedToSize:CGSizeMake(215, MAXFLOAT)
                                   lineBreakMode:NSLineBreakByCharWrapping
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName : FONT(15)}].height + 40;
    
    return MAX(VOTE_CELL_HEIGHT, height);
}

#pragma mark - uitableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.fetchedRC.fetchedObjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self calculateCellHeight:tableView atIndexPath:indexPath];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return REFRESH_BUTTON_HEIGHT + 50;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 94)] autorelease];
//    footer.backgroundColor = TRANSPARENT_COLOR;
//    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    refreshBtn.layer.cornerRadius = 4.f;
//    refreshBtn.frame = CGRectMake(20, 30, REFRESH_BUTTON_WIDTH, REFRESH_BUTTON_HEIGHT);
//    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
//    [refreshBtn setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0xe83e0b"]] forState:UIControlStateNormal];
//    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [refreshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
//    refreshBtn.layer.cornerRadius = 3.0f;
//    refreshBtn.layer.masksToBounds=YES;
//    [footer addSubview:refreshBtn];
//    return footer;
//}

- (CircleMarketingVoteViewCell *)drawCircleMarketingVoteViewCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *voteCellId = @"vote_cell";
    
    CircleMarketingVoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voteCellId];
    
    if (!cell) {
        cell = [[[CircleMarketingVoteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voteCellId] autorelease];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
    }
    
    EventVoteList *evList = (EventVoteList *)[self.fetchedRC objectAtIndexPath:indexPath];
    NSLog(@"eventId: %d",evList.eventId.intValue);
    [cell drawEventVoteList:evList];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self drawCircleMarketingVoteViewCell:tableView atIndexPath:indexPath];
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.row == self.fetchedRC.fetchedObjects.count) {
//        return;
//    }
//    
//    EventVoteList *evList = (EventVoteList *)[self.fetchedRC objectAtIndexPath:indexPath];
//    
//    if (evList.voteFlag.intValue == 0) {
//        CircleMarketingVoteCommitViewController *vc = [[[CircleMarketingVoteCommitViewController alloc] initWithMOC:_MOC parentVC:self eventVoteList:evList] autorelease];
//        [CommonMethod pushViewController:vc withAnimated:YES];
//    }
////    CircleMarketingVoteCommitViewController *vc = [[[CircleMarketingVoteCommitViewController alloc] initWithMOC:_MOC parentVC:self eventVoteList:evList] autorelease];
////    [CommonMethod pushViewController:vc withAnimated:YES];
//    
//    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
//}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case LOAD_EVENT_VOTE_LIST:
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
    self.entityName = @"EventVoteList";
    
    self.descriptors = [NSMutableArray array];
    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"voteId"
                                                              ascending:YES] autorelease];
    [self.descriptors addObject:sortDesc];
}

- (void)loadListData:(LoadTriggerType)triggerType forNew:(BOOL)forNew {
    
    [super loadListData:triggerType forNew:forNew];
    
    _currentType = LOAD_EVENT_VOTE_LIST;
    
//    NSInteger index = 0;
//    if (!forNew) {
//        index = ++_currentStartIndex;
//    }
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(eventID) forKey:KEY_API_PARAM_EVENT_ID];
    
    NSDictionary *commonDict = [AppManager instance].common;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (commonDict) {
        [dict setObject:commonDict forKey:@"common"];
    }
    if (specialDict) {
        [dict setObject:specialDict forKey:@"special"];
    }
    
    NSString *url = [ProjectAPI getRequestURL:API_SERVICE_EVENT withApiName:API_NAME_GET_EVENT_VOTE_LIST withCommon:commonDict withSpecial:specialDict];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
    
}

#pragma mark -- CircleMarketingVoteViewCellDelegate
- (void)selecteVoteCell:(EventVoteList *)evList
{
    if (evList.voteFlag.intValue == 0) {
        CircleMarketingVoteCommitViewController *vc = [[[CircleMarketingVoteCommitViewController alloc] initWithMOC:_MOC parentVC:self eventVoteList:evList] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
    }
}

@end
