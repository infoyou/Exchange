//
//  ImageWallView.h
//  Project
//
//  Created by XXX on 13-11-14.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECImageConsumerCell.h"
#import "WXWImageFetcherDelegate.h"
#import "WXWImageDisplayerDelegate.h"
#import "GlobalConstants.h"
#import "WXWImageManager.h"
#import "WXWConstants.h"
#import "WXWCommonUtils.h"
#import "WXWLabel.h"
#import "CommonHeader.h"


@interface ImageWallView : UIImageView<WXWImageFetcherDelegate,WXWImageDisplayerDelegate>
{
@private
    UIView *_titleBackgroundView;
    
    WXWLabel *_titleLabel;
    
    WXWLabel *_subTitleLabel;
    
    NSInteger _titlePosition;
    
}

@property (nonatomic, assign) id<WXWImageDisplayerDelegate> imageDisplayerDelegate;
@property (nonatomic, retain) NSString *localImageURL;

//- (BOOL)currentUrlMatchCell:(NSString *)url;
//- (void)fetchImage:(NSString *)imageUrl forceNew:(BOOL)forceNew;
- (id)initWithFrame:(CGRect)frame url:(NSString *)url title:(NSString *)title backgroundImage:(NSString *)backgroundImageName;

- (id)initNeedBottomTitleWithFrame:(CGRect)frame url:(NSString *)url showTitle:(BOOL)showTitle backgroundImage:(NSString *)backgroundImageName;

- (id)initNeedLeftTitleWithFrame:(CGRect)frame url:(NSString *)url showTitle:(BOOL)showTitle backgroundImage:(NSString *)backgroundImageName;

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle;

//- (void)setThumbnail:(UIImage *)thumbnail animated:(BOOL)animated;

- (void)setLeftTitle:(NSString *)title limitedWidth:(CGFloat)limitedWidth;


- (void)drawImageView:(NSString *)imageUrl;
@end
