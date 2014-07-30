//
//  SliderImageView.h
//  Project
//
//  Created by user on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHImageView : UIImageView

@property (nonatomic, copy) NSString *downloadFile;

- (id)initWithFrame:(CGRect)frame defaultImage:(NSString *)defaultName;

- (void)updateImage:(NSString *)url;
- (void)updateImage:(NSString *)url withId:(NSString *)imageId;

@end
