//
//  ECImageBrowseViewController.m
//  Project
//
//  Created by XXX on 11-11-21.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "ECImageBrowseViewController.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "UIUtils.h"
#import "AppManager.h"
#import "WXWLabel.h"

enum {
	DIFF_ORI,
	LANDSCAPE_ORI,
	PORTRAIT_ORI,
};

#define MAX_ZOOM_LEVEL		4.0f

#define PORTRAIT_WIDTH		320.0f
#define PORTRAIT_HEIGHT		460.0f

#define LANDSCAPE_WIDTH		480.0f
#define LANDSCAPE_HEIGHT	320.0f

#define LANDSCAPE_IMG_X(imgWitdh)	(LANDSCAPE_WIDTH - imgWitdh)/2
#define LANDSCAPE_IMG_Y(imgHeight)	(LANDSCAPE_HEIGHT - imgHeight)/2

#define PORTRAIT_IMG_X(imgWitdh)	(PORTRAIT_WIDTH - imgWitdh)/2
#define PORTRAIT_IMG_Y(imgHeight)	(PORTRAIT_HEIGHT - imgWitdh)/2

#define WIDTH						self.view.bounds.size.width
#define HEIGHT						self.view.bounds.size.height

#define LANDSCAPE_W_H_RATIO	(480/HEIGHT)
#define PORTRAIT_W_H_RATIO	(320/HEIGHT)

#define IMAGE_IS_LANDSCAPE			[self imageOrientationIsLandscape]

@interface ECImageBrowseViewController()

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UITapGestureRecognizer *oneTapRecoginzer;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imageCaption;
@property (nonatomic, retain) WXWLabel *captionLabel;

- (BOOL)imageIsBigWithDifferentOrientation:(float)width height:(float)height;
- (BOOL)imageIsBigWithSameOrientation:(NSInteger)orientation width:(float)width height:(float)height;
- (void)setImageToView;
- (void)fetchImage:(NSString *)imageUrl forceNew:(BOOL)forceNew;
@end

@implementation ECImageBrowseViewController

@synthesize image = _image;
@synthesize oneTapRecoginzer = _oneTapRecoginzer;
@synthesize imageUrl = _imageUrl;
@synthesize imageCaption = _imageCaption;
@synthesize captionLabel = _captionLabel;

#pragma mark - set view layout
- (void)setImgViewZoonScale
{
  CGSize screenSize = self.view.bounds.size;
	
	CGFloat widthRatio = screenSize.width/self.image.size.width;
	CGFloat heightRatio = screenSize.height/self.image.size.height;
	
	initialZoom = (widthRatio > heightRatio) ? heightRatio : widthRatio;
	imgScrollView.minimumZoomScale = initialZoom;
	imgScrollView.zoomScale = initialZoom;
  imgScrollView.maximumZoomScale = MAX_ZOOM_LEVEL;
}

- (void)initScrollView {
	imgScrollView = [[UIScrollView alloc] init];
	
  imgScrollView.frame = CGRectMake(0, 0, [CommonUtils screenWidth], [CommonUtils screenHeight]);
	
	[self setImgViewZoonScale];
	
	[imgScrollView addSubview:imageView];
	imgScrollView.backgroundColor = [UIColor blackColor];
	imgScrollView.showsVerticalScrollIndicator = NO;
	imgScrollView.showsHorizontalScrollIndicator = NO;
	imgScrollView.canCancelContentTouches = NO;
	
	imgScrollView.bouncesZoom = YES;
	imgScrollView.clipsToBounds = YES;
	imgScrollView.delegate = self;
	
	imgScrollView.contentMode = UIViewContentModeCenter;
	
	[self.view addSubview:imgScrollView];
}

- (void)initCaptionLabeIfNecessary {
  if (self.imageCaption && self.imageCaption.length > 0) {
    self.captionLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                               textColor:[UIColor whiteColor]
                                             shadowColor:TRANSPARENT_COLOR] autorelease];
    self.captionLabel.font = BOLD_FONT(13);
    self.captionLabel.numberOfLines = 0;
    
    self.captionLabel.text = self.imageCaption;
    CGSize size = [self.captionLabel.text sizeWithFont:self.captionLabel.font
                                     constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX)
                                         lineBreakMode:NSLineBreakByWordWrapping];
    self.captionLabel.frame = CGRectMake((self.view.frame.size.width - size.width)/2.0f,
                                         (self.view.frame.size.height - MARGIN * 2 - size.height),
                                         size.width, size.height);
    [self.view addSubview:self.captionLabel];
    
    [self.view bringSubviewToFront:self.captionLabel];
  }
}

