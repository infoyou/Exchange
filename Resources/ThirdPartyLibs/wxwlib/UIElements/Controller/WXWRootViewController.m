//
//  WXWRootViewController.m
//  Project
//
//  Created by XXX on 12-05-02.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWRootViewController.h"
#import "WXWDebugLogOutput.h"
#import "WXWCoreDataUtils.h"
#import "WXWImageManager.h"
#import "WXWTextPool.h"
#import "WXWBarItemButton.h"
#import "WXWConstants.h"
#import "WXWSyncConnectorFacade.h"
#import "MobClick.h"


#define ASYNC_LOADING_VIEW_HEIGHT 40.0f
#define OPERA_FACEBOOK_HEIGHT     38.0f
#define OPERA_FACEBOOK_WIDTH      38.0f
#define OPERA_FACEBOOK_COUNT      28

#define TINY_NOTIFY_VIEW_HEIGHT   23.0f

#define ASYNC_LOADING_KEY       @"ASYNC_LOADING_KEY"

#define BACK_BUTTON_WIDTH   48.0f
#define BACK_BUTTON_HEIGHT  44.0f

@interface WXWRootViewController()
@property (nonatomic, retain) WXWBarItemButton *rightButton;
@property (nonatomic, retain) WXWBarItemButton *leftButton;
@property (nonatomic, copy) NSString *sessionExpiredUrl;

- (void) timerTitleLoading:(NSTimer*)timer;
@end


@implementation WXWRootViewController

@synthesize parentVC;
@synthesize MOC = _MOC;
@synthesize tableView = _tableView;
@synthesize connFacade = _connFacade;
@synthesize connectionErrorMsg = _connectionErrorMsg;
@synthesize connDic = _connDic;
@synthesize errorMsgDic = _errorMsgDic;
@synthesize entityName = _entityName;
@synthesize descriptors = _descriptors;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize predicate = _predicate;
@synthesize imageUrlDic = _imageUrlDic;
@synthesize fetchedRC = _fetchedRC;
@synthesize connectionResultMessage = _connectionResultMessage;
@synthesize disableViewOverlay;
@synthesize modalDisplayedVC;

// Pop View
@synthesize _PopView;
@synthesize _PopBGView;
@synthesize DropDownValArray = _DropDownValArray;
@synthesize _PickData;
@synthesize _PickerView;

- (void)adjustNavigationBarImage:(UIImage *)image forNavigationController:(UINavigationController *)navigationController
{
    ColofulNavigationBar *navBar = [[[ColofulNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)] autorelease];
    [navBar changeBarImage:image];
    [navigationController setValue:navBar forKeyPath:@"navigationBar"];
}

- (void)initNavigationbar {
    
    self.navigationItem.leftBarButtonItem = BAR_IMG_BUTTON([UIImage imageNamed:@"home_btn.png"], UIBarButtonItemStyleBordered, self, @selector(menuBtnTapped:));
}

- (void)updateNavigationBarSizeFont:(NSString *)fontName size:(int)size
{
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    
    
    [titleBarAttributes setValue:[UIColor colorWithRed:0xfe/255.0 green:0xfe/255.0 blue:0xfe/255.0 alpha:1.0f] forKey:UITextAttributeTextColor];
    [titleBarAttributes setValue:[UIFont fontWithName:fontName size:size]forKey:UITextAttributeFont];
    [[UINavigationBar appearance] setTitleTextAttributes:titleBarAttributes];
}

#pragma mark - network consumer methods-- sync
- (WXWSyncConnectorFacade *)setupSyncConnectorForUrl:(NSString *)url
                                         contentType:(NSInteger)contentType
{
    WXWSyncConnectorFacade *connector = [[[WXWSyncConnectorFacade alloc] initWithDelegate:self interactionContentType:contentType] autorelease];
    (self.connDic)[url] = connector;
    return connector;
}

#pragma mark - network consumer methods -- async
- (WXWAsyncConnectorFacade *)setupAsyncConnectorForUrl:(NSString *)url
                                           contentType:(NSInteger)contentType {
    WXWAsyncConnectorFacade *connector = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                                     interactionContentType:contentType] autorelease];
    (self.connDic)[url] = connector;
    return connector;
}

#pragma mark - cancel connection / location when navigation back to parent layer
- (void)cancelSubViewConnections {
    // stop the connection for sub views, e.g., some kind of table view cells in list, which triggered load comments,
    // if the UI being destructed, the processing loading should be stopped, then this connection will be cancelled in
    // following code;
    // these connections registered by the protocal WXWConnectionTriggerHolderDelegate method
    for (NSString *url in self.connDic.allKeys) {
        WXWAsyncConnectorFacade *connFacade = (self.connDic)[url];
        [connFacade cancelConnection];
    }
    
    [self.connDic removeAllObjects];
    
}

- (void)cancelConnection {
    if (self.connFacade) {
        [self.connFacade cancelConnection];
    }
    
    [self cancelSubViewConnections];
}

- (void)cancelLocation {
    if (_locationManager) {
        [_locationManager cancelLocation];
    }
}

#pragma mark - cancel connection and image loading
- (void)cancelConnectionAndImageLoading {
    [self cancelConnection];
    
    [[WXWImageManager instance].imageCache cancelPendingImageLoadProcess:self.imageUrlDic];
}


