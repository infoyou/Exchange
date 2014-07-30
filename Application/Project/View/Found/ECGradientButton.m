//
//  ECGradientButton.m
//  Project
//
//  Created by XXX on 11-11-8.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "ECGradientButton.h"
#import <QuartzCore/QuartzCore.h>

#define BORDER_CORNER_RDU       4.0f
#define OVAL_CORNER_RDU         9.0f
#define INNER_AREA_CORNER_RDU   0.0f // because the rendering corner radius of inner area inconsistence with border corner radius, we make the inner area full, then the corner will be full with corresponding color
#define BORDER_WIDTH            1.0f

@implementation ECGradientButton

#pragma mark - lifecycle methods
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
    titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert {
  
  self = [super init];
  if (self) {
    self.frame = frame;
    
    _colorType = colorType;
    
    [self addTarget:target
             action:action
   forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor = TRANSPARENT_COLOR;
    
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = titleFont;
    
    if (titleColor) {
      self.titleLabel.textColor = titleColor;
    }
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (image) {
      self.titleEdgeInsets = titleEdgeInsert;
      
      [self setImage:image forState:UIControlStateNormal];
      self.imageEdgeInsets = imageEdgeInsert;
    }
    
    
    _hideBorder = YES;
    if (!_hideBorder) {
      self.layer.borderWidth = BORDER_WIDTH;
      self.layer.masksToBounds = YES;
    } else {
      self.layer.borderWidth = 0.0f;
      self.layer.masksToBounds = NO;
    }
    
    switch (roundedType) {
      case HAS_ROUNDED:
        self.layer.cornerRadius = BORDER_CORNER_RDU;
        break;
        
      case OVAL_ROUNDED:
        self.layer.cornerRadius = OVAL_CORNER_RDU;
        break;
      default:
        break;
    }
  }
  return self;
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
    titleEdgeInsert:(UIEdgeInsets)titleEdgeInsert
         hideBorder:(BOOL)hideBorder {
  
  _hideBorder = hideBorder;
  
  self = [self initWithFrame:frame
                      target:target
                      action:action
                   colorType:colorType
                       title:title
                       image:image
                  titleColor:titleColor
            titleShadowColor:titleShadowColor
                   titleFont:titleFont
                 roundedType:roundedType
             imageEdgeInsert:imageEdgeInsert
             titleEdgeInsert:titleEdgeInsert];
  if (self) {
    
  }
  return self;
}

- (void)dealloc {
  
  [super dealloc];
}

- (void) drawLinearGradient:(CGContextRef)context
                       rect:(CGRect)rect
                 startColor:(CGColorRef)startColor
                   endColor:(CGColorRef)endColor {
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = { 0.0, 1.0 };
  
  NSArray *colors = @[(id)startColor, (id)endColor];
  
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextSaveGState(context);
  CGContextAddRect(context, rect);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGColorSpaceRelease(colorSpace);
  CGGradientRelease(gradient);
}

- (void) drawGlossAndGradient:(CGContextRef)context
                         rect:(CGRect)rect
                   startColor:(CGColorRef)startColor
                     endColor:(CGColorRef)endColor {
  
  [self drawLinearGradient:context
                      rect:rect
                startColor:startColor
                  endColor:endColor];
  
  /*
  CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
  CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
  
  CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
  
  [self drawLinearGradient:context
                      rect:topHalf
                startColor:glossColor1
                  endColor:glossColor2];
   */
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat outerMargin = 0.0f;
  CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
  
  CGColorRef topColorRef;
  CGColorRef bottomColorRef;
  CGFloat actualBrightness = 1.0f;
  switch (_colorType) {
      
    case TRANSPARENT_BTN_COLOR_TY:
    {
      
      topColorRef = [UIColor clearColor].CGColor;
      bottomColorRef = [UIColor clearColor].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
      }
    }
      break;
      
    case RED_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      
      topColorRef = COLOR_HSB(0, 74, 87, actualBrightness).CGColor;//COLOR_HSB(360.0f, 100.0f, 78.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0, 74, 87, actualBrightness).CGColor;//COLOR_HSB(359.0f, 77.0f, 47.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = ORANGE_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 0.742f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = [UIColor colorWithHue:1 saturation:0 brightness:1.0*actualBrightness alpha:1.0].CGColor;
      bottomColorRef = [UIColor colorWithHue:1 saturation:0 brightness:1.0*actualBrightness alpha:1.0].CGColor;//[UIColor colorWithHue:0.8 saturation:0 brightness:0.8*actualBrightness alpha:1.0].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case LIGHT_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = [UIColor colorWithHue:0.667f saturation:0 brightness:0.731*actualBrightness alpha:1.0].CGColor;//[UIColor colorWithHue:1 saturation:0 brightness:0.92*actualBrightness alpha:1.0].CGColor;
      bottomColorRef = [UIColor colorWithHue:0.667f saturation:0 brightness:0.731*actualBrightness alpha:1.0].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = LIGHT_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case TINY_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0.0f, 0.0f, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 100.0f, actualBrightness).CGColor;//COLOR_HSB(0.0f, 0.0f, 79.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = LIGHT_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case DEEP_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0.0f, 0.0f, 79.0f, actualBrightness).CGColor;//COLOR_HSB(0.0f, 0.0f, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 79.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = DEEP_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case BLUE_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(216, 66, 48, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(216, 66, 48, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = BLUE_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case WHITE_BTN_COLOR_TY:
    {
      
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0, 0, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0, 0, 100.0f, actualBrightness).CGColor;//COLOR_HSB(231.0f, 3.0f, 94.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = COLOR(214, 214, 214).CGColor;
      }
      
      break;
    }
      
    case BLACK_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0.0f, 0.0f, 1.0f, actualBrightness).CGColor;//COLOR_HSB(206.0f, 12.0f, 24.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 1.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = BLACK_BTN_BORDER_COLOR.CGColor;
      }
      break;
    }
      
    default:
      topColorRef = [UIColor whiteColor].CGColor;
      bottomColorRef = [UIColor whiteColor].CGColor;
      break;
  }
  
  [self drawGlossAndGradient:context rect:outerRect startColor:topColorRef endColor:bottomColorRef];
  
}

