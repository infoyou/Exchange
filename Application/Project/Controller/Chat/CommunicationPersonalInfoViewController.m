//
//  CommunicationPersonalInfoViewController.m
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationPersonalInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PersonalInfoCell.h"
#import "UIColor+expanded.h"
#import "UserHeader.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "ProjectAPI.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "JSONKit.h"
#import "ChatListViewController.h"
#import "GoHighDBManager.h"

#define BUTTON_WIDTH  150.f
#define BUTTON_HEIGHT 50.f


extern CellMargin PICM;

@interface CommunicationPersonalInfoViewController ()<UITableViewDataSource, UITableViewDelegate> {
    UserBaseInfo *ubf;
    UserProfile *up;
    
    int _userId;
    int _isFriend;
}
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, assign) NSMutableArray *numberOfRows;
@property (nonatomic) int numberOfSection;

@end

@implementation CommunicationPersonalInfoViewController{
    BOOL _isFromChatVC;
    enum FRIEND_TYPE _requestFriendType;
    
}

@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;

- (CGFloat)cellHeightWithTitle:(NSString *)title titleFont:(UIFont *)titFont subTitle:(NSString *)subTitle subTitleFont:(UIFont *)subTitleFont {
    return [title sizeWithFont:FONT_TITLE constrainedToSize:CGSizeMake(LABEL_WIDTH, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + [subTitle sizeWithFont:FONT_SUBTITLE constrainedToSize:CGSizeMake(292, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height + PICM.top + PICM.bottom;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)VC
           userId:(int)userId
     withDelegate:(id)delegate
     isFromChatVC:(BOOL)chatVC
{
    if (self = [super initWithMOC:MOC]) {
        
        _userId = userId;
        self.delegate = delegate;
        _isFromChatVC = chatVC;
    }
    
    return self;
}

- (id) initWithUserId:(int )userId withDelegate:(id)delegat
{
    if (self = [super init]) {
        _userId = userId;
        self.delegate = delegat;
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [self initData];
    
    [self addMainTable];
    
}

- (void)initData {
    
    self.numberOfSection = [[GoHighDBManager instance] getGroupCountByUserId:_userId];
    _isFriend = [[GoHighDBManager instance] isFriend:_userId];
    
    self.numberOfRows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.numberOfSection; ++i) {
        [self.numberOfRows addObject:[[GoHighDBManager instance] getUserPropertiesByUserId:_userId groupId:i+1]];
    }
}

- (void)addMainTable {
    int marginX = 10;
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(marginX, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width - 2*marginX, self.view.frame.size.height - ITEM_BASE_TOP_VIEW_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.separatorColor = TRANSPARENT_COLOR;
    _mainTable.backgroundView = nil;
    _mainTable.backgroundColor = TRANSPARENT_COLOR;
    if (self.numberOfRows.count > 0) {
        _mainTable.tableFooterView = [self tableViewForFooterWithBool:up.isFriend];
    }
    
    [self.view addSubview:_mainTable];
}

- (void)dealloc {
    [_mainTable release];
    [_numberOfRows release];
    [_leftButton release];
    [_rightButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)tableViewForFooterWithBool:(BOOL)bol {
    
    int marginX = 10;
    UIView *footerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 80)] autorelease];
    footerView.backgroundColor = [UIColor clearColor];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(-2, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
    _leftButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    if (_isFriend) {
        [_leftButton setTitle:@"删除好友" forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"personalInfo_button_red"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_leftButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"personalInfo_button_orange"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [footerView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(_leftButton.frame.origin.x + _leftButton.frame.size.width + 4, 0, BUTTON_WIDTH, BUTTON_HEIGHT);
    _rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_rightButton setTitle:@"发私信" forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"personalInfo_button_orange"] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_userId == [[AppManager instance].userId integerValue]) {
//        [_rightButton setEnabled:NO];
//        [_leftButton setEnabled:NO];
        
        [_leftButton setHidden:YES];
        [_rightButton setHidden:YES];
    }
    
//    hidden button for kill private chat
    [_leftButton setHidden:YES];
    [_rightButton setHidden:YES];
    
    [footerView addSubview:_rightButton];
    
    return footerView;
}

- (void)updateFriendButtonStatus:(BOOL)isFriend
{
    _isFriend = isFriend;
    if (_isFriend) {
        [_leftButton setTitle:@"删除好友" forState:UIControlStateNormal];
        
        [_leftButton removeTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_leftButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [_leftButton removeTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
        [_leftButton addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
        case SUBMIT_PRIVETE_LETTER_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:[CommonMethod getInstance].MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                 paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                if (up.isFriend) {
                    if (_delegate && [_delegate respondsToSelector:@selector(deleteFriendUser:)]) {
                        [_delegate deleteFriendUser:up.userID];
                    }
                }
                
                switch (_requestFriendType) {
                    case FRIEND_TYPE_UPDATE:
                        break;
                    case FRIEND_TYPE_ADD:
                        [self updateFriendButtonStatus:TRUE];
                        break;
                    case FRIEND_TYPE_DELETE:
                        [self updateFriendButtonStatus:FALSE];
                        
                        break;
                        
                    default:
                        break;
                }
                
                [[GoHighDBManager instance] updateIsFriendWithId:[NSString stringWithFormat:@"%d",_userId ] isFriend:_isFriend];
                
                [WXWUIUtils showNotificationOnTopWithMsg:@"操作成功"
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
//            [self back:nil];
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
    
    //    self.entityName =  @"ImageList";
    //
    //    self.descriptors = [NSMutableArray array];
    //    NSSortDescriptor *sortDesc = [[[NSSortDescriptor alloc] initWithKey:@"imageID"
    //                                                              ascending:YES] autorelease];
    //    [self.descriptors addObject:sortDesc];
}

#pragma mark - button action

- (void)loadSubmitPrivateLetter:(LoadTriggerType)triggerType forNew:(BOOL)forNew type:(enum FRIEND_TYPE)type
{
    _currentType = SUBMIT_PRIVETE_LETTER_TY;
    
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [specialDict setObject:NUMBER(_userId) forKey:KEY_API_PARAM_USERID];
    [specialDict setObject:NUMBER(type) forKey:KEY_API_PARAM_TYPE];
    
    _requestFriendType = type;
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_SUBMIT_PRIVATE_LETTER];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:urlString
                                                              contentType:_currentType];
    
    [connFacade post:urlString data:[requestDict JSONData]];
    
}

- (void)deleteUser:(UIButton *)sender {
    [self loadSubmitPrivateLetter:TRIGGERED_BY_AUTOLOAD forNew:YES type:FRIEND_TYPE_DELETE];
}

- (void)addUser:(UIButton *)sender {
    
    [self loadSubmitPrivateLetter:TRIGGERED_BY_AUTOLOAD forNew:YES type:FRIEND_TYPE_ADD];
}

- (void)sendMessage:(UIButton *)sender {
    
    if (_isFromChatVC) {
        [self back:nil];
    } else {
        ChatListViewController *vc = [[[ChatListViewController alloc] initWithPrivateDataWithUserBaseInfo:[[GoHighDBManager instance] getUserInfoFromDB:_userId] withType:CHAT_TYPE_PRIVATE MOC:_MOC] autorelease];
        
        [CommonMethod pushViewController:vc withAnimated:YES];
    }
}

#pragma mark - left right button action

- (void)rightNavButtonClicked:(id)sender
{
    
}

#pragma mark - tableview datasource && delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr = self.numberOfRows[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 110.f;
    } else {
        
        NSArray *values = self.numberOfRows[indexPath.section];
        UserDBProperty *dbprop = [values objectAtIndex:indexPath.row];
        
        CGFloat height = [self cellHeightWithTitle:dbprop.propName titleFont:FONT_TITLE subTitle:dbprop.propValue subTitleFont:FONT_SUBTITLE] + 10;
        return height;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"PersonalInfoCell_%d_%d", indexPath.section,indexPath.row];
    PersonalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        NSArray *values = self.numberOfRows[indexPath.section];
        if (indexPath.section == 0 && indexPath.row == 0) {
            UserDBProperty *dbprop0 = [values objectAtIndex:0];
            UserDBProperty *dbprop1 = [values objectAtIndex:1];
            UserDBProperty *dbprop2 = [values objectAtIndex:2];
            
            cell = [[[PersonalInfoCell alloc] initWithStyle:CellStyle_Header reId:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.headerImage updateImage:dbprop0.propValue withId:[NSString stringWithFormat:@"%d", dbprop0.userId]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@",dbprop1.propValue,dbprop2.propValue];
            [cell setBackgroundImageWithIndexFlag:IndexFlag_Top];
        } else {
            
            UserDBProperty *dbprop = [values objectAtIndex:indexPath.row];
            
            cell = [[[PersonalInfoCell alloc] initWithStyle:CellStyle_Content reId:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = dbprop.propName;
            cell.subTitLabel.text = dbprop.propValue;
            
            if (indexPath.row == values.count -1) {
                [cell setBackgroundImageWithIndexFlag:IndexFlag_Bottom];
            } else {
                [cell setBackgroundImageWithIndexFlag:IndexFlag_Middle];
            }
            
            if( indexPath.row == 0){
                
                [cell setBackgroundImageWithIndexFlag:IndexFlag_Top];
            }
        }
    }
    
    NSLog(@"%f",cell.frame.size.height);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
