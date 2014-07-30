//
//  ContentWebView.m
//  Project
//
//  Created by XXX on 13-10-29.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "ContentWebView.h"

@implementation ContentWebView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self webViewDidFinishLoad:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSString* str = [self  stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '350%'"];
    
    
    NSString* str1 =[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",200.0f];
    
    [webView stringByEvaluatingJavaScriptFromString:str1];
}

@end
