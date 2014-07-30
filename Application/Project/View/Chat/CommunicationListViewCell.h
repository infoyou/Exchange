//
//  CommunicationListViewCell.h
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatGroupDataModal.h"
#import "ChatModel.h"

@protocol CommunicatGroupBriefViewCellDelegate;

@interface CommunicationListViewCell : UITableViewCell {
    UIImageView *_avataImageView;
    UIImageView *_checkImageView;
    UIImageView *_noticeImageView;
    UIImageView *_publicGroupImageView;
    UILabel *_numberLabel;
    
    UILabel *_titleLabel;
    UILabel *_lastSpeakMemberNameLabel;
    UILabel *_lastSpeakContentLabel;
    UILabel *_dateLabel;
    UILabel *_groupTypeLabel;
    
    //    NSString *_downloadFile;
    
    UILabel *_bottomLineLabel;
    
    ChatGroupDataModal *_dataModal;
    ChatModel *_chatModel;
    //    UILabel *_newMessageLabel;
    UIButton *_newMessageButton;
    UILabel *_newMessageLabel;
    
    int newMessageCount;
    
    NSString *_vipId;
}

@property (nonatomic, retain) UIButton *newMessageButton;
@property (nonatomic, retain) UILabel *newMessageLabel;
@property (nonatomic, retain) NSString *downloadFile;
@property (nonatomic, assign) id<CommunicatGroupBriefViewCellDelegate> delegate;

- (void)updateCellInfo:(ChatGroupDataModal *)dataModal  chatModel:(ChatModel *)chatModel;
- (void)updateMessageCount;
- (void)updateMessageCount:(int)count;
- (void)updateGroupName:(NSString *)groupName;
- (void)updateData:(ChatGroupDataModal *)dataModal  chatModel:(ChatModel *)chatModel;

- (int)newMessageCount;
- (ChatGroupDataModal *)getGroupDataModal;

@end
@protocol CommunicatGroupBriefViewCellDelegate <NSObject>

@optional
- (void)getMemberList:(ChatGroupDataModal *)dataModal;
- (void)startToChat:(CommunicationListViewCell *)cell withDataModal:(ChatGroupDataModal *)dataModal newMessageCount:(int)newMessageCount;

@end