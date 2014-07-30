//
//  WXWNumberBadge.m
//  wxwlib
//
//  Created by XXX on 13-1-23.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWNumberBadge.h"
#import <QuartzCore/QuartzCore.h>
#import "WXWLabel.h"

@implementation WXWNumberBadge

#pragma mark - lifecycle methods

- (void)addShadow {
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:CGRectOffset(self.bounds, 1.0f, 1.0f)];
  
  self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
  self.layer.shadowOpacity = 0.9f;
  self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
  self.layer.shadowRadius = 2.0f;
  self.layer.masksToBounds = NO;
  self.layer.shadowPath = shadowPath.CGPath;
}

- (id)initWithFrame:(CGRect)frame
    backgroundColor:(UIColor *)backgroundColor
               font:(UIFont *)font
{
  self = [super initWithFrame:frame];
  if (self) {
    
    self.backgroundColor = backgroundColor;
    
    self.layer.cornerRadius = 4.0f;

    _numberLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                          textColor:[UIColor whiteColor]
                                        shadowColor:TRANSPARENT_COLOR] autorelease];
    _numberLabel.font = font;
    _numberLabel.textAlignment = UITextAlignmentCenter;
    _numberLabel.numberOfLines = 1;
    [self addSubview:_numberLabel];
  }
  return self;
}

- (void)dealloc {
  
  [super dealloc];
}

#pragma mark - set title
- (void)setNumberWithTitle:(NSString *)title {
  _numberLabel.text = title;
  
  CGSize size = [_numberLabel.text sizeWithFont:_numberLabel.font
                              constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                  lineBreakMode:NSLineBreakByWordWrapping];
  
  CGFloat width = size.width + 6;
  if (width < MARGIN * 4) {
    width = MARGIN * 4;
  }
  
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                          width, self.frame.size.height);
  
  _numberLabel.frame = CGRectMake((self.frame.size.width - size.width)/2.0f,
                                  (self.frame.size.height - size.height)/2.0f,
                                  size.width, size.height);
  
  //[self addShadow];
}

@end
