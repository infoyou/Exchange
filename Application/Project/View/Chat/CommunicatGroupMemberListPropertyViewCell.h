//
//  CommunicatGroupMemberListPropertyViewCell.h
//  Project
//
//  Created by XXX on 13-9-28.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface CommunicatGroupMemberListPropertyViewCell : UITableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDictionary:(NSDictionary *)dict  withParentViewWidth:(int)parentViewWidth withShowBottomLine:(BOOL)showLine;

-(void)updateDefaultValue:(NSString *)value;
@end
