//
//  CircleMarketingDetailViewCell.h
//  Project
//
//  Created by Jang on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "EventDetailList.h"
#import "GlobalConstants.h"

#define CELL_DETAIL_BASE_HEIGHT 47.f


@interface CircleMarketingDetailViewCell : BaseTextBoardCell {

}

@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) UIImageView *line;
@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
