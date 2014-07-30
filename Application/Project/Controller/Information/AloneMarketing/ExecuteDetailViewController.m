//
//  ExecuteDetailViewController.m
//  Project
//
//  Created by user on 13-10-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ExecuteDetailViewController.h"
#import "CaseDetailCell.h"
#import "CommonHeader.h"
#import "BaseCategory.h"
#import "ExecuteContentViewController.h"

@interface ExecuteDetailViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic, copy) NSString *navTitle;
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) ChildSubCategory *childCC;


@end

@implementation ExecuteDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithChildSubCategory:(ChildSubCategory *)cc andTitle:(NSString *)tit {
    self = [super init];
    if (self) {
        self.navTitle = tit;
        self.childCC = cc;
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-执行详情",self.navTitle];
    
    [self initData];
    [self addMainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _titles = [[NSMutableArray alloc] init];
    _dates = [[NSMutableArray alloc] init];
    _urls = [[NSMutableArray alloc] init];
    
    if (self.childCC.list1 && self.childCC.list1.count > 0) {
        for (BaseCategory *bc in self.childCC.list1) {
            [self.titles addObject:bc.param3];
            [self.dates addObject:bc.param7];
            [self.urls addObject:bc.param8];
        }
    }
}

- (void)addMainTable {
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - ITEM_BASE_TOP_VIEW_HEIGHT) style:UITableViewStylePlain];
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    self.mainTable.showsVerticalScrollIndicator = NO;
    self.mainTable.backgroundColor = TRANSPARENT_COLOR;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTable];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CASE_DETAIL_CELL_HEIGHT;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"case_detail_cell";
    
    CaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[CaseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = self.titles[indexPath.row];
    cell.dateLabel.text = self.dates[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExecuteContentViewController *vc = [[[ExecuteContentViewController alloc] initWithURL:self.urls[indexPath.row] title:self.titles[indexPath.row]] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)dealloc {
    [_titles release];
    [_urls release];
    [_dates release];
    [_mainTable release];
    [_childCC release];
    
    [super dealloc];
}

@end
