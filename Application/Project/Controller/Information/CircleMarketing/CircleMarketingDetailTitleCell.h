//
//  CircleMarketingDetailTitleCell.h
//  Project
//
//  Created by Yfeng__ on 13-11-6.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"

#define TITLE_CELL_HEIGHT 80.f

@class CircleMarketingDetailTitleCell;
@protocol CircleMarketingDetailTitleCellDelegate <NSObject>

- (void)circleMarketingDetailTitleCell:(CircleMarketingDetailTitleCell *)cell leftButtonClicked:(UIButton *)leftButton;
- (void)circleMarketingDetailTitleCell:(CircleMarketingDetailTitleCell *)cell rightButtonClicked:(UIButton *)rightButton;

@end

@interface CircleMarketingDetailTitleCell : BaseTextBoardCell

@property (nonatomic, assign) id<CircleMarketingDetailTitleCellDelegate> delegate;

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