#pragma mark - lifecycle methods
- (id)initWithMOC:(NSManagedObjectContext *)MOC {
    
    self = [super init];
    
    if (self) {
        _MOC = MOC;
        _holder = nil;
        _backToHomeAction = nil;
        
        self.connDic = [NSMutableDictionary dictionary];
        self.errorMsgDic = [NSMutableDictionary dictionary];
        _needGoHome = NO;
        
        _allowSwipeBackToParentVC = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(redoRequestForSessionExpired:)
                                                     name:REDO_REQUEST_NOTIFY
                                                   object:nil];
    }
    return self;
}

- (id)initWithMOCWithoutBackButton:(NSManagedObjectContext *)MOC {
    self = [self initWithMOC:MOC];
    if (self) {
        _noNeedBackButton = YES;
    }
    return self;
}

- (void)dealloc
{
    self.fetchedRC = nil;
    self.connFacade = nil;
    self.connDic = nil;
    self.connectionErrorMsg = nil;
    self.errorMsgDic = nil;
    self.entityName = nil;
    self.sectionNameKeyPath = nil;
    self.descriptors = nil;
    self.predicate = nil;
    self.imageUrlDic = nil;
    self.connectionResultMessage = nil;
    
    self.modalDisplayedVC = nil;
    self.DropDownValArray = nil;
    
    self.disableViewOverlay = nil;
    
    self.rightButton = nil;
    self.leftButton = nil;
    
    // temp
    [_PopView release];
    [_PopBGView release];
    
    _PickerView.delegate = nil;
    _PickerView.dataSource = nil;
    RELEASE_OBJ(_PickerView);
    
    self._PickData = nil;
    
    self.sessionExpiredUrl = nil;
    
    [_timerTitleLoading invalidate];
    _timerTitleLoading = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - back to homepage
- (void)backToHomepage:(id)sender {
    
    [self cancelConnection];
    
    [self cancelLocation];
    
    [[WXWImageManager instance].imageCache cancelPendingImageLoadProcess:self.imageUrlDic];
    
    if (_holder && _backToHomeAction) {
        [_holder performSelector:_backToHomeAction];
    }
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backToRootViewController:(id)sender
{
    [self cancelConnection];
    
    [self cancelLocation];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - activity view show/close
- (void)showActivityView:(NSString *)text {
    
    self.view.userInteractionEnabled = NO;
    
    if (nil == _activityBackgroundView) {
        _activityBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ACTIVITY_BACKGROUND_WIDTH, ACTIVITY_BACKGROUND_HEIGHT)];
		_activityBackgroundView.layer.cornerRadius = 6.0f;
		_activityBackgroundView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
		_activityBackgroundView.center = self.view.center;
    }
    
    if (nil == _activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        CGRect activityViewFrame = _activityView.frame;
        if (text && [text length] > 0) {
            _activityView.frame = CGRectMake(_activityBackgroundView.bounds.size.width/2 - 10,
                                             _activityBackgroundView.bounds.size.height/2 - 30,
                                             activityViewFrame.size.width,
                                             activityViewFrame.size.height);
        } else {
            _activityView.frame = CGRectMake(_activityBackgroundView.bounds.size.width/2 - 10,
                                             _activityBackgroundView.bounds.size.height/2 - 15,
                                             activityViewFrame.size.width,
                                             activityViewFrame.size.height);
        }
    }
    
    if (text && [text length] > 0) {
        if (nil == _loadingLabel) {
            _loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, LOADING_LABEL_WIDTH, LOADING_LABEL_HEIGHT)];
            _loadingLabel.textAlignment = UITextAlignmentCenter;
            _loadingLabel.backgroundColor = TRANSPARENT_COLOR;
            _loadingLabel.font = BOLD_FONT(14);
            _loadingLabel.textColor = [UIColor whiteColor];
            _loadingLabel.text = text;
            _loadingLabel.center = self.view.center;//appDelegate.window.center;
            _loadingLabel.numberOfLines = 2;
            _loadingLabel.lineBreakMode = NSLineBreakByWordWrapping;
            CGRect loadingFrame = _loadingLabel.frame;
            _loadingLabel.frame = CGRectMake(_activityBackgroundView.bounds.size.width/2 - 50, _activityBackgroundView.bounds.size.height/2 - MARGIN, loadingFrame.size.width, loadingFrame.size.height);
        }
    }
    
    [_activityView startAnimating];
	
	[_activityBackgroundView addSubview:_activityView];
    
    if (text && [text length] > 0) {
        [_activityBackgroundView addSubview:_loadingLabel];
    }
    
	_activityBackgroundView.alpha = 0.0f;
    
    [self.view addSubview:_activityBackgroundView];
    [self.view bringSubviewToFront:_activityBackgroundView];
    
    [UIView beginAnimations:@"ShowBusyBeeAnimation" context:nil];
    [UIView setAnimationDuration:FADE_IN_DURATION];
    _activityBackgroundView.alpha = 1.0f;
    [UIView commitAnimations];
}

- (void)transitionDidStop {
	if (_activityView) {
		[_activityView removeFromSuperview];
		RELEASE_OBJ(_activityView);
	}
    
    if (_loadingLabel) {
        [_loadingLabel removeFromSuperview];
        RELEASE_OBJ(_loadingLabel);
    }
	
	if (_activityBackgroundView) {
		[_activityBackgroundView removeFromSuperview];
		RELEASE_OBJ(_activityBackgroundView);
	}
}

