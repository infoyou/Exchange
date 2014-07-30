//
//  CircleMarketingVoteCommitViewController.m
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingVoteCommitViewController.h"
#import "CircleMarketingVoteCommitCell.h"
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

#define COMMIT_BUTTON_WIDTH  280.f
#define COMMIT_BUTTON_HEIGHT 44.f

@interface CircleMarketingVoteCommitViewController () <CircleMarketingVoteCommitCellDelegate>

@property (nonatomic, retain) EventVoteList *voteList;
@property (nonatomic, retain) NSMutableArray *optionLists;
@property (nonatomic, assign) NSInteger optID;

@end

@implementation CircleMarketingVoteCommitViewController

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
    eventVoteList:(EventVoteList *)evList {
    
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    
    if (self) {
        self.voteList = evList;;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = @"填写投票";
    
    [self initData];
    
    _tableView.backgroundColor = TRANSPARENT_COLOR;
    _tableView.hidden = NO;
    _tableView.alpha = 1.f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _optionLists = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.voteList.displayIndex.count; i++) {
        EventOptionList *opl = (EventOptionList *)[[self.voteList.displayIndex.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"optionId" ascending:YES]]] objectAtIndex:i];
        [self.optionLists addObject:opl];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_tableView reloadData];
}

#pragma mark - commitbutton action

- (void)commit:(UIButton *)sender {
    
    _currentType = SUBMIT_VOTE_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
//    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
//    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(self.optID) forKey:KEY_API_PARAM_OPTION_ID];
    [specialDict setObject:self.voteList.voteId forKey:KEY_API_PARAM_VOTE_ID];
    [specialDict setObject:self.voteList.eventId forKey:KEY_API_PARAM_EVENT_ID];
    
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
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_EVENT,API_NAME_SUBMIT_EVENT_VOTE_OPTION];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    [connFacade post:urlString data:[requestDict JSONData]];
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    _noNeedDisplayEmptyMsg = YES;
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case SUBMIT_VOTE_TY:
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
                                          [self back:nil];
                                      }];
                
            }else {
                [WXWUIUtils showNotificationOnTopWithMsg:@"提交失败！"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES
                                          animationEnded:^{
                                              [self back:nil];
                                          }];
                
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

- (CGFloat)calculateCellHeight {
    CGFloat height = [WXWCommonUtils sizeForText:[NSString stringWithFormat:@"%d. %@",self.voteList.voteId.intValue, self.voteList.voteTitle]
                                            font:FONT(15)
                               constrainedToSize:CGSizeMake(280, MAXFLOAT)
                                   lineBreakMode:NSLineBreakByCharWrapping
                                         options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                      attributes:@{NSFontAttributeName : FONT(15)}].height + 40;
    return MAX(60, height);
}

#pragma mark - uitableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return (indexPath.row == 0) ? [self calculateCellHeight] : VOTE_COMMIT_CELL_HEIGHT * self.optionLists.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return COMMIT_BUTTON_HEIGHT + 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 94)] autorelease];
    footer.backgroundColor = TRANSPARENT_COLOR;
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.layer.cornerRadius = 4.f;
    refreshBtn.frame = CGRectMake(20, 30, COMMIT_BUTTON_WIDTH, COMMIT_BUTTON_HEIGHT);
    [refreshBtn setTitle:@"提交" forState:UIControlStateNormal];
    [refreshBtn setBackgroundColor:[UIColor colorWithHexString:@"0xe83e0b"]];
    [refreshBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:refreshBtn];
    return footer;
}

- (UITableViewCell *)drawTitleCell:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    static NSString *titleCellId = @"title_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = TRANSPARENT_COLOR;
    }
    cell.contentView.frame = CGRectMake(20, 20, 280, [self calculateCellHeight]);
    cell.textLabel.text = [NSString stringWithFormat:@"%d. %@",self.voteList.voteId.intValue, self.voteList.voteTitle];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = FONT(15);
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(20, cell.contentView.frame.size.height - 1, cell.contentView.frame.size.width, 1)];
    line.image = ImageWithName(@"line_d.png");
    [cell.contentView addSubview:line];
    [line release];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self drawTitleCell:tableView atIndexPath:indexPath];
    }else {
        static NSString *voteCellId = @"vote_cell";
        
        CircleMarketingVoteCommitCell *cell = [tableView dequeueReusableCellWithIdentifier:voteCellId];
        
        if (!cell) {
            cell = [[[CircleMarketingVoteCommitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:voteCellId] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        [cell drawVoteCommitCellWithArray:self.optionLists];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - cell delegate

- (void)circleMarketingVoewCommiteCell:(CircleMarketingVoteCommitCell *)cell selectedWithOptionID:(int)optionId {
    self.optID = optionId;
}

@end
