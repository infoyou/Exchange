//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>
#import "GHImageView.h"

@class GHPageControl;
@class EScrollerView;
@protocol EScrollerViewDelegate <NSObject>

@optional
- (void)scrollView:(EScrollerView *)view clickedAtIndex:(NSInteger)index;
- (void)scrollView:(EScrollerView *)view scrollAtIndex:(NSInteger)index;

@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
	
    GHImageView *firstImageView;
    GHImageView *middleImageView;
    GHImageView *lastImageView;
    
    UIGestureRecognizer *tap;
    
    NSTimer *autoScrollTimer;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, readonly) GHPageControl *pageControl;

@property (nonatomic, retain) NSMutableArray *imageUrls;
@property (nonatomic, retain) NSMutableArray *viewsArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) CGFloat marginX;
@property (nonatomic, assign) NSTimeInterval autoScrollDelayTime;
@property (nonatomic, retain) id<EScrollerViewDelegate> delegate;

- (void)shouldAutoShow:(BOOL)shouldStart;//自动滚动，界面不在的时候请调用这个停止timer
- (void)startAutoShow;
- (void)pauseAutoShow;

@end
