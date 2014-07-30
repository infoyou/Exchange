//
//  CommunicatGroupMemberListViewController.m
//  Project
//
//  Created by XXX on 13-9-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommunicatGroupMemberListViewController.h"
#import "ChatListViewController.h"
#import "CommunicatMemberHeaderBriefView.h"
#import "CommunicatGroupMemberListPropertyViewCell.h"
#import "CommunicatGroupPropertyInfoViewController.h"
#import "CommunicationPersonalInfoViewController.h"
#import "CommunicationListViewController.h"
#import "HomepageContainerViewController.h"
#import "NKColorSwitch.h"
#import "ToggleView.h"
#import "ProjectAPI.h"
#import "GlobalConstants.h"
#import "AppManager.h"
#import "JSONParser.h"
#import "TextPool.h"
#import "JSONKit.h"
#import "CommonHeader.h"
#import "ChatAddGroupViewController.h"
#import "CustomeAlertView.h"
#import "QPlusMessage.h"
#import "ChatModel.h"
#import "GoHighDBManager.h"
#import "GlobalConstants.h"
#import "CommonUtils.h"
#import "ImageObject.h"
#import "CommunicationGroupHeaderViewController.h"
#import "WXWCoreDataUtils.h"
#import "iChatInstance.h"

enum GROUP_MEMBER_PROPERTY_TYPE {
    GROUP_MEMBER_PROPERTY_TYPE_EDIT,
    GROUP_MEMBER_PROPERTY_TYPE_STATIC,
};


#define GROUP_PROPERTY_GROUP_NAME           @"群组名称"
#define GROUP_PROPERTY_GROUP_ICON           @"群组图标"
#define GROUP_PROPERTY_GROUP_BRIEF          @"群组简介"
#define GROUP_PROPERTY_GROUP_PHONE          @"电话"
#define GROUP_PROPERTY_GROUP_EMAIL          @"邮箱"
#define GROUP_PROPERTY_GROUP_WEBSITE    @"网址"

@interface CommunicatGroupMemberListViewController ()<UITableViewDataSource, UITableViewDelegate,CommunicatMemberHeaderBriefViewDelegate,ToggleViewDelegate, CommunicatGroupPropertyInfoViewControllerDelegate,CommunicatAddGroupViewControllerDelegate>

@property (nonatomic, assign) int marginX;
@property (nonatomic, assign) int lastY;
@property (nonatomic, retain) NKColorSwitch *adminSwitch;
@property(nonatomic, strong)ToggleView *toggleViewButtonChange;
@property (nonatomic, retain) NSArray *groupMemberList;

@property (nonatomic, assign) UIScrollView *itemBaseScrollView;
@property (nonatomic, assign) UIScrollView *topInfoScrollView;;

@property (nonatomic, retain) ChatGroupDataModal *dataModal;
@end

@implementation CommunicatGroupMemberListViewController{
    
    int _marginX;
    int _groupBriefCount;
    int _memberListCount;
    
    int _lastY;
    
    UITableView *_propertyTableView;
    UIView *_infoView;
    UIView *_memberListView;
    NSMutableArray *_propertyArray;
    NSMutableArray *_propertyStaticArray;
    
    NSMutableArray *_memberHeaderBriefArray;
    
    BOOL  _changed;
    BOOL _userListChanged;
    BOOL _showCellDeleteButton;
    BOOL _submited;
    BOOL _isDeleteGroup;
    
    int _groupId;
    int _deleteUserId;
}

@synthesize marginX = _marginX;
@synthesize lastY = _lastY;
@synthesize toggleViewButtonChange = _toggleViewButtonChange;
@synthesize groupMemberList = _groupMemberList;
@synthesize itemBaseScrollView = _itemBaseScrollView;
@synthesize topInfoScrollView = _topInfoScrollView;
@synthesize delegate = _delegate;
@synthesize dataModal = _dataModal;

