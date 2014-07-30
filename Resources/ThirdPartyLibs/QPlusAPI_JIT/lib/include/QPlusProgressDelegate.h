//
//  QPlusProgressDelegate.h
//  QPlusAPI
//
//  Created by ouyang on 13-5-7.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QPlusMessage;

@protocol QPlusProgressDelegate <NSObject>

- (void)onProgressUpdate:(QPlusMessage *)msgObejct percent:(float)percent;

@end
