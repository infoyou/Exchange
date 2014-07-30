//
//  UIWebViewController.m
//  Module
//
//  Created by XXX on 14-1-14.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "UIWebViewController.h"
#import "GlobalConstants.h"
#import "TextPool.h"
#import "CommonUtils.h"
#import "UIUtils.h"
#import "WXWBarItemButton.h"
#import "AppManager.h"

#define BACK_BUTTON_WIDTH   48.0f
#define BACK_BUTTON_HEIGHT  44.0f

@interface UIWebViewController()
{
    NSTimer  *contextualMenuTimer;
    CGPoint  tapLocation;
    BOOL     isShowing;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain)  NSString *selectedImageURL;
@end

@implementation UIWebViewController
@synthesize strUrl;
@synthesize strTitle;
@synthesize webView = _webView;
@synthesize needShowImageSave;
@synthesize selectedImageURL;
@synthesize needBackImag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.strUrl = nil;
    self.strTitle = nil;
    
    [UIUtils closeActivityView];
    [self.webView setDelegate:nil];
    [self.webView stopLoading];
    self.webView = nil;
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.strTitle;
    
    WXWBarItemButton *backButton = [[[WXWBarItemButton alloc] initBackStyleButtonWithFrame:CGRectMake(0, 0, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)] autorelease];
    [backButton addTarget:self action:@selector(doClose:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    [self addRightBarButtonWithTitle:LocaleStringForKey(NSCloseTitle, nil)
                              target:self
                              action:@selector(doClose:)];
    
    CGRect frame = CGRectMake(self.view.frame.origin.x, 0.0, SCREEN_WIDTH, self.view.frame.size.height-HOMEPAGE_TAB_HEIGHT);
    
    if (self.needBackImag) {
        //    background
        UIImageView *bgImgView = [[[UIImageView alloc] init] autorelease];
        bgImgView.frame = frame;
        if ([CommonUtils screenHeightIs4Inch]) {
            bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login4.png");
        } else {
            bgImgView.image = IMAGE_WITH_IMAGE_NAME(@"login3.5.png");
        }
        [self.view insertSubview:bgImgView atIndex:0];
    }
    
//    web view
    CGRect webFrame = frame;
    self.webView = [[[UIWebView alloc] initWithFrame:webFrame] autorelease];
    if (self.needBackImag) {
        self.webView.backgroundColor = TRANSPARENT_COLOR;
    } else {
        self.webView.backgroundColor = [UIColor whiteColor];
    }
    self.webView.opaque = NO;
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.userInteractionEnabled = YES;
    
    if (![self.strUrl hasPrefix:@"http://"]) {
        self.strUrl = [NSString stringWithFormat:@"http://%@",self.strUrl];
    }
    NSURL *url = [NSURL URLWithString:[self.strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.view addSubview:self.webView];
    
    [self needAddImageSave];
}

-(void) needAddImageSave
{
    if(self.needShowImageSave == YES) {
        UILongPressGestureRecognizer *longPress = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:) ]autorelease ];
        longPress.minimumPressDuration = 0.4;
        self.view.userInteractionEnabled = YES;
        [self.view addGestureRecognizer:longPress];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIWebViewDelegate methods
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIUtils showActivityView:self.view text:LocaleStringForKey(NSLoadingTitle, nil)];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];
    
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIUtils closeActivityView];
    
    [self disableSelectAndTouch];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIUtils closeActivityView];
}

- (void)doClose:(id)sender {
    
    [UIUtils closeActivityView];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) disableSelectAndTouch
{
    if(self.needShowImageSave == YES) {
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
        [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    }
}

#pragma mark add image function
-(void) onLongPress:(UILongPressGestureRecognizer*) gest
{
    if(isShowing == NO) {
        isShowing = YES;
        CGPoint pt = [gest locationInView:self.webView];
        [self openContextualMenuAt:pt];
    }
}

- (void)openContextualMenuAt:(CGPoint)pt{
    // Load the JavaScript code from the Resources and inject it into the web page
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView stringByEvaluatingJavaScriptFromString:jsCode];
    
    // get the Tags at the touch location
    NSString *tags = [self.webView stringByEvaluatingJavaScriptFromString:
                      [NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    NSString *tagsSRC = [self.webView stringByEvaluatingJavaScriptFromString:
                         [NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(NSInteger)pt.x,(NSInteger)pt.y]];
    
    // If an image was touched, add image-related buttons.
    if ([tags rangeOfString:@",IMG,"].location != NSNotFound) {
        self.selectedImageURL = tagsSRC;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:tagsSRC
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
        
        [sheet addButtonWithTitle:LocaleStringForKey(NSSaveImageTitle, nil)];
        [sheet addButtonWithTitle:LocaleStringForKey(NSCopyImageTitle, nil)];
        [sheet addButtonWithTitle:LocaleStringForKey(NSCancelTitle, nil)];
        sheet.cancelButtonIndex = (sheet.numberOfButtons-1);
        [sheet showInView:self.webView];
        [sheet release];
    } else {
        isShowing = NO;
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:LocaleStringForKey(NSCopyImageTitle, nil)]){
        [[UIPasteboard generalPasteboard] setString:self.selectedImageURL];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:LocaleStringForKey(NSSaveImageTitle, nil)]){
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImageURL:) object:self.selectedImageURL];
        [queue addOperation:operation];
        [operation release];
    }
    
    isShowing = NO;
}

-(void)saveImageURL:(NSString*)url{
    [self performSelectorOnMainThread:@selector(showStartSaveAlert) withObject:nil waitUntilDone:YES];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]], nil, nil, nil);
    [self performSelectorOnMainThread:@selector(showFinishedSaveAlert) withObject:nil waitUntilDone:YES];
}

-(void)showStartSaveAlert{
    /*progressHud.mode = MBProgressHUDModeIndeterminate;
     progressHud.labelText = @"Saving Image...";
     [progressHud show:YES];*/
}

-(void)showFinishedSaveAlert{
    // Set custom view mode
    /*progressHud.mode = MBProgressHUDModeCustomView;
     progressHud.labelText = @"Completed";
     [progressHud performSelector:@selector(hide:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5];*/
}

@end
