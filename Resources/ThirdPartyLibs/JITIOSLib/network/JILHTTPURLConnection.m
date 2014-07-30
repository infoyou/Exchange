//
//  HttpClientSyn.m
//  cpos
//
//  Created by user on 13-1-23.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import "JILHTTPURLConnection.h"
#import "JILBase.h"

@implementation NSURLRequest (JITIOSLib)
- (NSString *) requestDescription
{
	NSData *data = self.HTTPBody;
	return [NSString stringWithFormat:@"%@ '%@' body[%@]",
			self.HTTPMethod,
			self.URL.absoluteString,
			data ? data.UTF8String : @"<EMPTY BODY>"];
}
@end

@implementation NSMutableURLRequest (JITIOSLib)

+ (NSMutableURLRequest *) GETRequestToURL:(NSString *) url
{
	return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
								   cachePolicy:NSURLRequestUseProtocolCachePolicy
							   timeoutInterval:120.0];
}

+ (NSMutableURLRequest *) POSTRequestToURL:(NSString *) url
{
	NSMutableURLRequest *r = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
													 cachePolicy:NSURLRequestUseProtocolCachePolicy
												 timeoutInterval:120.0];
	[r setHTTPMethod:@"POST"];
	return r;
}

+ (NSMutableURLRequest *) POSTRequestToURL:(NSString *) url
							   withJSONData:(NSData *) data
{
	NSMutableURLRequest *r = [NSMutableURLRequest POSTRequestToURL:url];
	if(data) {
		[r setHTTPBody:data];
		[r setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
		[r setValue:[NSString stringFromInt:data.length] forHTTPHeaderField:@"Content-Length"];
	}
	return r;
}
@end

@implementation JILHTTPURLConnection {
	NSMutableData *_data;
	BOOL _connecting;
}

+ (NSData *) sendRequestSynchronizedly:(NSURLRequest *) request
{
	JILHTTPURLConnection *conn = [[[JILHTTPURLConnection alloc] initWithRequest:request] autorelease];
	if(conn) {
		[conn start];
		[conn waitForResponse];
		return conn.responseData;
	} else {
		return nil;
	}
}

- (id) initWithRequest:(NSURLRequest *)request
{
	self = [super initWithRequest:request delegate:self startImmediately:NO];
	if(self) {
		_connecting = NO;
		_data = nil;
	}
	return self;
}

- (void) dealloc
{
	[_data release];
	[super dealloc];
}

- (NSData *) responseData
{
	return _data;
}

- (void) start
{
	assert(_data == nil);
	_data = [[NSMutableData alloc] init];
	_connecting = YES;
	[super start];
}

- (void) stopWithError:(NSError *) error
{
	_connecting = NO;
}

- (void) waitForResponse
{
	[self waitForFinishingLoading];
}

- (void) waitForFinishingLoading
{
	while (_connecting) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
	JILERROR(@"Failed with error \"%@\"", [error localizedDescription]);
	[self stopWithError:error];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
	assert(_data);
	JILDEBUG(@"Receive Data %d bytes", data.length);
	[_data appendData:data];
}


- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
	JILDEBUG(@"Finish Loading");
	[self stopWithError:nil];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.responseStatusCode = [((NSHTTPURLResponse *) response) statusCode];
	JILDEBUG(@"Get Response: StatusCode = %d", self.responseStatusCode);
}

- (void) connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	//Accept invalid server certification
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]
		 forAuthenticationChallenge:challenge];
}
@end
