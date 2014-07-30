//
//  FoundViewController.m
//  IPhoneCIO
//
//  Created by XXX on 13-11-27.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "FoundViewController.h"
#import "MyMessageCell.h"
#import "CIOPersonalInfoCell.h"
#import "UserBaseInfo.h"
#import "CommonHeader.h"
#import "AppManager.h"
#import "GoHighDBManager.h"
#import "CommunicationMessageListViewController.h"
#import "TextPool.h"
#import "WXApi.h"
#import "CommonUtils.h"
#import "BaseAppDelegate.h"
#import "iChatInstance.h"
#import "HomepageContainerViewController.h"
#import "UserListViewController.h"
#import "BizListViewController.h"

enum {
    FOUND_TABLE_CELL,
};

enum {
    FOUND_NEARBY_CELL,
    FOUND_BIZ_CELL,
    FOUND_WELFARE_CELL,
    };

@interface FoundViewController () <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate>
@end

@implementation FoundViewController {
    
    NSInteger _asOwnerType;
}

- (id)initWithMOC:(NSManagedObjectContext *)MOC
         parentVC:(WXWRootViewController *)pVC {
    self = [super initWithMOC:MOC
        needRefreshHeaderView:NO
        needRefreshFooterView:NO];
    if (self) {
        
        self.parentVC = pVC;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"发现";
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setAlpha:1.0f];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MORE_CELL_HEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    switch (indexPath.section) {
        
        case FOUND_TABLE_CELL:
        {
            NSString *identifier = @"MyMessageCell";
            MyMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            
            if (!cell) {
                cell = [[[MyMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            switch (indexPath.row) {
                    
                case FOUND_NEARBY_CELL:
                {
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"biz.png");
                    cell.textLabel.text = @"附近的人";
                }
                    break;
                    
                case FOUND_BIZ_CELL:
                {
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"nearby.png");
                    cell.textLabel.text = @"商机合作";
                }
                    break;
                    
                case FOUND_WELFARE_CELL:
                {
                    cell.imageView.image = IMAGE_WITH_IMAGE_NAME(@"group.png");
                    cell.textLabel.text = @"校友专享";
                }
                    break;
                    
                default:
                    break;
            }
            
            return cell;
        }
            
        default:
            return nil;
            break;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {

        case FOUND_TABLE_CELL:
        {
            switch (indexPath.row) {
                case FOUND_NEARBY_CELL:
                {
                    UserListViewController *userVC = [[[UserListViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
                    [CommonMethod pushViewController:userVC withAnimated:YES];
                }
                    break;
                    
                case FOUND_BIZ_CELL:
                {
                    BizListViewController *bizVC = [[[BizListViewController alloc] initWithMOC:_MOC parentVC:self] autorelease];
                    [CommonMethod pushViewController:bizVC withAnimated:YES];
                }
                    break;
                    
                case FOUND_WELFARE_CELL:
                    [[[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSCommonWarning, nil) message:@"制作中，敬请期待" delegate:nil cancelButtonTitle:LocaleStringForKey(NSSureTitle, nil) otherButtonTitles:nil] autorelease] show];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end


