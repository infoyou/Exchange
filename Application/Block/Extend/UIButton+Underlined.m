//
//  UIButton+Underlined.m
//
//  Created by Adam on 14-3-18.
//  Copyright (c) 2014年 com.jit. All rights reserved.
//

#import "UIButton+Underlined.h"

@implementation UIButton (Underlined)

- (void)drawUnderlined {
    CGRect textRect = self.titleLabel.frame;
    
    CGFloat descender = self.titleLabel.font.descender;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGFloat y = textRect.origin.y + textRect.size.height + descender + 3;
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, y);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, y);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
