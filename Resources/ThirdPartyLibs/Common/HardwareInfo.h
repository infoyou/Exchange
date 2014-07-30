//
//  HardwareInfo.h
//  Project
//
//  Created by XXX on 13-7-10.
//  Copyright (c) 2013年 kid. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_STATUS_BAR_HEIGHT   20

@interface HardwareInfo : NSObject

+ (HardwareInfo *)getInstance;

//获取硬件设备的分辨率
- (CGSize)getHardwareResolution;
- (CGSize)getScreenSize;

#pragma mark - device
- (NSString *)deviceModel;
- (CGFloat)currentOSVersion;
- (NSString *)deviceShortInfo;

@end