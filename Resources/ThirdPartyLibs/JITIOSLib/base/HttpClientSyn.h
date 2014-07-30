//
//  HttpClientSyn.h
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (CPOS)
+ (NSMutableURLRequest *) GETRequestForURL:(NSString *) url;
+ (NSMutableURLRequest *) POSTRequestForURL:(NSString *) url;
+ (NSMutableURLRequest *) POSTRequestForURL:(NSString *) url
							   withJSONData:(NSData *) data;
@end

@interface HttpClientSyn : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic) int lastStatusCode;
- (id) init;
- (NSData *) sendRequest:(NSURLRequest *) request;
- (id) sendRequestForJSONResponse:(NSURLRequest *) request;
- (NSData *) getFromURL:(NSString *) url;
- (NSData *) postData:(NSData *) data toURL:(NSString *) url;
- (NSError *) lastError;
@end
