//
//  ContentView.m
//  Project
//
//  Created by Jang on 13-10-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ContentView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalConstants.h"
#import "ContentWebView.h"

@interface ContentView() <UIWebViewDelegate>
{
    
}

@property (nonatomic, copy) NSString *content;

@end

@implementation ContentView {
    UIWebView *_wv;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self drawRadius];
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andContent:(NSString *)content
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        [self drawRadius];
        
        [self addTextViewWithContent:content];
        
        
    }
    return self;
}

- (void)addTextViewWithContent:(NSString *)content {
    
    _wv = [[UIWebView alloc] initWithFrame:CGRectMake(2, 10, self.frame.size.width - 2, self.frame.size.height)];
    _wv.scalesPageToFit = YES;
    _wv.backgroundColor = TRANSPARENT_COLOR;
    _wv.delegate = self;
//    _wv.hidden = YES;
//    wv.scrollView.showsHorizontalScrollIndicator = NO;
    //    wv.scrollView.showsVerticalScrollIndicator = NO;
    _wv.contentMode = UIViewContentModeScaleToFill;
//    _wv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_wv loadHTMLString:content baseURL:nil];
    [self addSubview:_wv];
//    [self loadURL:[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] webView:_wv];
}

- (void)loadURL:(NSString *)url webView:(UIWebView *)view {
    NSURL *requestUrl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request =  [[NSURLRequest alloc] initWithURL:requestUrl];
    [view loadRequest:request];
    
    [requestUrl release];
    [request release];
}

- (void)drawRadius {
    self.layer.cornerRadius = 4.f;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowRadius = 1.f;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
//    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",250.0f];
//    [webView stringByEvaluatingJavaScriptFromString:str1];
//    webView.hidden = NO;
}
@end
