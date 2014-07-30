//
//  LocationUtils.h
//  JITIOSLib
//
//  Created by user on 13-8-28.
//
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

void WGS2GCJ(double wgLat, double wgLon, double *mgLat, double *mgLon);
CLLocationCoordinate2D WGSCoordinate2GCJCoordinate(CLLocationCoordinate2D wgs);