#pragma mark - life cycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC
    withDataModal:(ChatGroupDataModal *)dataModal
{
    
    self = [super initWithMOC:MOC];
    if (self) {
        self.dataModal = [dataModal retain];
        _groupId = [dataModal.groupId integerValue];
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

- (id)initWithDataModal:(ChatGroupDataModal *)dataModal
{
    if (self = [super init]) {
        
        self.dataModal = [dataModal retain];
        _groupId = [dataModal.groupId integerValue];
        DLog(@"%@",dataModal);
    }
    
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.title = LocaleStringForKey(NSCommunicatMemberList, nil);
    
    _marginX = 11;
    _lastY = 0;
    _groupBriefCount = 13;
    _memberListCount = 11;
    _changed = NO;
    _userListChanged = NO;
    
    [self initTableView];
    [self initData];
    [self initScrollView];
    
    self.view.backgroundColor =DEFAULT_VIEW_COLOR;
}

- (void)initTableView {
    _propertyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _propertyTableView.delegate = self;
    _propertyTableView.dataSource = self;
    _propertyTableView.backgroundColor = TRANSPARENT_COLOR;
    _propertyTableView.showsVerticalScrollIndicator = NO;
    _propertyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _propertyTableView.showsHorizontalScrollIndicator = NO;
    _propertyTableView.showsVerticalScrollIndicator = NO;
    _propertyTableView.pagingEnabled=NO;
    _propertyTableView.scrollEnabled = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    _submited = FALSE;
    [super viewWillAppear:animated];
    [_propertyTableView reloadData];
    
    [self loadGetGroupUserList:TRIGGERED_BY_AUTOLOAD forNew:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteSuccessfulGroupFromAiLiao:)
                                                 name:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO];
}

- (void)dealloc
{
    _propertyTableView = nil;
    [_memberHeaderBriefArray release];
    [super dealloc];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP_FROM_AILIAO
-(void)deleteSuccessfulGroupFromAiLiao:(NSNotification *)note
{
    _isDeleteGroup = TRUE;
    [self loadDeleteGroupUserList:TRIGGERED_BY_AUTOLOAD forNew:YES];
}

- (void)initData
{
    _propertyArray = [[NSMutableArray alloc] init];
    _propertyStaticArray = [[NSMutableArray alloc] init];
    
    //------------------------------------------------------------------------------
    NSDictionary *dict ;
    
    if (_dataModal.isInGroup) {
        
        dict= [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_NAME, KEY_PROPERTY_CONTENT_TYPE_TITLE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(groupNameClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,_dataModal.groupName, KEY_PROPERTY_CONTENT_TYPE_VALUE,
               nil];
        
        [_propertyArray addObject:dict];
        
        //------------------------------------------------------------------------------
        dict = [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_ICON, KEY_PROPERTY_CONTENT_TYPE_TITLE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(groupIconClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,nil];
        
        [_propertyArray addObject:dict];
        
    }
    //------------------------------------------------------------------------------
    dict = [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_BRIEF, KEY_PROPERTY_CONTENT_TYPE_TITLE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(groupBriefClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,_dataModal.groupDescription, KEY_PROPERTY_CONTENT_TYPE_VALUE,
            nil];
    
    [_propertyArray addObject:dict];
    
    //------------------------------------------------------------------------------
    dict = [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_PHONE, KEY_PROPERTY_CONTENT_TYPE_TITLE, _dataModal.groupPhone, KEY_PROPERTY_CONTENT_TYPE_VALUE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(phoneClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,_dataModal.groupPhone, KEY_PROPERTY_CONTENT_TYPE_VALUE,nil];
    
    [_propertyStaticArray addObject:dict];
    
    //------------------------------------------------------------------------------
    dict = [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_EMAIL, KEY_PROPERTY_CONTENT_TYPE_TITLE, _dataModal.groupEmail, KEY_PROPERTY_CONTENT_TYPE_VALUE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(emailClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,_dataModal.groupEmail, KEY_PROPERTY_CONTENT_TYPE_VALUE,nil];
    
    [_propertyStaticArray addObject:dict];
    
    //------------------------------------------------------------------------------
    dict = [NSDictionary dictionaryWithObjectsAndKeys:GROUP_PROPERTY_GROUP_WEBSITE, KEY_PROPERTY_CONTENT_TYPE_TITLE, _dataModal.groupWebsite, KEY_PROPERTY_CONTENT_TYPE_VALUE, PROPERTY_TYPE_BUTTON,KEY_PROPERTY_CONTENT_TYPE_TYPE,[NSString stringWithFormat:@"%@",NSStringFromSelector(@selector(websiteClicked:))],KEY_PROPERTY_CONTENT_TYPE_SEL,self,KEY_PROPERTY_CONTENT_TYPE_TARGET,_dataModal.groupWebsite, KEY_PROPERTY_CONTENT_TYPE_VALUE,nil];
    
    [_propertyStaticArray addObject:dict];
}

- (UITableView *)initTableView:(UIView *)parentView withStartY:(int)startY
{
    
    int tableViewStartX = 0;
    int tableViewStartY = startY;
    int tableViewWidth = _screenSize.width - 2*_marginX;
    int tableViewHeight =  (_propertyArray.count + _propertyStaticArray.count)* COMMUNICATE_PROPERTY_CELL_HEIGHT + COMMUNICATE_PROPERTY_CELL_FOOTER_HEIGHT;
    
    CGRect rect = CGRectMake(tableViewStartX, tableViewStartY, tableViewWidth, tableViewHeight);
    
    _propertyTableView.frame = rect;
    
    [parentView addSubview:_propertyTableView];
    
    return _propertyTableView;
}

- (UIView *)initMemberList:(NSArray *)array withCount:(int)count
{
    int marginX = 9;
    int marginY = 9;
    int viewStartY = 12;
    int distX = (_screenSize.width - 2*_marginX - 2*viewStartY - 4*COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH ) / (COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT - 1);
    int distY = 5;
    
    int startX;
    int startY = 0;
    int width = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_WIDTH;
    int height = COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_HEIGHT;
    
    
    if (array.count == 0) {
        return nil;
    }
    UIView *view = [[[UIView alloc] init] autorelease];
    view.backgroundColor = [UIColor colorWithHexString:@"0xb4b8bb"];
    view.layer.masksToBounds = NO;
    //    //设置阴影的高度
    view.layer.shadowOffset = CGSizeMake(0, 11);
    //设置透明度
    //    view.layer.shadowOpacity = 0.7;
    //    view.layer.shadowRadius = 4.0f;
    view.layer.cornerRadius = 3.0f;
    view.layer.masksToBounds = YES;
    
    view.layer.cornerRadius = 5.0f;
    view.layer.borderWidth = 1.f;
    view.layer.borderColor = [UIColor colorWithHexString:@"0xd1d1d1"].CGColor;
    
    //    view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    
    [CommonMethod viewAddGuestureRecognizer:view withTarget:self withSEL:@selector(memberListViewTapped:)];
    int i=0;
    
    _memberHeaderBriefArray = [[NSMutableArray alloc] init];
    //-------------------------------------------------------
    for ( i = 0; i < array.count; ++i) {
        
        startX =marginX + i % COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(width + distX);
        startY =marginY + i / COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(height + distY);
        
        CommunicatMemberHeaderBriefView *headerBriefView = [[[CommunicatMemberHeaderBriefView alloc] initWithFrame:CGRectMake(startX, startY, width, height) withType:MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL withUserProfile:[array objectAtIndex:i]] autorelease];
        headerBriefView.delegate = self;
        [view addSubview:headerBriefView];
        
        [_memberHeaderBriefArray addObject:headerBriefView];
    }
    
    CommunicatMemberHeaderBriefView *headerBriefView;
    //-----------------------------add--------------------------
    
    if ([_dataModal.canInvite integerValue] || _dataModal.isAdmin) {
        
        startX =marginX + i % COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(width + distX);
        startY =marginY + i / COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(height + distY);
        
        headerBriefView = [[[CommunicatMemberHeaderBriefView alloc] initWithFrame:CGRectMake(startX, startY, width, height) withType:MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD withUserProfile:nil] autorelease];
        headerBriefView.delegate = self;
        [view addSubview:headerBriefView];
        
    }
    //------------------------------min-------------------------
    if (_dataModal.isAdmin) {
        
        ++i;
        
        startX =marginX + i % COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(width + distX);
        startY =marginY + i / COMMUNICATION_MEMBER_HEADER_BRIEF_VIEW_MAX_COLUMN_COUNT *(height + distY);
        
        headerBriefView = [[[CommunicatMemberHeaderBriefView alloc] initWithFrame:CGRectMake(startX, startY, width, height) withType:MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN withUserProfile:nil] autorelease];
        headerBriefView.delegate = self;
        [view addSubview:headerBriefView];
        
    }
    //-------------------------------------------------------
    view.frame = CGRectMake(1.5, 0 + viewStartY, _screenSize.width - 2*self.marginX - 2*1.5, startY + height + marginY);
    //    view.backgroundColor = TRANSPARENT_COLOR;
    //-------------------------------------------------------
    
    self.lastY += view.frame.size.height + viewStartY;
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
    
    [self.view addSubview:scrollView];
    return scrollView;
}

- (UIScrollView *)initScrollView
{
    int width = _screenSize.width - 2*_marginX;
    int height = _screenSize.height - ITEM_BASE_TOP_VIEW_HEIGHT - _topInfoScrollView.frame.size.height  - SYSTEM_STATUS_BAR_HEIGHT - 44;
    _itemBaseScrollView = [self initScrollView:CGRectMake(_marginX, ITEM_BASE_TOP_VIEW_HEIGHT + _topInfoScrollView.frame.size.height, width, height) withContentSize:CGSizeMake(0,0)];
    _itemBaseScrollView.pagingEnabled = NO;
    _itemBaseScrollView.backgroundColor = TRANSPARENT_COLOR;
    
    return _itemBaseScrollView;
}

#pragma mark -

- (UIView *)initInfos:(int)startY
{
    UIView *parentView = [[UIView alloc] init];
    parentView.backgroundColor = TRANSPARENT_COLOR;
    
    int startYFromView = 5;
    int distYView = 10;
    
    //-------------------------------------------------------------
    int tableViewStartY = 5;
    
    // TODO only 4 test
    /*
    if (_dataModal.isAdmin) {
        
        UIView *adminView = [self initAdminAddView:startYFromView];
        [parentView addSubview:adminView];
        tableViewStartY = adminView.frame.origin.y + adminView.frame.size.height + distYView;
    }
    */
    
    //------------------------------------------------------------
    UIView *groupInfoView = [self initTableView:parentView withStartY:tableViewStartY];
    //-------------------------------------------------------------
    
    CGRect rect = CGRectMake(0, groupInfoView.frame.origin.y + groupInfoView.frame.size.height + 15, 0, 0);
    
    if ([_dataModal.canQuit integerValue] || [_dataModal isAdmin]) {
        
        UIView *submitButton = [self initSubmitButton:groupInfoView.frame.origin.y + groupInfoView.frame.size.height + 15];
        [parentView addSubview:submitButton];
        rect = submitButton.frame;
    }
    
    //-------------------------------------------------------------
    parentView.frame = CGRectMake(0, startY, _screenSize.width, rect.size.height + rect.origin.y + 5);
    
    _lastY += parentView.frame.size.height;
    return parentView;
}

#pragma mark - only admin
- (UIView *)initAdminAddView:(int)startY
{
    int height = COMMUNICATE_PROPERTY_CELL_HEIGHT;
    
    int switchWidth = 60;
    int marginY = 10;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, startY, _screenSize.width - 2*_marginX , height )];
    
    //-------------------------------------------------------------
    UILabel *adminControlLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, _itemBaseScrollView.frame.size.width - switchWidth - marginY, height)] autorelease];
    [adminControlLabel setText:@"仅限管理员可添加成员"];
    [adminControlLabel setBackgroundColor:TRANSPARENT_COLOR];
    [adminControlLabel sizeToFit];
    [adminControlLabel setTextColor:[UIColor colorWithHexString:@"0x666666"]];
    [adminControlLabel setFont:FONT_SYSTEM_SIZE(16)];
    
    CGRect rect = adminControlLabel.frame;
    rect.origin.y = (height - rect.size.height) / 2.0f;
    adminControlLabel.frame = rect;
    
    [view addSubview:adminControlLabel];
    //-----------------------------switch--------------------------------
    height = 27;
    int startX = view.frame.size.width - 10 - switchWidth;
    startY = (view.frame.size.height - height)/2.0f;
    
#if 1
    _adminSwitch = [[NKColorSwitch alloc] initWithFrame:CGRectMake(startX, startY, switchWidth, height)];
    
	[_adminSwitch addTarget:self action:@selector(adminSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    
    NSLog(@"%d", ![_dataModal.invitationPublicLevel intValue]);
    
    _adminSwitch.on = ![_dataModal.invitationPublicLevel intValue];
    
    _adminSwitch.on = ![[_dataModal invitationPublicLevel] integerValue];
    [_adminSwitch setOnTintColor:[UIColor colorWithHexString:STYLE_BLUE_COLOR]];
    // 未选颜色
    [_adminSwitch setTintColor:[UIColor grayColor]];
    // 按钮小球颜色
    [_adminSwitch setThumbTintColor:[UIColor whiteColor]];
    [view addSubview:_adminSwitch];
#elif 1
    
    _toggleViewButtonChange = [[ToggleView alloc] initWithFrame:CGRectMake(startX, startY, switchWidth, height) toggleViewType:ToggleViewTypeNoLabel toggleBaseType:ToggleBaseTypeDefault toggleButtonType:ToggleButtonTypeChangeImage];
    _toggleViewButtonChange.toggleDelegate = self;
    
    [_toggleViewButtonChange setSelectedButton:ToggleButtonSelectedRight];
    [view addSubview:_toggleViewButtonChange];
#endif
    //-------------------------------------------------------------
    
    view.layer.cornerRadius = 3;
    //    view.backgroundColor = [UIColor whiteColor];
    view.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_member_single_cell.png");
    
    return view;
}

#pragma mark -- submit button
- (UIButton *)initSubmitButton:(int)startY
{
    
    int height = COMMUNICATE_PROPERTY_CELL_HEIGHT;
    UIButton *submitButton  = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    submitButton.frame = CGRectMake(5, startY, _screenSize.width - 2*_marginX-10, height);
    
    [submitButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    
    /*if(_dataModal.isAdmin){
        [submitButton setTitle:LocaleStringForKey(@"删除群组", Nil) forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else*/ if (_dataModal.isInGroup) {
        [submitButton setTitle:LocaleStringForKey(NSQuitButTitle, Nil) forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(quitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        
        [submitButton setTitle:LocaleStringForKey(NSJoinButTitle, Nil) forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(joinButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [submitButton.layer setMasksToBounds:YES];
    submitButton.layer.cornerRadius = 3.0f;
    return submitButton;
}

- (void)groupNameClicked:(id)sender
{
    CommunicatGroupPropertyInfoViewController *vc = [[[CommunicatGroupPropertyInfoViewController alloc] initWithDataModal:_dataModal]autorelease];
    vc.title = GROUP_PROPERTY_GROUP_NAME;
    vc.type = GROUP_PROPERTY_TYPE_NAME;
    vc.delegate = self;
    [vc updateInfo:_dataModal];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)groupIconClicked:(id)sender
{
    //    [self showActionSheet];
    
    CommunicationGroupHeaderViewController *vc = [[CommunicationGroupHeaderViewController alloc] initWithMOC:_MOC parentVC:nil withDataModal:_dataModal];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)groupBriefClicked:(id)sender
{
    
    CommunicatGroupPropertyInfoViewController *vc = [[[CommunicatGroupPropertyInfoViewController alloc] initWithDataModal:_dataModal] autorelease];
    vc.title = GROUP_PROPERTY_GROUP_BRIEF;
    vc.type = GROUP_PROPERTY_BRIEF;
    [vc updateInfo:_dataModal];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)phoneClicked:(id)sender
{
    
    CommunicatGroupPropertyInfoViewController *vc = [[[CommunicatGroupPropertyInfoViewController alloc] initWithDataModal:_dataModal]autorelease];
    vc.title = GROUP_PROPERTY_GROUP_PHONE;
    vc.type = GROUP_PROPERTY_PHONE;
    [vc updateInfo:_dataModal];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)emailClicked:(id)sender
{
    
    CommunicatGroupPropertyInfoViewController *vc = [[[CommunicatGroupPropertyInfoViewController alloc] initWithDataModal:_dataModal]autorelease];
    vc.title = GROUP_PROPERTY_GROUP_EMAIL;
    vc.type = GROUP_PROPERTY_EMAIL;
    [vc updateInfo:_dataModal];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)websiteClicked:(id)sender
{
    
    CommunicatGroupPropertyInfoViewController *vc = [[[CommunicatGroupPropertyInfoViewController alloc] initWithDataModal:_dataModal]autorelease];
    vc.title = GROUP_PROPERTY_GROUP_WEBSITE;
    vc.type = GROUP_PROPERTY_WEBSITE;
    [vc updateInfo:_dataModal];
    [CommonMethod pushViewController:vc withAnimated:YES];
}


#pragma mark -- table view delegate
//-------------------------------


//-------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case GROUP_MEMBER_PROPERTY_TYPE_EDIT:
            return _propertyArray.count;
            break;
            
        case GROUP_MEMBER_PROPERTY_TYPE_STATIC:
            return _propertyStaticArray.count;
            
        default:
            break;
    }
    return _propertyArray.count;
}

-(void)updateCellBkColor:(NSArray *)array indexRow:(int)row cell:(CommunicatGroupMemberListPropertyViewCell *)cell
{
    if (array.count == 1) {
        cell.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_member_single_cell.png");
    }else{
        if (row == array.count - 1) {
            cell.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_member_cell_bottom.png");
        }else if (row == 0) {
            
            cell.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_member_cell_top.png");
        }else {
            cell.backgroundColor = COLOR_WITH_IMAGE_NAME(@"communication_member_cell_middle.png");
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tableIdentifier=@"CommunicatGroupMemberListPropertyViewCell";
    
    CommunicatGroupMemberListPropertyViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    switch (indexPath.section) {
        case GROUP_MEMBER_PROPERTY_TYPE_EDIT: {
            if(cell==nil)
            {
                BOOL showLine = indexPath.row == _propertyArray.count - 1 ? FALSE:TRUE;
                
                cell=[[[CommunicatGroupMemberListPropertyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier withDictionary:[_propertyArray objectAtIndex:indexPath.row] withParentViewWidth:tableView.frame.size.width withShowBottomLine:showLine] autorelease];
                
                [self updateCellBkColor:_propertyArray indexRow:indexPath.row cell:cell];
            } else{
                NSDictionary *dict = [_propertyArray objectAtIndex:indexPath.row];
                NSString * title =[dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_TITLE];
                if ([title isEqualToString:GROUP_PROPERTY_GROUP_NAME]) {
                    [cell updateDefaultValue:_dataModal.groupName];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_BRIEF]) {
                    [cell updateDefaultValue:_dataModal.groupDescription];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_PHONE]) {
                    [cell updateDefaultValue:_dataModal.groupPhone];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_EMAIL]) {
                    [cell updateDefaultValue:_dataModal.groupEmail];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_WEBSITE]) {
                    [cell updateDefaultValue:_dataModal.groupWebsite];
                }
            }
        }
            
            break;
            
        case GROUP_MEMBER_PROPERTY_TYPE_STATIC: {
            
            if(cell==nil)
            {
                BOOL showLine = indexPath.row == _propertyStaticArray.count - 1 ? FALSE:TRUE;
                
                cell=[[[CommunicatGroupMemberListPropertyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier withDictionary:[_propertyStaticArray objectAtIndex:indexPath.row] withParentViewWidth:tableView.frame.size.width withShowBottomLine:showLine] autorelease];
                
                
                [self updateCellBkColor:_propertyStaticArray indexRow:indexPath.row cell:cell];
            } else{
                NSDictionary *dict = [_propertyStaticArray objectAtIndex:indexPath.row];
                NSString * title =[dict objectForKey:KEY_PROPERTY_CONTENT_TYPE_TITLE];
                if ([title isEqualToString:GROUP_PROPERTY_GROUP_NAME]) {
                    [cell updateDefaultValue:_dataModal.groupName];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_BRIEF]) {
                    [cell updateDefaultValue:_dataModal.groupDescription];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_PHONE]) {
                    [cell updateDefaultValue:_dataModal.groupPhone];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_EMAIL]) {
                    [cell updateDefaultValue:_dataModal.groupEmail];
                }else if([title isEqualToString:GROUP_PROPERTY_GROUP_WEBSITE]) {
                    [cell updateDefaultValue:_dataModal.groupWebsite];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case GROUP_MEMBER_PROPERTY_TYPE_EDIT:
        {
            UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, COMMUNICATE_PROPERTY_CELL_HEIGHT)] autorelease];
            view.backgroundColor = DEFAULT_VIEW_COLOR;
            
            return view;
            
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COMMUNICATE_PROPERTY_CELL_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case GROUP_MEMBER_PROPERTY_TYPE_EDIT:
            return COMMUNICATE_PROPERTY_CELL_FOOTER_HEIGHT;
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark -- CommunicatMemberHeaderBriefViewDelegate
- (void)memberHeaderBriefViewClicked:(CommunicatMemberHeaderBriefView *)view withUserID:(int)userID withHeaderType:(enum MEMBER_HEADER_BRIEF_VIEW_TYPE)type
{
    [self getGroupInfo:_groupId];
    switch (type) {
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_NORMAL: {
            if ( ![view isDelete] ) {
                
                CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:userID  withDelegate:self  isFromChatVC:FALSE];
                [CommonMethod pushViewController:vc withAnimated:YES];
                
            } else {
                [self loadQuiteChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES userList:[NSArray arrayWithObject:
                                                                                    NUMBER(userID)]];
                _deleteUserId = userID;
            }
            
        }
            break;
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_ADD: {
            
            ChatAddGroupViewController *addGroupVC = nil;
            //    TODO
            int size = _groupMemberList.count;
            
            if (size == 2) {
                //  如果是2人就创建新组
                 addGroupVC =  [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:nil userList:_groupMemberList groupInfo:_dataModal type:CHAT_GROUP_TYPE_INFO_CREATE] autorelease];
            } else {
            // 如果是3人就添加人员
            addGroupVC = [[[ChatAddGroupViewController alloc] initWithMOC:_MOC parentVC:nil userList:_groupMemberList groupInfo:_dataModal type:CHAT_GROUP_TYPE_INFO_MODIFY] autorelease];
            }
                addGroupVC.delegate = self;
            [CommonMethod pushViewController:addGroupVC withAnimated:YES];
        }
            break;
        case MEMBER_HEADER_BRIEF_VIEW_TYPE_MIN: {
            [self cellShowDeleteButton:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark -- member list view tapped
- (void)memberListViewTapped:(UISwipeGestureRecognizer *)recognizer
{
    if (_showCellDeleteButton)
        [self cellShowDeleteButton:FALSE];
    
    _showCellDeleteButton = FALSE;
}

#pragma mark -- show delete icon
- (void)cellShowDeleteButton:(BOOL)show
{
    _showCellDeleteButton = TRUE;
    for (int i = 0; i < _memberHeaderBriefArray.count; ++i) {
        CommunicatMemberHeaderBriefView *briefView =(CommunicatMemberHeaderBriefView *) [_memberHeaderBriefArray objectAtIndex:i];
        if (briefView.userProfile.userID != [[AppManager instance].userId integerValue])
            [briefView showDeleteButton:show];
    }
}

#pragma mark -- admin switch
- (void)adminSwitchToggled:(id)sender
{
    if (!_submited) {
        _submited = TRUE;
        _dataModal.invitationPublicLevel =NUMBER(!_adminSwitch.on);
        [self loadUpdateChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
}


#pragma mark - ToggleViewDelegate

- (void)selectLeftButton
{
    NSLog(@"LeftButton Selected");
}

- (void)selectRightButton
{
    NSLog(@"RightButton Selected");
}

- (void)deleteButtonClicked:(id)sender
{
    
    [[iChatInstance instance] sendDeleteGroupMessage:[NSString stringWithFormat:@"%d", _groupId]];
    [self performSelector:@selector(deleteSuccessfulGroupFromAiLiao:) withObject:nil afterDelay:2.f];
}

- (void)quitButtonClicked:(id)sender
{
    _isDeleteGroup = TRUE;
    [self loadExitChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES userList:[NSArray arrayWithObjects:[AppManager instance].userId, nil]];
    
}

- (void)joinButtonClicked:(id)sender
{
    
    [self loadJoinChatGroup:TRIGGERED_BY_AUTOLOAD forNew:YES userList:[NSArray arrayWithObjects:[AppManager instance].userId, nil]];
    
}

- (void)CustomeAlertViewDismiss:(CustomeAlertView *)alertView {
    [alertView release];
}

#pragma mark -- load data
- (void)loadGetGroupUserList:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    //    [self.dataModal retain];
    NSMutableDictionary *dict = [[[NSMutableDictionary alloc] init] autorelease];
    [dict setValue:self.dataModal.groupId forKey:KEY_API_PARAM_GROUP_ID];
    [dict setValue:@"1" forKey:KEY_API_PARAM_PAGE_NO];
    
    _currentType = GET_GROUP_USER_LIST;
    
    NSString *url = [CommonUtils geneJSONUrl:dict itemType:_currentType];
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:_currentType];
    [connFacade fetchGets:url];
}

- (void)loadJoinChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew userList:(NSArray *)userList
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[userList componentsJoinedByString:@","] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_JOIN_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_JOING_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}


-(void)getGroupInfo:(int)groupId
{
    self.entityName = @"ChatGroupDataModal";
    self.descriptors = [NSMutableArray array];
    self.predicate = [NSPredicate predicateWithFormat:@"groupId == %d",groupId];
    
    NSSortDescriptor *dateDesc = [[[NSSortDescriptor alloc] initWithKey:@"displayIndex" ascending:YES] autorelease];
    [self.descriptors addObject:dateDesc];
    
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        //        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
    if (self.fetchedRC.fetchedObjects.count) {
        _dataModal = [self.fetchedRC.fetchedObjects objectAtIndex:0];
    }
    
}

- (void)loadQuiteChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew userList:(NSArray *)userList
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    
    [self getGroupInfo:_groupId];
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[userList componentsJoinedByString:@","] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_QUIT_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_QUIT_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

- (void)loadDeleteGroupUserList:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    //    [specialDict setValue:VALUE_API_PREFIX forKey:KEY_API_PREFIX];
    //    [specialDict setValue:VALUE_API_CONTENT forKey:KEY_API_CONTENT];
    [self getGroupInfo:_groupId];
    [specialDict setObject:NUMBER(_groupId) forKey:KEY_API_PARAM_GROUP_ID];
    
    //------------------------------
    NSMutableDictionary *requestDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_DELETE_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_DELETE_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
    
}

#pragma mark -- exit gorup

- (void)loadExitChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew userList:(NSArray *)userList
{
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[userList componentsJoinedByString:@","] forKey:KEY_API_PARAM_USERIDLIST];
    
    //------------------------------
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_QUIT_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_QUIT_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}

#pragma mark --

/*
 groupId			群组ID
 groupName		群组名称
 groupImage		群组图片
 groupDescription		群组简介
 groupPhone		群组电话
 groupEmail		群组邮箱
 groupWebsite	群组网址
 invitationPublicLevel			添加新成员权限级别（0：非公开，仅管理员可添加；1：公开，成员可添加）
 */
- (void)loadUpdateChatGroup:(LoadTriggerType)triggerType forNew:(BOOL)forNew
{
    
    NSLog(@"%d:%d", !_adminSwitch.on, [_dataModal.invitationPublicLevel  intValue]);
    NSMutableDictionary *specialDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [specialDict setObject:[_dataModal  groupId] forKey:KEY_API_PARAM_GROUP_ID];
    [specialDict setObject:[_dataModal groupName] forKey:KEY_API_PARAM_GROUP_NAME];
    [specialDict setObject:[_dataModal groupImage] forKey:KEY_API_PARAM_GROUP_IMAGE];
    [specialDict setObject:[_dataModal groupDescription] forKey:KEY_API_PARAM_GROUP_DESCRIPTION];
    [specialDict setObject:[_dataModal groupPhone] forKey:KEY_API_PARAM_GROUP_PHONE];
    [specialDict setObject:[_dataModal groupEmail] forKey:KEY_API_PARAM_GROUP_EMAIL];
    [specialDict setObject:[_dataModal groupWebsite] forKey:KEY_API_PARAM_GROUP_WEBSITE];
    [specialDict setObject:[_dataModal invitationPublicLevel] forKey:KEY_API_PARAM_GROUP_INVITATION_PUBLIC_LEVEL];
    
    //------------------------------
    NSMutableDictionary *requestDict = [[NSMutableDictionary alloc] init];
    
    [requestDict setObject:[AppManager instance].common forKey:@"common"];
    [requestDict setObject:specialDict forKey:@"special"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",VALUE_API_PREFIX,API_SERVICE_CHAT_GROUP,API_NAME_UPDATE_CHAT_GROUP];
    
    WXWAsyncConnectorFacade *connFacade = [self setupAsyncConnectorForUrl:url
                                                              contentType:SUBMIT_UPDATE_CHAT_GROUP_TY];
    
    [connFacade post:url data:[requestDict JSONData]];
}


#pragma mark - ECConnectorDelegate methods
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType {
    [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:YES];
    
    [super connectStarted:url contentType:contentType];
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
    
    switch (contentType) {
            
        case UPLOAD_IMAGE_TY: {
            ImageObject *imageObj = [JSONParser handleImageUploadResponseData:result
                                                            connectorDelegate:self
                                                                          url:url];
            DLog(@"%@", imageObj.thumbnailUrl);
            
            break;
        }
            
        case GET_GROUP_USER_LIST:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                
                NSDictionary *resultDic = [result objectFromJSONData];
                NSString *timestamp = OBJ_FROM_DIC(resultDic, @"timestamp");
                
                NSDictionary *contentDict = [resultDic objectForKey:@"content"];
                if (contentDict) {
                    NSArray *userListArr = [contentDict objectForKey:@"userList"];
                    
                    if (![userListArr isEqual:[NSNull null]] && userListArr.count) {
                        for (int i = 0; i < userListArr.count; i++) {
                            NSDictionary *deltaDic = [userListArr objectAtIndex:i];
                            DLog(@"%d", [[deltaDic objectForKey:@"userID"] integerValue]);
                            
                            UserProfile *userProfile =[CommonMethod formatUserProfileWithParam:deltaDic];
                            [[AppManager instance].userDM.userProfiles addObject:userProfile];
                            
                            //保存用户到DB
                            /*
                            [[GoHighDBManager instance] upinsertUserIntoDB:[CommonMethod userBaseInfoWithDictUserProfile:userProfile] timestamp:[timestamp doubleValue]];
                            [[GoHighDBManager instance] upinsertUserProfile:userProfile];
                             
                             // TODO
                             造成用户明细 中文名和头像 重复
                            */
                            
                            NSMutableArray * arr = [[GoHighDBManager instance] getUserPropertiesByUserId:userProfile.userID] ;
                            DLog(@"%d",arr.count);
                        }
                    }
                    _groupMemberList = [[CommonMethod userProfilesFromUserList:userListArr] retain];
                }
                
                _lastY = 0;
                
                if (!_userListChanged) {
                    if ([_dataModal.groupType integerValue] != CHAT_GROUP_TYPE_PUBLIC) {
                        _memberListView = [self initMemberList:_groupMemberList withCount:_groupMemberList.count];
                        [_itemBaseScrollView addSubview:_memberListView];
                    }
                    _infoView = [self initInfos:_lastY];
                    [_itemBaseScrollView addSubview:_infoView];
                } else {
                    
                    [self getGroupInfo:_groupId];
                    
                    for (UIView *subView in [_memberListView subviews]) {
                        [subView removeFromSuperview];
                        subView = nil;
                    }
                    
                    if ([_dataModal.groupType integerValue] != CHAT_GROUP_TYPE_PUBLIC) {
                        [_memberListView removeFromSuperview];
                        _memberListView = nil;
                        _memberListView = [self initMemberList:_groupMemberList withCount:_groupMemberList.count];
                        [_itemBaseScrollView addSubview:_memberListView];
                    }
                    
                    CGRect rect = _infoView.frame;
                    rect.origin.y = _lastY;
                    _infoView.frame = rect;
                    _lastY += rect.size.height;
                    _userListChanged = NO;
                    [_memberListView setNeedsDisplay];
                }
                
                [_itemBaseScrollView setContentSize:CGSizeMake(_screenSize.width - 2*_marginX, _lastY + 5)];
            }
            
            break;
        }
            
        case SUBMIT_JOING_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep0Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                    [_delegate refreshGroupList];
                }
            } else if (ret == GROUP_NEED_AUDIT_JOIN) {
                
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep1Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            } else if (ret == GROUP_APPLY_JOINED) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatJoinGroupStep2Msg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            break;
        }
            
        case SUBMIT_QUIT_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE || ret == GROUP_NOT_EXIST) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatOutGroupSucMsg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                _userListChanged  = YES;
                [self loadGetGroupUserList:TRIGGERED_BY_AUTOLOAD forNew:YES];
                
                if (_isDeleteGroup) {
                    if (_delegate && [_delegate respondsToSelector:@selector(deleteSuccessfulGroup:)]) {
                        [_delegate deleteSuccessfulGroup:[_dataModal.groupId integerValue]];
                    }
                    
                    UIViewController* listViewController = nil;
                    UserBaseInfo* currentInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
                    for (UIViewController* viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[ChatListViewController class]]) {
                            [((ChatListViewController*)viewController) sendTextMsg:MESSAGE_QUIT_GROUP(currentInfo.chName)];
                        } else if ([viewController isKindOfClass:[HomepageContainerViewController class]]) {
                            if ([((HomepageContainerViewController*)viewController).currentVC isKindOfClass:[CommunicationListViewController class]]) {
                                listViewController = viewController;
                            }
                        }
                    }
                    _isDeleteGroup = FALSE;
                    
                    if (listViewController) {
                        [self.navigationController popToViewController:listViewController animated:YES];
                    } else {
                        [self back:nil];
                    }
                    
                    
                } else {
                    //删除群成员
                    if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
                        [_delegate refreshGroupList];
                    } else {
                        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_dataModal.groupId, @"groupId", nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_QUIT_CHAT_GROUP object:nil userInfo:dict];
                    }
                    
                    UserBaseInfo *myUserInfo = [[GoHighDBManager instance] getUserInfoFromDB:[[AppManager instance].userId integerValue]];
                    
                    UserBaseInfo* deleteUserInfo = [[GoHighDBManager instance] getUserInfoFromDB:_deleteUserId];
                    for (UIViewController* viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[ChatListViewController class]]) {
                            [((ChatListViewController*)viewController) sendTextMsg:MESSAGE_REMOVE_FROM_GROUP(myUserInfo.chName, deleteUserInfo.chName)];
                            break;
                        }
                    }
                }
                
            } else if (ret == GROUP_EXIT_FAILED) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSICchatOutGroupMsg, nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            } else {
                
                [WXWUIUtils showNotificationOnTopWithMsg:[NSString stringWithFormat:@"%@错误代码:%d", LocaleStringForKey(NSICchatOutGroupMsg, nil), ret]
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
            }
            
            break;
        }
            
        case  SUBMIT_DELETE_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                //                NSString *astr = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
                NSDictionary *resultDic = [result objectFromJSONData];
                
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"删除成功", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                
                if (_delegate && [_delegate respondsToSelector:@selector(deleteSuccessfulGroup:)]) {
                    [_delegate deleteSuccessfulGroup:[_dataModal.groupId integerValue]];
                } else {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:_dataModal.groupId, @"groupId", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:COMMUNICAT_VIEW_CONTROLLER_DELETE_GROUP object:nil userInfo:dict];
                }
                //                [self back:nil];
                [self backToRootViewController:nil];
            }
        }
            break;
            
        case SUBMIT_UPDATE_CHAT_GROUP_TY:
        {
            ConnectionAndParserResultCode ret = [JSONParser parserResponseJsonData:result
                                                                              type:contentType
                                                                               MOC:_MOC
                                                                 connectorDelegate:self
                                                                               url:url
                                                                           paramID:0];
            if (ret == SUCCESS_CODE) {
                [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(@"更新成功", nil)
                                                 msgType:INFO_TY
                                      belowNavigationBar:YES];
                _submited = FALSE;
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


#pragma mark - nav bar button

- (void)contentChanged:(BOOL)changed
{
    _changed = YES;
}

- (void)userListChanged:(BOOL)changed
{
    _userListChanged = changed;
    if (changed) {
        
        [self loadGetGroupUserList:TRIGGERED_BY_AUTOLOAD forNew:YES];
    }
}

#pragma mark - ichat

- (void)onReceiveMessage:(QPlusMessage *)message
{
    //群消息
    if (!message.isPrivate) {
        [_tableView reloadData];
        
    }
}

-(void)refreshGroupList
{
    if (_delegate && [_delegate respondsToSelector:@selector(refreshGroupList)]) {
        [_delegate refreshGroupList];
    }
}

@end
