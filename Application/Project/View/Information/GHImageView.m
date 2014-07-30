//
//  SliderImageView.m
//  Project
//
//  Created by user on 13-10-15.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "GHImageView.h"
#import "CommonHeader.h"
#import "CommonUtils.h"

@interface GHImageView() {
    
}

@end

@implementation GHImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame defaultImage:(NSString *)defaultName {
    if (self = [self initWithFrame:frame]) {
        self.image = IMAGE_WITH_IMAGE_NAME(defaultName);
    }
    return self;
}

- (void)updateImage:(NSString *)url {
    _downloadFile = [CommonMethod getLocalDownloadFileName:url withId:@""];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:url delegateFor:self localName:_downloadFile finished:^{
        [self updateImage];
    }];
}


- (void)updateImage:(NSString *)url withId:(NSString *)imageId{
    _downloadFile = [CommonMethod getLocalDownloadFileName:url withId:imageId];
    
    if (_downloadFile)
        [CommonMethod loadImageWithURL:url delegateFor:self localName:_downloadFile finished:^{
            [self updateImage];
        }];
}

- (void)updateImage {
    if (_downloadFile && [_downloadFile length] > 0) {
        
        [self setImage:[UIImage imageWithContentsOfFile:_downloadFile]];
        
        /*
        NSMutableArray *imageArray = [[[NSMutableArray alloc] init] autorelease];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:0];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:1];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:2];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:3];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:4];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:5];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:6];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:7];
        [imageArray insertObject:[UIImage imageWithContentsOfFile:_downloadFile] atIndex:8];

        UIImage *tempImage = [CommonUtils combineImage:imageArray];
        [self setImage:tempImage];
         */
    }

}

#pragma mark -- ASIHttp delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSLog(@"download finished!");
    [self updateImage];
}


- (void)dealloc {
    [super dealloc];
}

@end
