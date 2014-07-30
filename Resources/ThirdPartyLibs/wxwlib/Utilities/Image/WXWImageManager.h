//
//  WXWImageManager.h
//  WXLib
//
//  Created by XXX on 13-1-2.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXWImageFetcherDelegate.h"

@class WXWImageCache;

@interface WXWImageManager : NSObject {
  WXWImageCache *_imageCache;
}

@property (nonatomic, retain) WXWImageCache *imageCache;

+ (WXWImageManager *)instance;

#pragma mark - image management
- (void)fetchImage:(NSString*)url
            caller:(id<WXWImageFetcherDelegate>)caller
          forceNew:(BOOL)forceNew;
- (void)clearImageCacheForHandleMemoryWarning;
- (void)cancelPendingImageLoadProcess:(NSMutableDictionary *)urlDic;
- (void)clearCallerFromCache:(NSString *)url;
- (void)clearAllCachedImages;
- (void)clearAllCachedAndLocalImages;
- (UIImage *)getImage:(NSString*)anUrl;
- (void)saveImageIntoCache:(NSString *)url image:(UIImage *)image;
- (void)removeDelegate:(id)delegate forUrl:(NSString *)key;


@end
