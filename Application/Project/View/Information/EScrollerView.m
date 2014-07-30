//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
#import "GHPageControl.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "CommonHeader.h"

#define PAGECONTROL_WIDTH   320.f
#define PAGECONTROL_HEIGHT  30.f

#define MARGINY 5.f

@implementation EScrollerView
//@synthesize delegate;

- (void)dealloc {
	[_scrollView release];
	_delegate = nil;
    if (_pageControl) {
        [_pageControl release];
    }
    
    [_viewsArray release];
    [_imageUrls release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        [self addBG];
        [_scrollView addGestureRecognizer:tap];
        
        [self addSubview:_scrollView];
        
        CGFloat pageControlheight = 20.f;
        //        CGFloat pageControlWidth = 380.f;
        
        //        CGFloat startX = (self.frame.size.width - pageControlWidth)/2;
        CGFloat startY = self.frame.size.height - pageControlheight - 5;
        
        _pageControl = [[GHPageControl alloc] initWithFrame:CGRectMake(0, startY, _scrollView.frame.size.width, pageControlheight)];
        [_pageControl setCurrentPage:0];
        [_pageControl setNumberOfPages:_imageUrls.count];
        [_pageControl setBackgroundColor:[UIColor lightGrayColor]];
        if ([CommonMethod is7System]) {
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];

        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        }
        [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"information_pagecontrol_unselect"]];//灰色圆点图片
        [_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"information_pagecontrol_selected"]];//黑色圆点图片
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
//        _pageControl.layer.cornerRadius = pageControlheight / 2;
//        _pageControl.layer.masksToBounds = YES;
        
        
//        [self addSubview:_pageControl];
        
//        CGSize size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
//        CGFloat width = size.width + MARGINY * 2;
//        _pageControl.frame = CGRectMake((self.frame.size.width - width)/2.0f,
//                                        _pageControl.frame.origin.y,
//                                        width,
//                                        _pageControl.frame.size.height);
//        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addBG {
    _bgImageView = [[UIImageView alloc] initWithFrame:_scrollView.bounds];
    _bgImageView.image = [UIImage imageNamed:@"defaultLoadingImage.png"];
//    _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_bgImageView];
}

- (void)removeBG {
    [_bgImageView removeFromSuperview];
}

- (void)shouldAutoShow:(BOOL)shouldStart
{
    if (shouldStart) {
        if ([autoScrollTimer isValid]) {
            
        }
        else
            autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime target:self selector:@selector(autoShowNext) userInfo:nil repeats:YES];
    }
    else
    {
        if ([autoScrollTimer isValid]) {
            [autoScrollTimer invalidate];
            autoScrollTimer = nil;
        }
    }
}

- (void)autoShowNext
{
    if (_numberOfPages > 0) {
        if (_currentPage + 1 >= [_imageUrls count]) {
            _currentPage = 0;
        }
        else
            _currentPage++;
        
        [_scrollView setContentOffset:CGPointMake(self.bounds.size.width * 2, 0) animated:YES];
    }
    
}

- (void)initViewsArray {
    _scrollView.scrollEnabled = YES;
    [self removeBG];
    
    _viewsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _imageUrls.count; i++) {
        GHImageView *iv = [[GHImageView alloc] initWithFrame:self.bounds defaultImage:@"business_main_default_image.png"];
//        iv.contentMode = UIViewContentModeScaleAspectFit;
        [iv updateImage:_imageUrls[i]];
        [_viewsArray addObject:iv];
        [iv release];
    }
    
    [self reloadData];
}

- (void)reloadData
{
    [firstImageView removeFromSuperview];
    [middleImageView removeFromSuperview];
    [lastImageView removeFromSuperview];
    
    if (_currentPage == 0)
    {
        firstImageView = [_viewsArray lastObject];
        middleImageView = [_viewsArray objectAtIndex:_currentPage];
        lastImageView = [_viewsArray objectAtIndex:_currentPage + 1];
    }
    else if (_currentPage == [_viewsArray count] - 1)
    {
        firstImageView = [_viewsArray objectAtIndex:_currentPage - 1];
        middleImageView = [_viewsArray objectAtIndex:_currentPage];
        lastImageView = [_viewsArray objectAtIndex:0];
    }
    else
    {
        firstImageView = [_viewsArray objectAtIndex:_currentPage - 1];
        middleImageView = [_viewsArray objectAtIndex:_currentPage];
        lastImageView = [_viewsArray objectAtIndex:_currentPage + 1];
    }
    
    [_pageControl setCurrentPage:_currentPage];
    [_pageControl updateDots];
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollView:scrollAtIndex:)]) {
        [_delegate scrollView:self scrollAtIndex:_currentPage];
    }
    
    CGSize scrollSize = _scrollView.bounds.size;
    [firstImageView setFrame:CGRectMake(0, 0, scrollSize.width, scrollSize.height)];
    [middleImageView setFrame:CGRectMake(scrollSize.width, 0, scrollSize.width, scrollSize.height)];
    [lastImageView setFrame:CGRectMake(scrollSize.width * 2, 0, scrollSize.width, scrollSize.height)];
    
    
    [_scrollView addSubview:firstImageView];
    [_scrollView addSubview:middleImageView];
    [_scrollView addSubview:lastImageView];
    
    //自动timer滑行后自动替换，不再动画
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
}


- (void)changePage:(id)sender {
    
    [_pageControl updateDots];
}

#pragma mark Setter

- (void)setImageUrls:(NSMutableArray *)imageUrls
{
    if (imageUrls) {
        _pageControl.numberOfPages = [imageUrls count];
        _numberOfPages = imageUrls.count;
        _imageUrls = imageUrls;
        _currentPage = 0;
        [_pageControl setCurrentPage:_currentPage];
        [_pageControl updateDots];
    }
    [self initViewsArray];
}

- (void)startAutoShow {
    if (![autoScrollTimer isValid]) {
        autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime target:self selector:@selector(autoShowNext) userInfo:nil repeats:YES];
    }
}

- (void)pauseAutoShow {
    if ([autoScrollTimer isValid]) {
        [autoScrollTimer invalidate];
        autoScrollTimer = nil;
    }
}


#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //自动timer滑行后自动替换，不再动画
    [self reloadData];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //手动滑动自动替换，悬停timer
    [autoScrollTimer invalidate];
    autoScrollTimer = nil;
    
//    autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollDelayTime target:self selector:@selector(autoShowNext) userInfo:nil repeats:YES];
    
    int x = scrollView.contentOffset.x;
//    NSLog(@"x is %d",x);
    
    //往下翻一张
    if(x >= (2 * self.frame.size.width)) {
        if (_currentPage + 1 == [_imageUrls count]) {
            _currentPage = 0;
        }
        else
            _currentPage++;
    }
    
    //往上翻一张
    if(x <= 0) {
        if (_currentPage - 1 < 0) {
            _currentPage = [_imageUrls count] - 1;
        }
        else
            _currentPage--;
    }
    
    [self reloadData];
    
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    
    if ([_delegate respondsToSelector:@selector(scrollView:clickedAtIndex:)]) {
        [_delegate scrollView:self clickedAtIndex:_currentPage];
    }
}

@end