#pragma mark - async loading view
- (void)clearAsyncLoadingViews {
    [_asyncLoadingLabel removeFromSuperview];
    RELEASE_OBJ(_asyncLoadingLabel);
    
    [_operaFacebookImageView removeFromSuperview];
    RELEASE_OBJ(_operaFacebookImageView);
    
    [_asyncLoadingBackgroundView removeFromSuperview];
    RELEASE_OBJ(_asyncLoadingBackgroundView);
    
    // connectionResultMessage will be set when connection done in sub class
    if (self.connectionResultMessage && self.connectionResultMessage.length > 0) {
        [self showTinyNotification:self.connectionResultMessage];
    }
}

- (void)closeAsyncLoadingView {
    
    if (_blockCurrentView) {
        self.view.userInteractionEnabled = YES;
        _blockCurrentView = NO;
    }
    
    _stopAsyncLoading = YES;
    
    if (_asyncLoadingBackgroundView && _asyncLoadingLabel/* && _operaFacebookImageView*/) {
        [UIView beginAnimations:ASYNC_LOADING_KEY context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(clearAsyncLoadingViews)];
        _asyncLoadingBackgroundView.frame = CGRectMake(0, APP_WINDOW.frame.size.height, APP_WINDOW.frame.size.width, ASYNC_LOADING_VIEW_HEIGHT);
        [UIView commitAnimations];
    }
}

- (void)reverseFacebook {
    
    [UIView beginAnimations:nil
                    context:nil];
	[UIView setAnimationDuration:FADE_IN_DURATION];
    UIViewAnimationTransition transition;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDelay:1.0f];
    if (_reverseFromRightToLeft) {
        transition = UIViewAnimationTransitionFlipFromRight;
        [UIView setAnimationDidStopSelector:@selector(showSecondRightToLeftOperaFacebooks)];
    } else {
        transition = UIViewAnimationTransitionFlipFromLeft;
        [UIView setAnimationDidStopSelector:@selector(showSecondLeftToRightOperaFacebooks)];
    }
    
    [UIView setAnimationTransition:transition
                           forView:_operaFacebookImageView
                             cache:YES];
    [UIView commitAnimations];
    
    int index = arc4random() % OPERA_FACEBOOK_COUNT;
    _operaFacebookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"beijingOpera%d.png", index]];
    
}

- (void)addXMoveAnimationFor_operaFacebookImageView:(CGFloat)endPointX {
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    moveAnimation.duration = 1;
    moveAnimation.repeatCount = 1;
    moveAnimation.toValue = @(endPointX);
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.removedOnCompletion = NO;
    [_operaFacebookImageView.layer addAnimation:moveAnimation forKey:nil];
}

- (void)showMoveOperaFacebooksToMediaPosition {
    
    if (_stopAsyncLoading) {
        return;
    }
    
    int index = arc4random() % OPERA_FACEBOOK_COUNT;
    _operaFacebookImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"beijingOpera%d.png", index]];
    
    CGFloat endX = (_asyncLoadingLabel.frame.origin.x - MARGIN * 2)/2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(reverseFacebook)];
    _reverseFromRightToLeft = !_reverseFromRightToLeft;
    _operaFacebookImageView.alpha = 1.0f;
    //_operaFacebookImageView.frame = CGRectMake(endX, _operaFacebookImageView.frame.origin.y, OPERA_FACEBOOK_WIDTH, OPERA_FACEBOOK_HEIGHT);
    
    [self addXMoveAnimationFor_operaFacebookImageView:endX];
    [UIView commitAnimations];
}

- (void)showSecondLeftToRightOperaFacebooks {
    
    if (_stopAsyncLoading) {
        return;
    }
    
    CGFloat endX = _asyncLoadingLabel.frame.origin.x - MARGIN * 2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMoveOperaFacebooksToMediaPosition)];
    _operaFacebookImageView.alpha = 0.0f;
    //_operaFacebookImageView.frame = CGRectMake(endX, _operaFacebookImageView.frame.origin.y, OPERA_FACEBOOK_WIDTH, OPERA_FACEBOOK_HEIGHT);
    
    [self addXMoveAnimationFor_operaFacebookImageView:endX];
    
    [UIView commitAnimations];
}

- (void)showSecondRightToLeftOperaFacebooks {
    
    if (_stopAsyncLoading) {
        return;
    }
    
    CGFloat endX = 0.0f;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showMoveOperaFacebooksToMediaPosition)];
    _operaFacebookImageView.alpha = 0.0f;
    //_operaFacebookImageView.frame = CGRectMake(endX, _operaFacebookImageView.frame.origin.y, OPERA_FACEBOOK_WIDTH, OPERA_FACEBOOK_HEIGHT);
    [self addXMoveAnimationFor_operaFacebookImageView:endX];
    
    [UIView commitAnimations];
}

