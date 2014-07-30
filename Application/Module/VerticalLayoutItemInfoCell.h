//
//  VerticalLayoutItemInfoCell.h
//  Project
//
//  Created by XXX on 12-3-11.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalConstants.h"
#import "BaseTextBoardCell.h"
#import "WXWConstants.h"

@class WXWLabel;

@interface VerticalLayoutItemInfoCell : BaseTextBoardCell {
@private
  WXWLabel *_titleLabel;
  WXWLabel *_subTitleLabel;
  WXWLabel *_contentLabel;

  SeparatorType _separatorType;
  CGFloat _cellHeight;
}

- (void)drawNoShadowInfoCell:(NSString *)title 
                    subTitle:(NSString *)subTitle
                     content:(NSString *)content
                   clickable:(BOOL)clickable;

- (void)drawDashSeparatorNoShadowInfoCell:(NSString *)title
                                 subTitle:(NSString *)subTitle
                                  content:(NSString *)content
                                clickable:(BOOL)clickable
                               cellHeight:(CGFloat)cellHeight;

- (void)drawShadowInfoCell:(NSString *)title 
                  subTitle:(NSString *)subTitle
                   content:(NSString *)content
                cellHeight:(CGFloat)cellHeight
                 clickable:(BOOL)clickable;

- (void)drawShadowInfoCell:(NSString *)title 
                  subTitle:(NSString *)subTitle
                   content:(NSString *)content
  contentConstrainedHeight:(CGFloat)contentConstrainedHeight
                cellheight:(CGFloat)cellheight
             lineBreakMode:(NSLineBreakMode)lineBreakMode
                 clickable:(BOOL)clickable;

@end
