//
//  HttpClientSyn.h
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (JITIOSLib)
- (NSString *) requestDescription;
@end

@interface NSMutableURLRequest (JITIOSLib)
+ (NSMutableURLRequest *) GETRequestToURL:(NSString *) url;
+ (NSMutableURLRequest *) POSTRequestToURL:(NSString *) url;
+ (NSMutableURLRequest *) POSTRequestToURL:(NSString *) url
							   withJSONData:(NSData *) data;
@end


@interface JILHTTPURLConnection : NSURLConnection<NSURLConnectionDataDelegate>
@property (nonatomic) int responseStatusCode;

+ (NSData *) sendRequestSynchronizedly:(NSURLRequest *) request;
- (id) initWithRequest:(NSURLRequest *)request;
- (NSData *) responseData;
- (void) waitForResponse;
@end

/*@interface JLHttpClient : NSObject<NSURLConnectionDataDelegate>
@property (nonatomic) int lastStatusCode;
- (id) init;
- (NSData *) sendRequest:(NSURLRequest *) request;
- (id) sendRequestForJSONResponse:(NSURLRequest *) request;
- (NSData *) getFromURL:(NSString *) url;
- (NSData *) postData:(NSData *) data toURL:(NSString *) url;
- (NSError *) lastError;
@end*/
