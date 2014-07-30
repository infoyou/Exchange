//
//  ImageWallScrollView.m
//  Project
//
//  Created by XXX on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ImageWallScrollView.h"

#define MAX_SHOW_SIZE   18

@interface ImageWallScrollView ()

@property (nonatomic, retain) NSArray *imageListArray;
@property (nonatomic, assign) NSInteger imageSize;
@end

@implementation ImageWallScrollView {
    
    NSString *_backgroundImageName;
}

@synthesize scrollView = _scrollView;
@synthesize  ltype = _ltype;
@synthesize pageControl = _pageControl;


#pragma mark - current image
- (NSInteger)currentImageId {
    if (_ltype == Lists_Type_Image) {
        return ((ImageList *)self.imageListArray[_currentPageIndex]).imageID.intValue;
    }else if (_ltype == Lists_Type_Book) {
        return ((BookImageList *)self.imageListArray[_currentPageIndex]).bookID.intValue;
    }else if (_ltype == Lists_Type_Event) {
        
    }
    return 0;
}

- (NSInteger)targetID {
    //    return [((ImageList *)self.allImages[_currentPageIndex]).imageID integerValue];
    if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] lastObject] integerValue];
    }else if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] lastObject] integerValue];
    }
    return 0;
}

- (NSInteger)subModule {
    if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
    }else if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] objectAtIndex:1] integerValue];
    }
    return 0;
}

- (NSInteger)rootModule {
    
    if (_ltype == Lists_Type_Book) {
        return [[[((BookImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
    }else if (_ltype == Lists_Type_Image) {
        return [[[((ImageList *)_imageListArray[_currentPageIndex]).target componentsSeparatedByString:@"/"] objectAtIndex:0] integerValue];
    }
    return 0;
}

//------------------custom init-------------

- (id)initWithFrame:(CGRect)frame backgroundImage:(NSString *)backgroundImageName
{
    if (self = [self initWithFrame:frame]) {
        _backgroundImageName = backgroundImageName;
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //#if APP_TYPE == APP_TYPE_BASE
        //        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"goHigh_defaultLoadingImage.png"]];
        //#elif APP_TYPE == APP_TYPE_CIO
        //        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cio_defaultLoadingImage.png"]];
        //#endif
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
    [_pageControl release];
    [_scrollView release];
    [_views release];
}

-(void)initControl:(CGRect)rect count:(int)count
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = DEFAULT_VIEW_COLOR;
    
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [_scrollView setContentSize:CGSizeMake(count*rect.size.width, rect.size.height)];
    
    UITapGestureRecognizer *singleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(clickImage:)] autorelease];
    [_scrollView addGestureRecognizer:singleTap];
    
    [self addSubview:_scrollView];
    
    //-------
    int pageControlHeight = 20;
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, rect.size.height - pageControlHeight ,rect.size.width, pageControlHeight)];
    [_pageControl setCurrentPage:0];
    [_pageControl setNumberOfPages:count];
    [_pageControl setBackgroundColor:TRANSPARENT_COLOR];
    [_pageControl setHidesForSinglePage:YES];
    if ([CommonMethod is7System]) {
        [_pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor darkGrayColor]];
    }
    
    [self addSubview:_pageControl];
}

- (void)addPageControl {
    _pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - MARGIN * 2 - 2.0f, self.frame.size.width, MARGIN * 2)] autorelease];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.hidesForSinglePage = YES;
    [_pageControl setCurrentSelectedPage:0];
    _pageControl.backgroundColor = TRANSPARENT_COLOR;
    [self addSubview:_pageControl];
}

-(void)updateImageListArray:(NSArray *)imageListArray
{
    if (!self.imageListArray.count) {
        
        self.imageListArray = imageListArray;
        
        self.imageSize = imageListArray.count;
        if (imageListArray.count > MAX_SHOW_SIZE) {
            self.imageSize = MAX_SHOW_SIZE;
        }
        //    CGRect rect = self.frame;
        [self initControl:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) count:self.imageSize];
        
        [self addImageView:imageListArray rect:self.frame];
    }
}

