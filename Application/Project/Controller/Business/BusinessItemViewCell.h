//
//  BusinessItemViewCell.h
//  Project
//
//  Created by XXX on 13-9-4.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECImageConsumerCell.h"
#import "BusinessItemModel.h"

#define BUSINESS_ITEM_VIEW_CELL_HEIGHT  157

@interface BusinessItemViewCell : ECImageConsumerCell

@property (nonatomic, assign) NSInteger projectID;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (void)updateItemInfo:(BusinessItemModel *)itemModel withContext:(NSManagedObjectContext*)context withDataArray:(NSDictionary *)dataDict;
@end
