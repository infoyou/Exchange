//
//  CircleMarkegingApplyWindowCell.h
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventApplyList.h"

@protocol CircleMarkegingApplyCellDelegate <NSObject>

@optional
- (void)didBeginEditingWithIndex:(int)index;

@end

@interface CircleMarkegingApplyWindowCell : UITableViewCell

@property (nonatomic, assign) EventApplyList *applyList;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UITextField *valueTextField;
@property (nonatomic, assign) id<CircleMarkegingApplyCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withInfo:(EventApplyList *)apply indexPth:(NSIndexPath *)indexPath;

- (EventApplyList *)getApplyList;
@end
