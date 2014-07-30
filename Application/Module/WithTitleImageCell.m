//
//  WithTitleImageCell.m
//  Project
//
//  Created by XXX on 12-11-24.
//
//

#import "WithTitleImageCell.h"
#import "GlobalConstants.h"
#import "WXWConstants.h"

@implementation WithTitleImageCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _titleImage = [[[UIImageView alloc] init] autorelease];
    _titleImage.backgroundColor = TRANSPARENT_COLOR;
    [self.contentView addSubview:_titleImage];
  }
  return self;
}

- (void)dealloc {
  
  
  [super dealloc];
}

- (void)drawWithTitleImageCellWithTitle:(NSString *)title
                               subTitle:(NSString *)subTitle
                                content:(NSString *)content
                                  image:(UIImage *)image
                   contentLineBreakMode:(NSLineBreakMode)contentLineBreakMode
                             cellHeight:(CGFloat)cellHeight
                              clickable:(BOOL)clickable {
  
  [self drawCellWithTitle:title
                 subTitle:subTitle
                  content:content
     contentLineBreakMode:contentLineBreakMode
               cellHeight:cellHeight
                clickable:clickable
            hasTitleImage:YES];
  
  _titleImage.image = image;
  
  _titleImage.frame = CGRectMake(MARGIN * 2, MARGIN,
                                 CELL_TITLE_IMAGE_SIDE_LENGTH,
                                 CELL_TITLE_IMAGE_SIDE_LENGTH);
}

@end
