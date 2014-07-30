//
//  WXWTextPool.m
//  WXLib
//
//  Created by XXX on 12-12-28.
//  Copyright (c) 2012年 _CompanyName_. All rights reserved.
//

#import "WXWTextPool.h"
#import "WXWCommonUtils.h"

@implementation WXWTextPool

+ (NSString *)localizedStringForKey:(NSString *)key
                              alter:(NSString *)alternate {
    
// return [[NSBundle mainBundle] localizedStringForKey:key value:alternate table:nil];
  return [[WXWCommonUtils getBundle] localizedStringForKey:key value:alternate table:nil];
}

@end
