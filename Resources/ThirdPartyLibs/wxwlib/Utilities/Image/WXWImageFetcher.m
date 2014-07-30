//
//  WXWImageFetcher.m
//  Project
//
//  Created by XXX on 11-11-9.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWImageFetcher.h"

@interface WXWImageFetcher()
@property (nonatomic, retain) NSMutableDictionary *urlDic;
@end

@implementation WXWImageFetcher

@synthesize urlDic = _urlDic;

- (void)dealloc {
  
  self.urlDic = nil;
  
  [super dealloc];
}

#pragma mark - get image

- (void)fetchImage:(NSString *)url showAlertMsg:(BOOL)showAlertMsg {
  
  if (nil == self.urlDic) {
    self.urlDic = [NSMutableDictionary dictionary];
  }
  
  if (url && url.length > 0) {
    (self.urlDic)[url] = url;
    
    [self asyncGet:url showAlertMsg:showAlertMsg];
  }
}

- (BOOL)imageBeingLoaded:(NSString *)url {
  if (self.urlDic) {
    if ((self.urlDic)[url] && [(NSString *)(self.urlDic)[url] length] > 0) {
      return YES;
    }
  }
  
  return NO;
}

- (void)cancelFetchImage:(NSString *)url {
  
}

@end
