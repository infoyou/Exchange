//
//  CircleMarketingViewCell.h
//  Project
//
//  Created by Yfeng__ on 13-10-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ECImageConsumerCell.h"
#import "EventList.h"

#define CIRLE_CELL_HEIGHT  235.f

@protocol CircleMarketingViewCellDelegate <NSObject>

- (void)cellTapped;

@end

@interface CircleMarketingViewCell : ECImageConsumerCell

@property (nonatomic, assign) id<CircleMarketingViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (void)drawEventList:(EventList *)eventList;
- (void)hideTimeLabel;
- (void)showTimeLabel;

@end
