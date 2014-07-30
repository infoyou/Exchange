//
//  ECGradientButton.h
//  Project
//
//  Created by XXX on 11-11-8.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalConstants.h"

@interface ECGradientButton : UIButton {
@private
  ButtonColorType _colorType;
  BOOL _hideBorder;
}

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action
          colorType:(ButtonColorType)colorType 
              title:(NSString *)title 
              image:(UIImage *)image 
         titleColor:(UIColor *)titleColor
   titleShadowColor:(UIColor *)titleShadowColor
          titleFont:(UIFont *)titleFont 
        roundedType:(ButtonRoundedType)roundedType
    imageEdgeInsert:(UIEdgeInsets)imageEdgeInsert 
    titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert;

- (id)initWithFrame:(CGRect)frame
             target:(id)target
             action:(SEL)action
          colorType:(ButtonColorType)colorType 
              title:(NSString *)title 
              image:(UIImage *)image 
         titleColor:(UIColor *)titleColor
   titleShadowColor:(UIColor *)titleShadowColor
          titleFont:(UIFont *)titleFont 
        roundedType:(ButtonRoundedType)roundedType
    imageEdgeInsert:(UIEdgeInsets)imageEdgeInsert 
    titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert
         hideBorder:(BOOL)hideBorder;

#pragma mark - change color type 
- (void)changeToColor:(ButtonColorType)coloType;


@end
