//
//  ExecuteViewController.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ExecuteViewController.h"
#import "CommonHeader.h"
#import "ExectueCell.h"
#import "ExecuteDetailViewController.h"
#import "SubCategory.h"
#import "ChildSubCategory.h"
#import "BaseCategory.h"

#define HEADER_HEIGHT 35.f

@interface ExecuteViewController ()<UITableViewDataSource, UITableViewDelegate> {
    

}

@property (nonatomic, retain) RootCategory *rootCate;
@property (nonatomic, retain) NSMutableArray *sectionTitles;
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableDictionary *rowDic;

@end

@implementation ExecuteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootCategory:(RootCategory *)rc {
    self = [super init];
    if (self) {
        self.rootCate = rc;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"information_list_bg"]];
    
    [self initData];
    [self addMainTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData {
    _sectionTitles = [[NSMutableArray alloc] init];
    _rowDic = [[NSMutableDictionary alloc] init];
    
    if (self.rootCate.list1 && self.rootCate.list1.count > 0) {
        for (int i = 0; i < self.rootCate.list1.count; i++) {
            
            SubCategory *sc = self.rootCate.list1[i];
            [self.sectionTitles addObject:sc.param3];
            
            if (sc.list1.count > 0 && sc.list1) {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                for (int j = 0; j < sc.list1.count; j++) {
                    
                    ChildSubCategory *cc = sc.list1[j];
                    [arr addObject:cc];
                }
                [self.rowDic setObject:arr forKey:[NSString stringWithFormat:@"%d",i]];
                [arr release];
            }
        }
    }
}

- (void)addMainTable {
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height - ALONE_MARKETING_TAB_HEIGHT - NAVIGATION_BAR_HEIGHT - SYS_STATUS_BAR_HEIGHT) style:UITableViewStylePlain];
    self.mainTable.dataSource = self;
    self.mainTable.delegate = self;
    self.mainTable.showsVerticalScrollIndicator = NO;
    self.mainTable.backgroundColor = TRANSPARENT_COLOR;
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTable];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = [self.rowDic objectForKey:[NSString stringWithFormat:@"%d",section]];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return EXECTUE_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionTitles[section];
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
    [sectionView setBackgroundColor:[UIColor colorWithPatternImage:IMAGE_WITH_IMAGE_NAME(@"information_aloneMarketing_tableview_separator")]];
    [sectionView addSubview:label];
//    [label release];
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"exectue_cell";
    
    ExectueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[ExectueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    NSArray *arr = [self.rowDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    ChildSubCategory *cc = (ChildSubCategory *)arr[indexPath.row];
    cell.titleLabel.text = cc.param3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    NSArray *arr = [self.rowDic objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    ChildSubCategory *cc = (ChildSubCategory *)arr[indexPath.row];
    
    ExecuteDetailViewController *vc = [[[ExecuteDetailViewController alloc] initWithChildSubCategory:cc andTitle:cc.param3] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}

- (void)dealloc {
    [_rootCate release];
    [_rowDic release];
    [_sectionTitles release];
    [_mainTable release];
    
    [super dealloc];
}

@end
