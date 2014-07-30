//
//  ImageWallView.m
//  Project
//
//  Created by XXX on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ImageWallView.h"
#import <QuartzCore/QuartzCore.h>


enum {
    BOTTOM_POSITION,
    LEFT_POSITION,
    
};

#define TITLE_BACKGROUND_HEIGHT 46.0f

@interface ImageWallView () 

@property (nonatomic, assign) UIImageView *imageView;
@property (nonatomic, assign) NSString *url;
@property (nonatomic, assign) NSString *title;
@end

@implementation ImageWallView

@synthesize imageView = _imageView;
@synthesize imageDisplayerDelegate = _imageDisplayerDelegate;

#pragma mark - lifecycle methods

- (void)arrangeTitleAndBackgroundViewWithFrame:(CGRect)frame {
    _titleBackgroundView = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    _titleBackgroundView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.7f];
    [self addSubview:_titleBackgroundView];
    
    _titleLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                         textColor:[UIColor whiteColor]
                                       shadowColor:TRANSPARENT_COLOR] autorelease];
    _titleLabel.font = BOLD_FONT(13);
    _titleLabel.numberOfLines = 2;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleBackgroundView addSubview:_titleLabel];
}

- (void)AddTitleLabels {
    
    CGRect frame = CGRectZero;
    
    switch (_titlePosition) {
        case BOTTOM_POSITION:
            frame = CGRectMake(0, self.frame.size.height - TITLE_BACKGROUND_HEIGHT, self.frame.size.width, TITLE_BACKGROUND_HEIGHT);
            break;
            
        case LEFT_POSITION:
            frame = CGRectMake(0, self.frame.size.height-TITLE_BACKGROUND_HEIGHT,
                               self.frame.size.width,
                               TITLE_BACKGROUND_HEIGHT);
            break;
            
        default:
            break;
    }
    
    [self arrangeTitleAndBackgroundViewWithFrame:frame];
}

-(void)initWithParam:(CGRect)frame url:(NSString *)url backgroundImage:(NSString *)backgroundImageName
{
    
    if (url && url.length > 0 )
        self.localImageURL = [[[CommonMethod getLocalImageFolder] stringByAppendingString:@"/"] stringByAppendingString:[CommonMethod convertURLToLocal:url withId:@""]];
    
    self.userInteractionEnabled = YES;
    
    _imageDisplayerDelegate = self;
    
    [self drawImageView:url];

    
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImageName]];
    
//#if APP_TYPE == APP_TYPE_BASE
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"goHigh_defaultLoadingImage.png"]];
//#elif APP_TYPE == APP_TYPE_CIO
//    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cio_defaultLoadingImage.png"]];
//#endif

}

- (id)initNeedBottomTitleWithFrame:(CGRect)frame url:(NSString *)url showTitle:(BOOL)showTitle backgroundImage:(NSString *)backgroundImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titlePosition = BOTTOM_POSITION;
        [self initWithParam:frame url:url backgroundImage:backgroundImageName];
        
        if (showTitle)
            [self AddTitleLabels];
    }
    return self;
}

- (id)initNeedLeftTitleWithFrame:(CGRect)frame url:(NSString *)url showTitle:(BOOL)showTitle  backgroundImage:(NSString *)backgroundImageName;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _titlePosition = LEFT_POSITION;
        
        [self initWithParam:frame url:url backgroundImage:backgroundImageName];
        
        if (showTitle)
            [self AddTitleLabels];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame url:(NSString *)url title:(NSString *)title backgroundImage:(NSString *)backgroundImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initWithParam:frame url:url backgroundImage:backgroundImageName];
    }
    return self;
}

#pragma mark - arrange views

- (void)setTitlePositionWithLimitedWidth:(CGFloat)width {
    CGFloat titleLimitedHeight = _titleBackgroundView.frame.size.height;
    
    if (_subTitleLabel.text.length > 0) {
        _titleLabel.numberOfLines = 1;
        
        titleLimitedHeight = _titleBackgroundView.frame.size.height / 2.0f;
    }
    
    CGSize titleSize = [_titleLabel.text sizeWithFont:_titleLabel.font
                                    constrainedToSize:CGSizeMake(width, titleLimitedHeight) lineBreakMode:_titleLabel.lineBreakMode];
    
    CGFloat textHeight = titleSize.height;
    
    CGSize subTitleSize = CGSizeZero;
    if (_subTitleLabel.text.length > 0) {
        subTitleSize = [_subTitleLabel.text sizeWithFont:_subTitleLabel.font
                                       constrainedToSize:CGSizeMake(width, 15.0f)
                                           lineBreakMode:_subTitleLabel.lineBreakMode];
        textHeight += titleSize.height;
    }
    
    CGFloat titleY = (_titleBackgroundView.frame.size.height - textHeight)/2.0f;
    _titleLabel.frame = CGRectMake(/*(_titleBackgroundView.frame.size.width - titleSize.width)/2.0f*/MARGIN,
                                   titleY,
                                   titleSize.width,
                                   titleSize.height);
    
    if (_subTitleLabel.text.length > 0) {
        _subTitleLabel.frame = CGRectMake(/*_titleBackgroundView.frame.size.width - subTitleSize.width - MARGIN*/MARGIN,
                                          _titleLabel.frame.origin.y + _titleLabel.frame.size.height,
                                          subTitleSize.width,
                                          subTitleSize.height);
    }
    
}