- (void)changeAsyncLoadingMessage:(NSString *)message {
    if (_asyncLoadingLabel) {
        _asyncLoadingLabel.text = message;
        CGSize size = [_asyncLoadingLabel.text sizeWithFont:_asyncLoadingLabel.font
                                          constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        _asyncLoadingLabel.frame = CGRectMake(APP_WINDOW.frame.size.width - MARGIN * 2 - size.width, ASYNC_LOADING_VIEW_HEIGHT/2 - size.height/2, size.width, size.height);
    }
}

- (void)showAsyncLoadingView:(NSString *)message blockCurrentView:(BOOL)blockCurrentView {
    
    if (_asyncLoadingBackgroundView) {
        // async loading view displayed currently, then no need to show it again
        return;
    }
    
    _blockCurrentView = blockCurrentView;
    if (_blockCurrentView) {
        self.view.userInteractionEnabled = NO;
    }
    
    _stopAsyncLoading = NO;
    
    if (nil == _asyncLoadingBackgroundView) {
        _asyncLoadingBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_WINDOW.frame.size.height, APP_WINDOW.frame.size.width, ASYNC_LOADING_VIEW_HEIGHT)];
        _asyncLoadingBackgroundView.backgroundColor = [UIColor blackColor];
        _asyncLoadingBackgroundView.alpha = 0.7f;
        
        [APP_WINDOW addSubview:_asyncLoadingBackgroundView];
    }
    
    if (nil == _asyncLoadingLabel) {
        _asyncLoadingLabel = [[UILabel alloc] init];
        _asyncLoadingLabel.backgroundColor = TRANSPARENT_COLOR;
        _asyncLoadingLabel.textAlignment = UITextAlignmentCenter;
        _asyncLoadingLabel.textColor = [UIColor whiteColor];
        _asyncLoadingLabel.font = BOLD_FONT(13);
        [_asyncLoadingBackgroundView addSubview:_asyncLoadingLabel];
    }
    
    _asyncLoadingLabel.text = message;
    CGSize size = [_asyncLoadingLabel.text sizeWithFont:_asyncLoadingLabel.font
                                      constrainedToSize:CGSizeMake(200, CGFLOAT_MAX)
                                          lineBreakMode:NSLineBreakByWordWrapping];
    _asyncLoadingLabel.frame = CGRectMake(APP_WINDOW.frame.size.width - MARGIN * 2 - size.width, ASYNC_LOADING_VIEW_HEIGHT/2 - size.height/2, size.width, size.height);
    
    /*
     if (nil == _operaFacebookImageView) {
     _operaFacebookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ASYNC_LOADING_VIEW_HEIGHT/2 - OPERA_FACEBOOK_HEIGHT/2, OPERA_FACEBOOK_WIDTH, OPERA_FACEBOOK_HEIGHT)];
     _operaFacebookImageView.backgroundColor = TRANSPARENT_COLOR;
     [_asyncLoadingBackgroundView addSubview:_operaFacebookImageView];
     }
     
     _operaFacebookImageView.alpha = 0.0f;
     */
    
    [UIView beginAnimations:ASYNC_LOADING_KEY context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(showMoveOperaFacebooksToMediaPosition)];
    //_reverseFromRightToLeft = YES;
    
    _asyncLoadingBackgroundView.frame = CGRectMake(0, APP_WINDOW.frame.size.height - ASYNC_LOADING_VIEW_HEIGHT, APP_WINDOW.frame.size.width, ASYNC_LOADING_VIEW_HEIGHT);
    
    [UIView commitAnimations];
}

#pragma mark - show tiny notification

- (void)clearTinyNotifyViews {
    [_tinyNotifyLabel removeFromSuperview];
    RELEASE_OBJ(_tinyNotifyLabel);
    
    [_tinyNotifyBackgroundView removeFromSuperview];
    RELEASE_OBJ(_tinyNotifyBackgroundView);
}

- (void)tinyInfoShowDone {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDelay:2.0];
	[UIView setAnimationDuration:0.2];
    [UIView setAnimationDidStopSelector:@selector(clearTinyNotifyViews)];
    
    _tinyNotifyBackgroundView.frame = CGRectMake(_tinyNotifyBackgroundView.frame.origin.x, APP_WINDOW.frame.size.height, APP_WINDOW.frame.size.width, ASYNC_LOADING_VIEW_HEIGHT);
    
    [UIView commitAnimations];
}

- (void)showTinyNotification:(NSString *)message {
    
    if (_tinyNotifyBackgroundView || nil == message || message.length == 0) {
        return;
    }
    
    _tinyNotifyBackgroundView = [[UIView alloc] init];
    _tinyNotifyBackgroundView.backgroundColor = [UIColor blackColor];
    _tinyNotifyBackgroundView.alpha = 0.7f;
    [APP_WINDOW addSubview:_tinyNotifyBackgroundView];
    
    if (nil == _tinyNotifyLabel) {
        _tinyNotifyLabel = [[UILabel alloc] init];
        _tinyNotifyLabel.font = BOLD_FONT(13);
        _tinyNotifyLabel.backgroundColor = TRANSPARENT_COLOR;
        _tinyNotifyLabel.textAlignment = UITextAlignmentCenter;
        _tinyNotifyLabel.textColor = [UIColor whiteColor];
        [_tinyNotifyBackgroundView addSubview:_tinyNotifyLabel];
    }
    
    _tinyNotifyLabel.text = message;
    CGSize size = [message sizeWithFont:_tinyNotifyLabel.font
                               forWidth:self.view.frame.size.width
                          lineBreakMode:NSLineBreakByWordWrapping];
    _tinyNotifyLabel.frame = CGRectMake(MARGIN, MARGIN, size.width, size.height);
    _tinyNotifyBackgroundView.frame = CGRectMake(APP_WINDOW.frame.size.width - (MARGIN * 2 + _tinyNotifyLabel.frame.size.width), APP_WINDOW.frame.size.height, MARGIN * 2 + _tinyNotifyLabel.frame.size.width, TINY_NOTIFY_VIEW_HEIGHT);
    
    [UIView beginAnimations:ASYNC_LOADING_KEY context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(tinyInfoShowDone)];
    
    _tinyNotifyBackgroundView.frame = CGRectMake(_tinyNotifyBackgroundView.frame.origin.x, APP_WINDOW.frame.size.height - TINY_NOTIFY_VIEW_HEIGHT, _tinyNotifyBackgroundView.frame.size.width, TINY_NOTIFY_VIEW_HEIGHT);
    
    [UIView commitAnimations];
    
}

