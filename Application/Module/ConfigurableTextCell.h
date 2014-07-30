//
//  ConfigurableTextCell.h
//  Project
//
//  Created by XXX on 12-11-18.
//
//

#import "BaseConfigurableCell.h"
//#import "GlobalConstants.h"


@class WXWLabel;

@interface ConfigurableTextCell : BaseConfigurableCell {
  @private
  WXWLabel *_titleLabel;
  WXWLabel *_subTitleLabel;
  WXWLabel *_contentLabel;

}

- (void)drawCellWithTitle:(NSString *)title
                 subTitle:(NSString *)subTitle
                  content:(NSString *)content
     contentLineBreakMode:(NSLineBreakMode)contentLineBreakMode
               cellHeight:(CGFloat)cellHeight
                clickable:(BOOL)clickable
            hasTitleImage:(BOOL)hasTitleImage;

- (void)drawCommonCellWithTitle:(NSString *)title
                 subTitle:(NSString *)subTitle
                  content:(NSString *)content
     contentLineBreakMode:(NSLineBreakMode)contentLineBreakMode
               cellHeight:(CGFloat)cellHeight
                clickable:(BOOL)clickable;

- (void)drawHeaderCellWithTitle:(NSString *)title
                       subTitle:(NSString *)subTitle
                        content:(NSString *)content
                     cellHeight:(CGFloat)cellHeight;

@end
