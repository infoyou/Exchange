//
//  BusinessItemDetailViewCell.m
//  Project
//
//  Created by Yfeng__ on 13-10-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemDetailViewCell.h"
#import "CommonHeader.h"
#import "BusinessItemCellDetailWebViewController.h"
#import "WXWNavigationController.h"
#import "WXWCommonUtils.h"

@implementation BusinessItemDetailViewCell {
    NSDictionary *_dataDict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = TRANSPARENT_COLOR;
        [self initSubviews];
        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
    }
    return self;
}


- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    
//    WXWWebViewController *webVC = [[[WXWWebViewController alloc] initWithNeedCloseButton:YES
//                                                                          needNavigation:YES
//                                                                          needHomeButton:YES] autorelease];
//    webVC.urlStr = [_dataDict objectForKey:@"param8"];
//    webVC.title = title;
//    
//    WXWNavigationController *webViewNav = [[WXWNavigationController alloc] initWithRootViewController:webVC];
//    
//    [self.version presentModalViewController:webViewNav
//                                           animated:YES];
//    RELEASE_OBJ(webViewNav);
    
//    BusinessItemCellDetailWebViewController *vc = [[BusinessItemCellDetailWebViewController alloc] initWithNeedCloseButton:NO needNavigation:NO blockViewWhenLoading:NO needHomeButton:NO];
//    
//    vc.urlStr = [_dataDict objectForKey:@"param8"];
//    vc.title = [_dataDict objectForKey:@"param3"];
//    
//    [CommonMethod pushViewController:vc withAnimated:YES];
    
//    [WXWCommonUtils openWebView:[CommonMethod getInstance].navigationRootViewController.navigationController title:[_dataDict objectForKey:@"param3"] url:[_dataDict objectForKey:@"param8"] needCloseButton:NO needNavigation:NO needHomeButton:NO];
    
    BusinessItemCellDetailWebViewController *vc = [[[BusinessItemCellDetailWebViewController alloc] initWithUrl:[_dataDict objectForKey:@"param8"] title:[_dataDict objectForKey:@"param3"]] autorelease];
    [CommonMethod pushViewController:vc withAnimated:YES];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_titleLabel release];
    [_contentLabel release];
    [super dealloc];
}

- (void)initSubviews {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 150, 30)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.font = FONT_SYSTEM_SIZE(15);
    _titleLabel.textColor = [UIColor colorWithHexString:@"0xe83e0b"];
    
    [CommonMethod viewAddGuestureRecognizer:_titleLabel withTarget:self withSEL:@selector(viewTapped:)];
    [self.contentView addSubview:_titleLabel];
    
    CGRect rect = _titleLabel.frame;
    rect.origin.y = (BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT - rect.size.height) / 2.0f;
    _titleLabel.frame = rect;
    
    UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(220 - 12, 14, 100, 30)];
    buttonLabel.backgroundColor = TRANSPARENT_COLOR;
    buttonLabel.font = FONT_SYSTEM_SIZE(12);
    buttonLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    buttonLabel.text = @"查看详情 >";
    buttonLabel.textAlignment = NSTextAlignmentRight;
    [CommonMethod viewAddGuestureRecognizer:buttonLabel withTarget:self withSEL:@selector(viewTapped:)];

    
    [self.contentView addSubview:buttonLabel];
    [buttonLabel release];
    
    rect = buttonLabel.frame;
    rect.origin.y = (BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT - rect.size.height) / 2.0f;
    buttonLabel.frame = rect;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(220 - 23, 14, 100, 30);
    [btn addTarget:self action:@selector(selectedAtIndex:) forControlEvents:UIControlEventTouchUpInside];
    
    [CommonMethod viewAddGuestureRecognizer:btn withTarget:self withSEL:@selector(viewTapped:)];
    [self.contentView addSubview:btn];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, _titleLabel.frame.origin.y + _titleLabel.frame.size.height - 5, self.frame.size.width - 46, 56)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = FONT_SYSTEM_SIZE(13);
    _contentLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    _contentLabel.backgroundColor = TRANSPARENT_COLOR;
    [_contentLabel setNumberOfLines:2];
//    [self.contentView addSubview:_contentLabel];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT - 1, self.contentView.frame.size.width, 1)];
    [lineLabel setBackgroundColor:[UIColor colorWithHexString:@"0xcdcdcd"]];
    [self addSubview:lineLabel];
    [lineLabel release];
}

- (void)layoutSubviews {
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width , BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT)];
//    v.image = ImageWithName(@"business_detail_cell_bg.png");
    v.image = [CommonMethod createImageWithColor:WHITE_COLOR];
    self.backgroundView = v;
    [v release];
}

- (void)selectedAtIndex:(UIButton *)sender {
    
}


- (void)updateInfo:(NSDictionary *)dict
{
    
    self.titleLabel.text = [dict objectForKey:@"param3"];
    self.contentLabel.text = [dict objectForKey:@"param9"];
    
    _dataDict = dict;
}
@end