#pragma mark - arrange the view location

- (BOOL)imageOrientationIsLandscape {
	return self.image.size.width > self.image.size.height;
}

- (NSInteger)currentSameOrientation {
  
	if ([CommonUtils currentOrientationIsLandscape] && IMAGE_IS_LANDSCAPE) {
		return LANDSCAPE_ORI;
	}
	
	if (![CommonUtils currentOrientationIsLandscape] && !IMAGE_IS_LANDSCAPE) {
		return PORTRAIT_ORI;
	}
	
	return DIFF_ORI;
}

- (void)arrangeCaptionLabelIfNecessary {
  if (self.captionLabel) {
    CGSize size = [self.captionLabel.text sizeWithFont:self.captionLabel.font
                                     constrainedToSize:CGSizeMake(300.0f, CGFLOAT_MAX)
                                         lineBreakMode:NSLineBreakByWordWrapping];
    self.captionLabel.frame = CGRectMake((self.view.frame.size.width - size.width)/2.0f,
                                         (self.view.frame.size.height - MARGIN * 2 - size.height),
                                         size.width, size.height);
  }
}

- (void)arrangeImageView {
  
  [self setImgViewZoonScale];
	
	float width = 0;
	float height = 0;
	float x = 0;
	float y = 0;
	
	NSInteger currentSameOrientation = [self currentSameOrientation];
	
	BOOL isBigImage = NO;
  
	if (currentSameOrientation == DIFF_ORI) {
		isBigImage = [self imageIsBigWithDifferentOrientation:self.image.size.width height:self.image.size.height];
	} else {
		isBigImage = [self imageIsBigWithSameOrientation:currentSameOrientation width:self.image.size.width height:self.image.size.height];
	}
  
	switch (currentSameOrientation) {
		case LANDSCAPE_ORI:
		{
			// both device and image are landscape orientation
			if (isBigImage) {
				if (self.image.size.width/self.image.size.height > LANDSCAPE_W_H_RATIO) {
					// means the width is the base, height should be calculated according to the ratio
					width = WIDTH;
					height = (self.image.size.height/self.image.size.width)*width;
					x = 0;
					y = (HEIGHT - height) / 2;
				} else if (self.image.size.width/self.image.size.height < LANDSCAPE_W_H_RATIO) {
					// means the height is the base, width should be calculated according to the ratio
					height = HEIGHT;
					width = (self.image.size.width/self.image.size.height)*height;
					y = 0;
					x = (WIDTH - width)/2;
				} else {
					// image width/height is same as current device width/height, then the displayed width and height
					// could be the same as the width and height of device
					x = 0;
					y = 0;
					width = WIDTH;
					height = HEIGHT;
				}
				
			} else {
				// image size is smaller than the screen size, so the actual displayed x and y could be
				// calculated according to the actual width and height of image and screen size
				height = self.image.size.height;
				width = self.image.size.width;
				x = (WIDTH - width)/2;
				y = (HEIGHT - height)/2;
			}
      
			break;
		}
			
		case PORTRAIT_ORI:
		{
			// both device and image are portrait
			if (isBigImage) {
				if (self.image.size.width/self.image.size.height > PORTRAIT_W_H_RATIO) {
					width = WIDTH;
					height = (self.image.size.height/self.image.size.width)*width;
					x = 0;
					y = (HEIGHT - height)/2;
				} else if (self.image.size.width/self.image.size.height < PORTRAIT_W_H_RATIO) {
					height = HEIGHT;
					width = (self.image.size.width/self.image.size.height)*height;
					y = 0;
					x = (WIDTH - width)/2;
				} else {
					x = 0;
					y = 0;
					width = WIDTH;
					height = HEIGHT;
				}
				
			} else {
				height = self.image.size.height;
				width = self.image.size.width;
				x = (WIDTH - width)/2;
				y = (HEIGHT - height)/2;
			}
      
			break;
		}
      
		case DIFF_ORI:
		{
			if (isBigImage) {
				if ([CommonUtils currentOrientationIsLandscape]) {
					// image is portrait
					height = HEIGHT;
					width = (self.image.size.width/self.image.size.height)*height;
					x = (WIDTH - width)/2;
					y = 0;
				} else {
					// image is landscape
					width = WIDTH;
					height = (self.image.size.height/self.image.size.width)*width;
					x = 0;
					y = (HEIGHT - height)/2;
				}
        
			} else {
				height = self.image.size.height;
				width = self.image.size.width;
				if ([CommonUtils currentOrientationIsLandscape]) {
					x = (WIDTH - width)/2;
					y = (HEIGHT - height)/2;
				} else {
					x = (WIDTH - width)/2;
					y = (HEIGHT - height)/2;
				}
			}
			break;
		}
      
		default:
			break;
	}
  y -= 24.5f;
  if (y < 0) {
    y = 0;
  }
  
	imageView.frame = CGRectMake(x, y, width, height);
	
	if (imgScrollView) {
		
		imgScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
		imgScrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
	}
}


