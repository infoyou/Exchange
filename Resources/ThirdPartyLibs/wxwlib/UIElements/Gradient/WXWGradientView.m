//
//  WXWGradientView.m
//  Project
//
//  Created by XXX on 11-11-15.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWGradientView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WXWGradientView

- (void)drawWithTopColor:(UIColor *)topColor
             bottomColor:(UIColor *)bottomColor {
  
  CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
  gradientLayer.colors = @[(id)topColor.CGColor,
                          (id)bottomColor.CGColor];
  
  NSArray *location = [[NSArray alloc] initWithObjects:@0.50f, @1.0f, nil];
  gradientLayer.locations = location;
  RELEASE_OBJ(location);
}

- (id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
  self = [super initWithFrame:frame];
  if (self) {

    [self drawWithTopColor:topColor bottomColor:bottomColor];
    
    self.backgroundColor = TRANSPARENT_COLOR;
  }
  return self;
}

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

@end
