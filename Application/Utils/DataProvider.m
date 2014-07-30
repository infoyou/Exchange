//
//  DataProvider.m
//  Product
//
//  Created by XXX on 13-10-15.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

/*
 *
 * 本类用于提供测试数据
 *
 */

#import "DataProvider.h"
#import "WXWAsyncConnectorFacade.h"
#import "GlobalConstants.h"
#import "EncryptUtil.h"
#import "BaseAppDelegate.h"
#import "WXWCoreDataUtils.h"

@interface DataProvider ()

@end

@implementation DataProvider

static DataProvider *shareInstance = nil;

+ (DataProvider *)instance {
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

#pragma mark - prepare
- (void)signIn {
  
  self.hostUrl = @"http://alumniapp.ceibs.edu:8080/ceibs_test";
  
  NSString *param = [NSString stringWithFormat:@"username=%@&password=%@",
                     @"zying.e09sh5",
                     @"yel0rihs"];
  
  NSString *url = [NSString stringWithFormat:@"%@%@&%@&locale=%@&plat=%@&version=%@&device_token=%@&channel=%d",
                   self.hostUrl,
                   @"/phone_controller?action=signin_ceibs",
                   param,
                   @"en",
                   PLATFORM,
                   VERSION,
                   NULL_PARAM_VALUE,
                   OTA_TYPE];
  
  WXWAsyncConnectorFacade *connFacade = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                                    interactionContentType:LOGIN_TY] autorelease];
  [connFacade fetchGets:url];
}

#pragma mark - ECConnectorDelegate methods

- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
  
}

- (void)connectDone:(NSData *)result
                url:(NSString *)url
        contentType:(NSInteger)contentType
{
  
  switch (contentType) {
    case LOGIN_TY:
    {
      
      [((BaseAppDelegate *)APP_DELEGATE) goHomePage];
      break;
    }
      
    default:
      break;
  }
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType closeAsyncLoadingView:(BOOL)closeAsyncLoadingView {
  
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  [((BaseAppDelegate *)APP_DELEGATE) goHomePage];
}


@end
