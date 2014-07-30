//
//  GHPageControl.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHPageControl : UIPageControl

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

- (void)updateDots;
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end
