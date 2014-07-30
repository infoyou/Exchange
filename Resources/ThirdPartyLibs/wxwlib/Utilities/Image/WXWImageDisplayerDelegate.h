//
//  WXWImageDisplayerDelegate.h
//  Project
//
//  Created by XXX on 11-11-16.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXWImageDisplayerDelegate <NSObject>

@optional
- (void)saveDisplayedImage:(UIImage *)image;

@required
- (void)registerImageUrl:(NSString *)url;

@end
