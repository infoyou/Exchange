//
//  WXWConnectorDelegate.h
//  Project
//
//  Created by XXX on 11-11-3.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import "WXWConstants.h"

@protocol WXWConnectorDelegate <NSObject>

@optional
- (void)connectStarted:(NSString *)url
           contentType:(NSInteger)contentType;

- (void)connectDone:(NSData *)result 
                url:(NSString *)url 
        contentType:(NSInteger)contentType;

- (void)connectDone:(NSData *)result 
                url:(NSString *)url 
        contentType:(NSInteger)contentType
closeAsyncLoadingView:(BOOL)closeAsyncLoadingView;

- (void)connectCancelled:(NSString *)url
             contentType:(NSInteger)contentType;

- (void)connectFailed:(NSError *)error
                  url:(NSString *)url 
          contentType:(NSInteger)contentType;

- (void)traceParserXMLErrorMessage:(NSString *)message url:(NSString *)url;

- (void)parserConnectionError:(NSError *)error;

- (void)saveShowAlertFlag:(BOOL)flag;

- (void)registerSessionExpiredForUrl:(NSString *)url requestType:(NSInteger)requestType;
@end
