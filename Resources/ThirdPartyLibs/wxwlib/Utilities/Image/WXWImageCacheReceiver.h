//
//  WXWImageCacheReceiver.h
//  CEIBS
//
//  Created by XXX on 10-9-23.
//  Copyright 2011 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WXWImageCacheReceiver : NSObject 
{
  id      imageConsumer;
	NSInteger photoType;
}

@property (nonatomic, assign) id		imageConsumer;
@property (nonatomic, assign) NSInteger photoType;

@end