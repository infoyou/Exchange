//
//  WXWConnectorConsumerView.m
//  wxwlib
//
//  Created by XXX on 13-1-9.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import "WXWConnectorConsumerView.h"
#import "WXWImageManager.h"
#import "WXWLabel.h"
#import "WXWTextPool.h"
#import "WXWUIUtils.h"

@interface WXWConnectorConsumerView()
@property (nonatomic, retain) NSMutableArray *imageUrls;
@property (nonatomic, retain) NSMutableArray *labelsContainer;
@end


@implementation WXWConnectorConsumerView

#pragma mark - lifecycle methods
- (id)initWithFrame:(CGRect)frame
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
connectTriggerDelegate:(id<WXWConnectionTriggerHolderDelegate>)connectTriggerDelegate {
  self = [super initWithFrame:frame];
  if (self) {
    _imageDisplayerDelegate = imageDisplayerDelegate;
    
    _connectTriggerDelegate = connectTriggerDelegate;
    
    self.errorMsgDic = [NSMutableDictionary dictionary];
  }
  return self;
}

- (void)dealloc {
  
  self.labelsContainer = nil;
  
  for (NSString *url in self.imageUrls) {
    [[WXWImageManager instance] clearCallerFromCache:url];
  }
  
  self.imageUrls = nil;
  
  self.errorMsgDic = nil;
  
  self.connectionErrorMsg = nil;
  
  [super dealloc];
}

#pragma mark - image fetch methods
- (CATransition *)imageTransition {
  CATransition *imageFadein = [CATransition animation];
  imageFadein.duration = FADE_IN_DURATION;
  imageFadein.type = kCATransitionFade;
  return imageFadein;
}

- (void)fetchImage:(NSMutableArray *)imageUrls forceNew:(BOOL)forceNew {
  
    if (imageUrls.count == 0) {
        return;
    }
  
    self.imageUrls = imageUrls;
  
    for (NSString *url in imageUrls) {
    
        // register image url, when the displayer (view controller) be pop up from view controller stack, if
        // image still being loaded, the process could be cancelled
      
      @try {
          
            [_imageDisplayerDelegate registerImageUrl:url];
          
      }
      @catch (NSException *exception) {
          DLog(@"%@", exception);
        }
      @finally {
          
      }
      
    
        [[WXWImageManager instance] fetchImage:url
                                        caller:self
                                      forceNew:forceNew];
    }
}

- (BOOL)currentUrlMatchView:(NSString *)url {
    // if the image of current url need be displayed in current cell, then return YES; otherwise return NO;
    return [self.imageUrls containsObject:url];
}

#pragma mark - WXWImageFetcherDelegate methods
- (void)imageFetchStarted:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchDone:(UIImage *)image url:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchFromeCacheDone:(UIImage *)image url:(NSString *)url {
  // implemented by sub class
}

- (void)imageFetchFailed:(NSError *)error url:(NSString *)url {
  // implemented by sub class
}


#pragma mark - label methods
- (WXWLabel *)initLabel:(CGRect)frame
              textColor:(UIColor *)textColor
            shadowColor:(UIColor *)shadowColor
                   font:(UIFont *)font {
  
  WXWLabel *label = [[[WXWLabel alloc] initWithFrame:frame
                                           textColor:textColor
                                         shadowColor:shadowColor] autorelease];
  
  label.font = font;
  
  if (nil == self.labelsContainer) {
    self.labelsContainer = [NSMutableArray array];
  }
  [self.labelsContainer addObject:label];
  return label;
}

#pragma mark - network consumer methods
- (WXWAsyncConnectorFacade *)setupAsyncConnectorForUrl:(NSString *)url
                                           contentType:(NSInteger)contentType {
    WXWAsyncConnectorFacade *connector = [[[WXWAsyncConnectorFacade alloc] initWithDelegate:self
                                                                   interactionContentType:contentType] autorelease];
    if (_connectTriggerDelegate) {
        [_connectTriggerDelegate registerRequestUrl:url
                                         connFacade:connector];
    }
    return connector;
}

#pragma mark - check connection error message
- (BOOL)connectionMessageIsEmpty:(NSError *)error {
    if (self.connectionErrorMsg && self.connectionErrorMsg.length > 0) {
        return NO;
    } else {
    
        if (error) {
            self.connectionErrorMsg = error.localizedDescription;
            return NO;
        }
    
        return YES;
    }
}

#pragma mark - ECConnectorDelegate methods

- (void)connectStarted:(NSString *)url contentType:(NSInteger)contentType {
    self.connectionErrorMsg = nil;
}

- (void)connectDone:(NSData *)result url:(NSString *)url contentType:(NSInteger)contentType {
  /*
  if (_connectionCancelled) {
    return;
  }
  */
  if (url && url.length > 0) {
    [self.errorMsgDic removeObjectForKey:url];
  }
}

- (void)traceParserXMLErrorMessage:(NSString *)message url:(NSString *)url {
  if (url && url.length > 0) {
    (self.errorMsgDic)[url] = message;
  }
}

- (void)connectCancelled:(NSString *)url contentType:(NSInteger)contentType {
  
}

- (void)connectFailed:(NSError *)error url:(NSString *)url contentType:(NSInteger)contentType {
  if (self.connectionErrorMsg && self.connectionErrorMsg.length > 0) {
    [WXWUIUtils showNotificationOnTopWithMsg:self.connectionErrorMsg
                                     msgType:ERROR_TY
                          belowNavigationBar:YES];
  }

}

- (void)parserConnectionError:(NSError *)error {
  if (nil == error) {
    return;
  }
  
  switch (error.code) {
    case kCFURLErrorTimedOut:
      self.connectionErrorMsg = LocaleStringForKey(NSTimeoutMsg, nil);
      break;
      
    case kCFURLErrorNotConnectedToInternet:
      self.connectionErrorMsg = LocaleStringForKey(NSNetworkUnstableMsg, nil);
      break;
      
    default:
      break;
  }
}

- (void)saveShowAlertFlag:(BOOL)flag {
  _showAlert = flag;
}
@end
