//
//  AuthorCellBackgroundView.m
//  Project
//
//  Created by XXX on 13-6-4.
//
//

#import "AuthorCellBackgroundView.h"
#import "WXWUIUtils.h"
#import "GlobalConstants.h"

@implementation AuthorCellBackgroundView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  [WXWUIUtils draw1PxStroke:ctx
                 startPoint:CGPointMake(0, 0)
                   endPoint:CGPointMake(self.frame.size.width, 0)
                      color:SEPARATOR_LINE_COLOR.CGColor
               shadowOffset:CGSizeZero
                shadowColor:TRANSPARENT_COLOR];
  
  [WXWUIUtils draw1PxStroke:ctx
                 startPoint:CGPointMake(0, self.frame.size.height - 1)
                   endPoint:CGPointMake(self.frame.size.width, self.frame.size.height - 1)
                      color:SEPARATOR_LINE_COLOR.CGColor
               shadowOffset:CGSizeZero
                shadowColor:TRANSPARENT_COLOR];

}


@end
