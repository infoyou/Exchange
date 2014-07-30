//
//  NSNotificationCenter+JITIOSLib.m
//  JITIPadQudao
//
//  Created by user on 13-5-8.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSNotificationCenter+JITIOSLib.h"

@implementation NSNotificationCenter (JITIOSLib)
+ (void) processNotificatioin:(NSString *) name
				 withObserver:(NSObject *)observer
					 selector:(SEL) sel
{
	[[NSNotificationCenter defaultCenter] addObserver:observer
											 selector:sel
												 name:name
											   object:nil];

}

+ (void) processNotificatioin:(NSString *) name
					withBlock:(void (^)(NSNotification *))block
{
	[[NSNotificationCenter defaultCenter] addObserverForName:name
													  object:nil
													   queue:[NSOperationQueue mainQueue]
												  usingBlock:block];
}

+ (void) postNotification:(NSString *) name sender:(id) sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:sender];
}

+ (void) removeObserver:(id) observer
{
	[[NSNotificationCenter defaultCenter] removeObserver:observer];
}
@end
