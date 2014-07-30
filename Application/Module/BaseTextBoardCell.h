//
//  BaseTextBoardCell.h
//  Project
//
//  Created by XXX on 12-5-11.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WXWLabel;

@interface BaseTextBoardCell : UITableViewCell {
  @private
  NSMutableArray *_labelsContainer;
}

- (WXWLabel *)initLabel:(CGRect)frame 
             textColor:(UIColor *)textColor 
           shadowColor:(UIColor *)shadowColor;

@end
