//
//  GHPageControl.m
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GHPageControl.h"

@implementation GHPageControl

@synthesize imagePageStateNormal = _imagePageStateNormal;
@synthesize imagePageStateHighlighted = _imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //        [self setNeedsDisplay];
    }
    return self;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount {
    return CGSizeMake(pageCount * 7 + 20, self.frame.size.height);
}

- (void)setImagePageStateNormal:(UIImage *)image {  // 设置正常状态点按钮的图片
    [_imagePageStateHighlighted release];
    _imagePageStateHighlighted = [image retain];
    [self updateDots];
}


- (void)setImagePageStateHighlighted:(UIImage *)image { // 设置高亮状态点按钮图片
    [_imagePageStateNormal release];
    _imagePageStateNormal = [image retain];
    [self updateDots];
}


- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event { // 点击事件
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    [self updateDots];
}

- (void)updateDots { // 更新显示所有的点按钮
    
    
    if (_imagePageStateNormal || _imagePageStateHighlighted)
    {
        NSArray *subview = self.subviews;  // 获取所有子视图
        for (NSInteger i = 0; i < [subview count]; i++)
        {
            UIImageView *dot = [subview objectAtIndex:i];  // 以下不解释, 看了基本明白
            if ([dot isKindOfClass:[UIImageView class]]) {
                
                
                dot.image = self.currentPage == i ? _imagePageStateNormal : _imagePageStateHighlighted;
                [dot sizeToFit];
            }else if ([dot isKindOfClass:[UIView class]]) {
                UIView *dotView = [subview objectAtIndex:i];
                dotView.backgroundColor = [UIColor colorWithPatternImage:self.currentPage == i ? _imagePageStateNormal : _imagePageStateHighlighted];
            }
        }
    }
}


- (void)dealloc { // 释放内存
    [_imagePageStateNormal release], _imagePageStateNormal = nil;
    [_imagePageStateHighlighted release], _imagePageStateHighlighted = nil;
    [super dealloc];
}

@end
