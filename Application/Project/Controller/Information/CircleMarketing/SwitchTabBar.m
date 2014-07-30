//
//  SwitchTabBar.m
//  Project
//
//  Created by Yfeng__ on 13-10-25.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "SwitchTabBar.h"
#import "CommonHeader.h"
#import "UIColor+expanded.h"

@interface SwitchTabBar() {
    UILabel *colorLabel;
    UIButton *currentButton;
    int numberOfItems;
}

@end

@implementation SwitchTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
         titleArray:(NSArray *)arr
   hasSeparatorLine:(BOOL)hasSeparatorLine
           delegate:(id)delegate
{
    self = [self initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.backgroundColor = [UIColor colorWithPatternImage:ImageWithName(@"tabBar_bg.png")];
        [self initViewsWithArray:arr hasSeparatorLine:hasSeparatorLine];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
         titleArray:(NSArray *)arr
   hasSeparatorLine:(BOOL)hasSeparatorLine {
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:ImageWithName(@"tabBar_bg.png")];
        [self initViewsWithArray:arr hasSeparatorLine:hasSeparatorLine];
    }
    return self;
}

- (void)dealloc {
    [colorLabel release];
    
    [super dealloc];
}

- (void)initViewsWithArray:(NSArray *)arr hasSeparatorLine:(BOOL)hasSeparatorLine {
    
    numberOfItems = arr.count;
    
    CGFloat buttonWidth = 0.f;
    
    if (hasSeparatorLine) {
        buttonWidth = (self.frame.size.width - numberOfItems + 1) / numberOfItems;
    }else {
        buttonWidth = self.frame.size.width / numberOfItems;
    }
    
    UIColor *selectedButtonTextColor = [UIColor colorWithHexString:@"0x666666"];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedButtonTextColor)]) {
        selectedButtonTextColor = [_delegate selectedButtonTextColor];
    }
    
    UIColor *selectedButtonBKColor = [UIColor colorWithHexString:@"0x666666"];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedButtonColor)]) {
        selectedButtonBKColor = [_delegate selectedButtonColor];
    }
    
    for (int i = 0; i < arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int dist = hasSeparatorLine ? i : 0;
        button.frame = CGRectMake(i * buttonWidth + dist, 0, buttonWidth, self.frame.size.height - 1);
        [button.titleLabel setFont:FONT_SYSTEM_SIZE(14)];
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [button setTitleColor:selectedButtonTextColor forState:UIControlStateHighlighted];
        [button setTitleColor:selectedButtonTextColor forState:UIControlStateSelected];
        //        [button setTitleColor:[UIColor colorWithHexString:@"0xe83e0b"] forState:UIControlStateSelected];
        [button setBackgroundImage:[CommonMethod createImageWithColor:selectedButtonBKColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[CommonMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
        button.adjustsImageWhenHighlighted = NO;
//        [button setBackgroundImage:[CommonMethod createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        if (hasSeparatorLine) {
            UILabel *vLine = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width, 0, 1, self.frame.size.height)];
            vLine.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:vLine];
            [vLine release];
        }
        
        if (i == 0) {
            colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 2, button.frame.size.width, 2)];
//            colorLabel.backgroundColor = [UIColor colorWithHexString:STYLE_BLUE_COLOR];
            colorLabel.backgroundColor = TRANSPARENT_COLOR;
            [self addSubview:colorLabel];
            currentButton = button;
            currentButton.selected = YES;
        }
    }
}

- (void)setButtonUnseleted:(UIButton *)sender {
    if (sender.selected) {
        sender.selected = NO;
    }
}

- (void)buttonClicked:(UIButton *)sender {
    
    if (currentButton == sender) return;
    
    sender.selected = YES;
    [self setButtonUnseleted:currentButton];
    currentButton = sender;
    
    [UIView animateWithDuration:.2
                          delay:.05
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         colorLabel.frame = CGRectMake(sender.frame.origin.x, colorLabel.frame.origin.y, colorLabel.frame.size.width, colorLabel.frame.size.height);
                         [self bringSubviewToFront:colorLabel];
                     }
                     completion:^(BOOL completion){
                         
                     }];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarSelectedAtIndex:)]) {
        [_delegate tabBarSelectedAtIndex:sender.tag];
    }
    
}

@end
