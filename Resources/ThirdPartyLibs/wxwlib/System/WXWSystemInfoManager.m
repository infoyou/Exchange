//
//  WXWSystemInfoManager.m
//  WXLib
//
//  Created by XXX on 13-1-2.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWSystemInfoManager.h"

@implementation WXWSystemInfoManager

static WXWSystemInfoManager *shareInstance = nil;

#pragma mark - singleton methods
+ (WXWSystemInfoManager *)instance {
  @synchronized(self) {
    if (nil == shareInstance) {
      shareInstance = [[self alloc] init];
    }
  }
  
  return shareInstance;
}

+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (nil == shareInstance) {
      shareInstance = [super allocWithZone:zone];
      return shareInstance;
    }
  }
  return nil;
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (oneway void)release {
}

- (unsigned)retainCount {
  return UINT_MAX;
}

- (id)autorelease {
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark - language set
- (void)setLanguageWithType:(LanguageType)type {
  
  switch (type) {
    case EN_TY:
      [WXWSystemInfoManager instance].currentLanguageCode = EN_TY;
      [WXWSystemInfoManager instance].currentLanguageDesc = LANG_EN_TY;
      break;
      
    case ZH_HANS_TY:
      [WXWSystemInfoManager instance].currentLanguageCode = ZH_HANS_TY;
      [WXWSystemInfoManager instance].currentLanguageDesc = LANG_CN_TY;
      break;
      
    default:
      break;
  }
  
}

#pragma mark - view controller navigation
- (void)backToHomepage {
  // implement by sub class
}

@end
