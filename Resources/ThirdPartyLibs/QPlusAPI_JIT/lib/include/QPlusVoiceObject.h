//
//  QPlusVoiceMessage.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-23.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPlusVoiceObject : NSObject

@property (nonatomic, copy) NSString *resPath;
@property (nonatomic, copy) NSString *resID;
@property (nonatomic, assign) long duration;

@end
