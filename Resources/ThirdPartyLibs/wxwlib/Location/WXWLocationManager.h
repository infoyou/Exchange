//
//  WXWLocationManager.h
//  wxwlib
//
//  Created by XXX on 13-1-4.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WXWLocationFetcherDelegate.h"

@interface WXWLocationManager : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate> {
  id<WXWLocationFetcherDelegate> _delegate;
  
  CLLocationManager	*_locationManager;
	CLLocation			*_location;
	NSTimer				*_timer;
	
	BOOL _hasLocationGotten;
  
  BOOL _showAlertMsg;

}

- (id)initWithDelegate:(id<WXWLocationFetcherDelegate>)delegate
          showAlertMsg:(BOOL)showAlertMsg;

#pragma mark - location fetch methods
- (void)getCurrentLocation;

#pragma mark - cancel location
- (void)cancelLocation;

#pragma mark - get current city
- (NSString *)getAddress:(double)latitude longitude:(double)longitude;

@end
