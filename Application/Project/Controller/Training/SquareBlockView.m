//
//  SquareBlockView.m
//  Project
//
//  Created by Jang on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "SquareBlockView.h"
#import "WXWLabel.h"
#import "WXWCommonUtils.h"
#import "UIColor+expanded.h"
#import "CommonHeader.h"

@interface SquareBlockView() {
    
}

@property (nonatomic, retain) WXWLabel *titleLabel;
@property (nonatomic, retain) WXWLabel *courseLabel;
@property (nonatomic, retain) WXWLabel *numberLabel;

@end

@implementation SquareBlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
            viewTag:(NSInteger)vtag
    backgroundColor:(NSString *)colorString
              title:(NSString *)title
   numberLabelColor:(NSString *)labelColorString
             target:(id)target
             action:(SEL)action {
    if (self = [self initWithFrame:frame]) {
        _target = target;
        _action = action;
        _bgColor = colorString;
        _lbColor = labelColorString;
        _title = title;
        self.tag = vtag;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    self.backgroundColor = [UIColor colorWithHexString:_bgColor];
    
    CGFloat marginLeft = 16;
    CGFloat marginTop = 20;
    CGFloat marginRight = 20;
    CGFloat marginBottom = 15;
    
    _titleLabel = [[WXWLabel alloc] initWithFrame:CGRectZero textColor:[UIColor whiteColor] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(18)];
    [self addSubview:self.titleLabel];
    
    _courseLabel = [[WXWLabel alloc] initWithFrame:CGRectZero textColor:[UIColor colorWithHexString:_lbColor] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(15)];
    [self addSubview:self.courseLabel];
    
    _numberLabel = [[WXWLabel alloc] initWithFrame:CGRectZero textColor:[UIColor colorWithHexString:_lbColor] shadowColor:TRANSPARENT_COLOR font:FONT_SYSTEM_SIZE(35)];
    [self addSubview:self.numberLabel];
    
    self.titleLabel.text = _title;
    CGSize titleSize = [WXWCommonUtils sizeForText:self.titleLabel.text
                                              font:self.titleLabel.font
                                        attributes:@{NSFontAttributeName : self.titleLabel.font}];
    self.titleLabel.frame = CGRectMake(marginLeft, marginTop, titleSize.width, titleSize.height);
    
    self.courseLabel.text = @"课程";
    CGSize courseSize = [WXWCommonUtils sizeForText:self.courseLabel.text
                                               font:self.courseLabel.font
                                         attributes:@{NSFontAttributeName : self.courseLabel.font}];
    self.courseLabel.frame = CGRectMake(self.frame.size.width - marginRight - courseSize.width, self.frame.size.height - marginBottom - courseSize.height, courseSize.width, courseSize.height);
    
    self.numberLabel.text = @"0";
    CGSize numberSize = [WXWCommonUtils sizeForText:self.numberLabel.text
                                               font:self.numberLabel.font
                                         attributes:@{NSFontAttributeName : self.numberLabel.font}];
    self.numberLabel.frame = CGRectMake(self.courseLabel.frame.origin.x - numberSize.width - 2, self.frame.size.height - marginBottom - numberSize.height + 6, numberSize.width, numberSize.height);

}

- (void)updateNumber:(NSInteger)num {
    self.numberLabel.text = [NSString stringWithFormat:@"%d",num];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_target && _action) {
        [_target performSelector:_action withObject:self];
    }
}

@end
