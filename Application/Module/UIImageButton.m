//
//  UIImageButton.m
//  Project
//
//  Created by XXX on 12-9-13.
//
//

#import "UIImageButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImageButton

- (void)setButtonPropertiesWithFrame:(CGRect)frame
                               title:(NSString *)title
                           image:(UIImage*)image
                     backImgName:(NSString*)backImgName
                  selBackImgName:(NSString*)selBackImgName
                      titleColor:(UIColor *)titleColor
                titleShadowColor:(UIColor *)titleShadowColor
                 imageEdgeInsert:(UIEdgeInsets)imageEdgeInsert
                 titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert {
  
  UIImage *btnImg = [UIImage imageNamed:backImgName];
  UIImage *btnSelectImg = [UIImage imageNamed:selBackImgName];
  
  UIImageView *btnView = [[[UIImageView alloc] initWithImage:[btnImg stretchableImageWithLeftCapWidth:4 topCapHeight:10]] autorelease];
  btnView.frame = frame;
  
  UIImageView *btnSelectView = [[[UIImageView alloc] initWithImage:[btnSelectImg stretchableImageWithLeftCapWidth:4 topCapHeight:10]] autorelease];
  btnSelectView.frame = frame;
  
  
  [self setTitle:title forState:UIControlStateNormal];
  [self setTitleColor:titleColor forState:UIControlStateNormal];
  [self setTitleShadowColor:titleShadowColor forState:UIControlStateNormal];
  self.titleLabel.highlightedTextColor = [UIColor whiteColor];
  
  self.titleEdgeInsets = titleEdgeInsert;
    
  if (image) {
    [self setImage:nil forState:UIControlStateNormal];
    
    [self setImage:image forState:UIControlStateNormal];
    self.imageEdgeInsets = imageEdgeInsert;
  }
  
  [self setBackgroundImage:btnView.image forState:UIControlStateNormal];
  [self setBackgroundImage:btnSelectView.image forState:UIControlStateHighlighted];
  
}

- (id)initImageButtonWithFrame:(CGRect)frame
                        target:(id)target
                        action:(SEL)action
                         title:(NSString *)title
                         image:(UIImage*)image
                    backImgName:(NSString*)backImgName
                selBackImgName:(NSString*)selBackImgName
                     titleFont:(UIFont *)titleFont
                    titleColor:(UIColor *)titleColor
              titleShadowColor:(UIColor *)titleShadowColor
                   roundedType:(ButtonRoundedType)roundedType
               imageEdgeInsert:(UIEdgeInsets)imageEdgeInsert
               titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
      
      [self setButtonPropertiesWithFrame:frame
                                   title:title
                                   image:image
                             backImgName:backImgName
                          selBackImgName:selBackImgName
                              titleColor:titleColor
                        titleShadowColor:titleShadowColor
                         imageEdgeInsert:imageEdgeInsert
                         titleEdgeInsert:titleEdgeInsert];
      
      
      self.titleLabel.font = titleFont;
      
      [self addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
      
      switch (roundedType) {
        case HAS_ROUNDED:
          self.layer.cornerRadius = 6.0f;
          break;
          
        case NO_ROUNDED:
          self.layer.cornerRadius = 0.0f;
          break;
          
        default:
          break;
      }

    }
    
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}


@end
