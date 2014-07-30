//
//  CircleMarketingEventCommitViewCell.h
//  Project
//
//  Created by Yfeng__ on 13-10-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"

#define COMMENT_CELL_DEFAULT_HEIGHT 60.f

#define HEAD_IMAGE_WIDTH  38.f
#define HEAD_IMAGE_HEIGHT 38.f

#define LABEL_WIDTH  252.f

@class CommentList;
@interface CircleMarketingEventCommentViewCell : ECImageConsumerCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (void)drawEventCommit:(CommentList *)comList;

@end
