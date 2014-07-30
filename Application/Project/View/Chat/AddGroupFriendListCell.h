//
//  AddGroupFriendListCell.h
//  Project
//
//  Created by XXX on 13-10-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "UserBaseInfo.h"
#import "QCheckBox.h"
#define IMAGEVIEW_WIDTH   45.f
#define IMAGEVIEW_HEIGHT  45.f

#define BASE_TAG 100

#define ADD_GROUP_FRIEND_LIST_CELL_HEIGHT   67

@protocol AddGroupFriendListCellDelegate;

@interface AddGroupFriendListCell : ECImageConsumerCell
@property (nonatomic, retain) QCheckBox *checkBox;
@property (nonatomic, retain) UIImageView *portImageView;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *descLabel;

@property (nonatomic, assign) id<AddGroupFriendListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserBaseInfo *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
         withEnable:(BOOL)enable
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
  withUserInfoArray:(UserBaseInfo *)userInfo
     withIsLastCell:(BOOL)isLastCell
        withChecked:(BOOL)isCheck
   withEnable:(BOOL)enable;


- (void)setChecked:(BOOL)isCheck;
- (void)setChecked:(BOOL)isCheck  withEnable:(BOOL)enable;

-(UserBaseInfo *)getUserProfile;
@end

@protocol AddGroupFriendListCellDelegate <NSObject>

- (void)addGroupFriendListCell:(AddGroupFriendListCell *)cell withUserProfile:(UserBaseInfo *)userProfile;
- (void)deleteGroupFriendListCell:(AddGroupFriendListCell *)cell withUserProfile:(UserBaseInfo *)userProfile;
@end