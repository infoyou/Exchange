//
//  HardwareInfo.m
//  Project
//
//  Created by XXX on 13-7-10.
//  Copyright (c) 2013年 kid. All rights reserved.
//

#import "HardwareInfo.h"
#import "UIDevice+Hardware.h"

@implementation HardwareInfo {
}

static CGSize _size;
static CGSize _screenSize;
static HardwareInfo *instance = nil;

+ (HardwareInfo *)getInstance {
    
#if 0
    if (nil != instance) {
        return instance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        instance = [[HardwareInfo alloc] init];
    });
    
#endif
    
    @synchronized(self) {
        if(instance == nil)
            instance = [[super allocWithZone:NULL] init];
    }
    
    return instance;
}

//+ (id)allocWithZone:(NSZone *)zone {
//    return [[self getInstance] retain];
//}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}
- (oneway void)release {
    // never release
}
- (id)autorelease {
    return self;
}
- (id)init {
    if (self = [super init]) {
        //        someProperty = [[NSString alloc] initWithString:@"Default Property Value"];
        
        [self initHardwareResolution];
        [self initScreenSize];
    }
    return self;
}
- (void)dealloc {
    // Should never be called, but just here for clarity really.
    //    [someProperty release];
    [super dealloc];
}

- (void)initHardwareResolution
{
    //---------------------------------退出------------------------------------------------
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    //2、获得scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    size_screen.width *= scale_screen;
    size_screen.height *= scale_screen;
    
    _size.width = size_screen.width ;
    _size.height = size_screen.height ;
}

//获取硬件设备的分辨率
- (CGSize)getHardwareResolution
{
    return _size;
}


- (void)initScreenSize
{
    //---------------------------------退出------------------------------------------------
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    _screenSize.width = size_screen.width ;
    _screenSize.height = size_screen.height;
}


- (CGSize)getScreenSize
{
    return _screenSize;
}

#pragma mark - device
- (NSString *)deviceModel {
	UIDevice *device = [[[UIDevice alloc] init] autorelease];
	return [device platformString];
}

- (CGFloat)currentOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

- (NSString *)deviceShortInfo {
    return [NSString stringWithFormat:@"%@%@",[self deviceModel], [[UIDevice currentDevice] systemVersion]];
}

@end
