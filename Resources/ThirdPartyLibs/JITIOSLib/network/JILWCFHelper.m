//
//  JILWCFHelper.m
//  JITIPadQudao
//
//  Created by user on 13-4-19.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import "JILWCFHelper.h"
#import "JILBase.h"
#import "JILHTTPURLConnection.h"

@implementation JILDTResponse {
	NSMutableDictionary *_dict;
}

- (id) init
{
	self = [super init];
	if(self) {
		_dict = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (id) initWithData:(NSData *) data
{
	self = [super init];
	if(self) {
		assert(data);
		NSError *error = nil;
		_dict = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&error];
		if(_dict) {
			[_dict retain];
			NSNumber *rcode = (NSNumber *) [_dict objectForKey:@"ResultCode"];
			if(rcode) {
				_resultCode = [rcode intValue];
				_isSuccessful = _resultCode < 100;
			} else {
				_resultCode = JILDTRESPONSE_RESULTCODE_WRONGDATA;
				self.errorMessage = @"ResultCode is Missing";
				_isSuccessful = NO;
			}
			
		} else {
			_dict = [[NSMutableDictionary alloc] init];
			_isSuccessful = NO;
			_resultCode = JILDTRESPONSE_RESULTCODE_WRONGDATA;
			self.errorMessage = error.localizedDescription;
		}
	}
	return self;
}

- (id) initWithStatusCode:(int) statusCode
{
	self = [super init];
	if(self) {
		_dict = [[NSMutableDictionary alloc] init];
		_isSuccessful = NO;
		_resultCode = JILDTRESPONSE_RESULTCODE_NETWORKERROR;
		_errorMessage = [[NSString alloc] initWithFormat:@"Status Code: %d", statusCode];
	}
	return self;
}

- (id) initWithStatusCode:(int) statusCode data:(NSData *) data
{
	self = [super init];
	if(self) {
		if(statusCode != 200) {
			_isSuccessful = NO;
			_resultCode = JILDTRESPONSE_RESULTCODE_NETWORKERROR;
			_errorMessage = [[NSString alloc] initWithFormat:@"Status Code: %d", statusCode];
		} else if(data) {
			NSError *error = nil;
			_dict = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&error];
			if(_dict) {
				[_dict retain];
				NSNumber *rcode = (NSNumber *) [_dict objectForKey:@"ResultCode"];
				if(rcode) {
					_resultCode = [rcode intValue];
					_isSuccessful = _resultCode < 100;
				} else {
					_resultCode = JILDTRESPONSE_RESULTCODE_WRONGDATA;
					self.errorMessage = @"ResultCode is Missing";
					_isSuccessful = NO;
				}
			} else {
				_dict = [[NSMutableDictionary alloc] init];
				_isSuccessful = NO;
				_resultCode = JILDTRESPONSE_RESULTCODE_WRONGDATA;
				self.errorMessage = error.localizedDescription;
			}
		}
	}
	return self;
}

- (void) dealloc
{
	[_errorMessage release];
	[_dict release];
	[super dealloc];
}

- (id) valueForKey:(NSString *) key
{
	return _dict ? [_dict objectForKey:key] : nil;
}

- (NSString *) stringValueForKey:(NSString *) key
{
	return (NSString *) [self valueForKey:key];
}

- (NSArray *) arrayValueForKey:(NSString *) key
{
	return (NSArray *) [self valueForKey:key];
}

- (NSInteger) intValueForKey:(NSString *) key
{
	return [(NSNumber *) [self valueForKey:key] intValue];
	
}

- (NSString *) lastUpdateTime
{
	return [self stringValueForKey:@"LastUpdateTime"];
}

- (NSString *) downloadFile
{
	return [self stringValueForKey:@"DownloadFile"];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
	[_dict setValue:value forKey:key];
}
@end


@implementation NSMutableURLRequest (JILMSWCF)
+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
{
	return [NSMutableURLRequest POSTRequestToWCFServiceAtURL:url
												withJSONData:nil];
}

+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
												method:(NSString *) method
											 JSONParam:(id) param
{
	return [NSMutableURLRequest
			POSTRequestToWCFServiceAtURL:[url stringByAppendingPathComponent:method]
			withJSONData:param ? [param JSONData] : nil];
}

+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
										  withJSONData:(NSData *) data
{
	NSMutableURLRequest *r = [NSMutableURLRequest POSTRequestToURL:url];
	[r setValue:@"application/json" forHTTPHeaderField:@"Accept"];
	[r setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	if(data) {
		[r setHTTPBody:data];
		[r setValue:[NSString stringFromInt:data.length]forHTTPHeaderField:@"Content-Length"];
	}
	return r;
}

+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
												method:(NSString *) method
										  withJSONData:(NSData *) data
{
	return [NSMutableURLRequest
			POSTRequestToWCFServiceAtURL:[url stringByAppendingPathComponent:method]
			withJSONData:data];
}
@end

@implementation JILWCFHelper
+ (JILDTResponse *) responseFromWCFServiceAtURL:(NSString *) url
										 method:(NSString *) method
										 params:(NSDictionary *) params
{
	return [JILWCFHelper responseFromRequest:[NSMutableURLRequest POSTRequestToWCFServiceAtURL:url method:method JSONParam:params]];
}

+ (JILDTResponse *) responseFromRequest:(NSURLRequest *) request
{
	JILHTTPURLConnection *conn = [[[JILHTTPURLConnection alloc]
								   initWithRequest:request] autorelease];
	NSData *data = nil;
	if(conn) {
		JILDEBUG(@"Call Remote Service With Request %@", request.requestDescription);
		[conn start];
		[conn waitForResponse];
		data = conn.responseData;
	}
	JILDEBUG(@"Get Response %@ status code %d", data ? data.UTF8String : @"<EMPTY RESPONSE>", conn.responseStatusCode);
	return [[[JILDTResponse alloc] initWithStatusCode:conn.responseStatusCode
												 data:data] autorelease];
}

+ (NSData *) dataFromRequest:(NSURLRequest *) request
{
	JILHTTPURLConnection *conn = [[[JILHTTPURLConnection alloc]
								   initWithRequest:request] autorelease];
	NSData *data = nil;
	if(conn) {
		JILDEBUG(@"Call Remote Service With Request %@", request.requestDescription);
		[conn start];
		[conn waitForResponse];
		data = conn.responseData;
	}
	JILDEBUG(@"Get Response %@ status code %d", data ? data.UTF8String : @"<EMPTY RESPONSE>", conn.responseStatusCode);
	return data;
}
@end
