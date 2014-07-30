//
//  WXWImageCacheReceiver.m
//  CEIBS
//
//  Created by XXX on 10-9-23.
//  Copyright 2011 _MyCompanyName_. All rights reserved.
//

#import "WXWImageCacheReceiver.h"

@implementation WXWImageCacheReceiver

@synthesize imageConsumer;
@synthesize photoType;

- (void)dealloc {
	imageConsumer = nil;
	[super dealloc];
}

- (void)profileImageDidGetNewImage:(UIImage *)image {
	if (imageConsumer) {
    SEL updateImageSelector = sel_registerName("updateImage:");
    if ([imageConsumer respondsToSelector:updateImageSelector]) {
      [imageConsumer performSelector:updateImageSelector withObject:image];
    }
	}
}

- (void)postImageDidGetNewImage:(UIImage *)image {
	if (imageConsumer) {
    SEL updateImageSelector = sel_registerName("updatePostImage:");
		if ([imageConsumer respondsToSelector:updateImageSelector]) {
			[imageConsumer performSelector:updateImageSelector withObject:image];
		}
	}
}

- (void)albumImageDidGetNewImage:(UIImage *)image url:(NSString *)url {
  if (imageConsumer) {
    SEL updateImageSelector = sel_registerName("updateAlbumImage:url:");
    if ([imageConsumer respondsToSelector:updateImageSelector]) {
      [imageConsumer performSelector:updateImageSelector withObject:image withObject:url];
    }
  }
}

@end