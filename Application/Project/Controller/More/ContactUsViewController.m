//
//  ContactUsViewController.m
//  Project
//
//  Created by user on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ContactUsViewController.h"
#import "GlobalConstants.h"
#import "UIColor+expanded.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

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
//    self.view.backgroundColor = [UIColor colorWithHexString:@"0xe5ddd1"];
    self.view.backgroundColor = DEFAULT_VIEW_COLOR;
    [self initViews];
    self.navigationItem.title = @"联系我们";
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initViews {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10 + ITEM_BASE_TOP_VIEW_HEIGHT, self.view.frame.size.width - 12, 382)];
    bg.image = IMAGE_WITH_IMAGE_NAME(@"bg_1.png");
    [self.view addSubview:bg];
    
    UILabel *contactUSTitle=[[UILabel alloc] initWithFrame:CGRectMake(25, 30, bg.frame.size.width - 50, bg.frame.size.height)];
    contactUSTitle.text = @"高和资本GoHigh Capital";
    contactUSTitle.backgroundColor = TRANSPARENT_COLOR;
    contactUSTitle.font = FONT_SYSTEM_SIZE(20);
    contactUSTitle.textColor = [UIColor colorWithHexString:@"0x37332f"];
    contactUSTitle.numberOfLines = 1;
    [contactUSTitle sizeToFit];
    [bg addSubview:contactUSTitle];
    [contactUSTitle release];

    int distY = 5;
    
 UILabel *phoneLabel =    [self addContent:@"电话:(8610) 65055996" rect:CGRectMake(contactUSTitle.frame.origin.x, contactUSTitle.frame.origin.y + contactUSTitle.frame.size.height + distY, bg.frame.size.width - 50, bg.frame.size.height) parentView:bg];
    
    
    UILabel *addressLabel =    [self addContent:@"地址:" rect:CGRectMake(phoneLabel.frame.origin.x, phoneLabel.frame.origin.y + phoneLabel.frame.size.height + distY, bg.frame.size.width - 50, bg.frame.size.height) parentView:bg];
    
    UILabel *addressLabelValue =    [self addContent:@"北京市朝阳区建国门外大街1号国贸写字楼1座17层1725" rect:CGRectMake(addressLabel.frame.origin.x + addressLabel.frame.size.width, phoneLabel.frame.origin.y + phoneLabel.frame.size.height + distY, bg.frame.size.width -20 - addressLabel.frame.origin.x - addressLabel.frame.size.width, bg.frame.size.height) parentView:bg];
    
    UILabel *codeLabel =    [self addContent:@"邮编:100004" rect:CGRectMake(addressLabel.frame.origin.x, addressLabelValue.frame.origin.y + addressLabelValue.frame.size.height + distY, bg.frame.size.width - 50, bg.frame.size.height) parentView:bg];
    
    
    UILabel *descLabel =    [self addContent:@"技术支持: 上海杰亦特高和资本正在积极寻找和筛选适合整体收购的商业地产项目，如果您有合适的项目推荐（项目仅限一线城市和1.5线城市核心位置的商办物业），发邮件至：lihuizhong@gohighfund.com" rect:CGRectMake(codeLabel.frame.origin.x, codeLabel.frame.origin.y + codeLabel.frame.size.height + 5*distY, bg.frame.size.width - 50, bg.frame.size.height) parentView:bg];
    
    [bg release];
}

-(UILabel *)addContent:(NSString *)content rect:(CGRect)rect parentView:(UIView *)parentView
{
    UILabel *contentLabel =   [[[UILabel alloc] initWithFrame:rect] autorelease];
    contentLabel.text = content;
    contentLabel.backgroundColor = TRANSPARENT_COLOR;
    contentLabel.font = FONT_SYSTEM_SIZE(14);
    contentLabel.textColor = [UIColor colorWithHexString:@"0x7d7871"];
    contentLabel.numberOfLines = 20;
    [contentLabel sizeToFit];
    [parentView addSubview:contentLabel];
    
    return contentLabel;
}

@end
