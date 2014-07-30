//
//  ColofulNavigationBar.m
//  Product
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "ColofulNavigationBar.h"
#import "WXWConstants.h"

@interface ColofulNavigationBar ()
@property (nonatomic, retain) UIColor *barColor;
@property (nonatomic, retain) UIImage *barImage;
@end

@implementation ColofulNavigationBar

- (void)dealloc {
  
  self.barColor = nil;
    self.barImage = nil;
  
  [super dealloc];
}

- (void)changeBarImage:(UIImage *)barImage
{
    self.barImage = barImage;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.barImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}


@end
