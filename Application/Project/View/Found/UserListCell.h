//
//  UserListCell.h
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHImageView.h"
#import "Alumni.h"

#define SEARCH_RESULT_CELL_HEIGHT   85

@interface UserListCell : UITableViewCell

@property (nonatomic, retain) UILabel *titLabel;
@property (nonatomic, retain) UILabel *desLabel;
@property (nonatomic, retain) UILabel *bottomLineLabel;
@property (nonatomic, retain) UILabel *verLabel;
@property (nonatomic, retain) GHImageView *portImageView;

- (void)updateCell:(Alumni *)userProfile;

@end