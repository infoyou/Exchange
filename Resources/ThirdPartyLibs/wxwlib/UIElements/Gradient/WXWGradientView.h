//
//  WXWGradientView.h
//  Project
//
//  Created by XXX on 11-11-15.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWConstants.h"
#import "TextPool.h"

@interface WXWGradientView : UIView {
  
}

- (id)initWithFrame:(CGRect)frame topColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor;

- (void)drawWithTopColor:(UIColor *)topColor
             bottomColor:(UIColor *)bottomColor;
@end