- (BOOL)imageIsBigWithSameOrientation:(NSInteger)orientation width:(float)width height:(float)height {
	
	switch (orientation) {
		case LANDSCAPE_ORI:
			
			return (width > WIDTH || height > HEIGHT);
			
		case PORTRAIT_ORI:
			
			return (width > WIDTH || height > HEIGHT);
			
		default:
			return NO;
	}
}

- (BOOL)imageIsBigWithDifferentOrientation:(float)width height:(float)height {
	if ([CommonUtils currentOrientationIsLandscape]) {
		// means image is portrait
		if (height > HEIGHT) {
			return YES;
		} else {
			return NO;
		}
	} else {
		// means image is landscape
		if (width > WIDTH) {
			return YES;
		} else {
			return NO;
		}
	}
}


- (BOOL)imageIsBigWithSameOrientationForZoom:(NSInteger)orientation width:(float)width height:(float)height {
	
	switch (orientation) {
		case LANDSCAPE_ORI:
			
			return (width > WIDTH && height > HEIGHT);
			
		case PORTRAIT_ORI:
			
			return (width > WIDTH && height > HEIGHT);
			
		default:
			return NO;
	}
}

- (BOOL)imageIsBigWithDifferentOrientationForZoom:(float)width height:(float)height {
	if ([CommonUtils currentOrientationIsLandscape]) {
		// means image is portrait
		if (height > HEIGHT && width > WIDTH) {
			return YES;
		} else {
			return NO;
		}
	} else {
		// means image is landscape
		if (width > WIDTH && height > HEIGHT) {
			return YES;
		} else {
			return NO;
		}
	}
}

#pragma mark - scroll view delegate

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	
	if (imgScrollView.zoomScale <= initialZoom + 0.01) {
		imgScrollView.zoomScale = imgScrollView.zoomScale + 0.01;
	}
	
	// actual displayed image width
	float width = CGImageGetWidth(self.image.CGImage) * imgScrollView.zoomScale;
	
	// actual displayed image height
	float height = CGImageGetHeight(self.image.CGImage) * imgScrollView.zoomScale;
	float x = 0;
	float y = 0;
	
	NSInteger currentSameOrientation = [self currentSameOrientation];
	
	BOOL isBigImage = NO;
	if (currentSameOrientation == DIFF_ORI) {
		isBigImage = [self imageIsBigWithDifferentOrientationForZoom:width height:height];
	} else {
		isBigImage = [self imageIsBigWithSameOrientationForZoom:currentSameOrientation width:width height:height];
	}
	
	// If displayed image size is smaller than the screen size, then the x and y should be calculated according to
	// the actual width and height; otherwise, the x and y should be 0 if the size of
	// and 0.
	// If the calculated x or y is negative, then should be set as 0.
	switch (currentSameOrientation) {
		case LANDSCAPE_ORI:
		{
			if (!isBigImage) {
				x = (LANDSCAPE_WIDTH - width)/2;
				y = (LANDSCAPE_HEIGHT - height)/2;
			}
			
			break;
		}
			
		case PORTRAIT_ORI:
		{
			if (!isBigImage) {
				x = (PORTRAIT_WIDTH - width)/2;
				y = (PORTRAIT_HEIGHT - height)/2;
			}
			
			break;
		}
			
		case DIFF_ORI:
		{
			if (!isBigImage) {
				if ([CommonUtils currentOrientationIsLandscape]) {
					x = (LANDSCAPE_WIDTH - width)/2;
					y = (LANDSCAPE_HEIGHT - height)/2;
				} else {
					x = (PORTRAIT_WIDTH - width)/2;
					y = (PORTRAIT_HEIGHT - height)/2;
				}
			}
			break;
		}
			
		default:
			break;
	}
	
	if (x < 0) {
		x = 0;
	}
	
  y -= 24.5;
	if (y < 0) {
		y = 0;
	}
	
	imageView.frame = CGRectMake(x, y, width, height);
	
	// adjust content size of the scroll view accordingly
	imgScrollView.contentSize = imageView.frame.size;
	
	if (isBigImage &&  imgScrollView.zoomScale > initialZoom) {
		imgScrollView.zoomScale = imgScrollView.zoomScale - 0.01;
	}
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

