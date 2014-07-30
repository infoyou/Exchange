//
//  FriendListCell.h
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGEVIEW_WIDTH   80.f
#define IMAGEVIEW_HEIGHT  80.f

#define BASE_TAG 100

@class FriendListCell;
@protocol FriendListCellDelegate <NSObject>

- (void)friendListCell:(FriendListCell *)cell imageTappedWithIndex:(int)index;

@end

@interface FriendListCell : UITableViewCell

@property (nonatomic, retain) UIImageView *portImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *descLabel;

@property (nonatomic, assign) id<FriendListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(int)index;

@end
