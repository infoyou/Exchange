//
//  UIDevice+Hardware.h
//  Project
//
//  Created by XXX on 10-12-20.
//  Copyright 2010 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IFPGA_NAMESTRING				@"iFPGA"

#define IPHONE_1G_NAMESTRING			@"iPhone 1G"
#define IPHONE_3G_NAMESTRING			@"iPhone 3G"
#define IPHONE_3GS_NAMESTRING			@"iPhone 3GS" 
#define IPHONE_4_NAMESTRING				@"iPhone 4" 
#define IPHONE_4S_NAMESTRING      @"iPhone 4S"
#define IPHONE_5_NAMESTRING				@"iPhone 5"
#define IPHONE_5S_NAMESTRING			@"iPhone 5S"
#define IPHONE_5C_NAMESTRING			@"iPhone 5C"
#define IPHONE_UNKNOWN_NAMESTRING @"Unknown iPhone"

#define IPOD_1G_NAMESTRING				@"iPod touch 1G"
#define IPOD_2G_NAMESTRING				@"iPod touch 2G"
#define IPOD_3G_NAMESTRING				@"iPod touch 3G"
#define IPOD_4G_NAMESTRING				@"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING			@"Unknown iPod"

#define IPAD_1G_NAMESTRING				@"iPad 1G"
#define IPAD_2G_NAMESTRING				@"iPad 2G"
#define IPAD_UNKNOWN_NAMESTRING			@"Unknown iPad"

// Nano? Apple TV?
#define APPLETV_2G_NAMESTRING			@"Apple TV 2G"

#define IPOD_FAMILY_UNKNOWN_DEVICE			@"Unknown iOS device"

#define IPHONE_SIMULATOR_NAMESTRING			@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPHONE_NAMESTRING	@"iPhone Simulator"
#define IPHONE_SIMULATOR_IPAD_NAMESTRING	@"iPad Simulator"

typedef enum {
	UIDeviceUnknown,
	
	UIDeviceiPhoneSimulator,
	UIDeviceiPhoneSimulatoriPhone, // both regular and iPhone 4 devices
	UIDeviceiPhoneSimulatoriPad,
	
	UIDevice1GiPhone,
	UIDevice3GiPhone,
	UIDevice3GSiPhone,
	UIDevice4iPhone,
    UIDevice4SiPhone,
	UIDevice5iPhone,
  UIDevice5SiPhone,
  UIDevice5CiPhone,
	
	UIDevice1GiPod,
	UIDevice2GiPod,
	UIDevice3GiPod,
	UIDevice4GiPod,
  UIDevice5GiPod,
	
	UIDevice1GiPad, // both regular and 3G
	UIDevice2GiPad,
  UIDevice3GiPad,
	
	UIDeviceAppleTV2,
	
	UIDeviceUnknowniPhone,
	UIDeviceUnknowniPod,
	UIDeviceUnknowniPad,
	UIDeviceIFPGA,
	
} UIDevicePlatform;

@interface UIDevice (Hardware)
- (NSString *) platform;
- (NSString *) hwmodel;
- (NSUInteger) platformType;
- (NSString *) platformString;
- (NSString *) platformCode;

- (NSUInteger) cpuFrequency;
- (NSUInteger) busFrequency;
- (NSUInteger) totalMemory;
- (NSUInteger) userMemory;

- (NSNumber *) totalDiskSpace;
- (NSNumber *) freeDiskSpace;

- (NSString *) macaddress;

@end