#pragma mark - swipe for back gesture
- (void)addSwipeBackGestureRecognizer {
    UISwipeGestureRecognizer *swipeGR = [[[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(backToParentVC:)] autorelease];
    swipeGR.delegate = self;
    swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGR];
}

- (void)backToParentVC:(UISwipeGestureRecognizer *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - navigation bar button
- (void)initBackButton {
    
    WXWBarItemButton *backButton = [[[WXWBarItemButton alloc] initBackStyleButtonWithFrame:CGRectMake(MARGIN * -2, 0, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)] autorelease];
    
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
}

- (void)addRightBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self.rightButton = [[[WXWBarItemButton alloc] initRightButtonWithFrame:CGRectMake(0, 0, 0, 44.0f)
                                                                     title:title
                                                                    target:target
                                                                    action:action] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.rightButton] autorelease];
}

- (void)addLeftBarButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    self.leftButton = [[[WXWBarItemButton alloc] initLeftButtonWithFrame:CGRectMake(0, 0, 0, 44.0f)
                                                                   title:title
                                                                  target:target
                                                                  action:action] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.leftButton] autorelease];
}

- (void)setRightButtonTitle:(NSString *)title {
    
    if (self.rightButton) {
        [self.rightButton setTitle:title forState:UIControlStateNormal];
    }
    
}

- (void)setLeftButtonTitle:(NSString *)title {
    if (self.leftButton) {
        [self.leftButton setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - navigation title & loading animation
- (void) setLoadingTitle:(NSString*)title withAnimation:(BOOL)animation {
    
}

- (void) startLoadingTitle {
    if (_timerTitleLoading == nil) {
        _timerTitleLoading = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(timerTitleLoading:) userInfo:nil repeats:YES];
    }
    [_timerTitleLoading fire];
}

- (void) stopLoadingTitle {
    [_timerTitleLoading invalidate];
    _timerTitleLoading = nil;
}

- (void) resetTitle:(NSString *)title {
    [self stopLoadingTitle];
    self.navigationItem.title = title;
}

- (void) timerTitleLoading:(NSTimer *)timer {
    static NSInteger countOfPoint = 0;
    
    NSMutableString* points = [[NSMutableString alloc] initWithString:@"正在加载"];
    for (NSInteger i = 0; i < countOfPoint; i++) {
        [points appendString:@"."];
    }
    self.navigationItem.title = points;
    [points release];
    
    if (++countOfPoint > 6) {
        countOfPoint = 0;
    }
}

 #pragma mark - handle status bar issue for ios7
 - (UIStatusBarStyle)preferredStatusBarStyle
 {
 return UIStatusBarStyleLightContent;
 }
 
 - (BOOL)prefersStatusBarHidden
 {
 return NO;
 }

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}


- (void)initScreenSize
{
    //-------------------退出-------------------------------------
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    _screenSize.width = size_screen.width ;
    _screenSize.height = size_screen.height;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initScreenSize];
    
    // handle view edges issues in ios7
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    if (!_noNeedBackButton) {
        [self initBackButton];
    }
    
    if (_needGoHome) {
        [self initNavigationbar];
    }
    
    /*
     if (_allowSwipeBackToParentVC) {
     [self addSwipeBackGestureRecognizer];
     }
     */
    
    [self updateNavigationBarSizeFont:DEFAULT_NAVIGATION_BAR_FONT_NAME size:DEFAULT_NAVIGATION_BAR_FONT_SIZE];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self closeAsyncLoadingView];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - override UIViewController mehtods
- (void)presentModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated {
    
    [super presentModalViewController:modalViewController animated:animated];
    
    if ([WXWUIUtils showingNotification]) {
        [WXWUIUtils hideNotification];
    }
    
}

#pragma mark - check connection error message
- (BOOL)connectionMessageIsEmpty:(NSError *)error {
    if (self.connectionErrorMsg && self.connectionErrorMsg.length > 0) {
        return NO;
    } else {
        
        if (error) {
            self.connectionErrorMsg = error.localizedDescription;
            return NO;
        }
        
        return YES;
    }
}

#pragma mark - handle session expired

- (void)redoRequestForSessionExpired:(NSNotification *)notification {
    
    NSDictionary *userInfo = notification.userInfo;
    
    if (userInfo.count > 0) {
        
        NSString *sessionId = userInfo[SESSION_ID_KEY];
        if (sessionId.length > 0) {
            
            if (self.sessionExpiredUrl.length > 0) {
                NSString *url = [WXWCommonUtils replaceWithNewSessionId:sessionId url:self.sessionExpiredUrl];
                
                if (url && url.length > 0) {
                    WXWAsyncConnectorFacade *connector = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                                                     interactionContentType:_sessionExpiredRequestType] autorelease];
                    (self.connDic)[url] = connector;
                    
                    [connector asyncGet:url showAlertMsg:_showAlert];
                    
                }
            }
        }
    }
}

