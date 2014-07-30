//
//  FileDownload.m
//  cpos
//
//  Created by user on 13-1-24.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "JILURLDownload.h"
#import "JILBase.h"
#import "NSNotification+JILNetwork.h"

@interface JILURLDownload () <NSURLConnectionDataDelegate>

@end

@implementation JILURLDownload {
	NSString *_url;
	NSError *_error;
	NSOutputStream *_output;
}

- (id) initWithURL:(NSString *) url
			   dir:(NSString *) dir
{
	assert(url);
	assert(dir);
	self = [super init];
	if(self) {
		_url = [url  copy];
		_localfile = [[dir stringByAppendingPathComponent:[url lastPathComponent]] retain];
		_error = nil;
		_output = nil;
		self.remoteFileSize = 0;
		self.receivedDataLength = 0;
		self.finished = NO;
	}
	return self;
}

- (id) initWithURL:(NSString *) url
		 localFile:(NSString *) localfile
{
	assert(url);
	assert(localfile);
	self = [super init];
	if(self) {
		_url = [url  copy];
		_localfile = [localfile copy];
		_error = nil;
		_output = nil;
		self.remoteFileSize = 0;
		self.receivedDataLength = 0;
		self.finished = NO;
	}
	return self;
}

- (void) dealloc
{
	[_url release];
	[_localfile release];
	[_error release];
	[super dealloc];
}
- (NSError *) error
{
	return _error;
}

- (NSUInteger) fileSizeInKB
{
	return self.remoteFileSize/1024;
}

- (NSUInteger) downloadedLengthInKB
{
	return self.receivedDataLength/1024;
}

- (BOOL) downloadSynchronizedlly
{
	JILDEBUG(@"Download from \"%@\" to \"%@\"", _url, _localfile);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
	if(request == nil || ![NSURLConnection canHandleRequest:request]) {
	JILDEBUG(@"[FileDownload] Invalid or unsupproted URL");
		[self stopWithError:[NSError errorWithDomain:@"CPOSNetwork" code:2 userInfo:nil]];
		return NO;
	}
	_output = [[NSOutputStream alloc] initToFileAtPath:_localfile append:NO];
	[_output open];
	NSURLConnection *conn = [NSURLConnection  connectionWithRequest:request
														   delegate:self];
	if(!conn) {
		JILERROR(@"Failed to create connection");
		[self stopWithError:[NSError errorWithDomain:@"CPOSNetwork" code:2 userInfo:nil]];
		return NO;
	}
	[self waitForFinishingLoading];
    
	return _error == nil;
}

- (BOOL) downloadAsynchronizedlly {
    JILDEBUG(@"Download from \"%@\" to \"%@\"", _url, _localfile);
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
	if(request == nil || ![NSURLConnection canHandleRequest:request]) {
        JILDEBUG(@"[FileDownload] Invalid or unsupproted URL");
		[self stopWithError:[NSError errorWithDomain:@"CPOSNetwork" code:2 userInfo:nil]];
		return NO;
	}
	_output = [[NSOutputStream alloc] initToFileAtPath:_localfile append:NO];
	[_output open];
    
    NSOperationQueue *quene = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:quene
                           completionHandler:^(NSURLResponse* response, NSData * data, NSError* error){
                               if (error) {
                                   JILERROR(@"Failed with error \"%@\"", [error localizedDescription]);
                                   [self stopWithError:error];
                               }else {
                                   self.receivedDataLength += data.length;
                                   if([self writeData:data toStream:_output] == NO) {
                                       JILERROR(@"[FileDownload] Error when writing local file");
                                   }
                                   [NSNotificationCenter postNotification:JILNOTIFICATION_NETWORK sender:self];
                               }
                           }];
	[self waitForFinishingLoading];
    
	return _error == nil;
}

- (void) waitForFinishingLoading
{
	while (_output) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}

- (float) downloadProgress
{
	return self.remoteFileSize == 0 ? 0 : ((float) self.receivedDataLength / self.remoteFileSize) *100;
}

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error
{
	JILERROR(@"Failed with error \"%@\"", [error localizedDescription]);
	[self stopWithError:error];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)data
{
	self.receivedDataLength += data.length;
	if([self writeData:data toStream:_output] == NO) {
		JILERROR(@"[FileDownload] Error when writing local file");
	}
	[NSNotificationCenter postNotification:JILNOTIFICATION_NETWORK sender:self];
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection
{
	JILDEBUG(@"Finish Loading");
	[self stopWithError:nil];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	JILDEBUG(@"Get Response %@ %lld", [response description], response.expectedContentLength);
	self.remoteFileSize = response.expectedContentLength;
}

- (void) stopWithError:(NSError *) error
{
	self.finished = YES;
	if(error) {
		[_error release];
		_error = [error copy];
	}
	if(_output) {
		[_output close];
		[_output release];
		_output = nil;
	}
	[NSNotificationCenter postNotification:JILNOTIFICATION_NETWORK sender:self];
}

- (BOOL) writeData:(NSData *) data toStream:(NSOutputStream *) stream
{
    NSUInteger      dataLength;
    const uint8_t * dataBytes;
    NSInteger       bytesWritten;
    NSUInteger      bytesWrittenSoFar;
    
    dataLength = [data length];
    dataBytes  = [data bytes];
	
    bytesWrittenSoFar = 0;
    do {
        bytesWritten = [stream write:&dataBytes[bytesWrittenSoFar]
						   maxLength:dataLength - bytesWrittenSoFar];
        if (bytesWritten <= 0) {
            return NO;
        } else {
            bytesWrittenSoFar += (NSUInteger) bytesWritten;
        }
    } while (bytesWrittenSoFar != dataLength);
	return YES;
}

@end
