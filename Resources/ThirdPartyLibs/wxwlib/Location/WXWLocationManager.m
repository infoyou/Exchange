//
//  WXWLocationManager.m
//  wxwlib
//
//  Created by XXX on 13-1-4.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWLocationManager.h"
#import "SBJsonParser.h"
#import "WXWSystemInfoManager.h"
#import "WXWUIUtils.h"
#import "WXWTextPool.h"
#import "WXWDebugLogOutput.h"

#define GPS_TIMEOUT_TIME        31.0
#define GPS_ACCURACY_THRESHOLD  50.0
#define MAX_LOCATION_INTERVAL   30
#define DISTANCE_FILTER_RADIUS  2000

@interface WXWLocationManager()
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, retain) CLLocation *location;
@property(nonatomic, retain) id<WXWLocationFetcherDelegate> delegate;
@end

@implementation WXWLocationManager

@synthesize locationManager = _locationManager;
@synthesize location = _location;
@synthesize delegate = _delegate;


- (id)initWithDelegate:(id<WXWLocationFetcherDelegate>)delegate
          showAlertMsg:(BOOL)showAlertMsg {
  
  self = [super init];
  if (self) {
    
    NSLog(@"---init loc---");
    
    self.delegate = delegate;
    
    _location = nil;
    
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    _showAlertMsg = showAlertMsg;
  }
  return self;
}

- (void)dealloc {
  
  NSLog(@"---dealloc loc---");
  
  self.locationManager.delegate = nil;
  self.locationManager = nil;
  self.location = nil;
  self.delegate = nil;
  
  [super dealloc];
}

#pragma mark - location fetch methods

- (void)getCurrentLocation {
  [self.locationManager startUpdatingLocation];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  _timer = [NSTimer scheduledTimerWithTimeInterval:GPS_TIMEOUT_TIME
                                            target:self
                                          selector:@selector(locationManagerDidTimeout:userInfo:)
                                          userInfo:nil
                                           repeats:NO];
  
}

#pragma mark - cancel location
- (void)cancelLocation {
  
  [self.locationManager stopUpdatingLocation];
  [self.locationManager stopUpdatingHeading];
  //self.locationManager.delegate = nil;
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
  [self.delegate locationManagerCancelled:self];
}

#pragma mark - get current city
- (NSString *)getAddress:(double)latitude longitude:(double)longitude {
	NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?latlng=%f,%f&sensor=true", latitude, longitude];
	NSError *err = nil;
	NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                      encoding:NSUTF8StringEncoding
                                                         error:&err];
	if (err) {
		debugLog(@"Get address by latitude and longitude failed: %@", [err localizedDescription]);
		return nil;
	}
	
	// creating new parser
  SBJsonParser *parser = [[SBJsonParser alloc] init];
	
  // parsing the first level
  NSDictionary *data = (NSDictionary *) [parser objectWithString:locationString
                                                           error:&err];
	if (err) {
		debugLog(@"Pasing geo json result for getting address failed: %@", [err localizedDescription]);
		[parser release];
		parser = nil;
		return nil;
	}
	
	// pasing the second level
  NSDictionary *results = (NSDictionary *) data[@"results"];
	
	// pasing the third level
	NSArray *dictArray = [results valueForKey:@"formatted_address"];
	
	if (dictArray == nil) {
		[parser release];
		parser = nil;
		debugLog(@"No address for the latitude(%f) and longitude(%f)", latitude, longitude);
		return nil;
	}
	
	//NSString *address = (NSString *)[dictArray objectAtIndex:0];
	NSString *address = (NSString *)dictArray[3];
	[parser release];
	parser = nil;
	
	return address;
}

#pragma mark - check location time interval
- (BOOL)validatedLocation:(CLLocation *)newLocation {
  
  NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceNow];
  
  if (abs(interval) < MAX_LOCATION_INTERVAL && newLocation.horizontalAccuracy <= DISTANCE_FILTER_RADIUS) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - CLLocationManagerDelegate methods

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
  
  // indicate that whether latitude and longitude have been loacated
	// if they are be gotten, then no need to get the location again
	if (_hasLocationGotten) {
		return;
	}
  
  if ([self validatedLocation:newLocation]) {
    if (self.delegate) {
      [self.delegate locationManagerDidUpdateLocation:self location:newLocation];
      
      [WXWSystemInfoManager instance].locationFetched = YES;
    }
    
    //        debugLog(@"newLocation: %@", newLocation);
    self.location = newLocation;
    
    [_timer invalidate];
    
    _timer = nil;
    [manager stopUpdatingLocation];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    _hasLocationGotten = YES;
    
    [self.delegate locationManagerDidReceiveLocation:self location:newLocation];
  }
}

- (void)locationManagerDidTimeout:(NSTimer*)aTimer userInfo:(id)userInfo {
  _timer = nil;
  
  [self.locationManager stopUpdatingLocation];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  
  if (self.location) {
    NSDate* eventDate = self.location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
		
    if ([self.location horizontalAccuracy] < 10000 && abs(howRecent) < GPS_TIMEOUT_TIME + 5.0) {
      [self.delegate locationManagerDidReceiveLocation:self location:self.location];
      self.location = nil;
      
      return;
    }
    
    self.location = nil;
  }
  
  if (/*![WXWSystemInfoManager instance].hasLogoff &&*/ ![WXWSystemInfoManager instance].locationFetched) {
    if (_showAlertMsg) {
      [WXWUIUtils showNotificationOnTopWithMsg:LocaleStringForKey(NSLocationTimeOutMsg, nil)
                                    msgType:ERROR_TY
                         belowNavigationBar:YES];
    }
  }
  
  [self.delegate locationManagerDidFail:self];
  
  debugLog(@"Location Service Error caused by timeout");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [self.locationManager stopUpdatingLocation];
  
  if (error.code == kCLErrorDenied && [error.domain isEqualToString:kCLErrorDomain]) {
    // the error message will be displayed only for locate current place first time
    // the auto location error no need to display to user again and again
    if (![WXWSystemInfoManager instance].locationFetched) {
      
      if (_showAlertMsg) {
        ShowAlert(self, LocaleStringForKey(NSNoteTitle, nil), LocaleStringForKey(NSLocationSevDisabledMsg, nil), LocaleStringForKey(NSOKTitle, nil));
      }
		} else if (error.code == kCLErrorLocationUnknown) {
      // ignore this error and continue
      return;
    }
    
    [_timer invalidate];
    _timer = nil;
    
    self.location = nil;
    
    [self.delegate locationManagerDidFail:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }
}

@end
