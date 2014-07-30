//
//  EICheckBox.m
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import "QCheckBox.h"

#define Q_CHECK_ICON_WH                    (22.0)
#define Q_ICON_TITLE_MARGIN                (5.0)

#define Q_CHECK_NORMAL_IMAGE    @"checkbox1_unchecked.png"
#define Q_CHECK_SELECTED_IMAGE    @"checkbox1_checked.png"

@implementation QCheckBox

@synthesize delegate = _delegate;
@synthesize checked = _checked;
@synthesize userInfo = _userInfo;

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
        
        self.exclusiveTouch = YES;
        [self setImage:[UIImage imageNamed:Q_CHECK_NORMAL_IMAGE] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:Q_CHECK_SELECTED_IMAGE] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)updateStatus:(BOOL)enable selected:(BOOL)selected
{
    [self setEnabled:enable];
    if (selected) {
        [self setImage:[UIImage imageNamed:Q_CHECK_SELECTED_IMAGE] forState:UIControlStateNormal];
    }else{
        [self setImage:[UIImage imageNamed:Q_CHECK_NORMAL_IMAGE] forState:UIControlStateNormal];
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

- (void)dealloc {
    [_userInfo release];
    _delegate = nil;
    [super dealloc];
}

@end