/*
- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGFloat outerMargin = 0.0f;
  if (!_hideBorder) {
    outerMargin = 1.0f;
  }
  CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);
  
  CGMutablePathRef path = CGPathCreateMutable();
  if (!_hideBorder) {
    
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(outerRect), CGRectGetMinY(outerRect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), INNER_AREA_CORNER_RDU);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), INNER_AREA_CORNER_RDU);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(outerRect), CGRectGetMaxY(outerRect), CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), INNER_AREA_CORNER_RDU);
    
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(outerRect), CGRectGetMinY(outerRect), CGRectGetMaxX(outerRect), CGRectGetMinY(outerRect), INNER_AREA_CORNER_RDU);
    
    CGPathCloseSubpath(path);
  }
  
  CGMutablePathRef outerPath = path;
  
  CGColorRef topColorRef;
  CGColorRef bottomColorRef;
  CGFloat actualBrightness = 1.0f;
  switch (_colorType) {
      
    case TRANSPARENT_BTN_COLOR_TY:
    {
      
      topColorRef = [UIColor clearColor].CGColor;
      bottomColorRef = [UIColor clearColor].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = [UIColor clearColor].CGColor;
      }
    }
      break;
      
    case RED_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      
      topColorRef = COLOR_HSB(0, 74, 87, actualBrightness).CGColor;//COLOR_HSB(360.0f, 100.0f, 78.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0, 74, 87, actualBrightness).CGColor;//COLOR_HSB(359.0f, 77.0f, 47.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = ORANGE_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 0.742f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = [UIColor colorWithHue:1 saturation:0 brightness:1.0*actualBrightness alpha:1.0].CGColor;
      bottomColorRef = [UIColor colorWithHue:0.8 saturation:0 brightness:0.8*actualBrightness alpha:1.0].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case LIGHT_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = [UIColor colorWithHue:1 saturation:0 brightness:0.92*actualBrightness alpha:1.0].CGColor;
      bottomColorRef = [UIColor colorWithHue:0.667f saturation:0 brightness:0.731*actualBrightness alpha:1.0].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = LIGHT_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case TINY_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0.0f, 0.0f, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 79.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = LIGHT_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case DEEP_GRAY_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0.0f, 0.0f, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 79.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = DEEP_GRAY_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case BLUE_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = [UIColor colorWithHue:0.55f saturation:0.34f brightness:0.90*actualBrightness alpha:1.0].CGColor;
      bottomColorRef = [UIColor colorWithHue:0.58f saturation:0.59f brightness:0.81*actualBrightness alpha:1.0].CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = BLUE_BTN_BORDER_COLOR.CGColor;
      }
      
      break;
    }
      
    case WHITE_BTN_COLOR_TY:
    {
      
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(0, 0, 100.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(231.0f, 3.0f, 94.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = COLOR(214, 214, 214).CGColor;
      }
      
      break;
    }
      
    case BLACK_BTN_COLOR_TY:
    {
      actualBrightness = 1.0f;
      if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.20;
      }
      topColorRef = COLOR_HSB(206.0f, 12.0f, 24.0f, actualBrightness).CGColor;
      bottomColorRef = COLOR_HSB(0.0f, 0.0f, 1.0f, actualBrightness).CGColor;
      if (!_hideBorder) {
        self.layer.borderColor = BLACK_BTN_BORDER_COLOR.CGColor;
      }
      break;
    }
      
    default:
      topColorRef = [UIColor whiteColor].CGColor;
      bottomColorRef = [UIColor whiteColor].CGColor;
      break;
  }
  
  // Draw shadow
  if (self.state != UIControlStateHighlighted) {
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, topColorRef);
    CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, COLOR_ALPHA(51, 51, 52, 0.5).CGColor);
    CGContextAddPath(context, outerPath);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
  }
  
  // Draw gradient for outer path
  CGContextSaveGState(context);
  
  if (!_hideBorder) {
    CGContextAddPath(context, outerPath);
    CGContextClip(context);
  }
  [self drawGlossAndGradient:context rect:outerRect startColor:topColorRef endColor:bottomColorRef];
  CGContextRestoreGState(context);
  
  CFRelease(outerPath);
}
*/
 
#pragma mark - change color type
- (void)changeToColor:(ButtonColorType)coloType {
  _colorType = coloType;
  [self setNeedsDisplay];
}

#pragma mark - override touch methods to show highlight

- (void)hesitateUpdate
{
  [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesMoved:touches withEvent:event];
  [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  [self setNeedsDisplay];
  [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.2];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  [self setNeedsDisplay];
  [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.2];
}


@end
