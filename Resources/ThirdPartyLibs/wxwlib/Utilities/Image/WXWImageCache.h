//
//  WXWImageCache.h
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXWImageFetcherDelegate.h"
#import "WXWConnectorDelegate.h"

@interface WXWImageCache : NSObject <WXWConnectorDelegate> {
  
}

- (void)fetchImage:(NSString*)url 
            caller:(id<WXWImageFetcherDelegate>)caller
          forceNew:(BOOL)forceNew;

- (void)cancelPendingImageLoadProcess:(NSMutableDictionary *)urlDic;

- (void)clearCallerFromCache:(NSString *)url;

- (void)clearAllCachedImages;
- (void)clearAllCachedAndLocalImages;

- (void)didReceiveMemoryWarning;

- (UIImage *)getImage:(NSString*)anUrl;
- (void)saveImageIntoCache:(NSString *)url image:(UIImage *)image;
- (void)removeDelegate:(id)delegate forUrl:(NSString *)key;

@end
