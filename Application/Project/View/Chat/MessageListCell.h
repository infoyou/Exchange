//
//  MessageListCell.h
//  Project
//
//  Created by Jang on 13-9-28.
//  Copyright (c) 2013å¹´ com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivateUserListDataModal.h"
#import "ECImageConsumerCell.h"

#define IMAGEVIEW_WIDTH   65.f
#define IMAGEVIEW_HEIGHT  70.f

#define DATELABEL_WIDTH    80.f
#define DATELABEL_HEIGHT   16.f



@protocol MessageListCellDelegate;

@interface MessageListCell : ECImageConsumerCell


@property (nonatomic, assign) id<MessageListCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (void)updateItemInfo:(PrivateUserListDataModal *)dataModal withContext:(NSManagedObjectContext*)context;

- (void)updateMessageCount;
- (void)updateMessageCount:(int)count;
-(int)newMessageCount;
-(void)hiddenDeleteButton:(BOOL)hidden;



-(PrivateUserListDataModal *)getPrivateUserListDataModal;

- (void)setDeleteButtonHidden:(BOOL)hidden;
@end

@protocol MessageListCellDelegate <NSObject>

- (void)getMemberInfo:(PrivateUserListDataModal *)dataModal;
//- (void)startToChat:(PrivateUserListDataModal *)dataModal;


- (void)startToChat:(MessageListCell *)cell withDataModal:(PrivateUserListDataModal *)dataModal newMessageCount:(int)newMessageCount;


@optional
- (void)deleteUserInfo:(PrivateUserListDataModal *)dataModal;

-(void)hiddenOtherCellDeleteButton;

@end