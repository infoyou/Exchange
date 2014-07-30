//
//  WXWLocationFetcherDelegate.h
//  wxwlib
//
//  Created by XXX on 13-1-4.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class WXWLocationManager;

@protocol WXWLocationFetcherDelegate <NSObject>

@optional
- (void)locationManagerDidUpdateLocation:(WXWLocationManager *)manager location:(CLLocation*)location;
- (void)locationManagerDidReceiveLocation:(WXWLocationManager *)manager location:(CLLocation*)location;
- (void)locationManagerDidFail:(WXWLocationManager *)manager;
- (void)locationManagerCancelled:(WXWLocationManager *)manager;

@end