- (void)arrangeTitleForBottomPosition {
    CGFloat width = self.frame.size.width - MARGIN * 4;
    CGFloat height = TITLE_BACKGROUND_HEIGHT - MARGIN * 2;
    CGSize size = [_titleLabel.text sizeWithFont:_titleLabel.font
                               constrainedToSize:CGSizeMake(width, height)
                                   lineBreakMode:_titleLabel.lineBreakMode];
    
    CGFloat pageControlY = TITLE_BACKGROUND_HEIGHT - MARGIN * 2 - 2.0f;
    _titleLabel.frame = CGRectMake(MARGIN,
                                   (pageControlY - size.height)/2.0f,
                                   size.width, size.height);
}

- (void)arrangeTitleForLeftPosition {
    
    //  _titleLabel.numberOfLines = 1;
    
    CGFloat titleLimitedWidth = _titleBackgroundView.frame.size.width - MARGIN * 2;
    
    [self setTitlePositionWithLimitedWidth:titleLimitedWidth];
}

- (void)arrangeTitle:(NSString *)title subTitle:(NSString *)subTitle {
    if (nil == title || title.length == 0) {
        return;
    }
    
    _titleLabel.text = title;
    
    if (subTitle.length > 0) {
        if (nil == _subTitleLabel) {
            _subTitleLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                                    textColor:TRANSPARENT_COLOR//[UIColor whiteColor]
                                                  shadowColor:TRANSPARENT_COLOR] autorelease];
            _subTitleLabel.font = BOLD_FONT(11);
            _subTitleLabel.numberOfLines = 1;
            _subTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            _subTitleLabel.textAlignment = UITextAlignmentLeft;
            
            [_titleBackgroundView addSubview:_subTitleLabel];
        }
        
        _subTitleLabel.text = subTitle;
    }
}

- (void)setLeftTitle:(NSString *)title limitedWidth:(CGFloat)limitedWidth {
    [self arrangeTitle:title subTitle:nil];
    
    [self setTitlePositionWithLimitedWidth:limitedWidth];
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    _titleLabel.text = title;
    
    switch (_titlePosition) {
        case BOTTOM_POSITION:
            [self arrangeTitleForBottomPosition];
            break;
            
        case LEFT_POSITION:
            [self arrangeTitleForLeftPosition];
            break;
            
        default:
            break;
    }
}

#pragma mark --------------

- (void)drawImageView:(NSString *)imageUrl {
    if (imageUrl && imageUrl.length > 0 ) {
        
        if ( [CommonMethod isExist:self.localImageURL]) {
//            [self fetchImage:imageUrl forceNew:NO];
            [self fetchImageFromLocal:self.localImageURL];
        }else{
            [self fetchImage:imageUrl forceNew:YES];
        }
    } else {
        self.image = nil;
    }
}


- (void)dealloc {
    
    [[WXWImageManager instance] clearCallerFromCache:self.url];
    [super dealloc];
}

- (BOOL)currentUrlMatchCell:(NSString *)url {
    return TRUE;
}

- (void)fetchImage:(NSString *)imageUrl forceNew:(BOOL)forceNew
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];
    [[WXWImageManager instance] fetchImage:imageUrl caller:self forceNew:forceNew];
}


- (void)fetchImageFromLocal:(NSString *)imageUrl
{
    [_imageDisplayerDelegate registerImageUrl:imageUrl];
    
//    CATransition *imageFadein = [CATransition animation];
//    imageFadein.duration = FADE_IN_DURATION;
//    imageFadein.type = kCATransitionFade;
//    
//    [self.layer addAnimation:imageFadein forKey:nil];
    
    self.image = [WXWCommonUtils cutCenterPartImage:[UIImage imageWithContentsOfFile:imageUrl] size:self.frame.size];
//    [[WXWImageManager instance] fetchImage:imageUrl caller:self forceNew:forceNew];
}

- (CATransition *)imageTransition {
    CATransition *imageFadein = [CATransition animation];
    imageFadein.duration = FADE_IN_DURATION;
    imageFadein.type = kCATransitionFade;
    return imageFadein;
}
#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
    }
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        
        CATransition *imageFadein = [CATransition animation];
        imageFadein.duration = FADE_IN_DURATION;
        imageFadein.type = kCATransitionFade;
        
        [self.layer addAnimation:imageFadein forKey:nil];
        
        self.image = [WXWCommonUtils cutCenterPartImage:image size:self.frame.size];
        
        [_imageDisplayerDelegate saveDisplayedImage:image];
    }
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
    if ([self currentUrlMatchCell:url]) {
        self.image = [WXWCommonUtils cutCenterPartImage:image size:self.frame.size];
    }
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
    
}


#pragma mark -- WXWImageDisplayerDelegate
- (void)saveDisplayedImage:(UIImage *)image
{
    [CommonMethod writeImage:image toFileAtPath:self.localImageURL];
}

- (void)registerImageUrl:(NSString *)url
{

}

@end
