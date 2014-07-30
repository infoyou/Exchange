//
//  NSNotification+JILNetwork.m
//  JITIPadQudao
//
//  Created by user on 13-5-8.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "NSNotification+JILNetwork.h"

NSString *const JILNOTIFICATION_NETWORK = @"JILNOTIFICATION_NETWORK";

@implementation NSNotification (JILNetwork)
- (JILURLDownload *) JILURLDownload
{
	return self.object;
}
@end
