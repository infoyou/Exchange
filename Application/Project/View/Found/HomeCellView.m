//
//  HomeCellView.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "HomeCellView.h"
#import "UIColor+expanded.h"
#import "GlobalConstants.h"
#import "InsertLabel.h"
#import "GlobalConstants.h"

@implementation HomeCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action backColor:(NSString*)backColor logoFrame:(CGRect)logoFrame logoImg:(NSString*)logoImg labelFrame:(CGRect)labelFrame labelEdge:(UIEdgeInsets)labelEdge labelText:(NSString*)labelText labelColor:(NSString*)labelColor
{
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:backColor];
        
        _target = target;
        _action = action;
        
        // logo image
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:logoFrame] autorelease];
        imageView.image = [UIImage imageNamed:logoImg];
        [self addSubview:imageView];
        
        // title lable
         InsertLabel *titleLabel = [[InsertLabel alloc] initWithFrame:labelFrame andInsets:labelEdge];
        titleLabel.text = labelText;
        titleLabel.textColor = [UIColor colorWithHexString:labelColor];
        titleLabel.font = FONT_SYSTEM_SIZE(16);
        titleLabel.backgroundColor = TRANSPARENT_COLOR;
        [self addSubview:titleLabel];
        [titleLabel release];
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_target && _action) {
        [_target performSelector:_action];
    }
}

@end
