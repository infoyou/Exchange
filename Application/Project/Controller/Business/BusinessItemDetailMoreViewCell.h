//
//  BusinessItemDetailMoreViewCell.h
//  Project
//
//  Created by XXX on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_EXPAND 43
#define BUSINESS_ITEM_DETAIL_MORE_VIEW_CELL_HEIGHT_DETAIL 60

enum BUSINESS_DETAIL_CELL_TYPE {
    BUSINESS_DETAIL_CELL_TYPE_EXPAND = 1,
    BUSINESS_DETAIL_CELL_TYPE_DETAIL = 2,
    };

@interface BusinessItemDetailMoreViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *contentLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(int)type;
- (void)updateInfo:(NSDictionary *)dict;
@end
