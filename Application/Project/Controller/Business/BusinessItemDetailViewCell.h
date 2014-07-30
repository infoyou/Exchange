//
//  BusinessItemDetailViewCell.h
//  Project
//
//  Created by Yfeng__ on 13-10-22.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT 103.f
#define BUSINESS_ITEM_DETAIL_VIEW_CELL_HEIGHT 50.f

@interface BusinessItemDetailViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;

- (void)updateInfo:(NSDictionary *)dict;

@end
