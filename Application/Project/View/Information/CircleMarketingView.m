//
//  CircleMarketingView.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarketingView.h"
#import "UIColor+expanded.h"
#import "GlobalConstants.h"

#define IMAGEVIEW_WIDTH  146.f
#define IMAGEVIEW_HEIGHT 32.f

@implementation CircleMarketingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithHexString:@"0x747ae8"];
        
//        [self addButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action {
    self = [self initWithFrame:frame];
    if (self) {
        _target = target;
        _action = action;
        
        [self addBG];
        [self addBottomView];
    }
    return self;
}

- (void)addBG {
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
    bg.image = [UIImage imageNamed:@"circleMarketing_bg.jpg"];
    [self addSubview:bg];
    [bg release];
}

- (void)addBottomView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - IMAGEVIEW_HEIGHT, IMAGEVIEW_WIDTH, IMAGEVIEW_HEIGHT)];
    imageView.image = [UIImage imageNamed:@"information_circleMarketing_bottom_bg"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:imageView.bounds];
    
#if APP_TYPE == APP_TYPE_BASE
    titleLabel.text = @"圈层营销";
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA
    titleLabel.text = @"发现";
#elif APP_TYPE == APP_TYPE_O2O
    titleLabel.text = @"圈层营销";
#endif
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = FONT_SYSTEM_SIZE(16);
    titleLabel.backgroundColor = TRANSPARENT_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:titleLabel];
    [titleLabel release];
    
    [self addSubview:imageView];
    [imageView release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_target && _action) {
        [_target performSelector:_action];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
