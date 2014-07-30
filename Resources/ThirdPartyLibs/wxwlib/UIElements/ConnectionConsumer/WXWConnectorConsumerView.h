//
//  WXWConnectorConsumerView.h
//  wxwlib
//
//  Created by XXX on 13-1-9.
//  Copyright (c) 2013年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WXWConnectorDelegate.h"
#import "WXWConnectionTriggerHolderDelegate.h"
#import "WXWImageDisplayerDelegate.h"
#import "WXWImageFetcherDelegate.h"

@class WXWAsyncConnectorFacade;
@class WXWLabel;

@interface WXWConnectorConsumerView : UIView <WXWConnectorDelegate, WXWImageFetcherDelegate> {
  
  id<WXWImageDisplayerDelegate> _imageDisplayerDelegate;
  
  BOOL _connectionCancelled;
  
  id<WXWConnectionTriggerHolderDelegate> _connectTriggerDelegate;

  BOOL _showAlert;
}

@property (nonatomic, retain) NSMutableDictionary *errorMsgDic;
@property (nonatomic, retain) NSString *connectionErrorMsg;

- (id)initWithFrame:(CGRect)frame
imageDisplayerDelegate:(id<WXWImageDisplayerDelegate>)imageDisplayerDelegate
connectTriggerDelegate:(id<WXWConnectionTriggerHolderDelegate>)connectTriggerDelegate;

#pragma mark - label methods
- (WXWLabel *)initLabel:(CGRect)frame
              textColor:(UIColor *)textColor
            shadowColor:(UIColor *)shadowColor
                   font:(UIFont *)font;

#pragma mark - image fetch methods
- (void)fetchImage:(NSMutableArray *)imageUrls forceNew:(BOOL)forceNew;
- (CATransition *)imageTransition;
- (BOOL)currentUrlMatchView:(NSString *)url;

#pragma mark - network consumer methods
- (WXWAsyncConnectorFacade *)setupAsyncConnectorForUrl:(NSString *)url
                                           contentType:(NSInteger)contentType;



@end