#pragma mark - WXWConnectorDelegate methods
- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    self.connectionResultMessage = nil;
    
    self.connectionErrorMsg = nil;
    
    [WXWSystemInfoManager instance].sessionExpired = NO;
    
    _sessionExpiredRequestType = INIT_VALUE_TYPE;
    
    self.sessionExpiredUrl = nil;
}

- (void)connectDone:(NSData *)result
                url:(NSString *)url
        contentType:(NSInteger)contentType
closeAsyncLoadingView:(BOOL)closeAsyncLoadingView {
    
    self.connFacade = nil;
    
    if (closeAsyncLoadingView) {
        [self closeAsyncLoadingView];
    }
    
    if (url && url.length > 0) {
        [self.connDic removeObjectForKey:url];
        [self.errorMsgDic removeObjectForKey:url];
    }
}

- (void)connectDone:(NSData *)result
                url:(NSString *)url
        contentType:(NSInteger)contentType {
    
    [self connectDone:result url:url contentType:contentType closeAsyncLoadingView:YES];
}


- (void)traceParserXMLErrorMessage:(NSString *)message url:(NSString *)url {
    if (url && url.length > 0) {
        (self.errorMsgDic)[url] = message;
    }
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
    self.connFacade = nil;
    
    [self closeAsyncLoadingView];
    
    if (url && url.length > 0) {
        [self.connDic removeObjectForKey:url];
    }
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
    self.connFacade = nil;
    
    if (self.connectionErrorMsg.length > 0) {
        [WXWUIUtils showNotificationOnTopWithMsg:self.connectionErrorMsg
                                         msgType:ERROR_TY
                              belowNavigationBar:YES];
    }
    
    [self closeAsyncLoadingView];
    
    if (url && url.length > 0) {
        [self.connDic removeObjectForKey:url];
    }
}

- (void)parserConnectionError:(NSError *)error {
    if (nil == error) {
        return;
    }
    
    switch (error.code) {
        case kCFURLErrorTimedOut:
            self.connectionErrorMsg = LocaleStringForKey(NSTimeoutMsg, nil);
            break;
            
        case kCFURLErrorNotConnectedToInternet:
            self.connectionErrorMsg = LocaleStringForKey(NSNetworkUnstableMsg, nil);
            break;
            
        default:
            break;
    }
}

- (void)registerSessionExpiredForUrl:(NSString *)url requestType:(NSInteger)requestType {
    
    _sessionExpiredRequestType = requestType;
    
    self.sessionExpiredUrl = url;
    
    [WXWSystemInfoManager instance].sessionExpired = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_SESSION_NOTIFY
                                                        object:nil
                                                      userInfo:@{SESSION_EXPIRED_VIEW_KEY:self.view, SESSION_EXPIRED_TYPE_KEY:@(requestType)}];
}

- (void)saveShowAlertFlag:(BOOL)flag {
    _showAlert = flag;
}

#pragma mark - WXWConnectionTriggerHolderDelegate method
- (void)registerRequestUrl:(NSString *)url connFacade:(WXWAsyncConnectorFacade *)connFacade {
    if (url && url.length > 0) {
        (self.connDic)[url] = connFacade;
    }
}

#pragma mark - WXWImageDisplayerDelegate method
- (void)registerImageUrl:(NSString *)url {
    if (nil == self.imageUrlDic) {
        self.imageUrlDic = [NSMutableDictionary dictionary];
    }
    if (url && url.length > 0) {
        (self.imageUrlDic)[url] = url;
    }
}

#pragma mark - Table
- (void)initTableView
{
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    //    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)deselectCell
{
	NSIndexPath *selection = [_tableView indexPathForSelectedRow];
	if (selection) {
		[_tableView deselectRowAtIndexPath:selection animated:YES];
	}
}

#pragma mark - WXWLocationFetcherDelegate methods
- (void)locationManagerDidUpdateLocation:(WXWLocationManager *)manager location:(CLLocation *)location
{
    return;
}

- (void)locationManagerDidReceiveLocation:(WXWLocationManager *)manager location:(CLLocation *)location
{
    [WXWSystemInfoManager instance].latitude = location.coordinate.latitude;
    [WXWSystemInfoManager instance].longitude = location.coordinate.longitude;
    
    [manager autorelease];
    _locationManager = nil;
    
    [self locationResult:LOCATE_SUCCESS_TY];
}

- (void)locationManagerDidFail:(WXWLocationManager *)manager {
    if (!_userCancelledLocate) {
        [manager autorelease];
    } else {
        _userCancelledLocate = NO;
    }
    _locationManager = nil;
    [self locationResult:LOCATE_FAILED_TY];
}

- (void)locationManagerCancelled:(WXWLocationManager *)manager {
    [manager autorelease];
    _locationManager = nil;
    _userCancelledLocate = YES;
    [self locationResult:LOCATE_FAILED_TY];
}

- (void)locationResult:(LocationResultType)type {
    // implemented by sub class
}

#pragma mark - location fetch
- (void)triggerGetLocation {
    
    if ([WXWCommonUtils currentOSVersion] >= IOS4_2) {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:LocaleStringForKey(NSNearbyServiceUnavailableMsg, nil)
                                                             message:LocaleStringForKey(NSLocationServiceDeniedMsg, nil)
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:LocaleStringForKey(NSOKTitle, nil), nil] autorelease];
            [alert show];
            
            return;
        }
    }
    
    _locationManager = nil;
    _locationManager = [[WXWLocationManager alloc] initWithDelegate:self
                                                       showAlertMsg:NO];
    [_locationManager getCurrentLocation];
    
}

