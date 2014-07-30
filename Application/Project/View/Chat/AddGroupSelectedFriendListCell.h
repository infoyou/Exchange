//
//  AddGroupSelectedFriendListCell.h
//  Project
//
//  Created by XXX on 13-10-16.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHeader.h"
#import "AddGroupFriendListCell.h"
#import "ECImageConsumerCell.h"


@protocol AddGroupSelectedFriendListCellDelegate;

@interface AddGroupSelectedFriendListCell : ECImageConsumerCell

@property (nonatomic, assign) id<AddGroupSelectedFriendListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withRect:(CGRect)rect
 imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;
- (void)updateUserProfile:(AddGroupFriendListCell *)friendListCell withUserProfile:(UserBaseInfo *)userProfile withDefault:(BOOL) isDefalut;
@end


@protocol AddGroupSelectedFriendListCellDelegate <NSObject>

- (void)avataTapped:(AddGroupFriendListCell *)friendListCell withUserProfile:(UserBaseInfo *)userProfile;

@end