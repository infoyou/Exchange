//
//  NSNotification+JILNetwork.h
//  JITIPadQudao
//
//  Created by user on 13-5-8.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JILURLDownload;

extern NSString *const JILNOTIFICATION_NETWORK;

@interface NSNotification (JILNetwork)
- (JILURLDownload *) JILURLDownload;
@end