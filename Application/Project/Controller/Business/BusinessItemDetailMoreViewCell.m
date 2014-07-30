//
//  BusinessItemDetailMoreViewCell.m
//  Project
//
//  Created by XXX on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BusinessItemDetailMoreViewCell.h"
#import "GlobalConstants.h"
#import "UIColor+expanded.h"
#import "CommonHeader.h"
#import "BusinessItemDetailMoreExpandViewController.h"
#import "BusinessItemCellDetailWebViewController.h"

@implementation BusinessItemDetailMoreViewCell {
    NSDictionary *_dataDict;
    int _type;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)type
{
    _type = type;
    return [self initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initSubviews];
        
        [CommonMethod viewAddGuestureRecognizer:self withTarget:self withSEL:@selector(viewTapped:)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
//        imageView.image =IMAGE_WITH_IMAGE_NAME(@"view_cell_background.png");
        imageView.image =[CommonMethod createImageWithColor:WHITE_COLOR];;
        self.backgroundView = imageView;
        [imageView release];
    }
    return self;
}

- (void)viewTapped:(UISwipeGestureRecognizer *)recognizer
{
    NSArray *listArray = [_dataDict objectForKey:@"list1"];
    if (listArray.count) {
    BusinessItemDetailMoreExpandViewController *vc = [[[BusinessItemDetailMoreExpandViewController alloc] initWithMOC:nil needRefreshHeaderView:NO needRefreshFooterView:NO] autorelease];
    
    [vc updateInfo:_dataDict];
    
    [CommonMethod pushViewController:vc withAnimated:YES];
    }else{
        
        NSString *url = [_dataDict objectForKey:@"param8"];
        NSString *title = [_dataDict objectForKey:@"param3"];
        
        BusinessItemCellDetailWebViewController *vc = [[[BusinessItemCellDetailWebViewController alloc] initWithUrl:url title:title] autorelease];
        [CommonMethod pushViewController:vc withAnimated:YES];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)layoutSubviews {
    
    if (_type == BUSINESS_DETAIL_CELL_TYPE_EXPAND) {
        
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(15, 6, self.frame.size.width - 15*2, BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_EXPAND - 12)];
//    v.image = ImageWithName(@"business_detail_cell_bg.png");
    v.image = [CommonMethod createImageWithColor:[UIColor colorWithHexString:@"EBEBEB"]];
    self.backgroundView = v;
        [v release];
        
        
        self.backgroundColor = [UIColor colorWithPatternImage:[CommonMethod createImageWithColor:[UIColor whiteColor] withRect:CGRectMake(0, 0, self.frame.size.width - 0, self.frame.size.height)]];
        
    }else{
        CGRect rect = _titleLabel.frame;
        rect.origin.y = (BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_DETAIL  - 30) / 2.0f;
        _titleLabel.frame = rect;
        
        [super layoutSubviews];
        
        
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_DETAIL - 1, self.contentView.frame.size.width, 1)];
        [lineLabel setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:lineLabel];
        [lineLabel release];
    }
}


- (void)initSubviews {
    int height = 30;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_EXPAND - height ) / 2, self.bounds.size.width - 20*2, height)];
    _titleLabel.backgroundColor = TRANSPARENT_COLOR;
    _titleLabel.font = FONT_SYSTEM_SIZE(16);
    _titleLabel.textColor = [UIColor colorWithHexString:@"0x333333"];
    [self.contentView addSubview:_titleLabel];
}


- (void)updateInfo:(NSDictionary *)dict
{
    _dataDict = dict;
    self.titleLabel.text = [dict objectForKey:@"param3"];
    
}

@end