- (void)forceGetLocation {
    [self triggerGetLocation];
}

- (void)getCurrentLocationInfoIfNecessary {
    
    [self triggerGetLocation];
}


#pragma mark - core data
- (void)setFetchCondition {
    // implemented by subclass
}

- (NSFetchedResultsController *)prepareFetchRC {
    
    [self setFetchCondition];
    
    //RELEASE_OBJ(self.fetchedRC);
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:nil
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    return self.fetchedRC;
}

- (void)menuBtnTapped:(id)sender {
    [[WXWSystemInfoManager instance] backToHomepage];
}

#pragma mark - Clear Picker Select Index
- (void)clearPickerSelIndex2Init:(int)size
{
    if ([WXWSystemInfoManager instance].pickerSel0IndexList) {
        [WXWSystemInfoManager instance].pickerSel0IndexList = nil;
        
        [WXWSystemInfoManager instance].pickerSel1IndexList = nil;
    }
    
    [WXWSystemInfoManager instance].pickerSel0IndexList = [NSMutableArray array];
    [WXWSystemInfoManager instance].pickerSel1IndexList = [NSMutableArray array];
    
    for (int i = 0; i<size; i++) {
        [[WXWSystemInfoManager instance].pickerSel0IndexList insertObject:[NSString stringWithFormat:@"%d", iOriginalSelIndexVal] atIndex:i];
        [[WXWSystemInfoManager instance].pickerSel1IndexList insertObject:[NSString stringWithFormat:@"%d", iOriginalSelIndexVal] atIndex:i];
    }
}

#pragma mark - Pop View
- (void)setDropDownValueArray {
}

-(void)setPopView
{
    [self initDisableView:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT - PopViewHeight)];
    [self showDisableView];
    
    isPickSelChange = NO;
    
    _PopBGView = [[UIView alloc] init];
    [_PopBGView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [_PopBGView setBackgroundColor:TRANSPARENT_COLOR];
    
    _PopView = [[UIView alloc] init];
    [_PopView setFrame:CGRectMake(PopViewX, PopViewY, PopViewWidth, PopViewHeight)];
    _PopView.backgroundColor = [UIColor whiteColor];
    
    UIToolbar * topView = [[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)] autorelease];
    
    [topView setBarStyle:UIBarStyleBlack];
    
    SEL cancelSelector = sel_registerName("onPopCancle:");
    UIBarButtonItem *cancelButton = BAR_BUTTON(LocaleStringForKey(NSCancelTitle, nil), UIBarButtonItemStyleBordered, self, cancelSelector);
    
    UIBarButtonItem *btnSpace = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
    
    SEL confirmSelector = sel_registerName("onPopOk:");
    UIBarButtonItem * sureButton = BAR_BUTTON(LocaleStringForKey(NSSureTitle, nil), UIBarButtonItemStyleDone, self, confirmSelector);
    
    NSArray *buttonsArray = @[cancelButton, btnSpace, sureButton];
    [topView setItems:buttonsArray];
    [_PopView addSubview:topView];
    
    // Pick Data
    self._PickData = [NSMutableArray array];
    [self setDropDownValueArray];
    
    int size = [self.DropDownValArray count];
    for (NSUInteger i=0; i<size; i++) {
        [_PickData addObject:(self.DropDownValArray)[i][RECORD_NAME_IDX]];
    }
    
    _PickerView = [[UIPickerView alloc] init];
    _PickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_PickerView setFrame:CGRectMake(0, TopViewHeight, SCREEN_WIDTH, PickViewHeight)];
    _PickerView.delegate = self;
    _PickerView.dataSource = self;
    
    // default select index row = 0
    int mPickSelectIndex = [([WXWSystemInfoManager instance].pickerSel0IndexList)[iFliterIndex] intValue];
    
    if (mPickSelectIndex == -1) {
        mPickSelectIndex = 0;
    }
    
    [_PickerView selectRow:mPickSelectIndex inComponent:0 animated:NO];
    
    if ([_PickerView numberOfComponents] == 2) {
        
        // default select index row = 1
        int mPickSelect1Index = [([WXWSystemInfoManager instance].pickerSel1IndexList)[iFliterIndex] intValue];
        
        if (mPickSelect1Index == -1) {
            mPickSelect1Index = 0;
        }
        
        [_PickerView selectRow:mPickSelect1Index inComponent:1 animated:NO];
    }
    
    _PickerView.showsSelectionIndicator = YES;
    [_PopView addSubview:_PickerView];
    
    [_PopBGView addSubview:_PopView];
    
    [self.view addSubview:_PopBGView];
}

- (void)onPopCancle {
    [_PopBGView removeFromSuperview];
    [self removeDisableView];
}

