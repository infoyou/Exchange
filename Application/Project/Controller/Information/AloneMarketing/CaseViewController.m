//
//  CaseViewController.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CaseViewController.h"
#import "CaseDetailViewController.h"
#import "CommonHeader.h"
#import "CaseCell.h"
#import "CaseDetailCell.h"
#import "SubCategory.h"
#import "SummaryViewController.h"
#import "NSDate+Utils.h"

@interface CaseViewController ()<UITableViewDataSource, UITableViewDelegate> {
    CellType cellType;
}

@property (nonatomic, retain) ChildSubCategory *rootCate;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) NSMutableArray *dates;
@property (nonatomic, retain) UITableView *mainTable;

@end

@implementation CaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootCategory:(ChildSubCategory *)rc cellType:(CellType)ctype {
    self = [super init];
    if (self) {
        self.rootCate = rc;
        cellType = ctype;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe9edee"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xeaedee"];
    self.navigationItem.title = self.rootCate.param3;
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
    _urls = [[NSMutableArray alloc] init];
    _dates = [[NSMutableArray alloc] init];
    DLog(@"%@",self.rootCate);
    if (self.rootCate.list1 && self.rootCate.list1.count > 0) {
        for (SubCategory *sc in self.rootCate.list1) {
            [self.titles addObject:sc.param3];
            [self.urls addObject:sc.param8];
            //            if (cellType == CellType_WithDate)
            {
                [self.dates addObject:sc.param7];
            }
        }
    }
}

- (void)addMainTable {
    int heigh=0;
    if ([CommonMethod is7System]) {
        heigh = SYS_STATUS_BAR_HEIGHT;
    }
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - ALONE_MARKETING_TAB_HEIGHT - HOMEPAGE_TAB_HEIGHT - heigh) style:UITableViewStylePlain];
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
    if (cellType == CellType_OnlyTitle) {
        return CASE_CELL_HEIGHT;
    }else if (cellType == CellType_WithDate)
    return CASE_DETAIL_CELL_HEIGHT;
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cellType == CellType_OnlyTitle) {
        static NSString *identifier = @"case_cell";
        
        CaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[[CaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = self.titles[indexPath.row];
        cell.dateLabel.text = [[self.dates[indexPath.row] componentsSeparatedByString:@" "] objectAtIndex:0];
        return cell;
    }else if (cellType == CellType_WithDate) {
        static NSString *identifier = @"case_detail_cell";
        
        CaseDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            cell = [[[CaseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text = self.titles[indexPath.row];
        
        cell.dateLabel.text = [[NSDate dateTimeFromString:self.dates[indexPath.row]] defaultDateWipeYearWithType:FormatType_Han];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    ChildSubCategory *ch = [self.rootCate.list1 objectAtIndex:indexPath.row];
    
    if (ch.list1.count) {
        CaseViewController *vc = [[[CaseViewController alloc] initWithRootCategory:ch cellType:CellType_OnlyTitle] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
    }else {
        //    CaseDetailViewController *vc = [[[CaseDetailViewController alloc] initWithURL:self.urls[indexPath.row] andTitle:self.titles[indexPath.row]] autorelease];
        
        SummaryViewController *vc = [[[SummaryViewController alloc] initWithRootCategory:ch showBottom:NO] autorelease];
        DLog(@"%@",ch.param8);
        [CommonMethod pushViewController:vc withAnimated:YES];
        
    }
}

- (void)dealloc {
    [_titles release];
    [_urls release];
    [_rootCate release];
    [_mainTable release];
    
    [super dealloc];
}

@end
