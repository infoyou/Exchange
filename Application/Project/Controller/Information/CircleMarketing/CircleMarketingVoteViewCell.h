//
//  CircleMarketingVoteViewCell.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "BaseTextBoardCell.h"
#import "EventVoteList.h"

#define VOTE_CELL_HEIGHT  52.f
//@class CircleMarketingVoteViewCell;
//@protocol CircleMarketingVoteViewCellDelegate <NSObject>
//
//- (void)circleMarketingVoteCell:(CircleMarketingVoteViewCell *)cell voteButtonTapped:(UIButton *)voteButton;
//
//@end


@protocol CircleMarketingVoteViewCellDelegate;

@interface CircleMarketingVoteViewCell : BaseTextBoardCell

@property (nonatomic, assign) id<CircleMarketingVoteViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)drawEventVoteList:(EventVoteList *)evList;

@end

@protocol CircleMarketingVoteViewCellDelegate <NSObject>

- (void)selecteVoteCell:(EventVoteList *)evList;

@end