- (void)onPopSelectedOk {
    [self removeDisableView];
    
    if (isPickSelChange) {
        [[WXWSystemInfoManager instance].pickerSel0IndexList removeObjectAtIndex:iFliterIndex];
        [[WXWSystemInfoManager instance].pickerSel0IndexList insertObject:[NSString stringWithFormat:@"%d", pickSel0Index] atIndex:iFliterIndex];
        
        [[WXWSystemInfoManager instance].pickerSel1IndexList removeObjectAtIndex:iFliterIndex];
        [[WXWSystemInfoManager instance].pickerSel1IndexList insertObject:[NSString stringWithFormat:@"%d", pickSel1Index] atIndex:iFliterIndex];
    }
    
    [_PopBGView removeFromSuperview];
}

- (int)pickerList0Index{
    int iPickSelectIndex = [([WXWSystemInfoManager instance].pickerSel0IndexList)[iFliterIndex] intValue];
    if (iPickSelectIndex == -1) {
        iPickSelectIndex = 0;
    }
    return iPickSelectIndex;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerSelectRow:(NSInteger)row
{
    NSLog(@"pickerView %d=%@", row, _PickData[row]);
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_PickData count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _PickData[row];
}

#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

#pragma mark - DisableView option
- (void)initDisableView:(CGRect)frame {
    self.disableViewOverlay = [[[UIView alloc]
                                initWithFrame:frame] autorelease];
    self.disableViewOverlay.backgroundColor=[UIColor blackColor];
    self.disableViewOverlay.alpha = 0;
}

- (void)showDisableView {
    self.disableViewOverlay.alpha = 0;
    [self.view addSubview:self.disableViewOverlay];
    
    [UIView beginAnimations:@"FadeIn" context:nil];
    [UIView setAnimationDuration:0.5];
    self.disableViewOverlay.alpha = 0.6;
    [UIView commitAnimations];
}

- (void)removeDisableView {
    [self.disableViewOverlay removeFromSuperview];
}

#pragma mark - manage modal view controller
- (UIView*)parentTarget {
    
    // To make it work with UINav & UITabbar as well
    UIViewController * target = self;
    while (target.parentViewController != nil) {
        target = target.parentViewController;
    }
    return target.view;
}

- (CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
    
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
    animation.duration = FADE_IN_DURATION/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:@[animation,animation2]];
    return group;
}

- (void)presentModalQuickViewController:(UIViewController*)vc {
    
    self.modalDisplayedVC = vc;
    
    [self presentModalQuickView:vc.view];
}

- (void)presentModalQuickView:(UIView*)view {
    
    // Determine target
    UIView * target = [self parentTarget];
    
    if (![target.subviews containsObject:view]) {
        // Calulate all frames
        CGRect sf = view.frame;
        CGRect vf = target.frame;
        CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
        CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
        
        // Add semi overlay
        UIView * overlay = [[[UIView alloc] initWithFrame:target.bounds] autorelease];
        overlay.backgroundColor = [UIColor blackColor];
        
        // Take screenshot and scale
        //UIGraphicsBeginImageContext(target.bounds.size);
        UIGraphicsBeginImageContextWithOptions(target.bounds.size, target.opaque, 2.0);
        [target.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView * ss = [[[UIImageView alloc] initWithImage:image] autorelease];
        [overlay addSubview:ss];
        [target addSubview:overlay];
        
        // Dismiss button
        // Don't use UITapGestureRecognizer to avoid complex handling
        UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [dismissButton addTarget:self
                          action:@selector(dismissModalQuickView)
                forControlEvents:UIControlEventTouchUpInside];
        dismissButton.backgroundColor = TRANSPARENT_COLOR;
        dismissButton.frame = of;
        [overlay addSubview:dismissButton];
        
        // Begin overlay animation
        [ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
        [UIView animateWithDuration:FADE_IN_DURATION
                         animations:^{
                             ss.alpha = 0.5;
                         }];
        
        // Present view animated
        view.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
        [target addSubview:view];
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, -2);
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOpacity = 0.8;
        [UIView animateWithDuration:FADE_IN_DURATION animations:^{
            view.frame = f;
        }];
    }
}

- (void)dismissModalQuickView {
    
    UIView * target = [self parentTarget];
    UIView * modal = (target.subviews)[target.subviews.count-1];
    UIView * overlay = (target.subviews)[target.subviews.count-2];
    
    [UIView animateWithDuration:FADE_IN_DURATION animations:^{
        modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
        self.modalDisplayedVC = nil;
    }];
    
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)(overlay.subviews)[0];
    [ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
    [UIView animateWithDuration:FADE_IN_DURATION animations:^{
        ss.alpha = 1;
    }];
}

- (void)configureMOCFetchConditions {
    // implemented by sub class
}

#pragma mark -- MOC

- (void)fetchContentFromMOC {
    
    self.fetchedRC = nil;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    [self configureMOCFetchConditions];
    
    self.fetchedRC = [WXWCoreDataUtils fetchObject:_MOC
                          fetchedResultsController:self.fetchedRC
                                        entityName:self.entityName
                                sectionNameKeyPath:self.sectionNameKeyPath
                                   sortDescriptors:self.descriptors
                                         predicate:self.predicate];
    NSError *error = nil;
    
    if (![self.fetchedRC performFetch:&error]) {
        debugLog(@"Unhandled error performing fetch: %@", [error localizedDescription]);
        NSAssert1(0, @"Unhandled error performing fetch: %@", [error localizedDescription]);
    }
    
}

@end