//
//  WXWImageManager.m
//  WXLib
//
//  Created by XXX on 13-1-2.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWImageManager.h"
#import "WXWImageCache.h"

@interface WXWImageManager()
@end

@implementation WXWImageManager

@synthesize imageCache = _imageCache;

static WXWImageManager *shareInstance = nil;

#pragma mark - singleton methods
+ (WXWImageManager *)instance {
  @synchronized(self) {
    if (nil == shareInstance) {
      shareInstance = [[self alloc] init];
    }
  }
  
  return shareInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (nil == shareInstance) {
      shareInstance = [super allocWithZone:zone];
      return shareInstance;
    }
  }
  return nil;
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (oneway void)release {
}

- (unsigned)retainCount {
  return UINT_MAX;
}

- (id)autorelease {
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - image management
- (WXWImageCache *)imageCache {
  if (nil == _imageCache) {
    _imageCache = [[WXWImageCache alloc] init];
  }
  return _imageCache;
}

- (void)clearImageCacheForHandleMemoryWarning {
  // clear image cache
  [[[WXWImageManager instance] imageCache] didReceiveMemoryWarning];
}

- (void)fetchImage:(NSString*)url
            caller:(id<WXWImageFetcherDelegate>)caller
          forceNew:(BOOL)forceNew {
  [[[WXWImageManager instance] imageCache] fetchImage:url
                                               caller:caller
                                             forceNew:forceNew];
}

- (void)cancelPendingImageLoadProcess:(NSMutableDictionary *)urlDic {
  [[[WXWImageManager instance] imageCache] cancelPendingImageLoadProcess:urlDic];
}

- (void)clearCallerFromCache:(NSString *)url {
  [[[WXWImageManager instance] imageCache] clearCallerFromCache:url];
}

- (void)clearAllCachedImages {
  [[[WXWImageManager instance] imageCache] clearAllCachedImages];
}

- (void)clearAllCachedAndLocalImages {
  [[[WXWImageManager instance] imageCache] clearAllCachedAndLocalImages];
}

- (UIImage *)getImage:(NSString*)anUrl {
  return [[[WXWImageManager instance] imageCache] getImage:anUrl];
}

- (void)saveImageIntoCache:(NSString *)url image:(UIImage *)image {
  [[[WXWImageManager instance] imageCache] saveImageIntoCache:url image:image];
}

- (void)removeDelegate:(id)delegate forUrl:(NSString *)key {
  [[[WXWImageManager instance] imageCache] removeDelegate:delegate
                                                forUrl:key];
}

@end