#pragma mark - go back
- (void)back:(id)sender
{
  [[WXWImageManager instance].imageCache cancelPendingImageLoadProcess:self.imageUrlDic];
  
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - save image to local
- (void)saveImage
{
  UIImageWriteToSavedPhotosAlbum(_image, nil, nil, nil);
  
  
  [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSSaveImageSuccessMsg, nil)
                                msgType:SUCCESS_TY
                     belowNavigationBar:NO];
}

#pragma mark - fetch image data

- (void)updateLatestBrowsedPhoto:(NSData *)data
{
  // update latest browsed image list
  // TODO
}

#pragma mark - set navigationBar style

- (void)setNavigationBarBlackTranslucentStyle {
  self.navigationController.navigationBar.translucent = YES;
  self.navigationController.navigationBar.tintColor = [UIColor blackColor];
  
}

#pragma mark - view lifecycle

- (void)oneTapHandle:(UITapGestureRecognizer *)recognizer
{
	if (isHidden == NO) {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    isHidden = YES;
  } else {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    isHidden = NO;
  }
	
}

- (void)initOneTapRecoginzer {
	_oneTapRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapHandle:)];
	_oneTapRecoginzer.numberOfTapsRequired = 1;
	_oneTapRecoginzer.numberOfTouchesRequired = 1;
	[self.view addGestureRecognizer:_oneTapRecoginzer];
	_oneTapRecoginzer.delegate = self;
}

- (void)setImageToView
{
  isHidden = YES;
  
  imageView = [[UIImageView alloc] init];
  
	imageView.image = self.image;
	
	[self arrangeImageView];
}

#pragma mark - lifecycle methods

- (id)initWithImage:(UIImage *)anImage {
  
	self = [super init];
  if (self) {
		self.image = anImage;
	}
	return self;
}

- (id)initWithImageUrl:(NSString *)imageUrl {
  
	self = [super init];
  if (self) {
		self.imageUrl = imageUrl;
	}
	return self;
}

- (id)initWithImageUrl:(NSString *)imageUrl imageCaption:(NSString *)imageCaption {
  self = [self initWithImageUrl:imageUrl];
  if (self) {
    self.imageCaption = imageCaption;
  }
  
  return self;
}

- (void)dealloc {
	
	[imageView release];
	imageView = nil;
	
	[imgScrollView release];
	imgScrollView = nil;
  
  [_oneTapRecoginzer release];
  _oneTapRecoginzer = nil;
  
  self.image = nil;
  self.imageUrl = nil;
  self.imageCaption = nil;
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
	[super viewDidLoad];
  
  [self addLeftBarButtonWithTitle:LocaleStringForKey(NSBackTitle, nil)
                           target:self
                           action:@selector(back:)];
  
  [self addRightBarButtonWithTitle:LocaleStringForKey(NSSaveTitle, nil)
                            target:self
                            action:@selector(saveImage)];
  
  
  [self setNavigationBarBlackTranslucentStyle];
  
	self.view.backgroundColor = [UIColor blackColor];
  
  if (self.imageUrl && [self.imageUrl length] > 0) {
    [self fetchImage:self.imageUrl forceNew:NO];
  } else if (self.image) {
    [self setImageToView];
    [self initScrollView];
  }
  
  [self initCaptionLabeIfNecessary];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  
  //[self.navigationController setNavigationBarHidden:YES animated:YES];
  
  //isHidden = YES;
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  self.navigationController.navigationBar.tintColor = NAVIGATION_BAR_COLOR;
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  
  [self arrangeImageView];
  
  [self arrangeCaptionLabelIfNecessary];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	return YES;
}

#pragma mark - fetch image if necessary

- (void)fetchImage:(NSString *)imageUrl forceNew:(BOOL)forceNew {
  
  [self registerImageUrl:imageUrl];
  
  [[WXWImageManager instance] fetchImage:imageUrl caller:self forceNew:forceNew];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
  [self showAsyncLoadingView:LocaleStringForKey(NSLoadingTitle, nil) blockCurrentView:NO];
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
  
  self.image = image;
  
  [self setImageToView];
  [self initScrollView];
  
  [self closeAsyncLoadingView];
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
  [self imageFetchDone:image url:url];
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
  
  [UIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSLoadImageFailedMsg, nil)
                                msgType:ERROR_TY
                     belowNavigationBar:YES];
  
  [self closeAsyncLoadingView];
}

@end
