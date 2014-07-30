//
//  QPlusRoom.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-23.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPlusRoom : NSObject

@property (nonatomic, assign) long roomID;
@property (nonatomic, copy) NSString *roomName;
@property (nonatomic, copy) NSString *roomInfo;

@end
