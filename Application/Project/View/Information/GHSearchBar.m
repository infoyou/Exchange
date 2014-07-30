//
//  GHSearchBar.m
//  Project
//
//  Created by user on 13-10-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GHSearchBar.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+expanded.h"
#import "CommonHeader.h"

@implementation GHSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    UITextField *searchField = nil;
    
    NSUInteger numViews = [self.subviews count];
    
    for(int i = 0; i < numViews; i++) {
        
        if([[self.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) { //conform?
            searchField = [self.subviews objectAtIndex:i];
        }
    }
    
    if(!(searchField == nil)) {
        
//        if ([searchField respondsToSelector:@selector(setTintColor:)]) {
//            [searchField setTintColor:[UIColor IMAGE_WITH_IMAGE_NAME(@"information_list_searchbar_bg.png")]];
//        }
        
        searchField.background = IMAGE_WITH_IMAGE_NAME(@"information_list_searchbar_bg.png");

//        UIImageView *imageView = nil;
//        
//        NSUInteger numViews = [searchField.subviews count];
//        
//        for(int i = 0; i < numViews; i++) {
//            
//            if([[searchField.subviews objectAtIndex:i] isKindOfClass:[UIImageView class]]) { //conform?
//                imageView = [searchField.subviews objectAtIndex:i];
//            }
//        }
//        
//        if (!(imageView == nil)) {
//            imageView.image = IMAGE_WITH_IMAGE_NAME(@"information_list_search_logo.png");
//        }
        
        
        UIImageView *iView = [[UIImageView alloc] initWithImage:IMAGE_WITH_IMAGE_NAME(@"information_list_search_logo.png")];
        searchField.leftView = iView;
        [iView release];
    }
    
    [super layoutSubviews];
}

@end
