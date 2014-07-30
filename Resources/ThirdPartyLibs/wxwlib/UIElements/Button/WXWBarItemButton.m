//
//  WXWBarItemButton.m
//  wxwlib
//
//  Created by XXX on 13-1-30.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWBarItemButton.h"
#import "WXWUIUtils.h"
#import "WXWCommonUtils.h"

@interface WXWBarItemButton()
@property (nonatomic, copy) NSString *title;
@end

@implementation WXWBarItemButton


- (id)initBackStyleButtonWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _forBackStyle = YES;
        
        self.showsTouchWhenHighlighted = NO;
        
        [self setImage:[UIImage imageNamed:@"but_back.png"] forState:UIControlStateNormal];
        
        self.imageEdgeInsets = UIEdgeInsetsMake(10,10,10,25);
    }
    
    return self;
}

- (void)setBasicPropertiesWithTitle:(NSString *)title
                             target:(id)target
                             action:(SEL)action {
    _forBackStyle = NO;
    
    self.showsTouchWhenHighlighted = YES;
    
    self.title = title;
    
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.font = BOLD_FONT(13);
    
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [self setTitleColor:[UIColor blackColor]
               forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor colorWithHue:0
                                   saturation:0
                                   brightness:0.5f
                                        alpha:1.0f]
               forState:UIControlStateHighlighted];
    
    
    CGSize size = [title sizeWithFont:self.titleLabel.font];
    
    self.frame = CGRectMake(0, 0, size.width + MARGIN * 4, self.frame.size.height);
    
    [self setTitle:title forState:UIControlStateNormal];
    
    if (_onRight) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, MARGIN * 2, 0, 0);
    } else {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, MARGIN * 2);
    }
}

- (id)initRightButtonWithFrame:(CGRect)frame
                         title:(NSString *)title
                        target:(id)target
                        action:(SEL)action {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _onRight = YES;
        
        [self setBasicPropertiesWithTitle:title target:target action:action];
        
    }
    
    return self;
}

- (id)initLeftButtonWithFrame:(CGRect)frame
                        title:(NSString *)title
                       target:(id)target
                       action:(SEL)action {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _onRight = NO;
        
        [self setBasicPropertiesWithTitle:title target:target action:action];
        
    }
    
    return self;
}

- (void)dealloc {
    
    self.title = nil;
    
    [super dealloc];
}

/*
 - (void)drawRect:(CGRect)rect {
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 CGFloat x = 0;
 
 if (_forBackStyle) {
 
 x = self.frame.size.width - 2.0f;
 
 } else {
 if (_onRight) {
 x = 0.0f;
 } else {
 x = self.frame.size.width - 2.0f;
 }
 }
 
 [WXWUIUtils draw1PxStroke:context
 startPoint:CGPointMake(x, 0)
 endPoint:CGPointMake(x, self.frame.size.height)
 color:COLOR(125, 28, 27).CGColor
 shadowOffset:CGSizeMake(1.0f, 0.0f)
 shadowColor:COLOR(187, 60, 64)];
 }
 */

@end
