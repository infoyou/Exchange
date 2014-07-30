//
//  CircleMarketingVoteCommitCell.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "EventOptionList.h"

#define VOTE_COMMIT_CELL_HEIGHT 50.f
#define BUTTON_TAG 1000

@class CircleMarketingVoteCommitCell;
@protocol CircleMarketingVoteCommitCellDelegate <NSObject>

- (void)circleMarketingVoewCommiteCell:(CircleMarketingVoteCommitCell *)cell selectedWithOptionID:(int)optionId;

@end

@interface CircleMarketingVoteCommitCell : BaseTextBoardCell

@property (nonatomic, assign) id<CircleMarketingVoteCommitCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (void)drawVoteCommitCellWithArray:(NSArray *)arr;

@end
