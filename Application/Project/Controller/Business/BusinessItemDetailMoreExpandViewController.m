//
//  BusinessItemDetailMoreExpandViewController.m
//  Project
//
//  Created by XXX on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemDetailMoreExpandViewController.h"
#import "BusinessItemDetailMoreViewCell.h"
#import "GlobalConstants.h"
#import "CommonMethod.h"
#import "HomepageContainerViewController.h"
#import "GlobalConstants.h"

@interface BusinessItemDetailMoreExpandViewController ()

@end

@implementation BusinessItemDetailMoreExpandViewController {
    NSArray *_dataArray;
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
    [self.view bringSubviewToFront:_tableView];
    [_tableView reloadData];
    [_tableView setBackgroundColor:TRANSPARENT_COLOR];
    _tableView.alpha = 1.0f;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor  = DEFAULT_VIEW_COLOR;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- table view delegate
//-------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_DETAIL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * tableIdentifier = @"BusinessItemDetailMoreViewCell";
    
    BusinessItemDetailMoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    if(cell == nil)
    {
        cell = [[[BusinessItemDetailMoreViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier withType:BUSINESS_DETAIL_CELL_TYPE_DETAIL] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.imageView.image= IMAGE_WITH_IMAGE_NAME(@"view_cell_background.png");
    }
    
  [cell updateInfo:[_dataArray objectAtIndex:indexPath.row]];
    return cell;
    
}


- (void)updateInfo:(NSDictionary *)dict
{
    _dataArray = [dict objectForKey:@"list1"];
    self.navigationItem.title = [dict objectForKey:@"param3"] ;
}

@end
