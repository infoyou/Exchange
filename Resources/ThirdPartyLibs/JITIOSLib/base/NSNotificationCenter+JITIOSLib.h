//
//  NSNotificationCenter+JITIOSLib.h
//  JITIPadQudao
//
//  Created by user on 13-5-8.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (JITIOSLib)
+ (void) processNotificatioin:(NSString *) name
				 withObserver:(NSObject *)observer
					 selector:(SEL) sel;
+ (void) processNotificatioin:(NSString *) name
					withBlock:(void (^)(NSNotification *))block;
+ (void) postNotification:(NSString *) name sender:(id) sender;
+ (void) removeObserver:(id) observer;
@end
