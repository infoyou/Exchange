//
//  CustomTabBar.h
//  CustomTabBar
//
//  Created by XXX Boctor on 1/2/11.
//
// Copyright (c) 2011 XXX Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

@class GHCustomTabBar;
@protocol GHCustomTabBarDelegate

- (CGSize)imageSize:(GHCustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (NSString *)nameFor:(GHCustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage *)imageFor:(GHCustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage *)imageForSelected:(GHCustomTabBar *)tabBar atIndex:(NSUInteger)itemIndex;
- (UIImage *)backgroundImage:(CGRect)rect;
- (UIImage *)selectedItemBackgroundImage;
- (UIImage *)glowImage;
- (UIImage *)selectedItemImage:(int)index;
- (UIImage *)tabBarArrowImage;
- (CGSize)buttonSize;
- (int)infoCount:(int)index;

@optional
- (void)touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end

@interface GHCustomTabBar : UIView
{
    NSObject <GHCustomTabBarDelegate> *delegate;
    NSMutableArray* buttons;
    NSMutableArray* texts;
}

@property (nonatomic, retain) NSMutableArray* buttons;
@property (nonatomic, retain) NSMutableArray* texts;
@property (nonatomic, retain) UILabel *countLabel;

- (id)initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize buttonSize:(CGSize)buttonSize tag:(NSInteger)objectTag delegate:(NSObject <GHCustomTabBarDelegate>*)customTabBarDelegate;

- (void)selectItemAtIndex:(NSInteger)index;
- (void)glowItemAtIndex:(NSInteger)index;
- (void)removeGlowAtIndex:(NSInteger)index;

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