-(void)subThreadMethod:(id)object
{
    
}

- (void)addImageView:(NSArray *)imageListArray rect:(CGRect)rect {
    
    _views = [[NSMutableArray alloc] init];
    [self.views removeAllObjects];
    
    for (int i  = 0; i < self.imageSize; i++) {
        id imageClass = [imageListArray objectAtIndex:i];
        
        if ([imageClass isKindOfClass:[ImageList class]]) {
            
            ImageList *imageList = (ImageList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.imageURL showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.title]
                      subTitle:nil];
            _ltype = Lists_Type_Image;
            
            [_scrollView addSubview:wallView];
            
            [self.views addObject:wallView];
            
            [wallView release];
            
        } else if ([imageClass isKindOfClass:[BusinessImageList class]]) {
            
            BusinessImageList *imageList = (BusinessImageList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.imageURL title:imageList.title backgroundImage:_backgroundImageName];
            [_scrollView addSubview:wallView];
            DLog(@"%@",imageList.imageURL);
            //            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Business;
        }else if ([imageClass isKindOfClass:[BookImageList class]]){
            BookImageList *imageList = (BookImageList *)imageClass;
            DLog(@"bookimagelist: target:%@",imageList.target);
            //            ImageWallView *wallView = [[[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage title:imageList.title] autorelease];
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.bookTitle]
                      subTitle:nil];
            
            [_scrollView addSubview:wallView];
            
            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Book;
        }else if ([imageClass isKindOfClass:[BookList class]]){
            BookList *imageList = (BookList *)imageClass;
            
            //            ImageWallView *wallView = [[[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage title:imageList.title] autorelease];
            
            ImageWallView *wallView = [[ImageWallView alloc] initNeedBottomTitleWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.bookImage showTitle:YES backgroundImage:_backgroundImageName];
            [wallView setTitle:[NSString stringWithFormat:@"%@", imageList.bookTitle]
                      subTitle:nil];
            
            [_scrollView addSubview:wallView];
            
            [self.views addObject:wallView];
            
            [wallView release];
            
            _ltype = Lists_Type_Book;
        }else if ([imageClass isKindOfClass:[EventImageDetailList class]]) {
            
            EventImageDetailList *imageList = (EventImageDetailList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.imageUrl title:@"xx" backgroundImage:_backgroundImageName];
            [_scrollView addSubview:wallView];
            //            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            [self.views addObject:wallView];
            
            [wallView release];
            _ltype = Lists_Type_Event;
        }else if ([imageClass isKindOfClass:[EventImageList class]]) {
            
            EventImageList *imageList = (EventImageList *)imageClass;
            
            ImageWallView *wallView = [[ImageWallView alloc] initWithFrame:CGRectMake(i*rect.size.width, 0, rect.size.width, rect.size.height) url:imageList.imageUrl title:@"xx" backgroundImage:_backgroundImageName];
            [_scrollView addSubview:wallView];
            //            [wallView setupImageViewerWithImageURL:[NSURL URLWithString:[imageList.imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            
            [self.views addObject:wallView];
            
            [wallView release];
            _ltype = Lists_Type_Event;
        }
    }
}

#pragma mark - gesture method

- (void)clickImage:(UIGestureRecognizer *)gesture {
    if (_delegate && [_delegate respondsToSelector:@selector(clickedImageWithImage:)]) {
        [_delegate clickedImageWithImage:self.views[_currentPageIndex]];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickedImage)]) {
        [_delegate clickedImage];
    }
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    [_pageControl setCurrentSelectedPage:floorf(scrollView.contentOffset.x / self.frame.size.width)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    _currentPageIndex = floorf(scrollView.contentOffset.x / self.frame.size.width);
    
    [_pageControl setCurrentSelectedPage:_currentPageIndex];
}

@end
