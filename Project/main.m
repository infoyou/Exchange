//
//  main.m
//  Project
//
//  Created by XXX on 13-10-21.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseAppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([BaseAppDelegate class]));
            
        }
        @catch (NSException *exception) {
                DLog(@"%@", exception);
        }
        @finally {
            
        }
    }
}
