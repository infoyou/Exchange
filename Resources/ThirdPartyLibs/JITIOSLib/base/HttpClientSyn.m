//
//  HttpClientSyn.m
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import "HttpClientSyn.h"
#import "NSString+JITIOSLib.h"
#import "Logging.h"

@implementation NSMutableURLRequest (CPOS)

+ (NSMutableURLRequest *) GETRequestForURL:(NSString *) url
{
	return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
								   cachePolicy:NSURLRequestUseProtocolCachePolicy
							   timeoutInterval:60.0];
}

+ (NSMutableURLRequest *) POSTRequestForURL:(NSString *) url
{
	NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:60.0];
	[r setHTTPMethod:@"POST"];
	return r;
}

+ (NSMutableURLRequest *) POSTRequestForURL:(NSString *) url
							   withJSONData:(NSData *) data
{
	NSMutableURLRequest *r = [NSMutableURLRequest POSTRequestForURL:url];
	if(data) {
		[r setHTTPBody:data];
		[r setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
		[r setValue:[NSString stringFromInt:data.length] forHTTPHeaderField:@"Content-Length"];
	}
	return r;
}
@end

@implementation HttpClientSyn {
	NSError *_error;
	NSURLConnection *_conn;
	NSMutableData *_data_buf;
	NSMutableDictionary *_headers;
	NSThread *_thread;
}

-(id) init
{
	self = [super init];
	if(self) {
		_conn = nil;
		_error = nil;
		_headers = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[_error release];
	[_headers release];
	[super dealloc];
}

- (void) setValue:(NSString *) value forHttpHeader:(NSString *) field
{
	[_headers setValue:value forKey:field];
}

- (void) removeHttpHeader:(NSString *) field
{
	[_headers removeObjectForKey:field];
}

- (void) removeAllHttpHeaders
{
	[_headers removeAllObjects];
}

- (NSData *) getFromURL:(NSString *) url
{
	LOGDEBUG(@"GET '%@'", url);
	NSURLRequest *req = [self requestForURL:url withMehtod:@"GET"];
	return [self sendRequest:req];
}

- (NSData *) postData:(NSData *) data toURL:(NSString *) url
{
	LOGDEBUG(@"POST TO '%@'", url);
	NSMutableURLRequest *req = [self requestForURL:url withMehtod:@"POST"];
	if(data)
		[req setHTTPBody:data];
	return [self sendRequest:req];
}

- (NSError *) lastError
{
	return _error;
}

// Helper methods
- (NSMutableURLRequest *) requestForURL:(NSString *) url withMehtod:(NSString *) method
{
	assert(url&&method);
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:
								[NSURL URLWithString:url]
													   cachePolicy:NSURLRequestUseProtocolCachePolicy
												   timeoutInterval:60.0];
	req.HTTPMethod = method;
	if(_headers.count > 0)
		[req setAllHTTPHeaderFields:_headers];
	return req;
}

- (NSData *) sendRequest:(NSURLRequest *) request
{
	[self connect:request];
	[self waitForFinishingLoading];
	return [self dataToReturn];
}


- (id) sendRequestForJSONResponse:(NSURLRequest *) request
{
	NSData *data = [self sendRequest:request];
    
	id resp = nil;
	if(data && data.length > 0) {
		NSError *error = nil;
		resp = [NSJSONSerialization JSONObjectWithData:data
											   options:NSJSONReadingMutableContainers
												 error:&error];
		if(!resp)
			LOGERROR(@"Failed to convert response to JSON values: %@, %@ ",
					 [error description], [NSString stringWithUTF8String:[data bytes]]);
	}
	return resp;
}

- (void) connect:(NSURLRequest *) request
{
    @try {
        
	[_error release];
	_error = nil;
	self.lastStatusCode = 0;
//        assert(_data_buf == nil);
        if (!_data_buf) {
            
            
	_data_buf = [[NSMutableData alloc] initWithCapacity:256];
	LOGDEBUG(@"HTTP Op: %@ %@", request.HTTPMethod, request.URL);
	_conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(!_conn)
		[self stopWithError:[NSError errorWithDomain:@"CPOSNetwork" code:1 userInfo:nil]];
}
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void) stopWithError:(NSError *) error
{
	if(error) {
		[_error release];
		_error = [error copy];
	}
	[_conn release];
	_conn = nil;
}

- (void) waitForFinishingLoading
{
	while (_conn) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}

- (NSData *) dataToReturn
{
	assert(_data_buf);
	NSData *d = [_data_buf autorelease];
	_data_buf = nil;
	return _error ? nil : d;
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
	LOGERROR(@"Failed with error \"%@\"", [error localizedDescription]);
	[self stopWithError:error];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
	assert(_data_buf);
	LOGDEBUG(@"Receive Data %d bytes", data.length);
	[_data_buf appendData:data];
}


- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
	LOGDEBUG(@"Finish Loading");
	[self stopWithError:nil];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.lastStatusCode = [((NSHTTPURLResponse *) response) statusCode];
	LOGDEBUG(@"Get Response: StatusCode = %d", self.lastStatusCode);
}

- (void) connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	//Accept invalid server certification
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
		 forAuthenticationChallenge:challenge];
}
@end
