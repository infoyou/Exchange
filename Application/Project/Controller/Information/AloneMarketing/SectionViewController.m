//
//  SectionViewController.m
//  Project
//
//  Created by XXX on 13-11-11.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "SectionViewController.h"
#import "GlobalConstants.h"
#import "CaseViewController.h"
#import "CommonMethod.h"
#import "CaseDetailViewController.h"
#import "CaseCell.h"
#import "UIColor+expanded.h"
#import "ExectueCell.h"

#define HEADER_HEIGHT 35.f

@interface SectionViewController ()<UITableViewDataSource, UITableViewDelegate> 

@property (nonatomic, retain) ChildSubCategory *rootCate;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, retain) NSMutableArray *urls;
@property (nonatomic, retain) UITableView *mainTable;
@end

@implementation SectionViewController

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
    [self initData];
    [self addMainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithRootCategory:(ChildSubCategory *)rc {
    self = [super init];
    if (self) {
        self.rootCate = rc;
    }
    return self;
}

- (void)initData {
    _titles = [[NSMutableArray alloc] init];
    _urls = [[NSMutableArray alloc] init];
    DLog(@"%@",self.rootCate);
    if (self.rootCate.list1 && self.rootCate.list1.count > 0) {
        for (ChildSubCategory *sc in self.rootCate.list1) {
            [self.titles addObject:sc.param3];
            [self.urls addObject:sc.param8];
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
    return [self.rootCate.list1 count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ChildSubCategory *ch = [self.rootCate.list1 objectAtIndex:section];
    return ch.list1.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EXECTUE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titles[section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(12, 0, tableView.bounds.size.width, HEADER_HEIGHT);
    label.backgroundColor = TRANSPARENT_COLOR;
    label.font = FONT_SYSTEM_SIZE(18);
    label.text = sectionTitle;
    label.textColor = [UIColor whiteColor];
    
    UIView *sectionView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, HEADER_HEIGHT)] autorelease];
//    [sectionView setBackgroundColor:[UIColor colorWithPatternImage:IMAGE_WITH_IMAGE_NAME(@"information_aloneMarketing_tableview_separator")]];
    [sectionView setBackgroundColor:[UIColor colorWithHexString:@"0xB4B8BB"]];
    [sectionView addSubview:label];
    //    [label release];
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"case_cell";
    
    ExectueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[ExectueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ChildSubCategory *ch = [self.rootCate.list1 objectAtIndex:indexPath.section];
    ChildSubCategory *cch = [ch.list1 objectAtIndex:indexPath.row];
    cell.titleLabel.text = cch.param3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    ChildSubCategory *ch = [self.rootCate.list1 objectAtIndex:indexPath.section];
    
    NSArray *list = ch.list1;
    
    if (ch.list1.count) {
        CaseViewController *vc = [[[CaseViewController alloc] initWithRootCategory:list[indexPath.row] cellType:CellType_WithDate] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
    }else {
        CaseDetailViewController *vc = [[[CaseDetailViewController alloc] initWithURL:self.urls[indexPath.row] andTitle:self.titles[indexPath.row]] autorelease];
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
