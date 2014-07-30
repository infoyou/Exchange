//
//  SearchResultViewController.m
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CommunicationSearchResultViewController.h"
#import "SearchResultCell.h"
#import "CommunicationPersonalInfoViewController.h"
#import "UIColor+expanded.h"
#import "UserDataManager.h"
#import "UserProfile.h"
#import "UserBaseInfo.h"
#import "GlobalConstants.h"
#import "CommonHeader.h"


@interface CommunicationSearchResultViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *userList;
}

@property (nonatomic, retain) UITableView *mainTable;

@end

@implementation CommunicationSearchResultViewController

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
    self.navigationItem.title = @"搜索结果";
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor =DEFAULT_VIEW_COLOR;
    
    [self initData];
    [self addTableView];
}

- (void)dealloc {
    [_mainTable release];
    [userList release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    userList = [[NSArray alloc] initWithArray:[UserDataManager defaultManager].userProfiles];
}

- (void)addTableView {
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - SYS_STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT) style:UITableViewStylePlain];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = [UIColor clearColor];
    _mainTable.showsVerticalScrollIndicator = NO;
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainTable];
}

#pragma mark - tableview delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SEARCH_RESULT_CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"reuse_cell";
    SearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[SearchResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor = [UIColor whiteColor];
    }
    
    UserProfile *uf = (UserProfile *)userList[indexPath.row];

    
    [cell updateCell:uf];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
//    CommunicationPersonalInfoViewController *personalInfoController = [[[CommunicationPersonalInfoViewController alloc] init] autorelease];
//    personalInfoController.index = indexPath.row;
//    [CommonMethod pushViewController:personalInfoController withAnimated:YES];
    
    
    UserProfile *uf = (UserProfile *)userList[indexPath.row];
    
    CommunicationPersonalInfoViewController *personalInfoController = [[[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:uf.userID withDelegate:nil isFromChatVC:FALSE] autorelease];
    [CommonMethod pushViewController:personalInfoController withAnimated:YES];
    
//    CommunicationPersonalInfoViewController *vc = [[CommunicationPersonalInfoViewController alloc] initWithMOC:_MOC parentVC:nil userId:[dataModal.userId integerValue]  withDelegate:self];
//    [CommonMethod pushViewController:vc withAnimated:YES];
}

@end
