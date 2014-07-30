//
//  FTPClientSyn.m
//  IOSLib
//
//  Created by user on 13-3-11.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "JILFTPUpload.h"
#import "JILBase.h"

static const int BUFFER_SIZE = 32768;

@interface JILFTPUpload () <NSStreamDelegate>

@end

@implementation JILFTPUpload {
    uint8_t _buffer[BUFFER_SIZE];
	NSString *_localfile, *_remotefile;
	BOOL _error;
	NSOutputStream *_output;
	NSInputStream *_input;
	size_t _bufferOffset, _bufferLimit;
	size_t _totalWritten;
}

+ (BOOL) uploadFile:(NSString *) localFile
	   toRemoteFile:(NSString *) remoteFile
{
	JILFTPUpload *upload = [[[JILFTPUpload alloc] initWithLocalFile:localFile remoteFile:remoteFile] autorelease];
	return [upload uploadSynchronizedly];
}

+ (BOOL) uploadFile:(NSString *) localFile
		toRemoteDir:(NSString *) remoteDir
{
	JILFTPUpload *upload = [[[JILFTPUpload alloc] initWithLocalFile:localFile remoteDir:remoteDir] autorelease];
	return [upload uploadSynchronizedly];
}

- (id) initWithLocalFile:(NSString *) localFile
			  remoteFile:(NSString *) remoteFile
{
	self = [super init];
	if(self) {
		_remotefile = [remoteFile copy];
		_localfile = [localFile copy];
		_output = nil;
		_input = nil;
	}
	return self;
}

- (id) initWithLocalFile:(NSString *) localFile
			   remoteDir:(NSString *) remoteDir
{
	self = [super init];
	if(self) {
		_remotefile = [[remoteDir stringByAppendingPathComponent:[localFile lastPathComponent]] retain];
		_localfile = [localFile copy];
		_output = nil;
		_input = nil;
	}
	return self;
}

- (void) dealloc
{
	if(_output) {
		[self stopSendWithError:YES];
	}
	[_localfile release];
	[_remotefile release];
	[super dealloc];
}

- (BOOL) uploadSynchronizedly
{
	assert(_localfile);
	assert(_remotefile);
	if(![FileUtils fileExistsAtPath:_localfile]) {
		JILERROR(@"File does not exist at '%@'", _localfile);
		return NO;
	}
	[self startSend];
	[self waitForFinishingSending];
	return !_error;
}

- (void) waitForFinishingSending
{
	while (_output) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}


- (BOOL) isSending
{
    return (_output != nil);
}

- (void) startSend
{
	JILDEBUG(@"Start FTP Upload @'%@' to @'%@'", _localfile, _remotefile);
	_totalWritten = 0;
	_error = NO;
	_input = [[NSInputStream inputStreamWithFileAtPath:_localfile] retain];
	assert(_input != nil);
	[_input open];
	_output = CFBridgingRelease(CFWriteStreamCreateWithFTPURL(NULL, (CFURLRef) [NSURL URLWithString:_remotefile]));
	assert(_output != nil);
	_output.delegate = self;
	[_output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[_output open];
}

- (void) waitForStreamToClose:(CFWriteStreamRef) stream
{
	while (CFWriteStreamGetStatus(stream)
		   != kCFStreamStatusClosed) {
		NSLog(@"waiting for uploading stream to close");
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}
}

- (void) stopSendWithError:(BOOL) error;
{
	JILDEBUG(@"Stop FTP Upload ...%@", error ? @"Failed" : @"OK");
	_error = error;
	if (_input != nil) {
        [_input close];
        _input = nil;
    }
    if (_output != nil) {
        [_output close];
		if(!error)
			[self waitForStreamToClose:(CFWriteStreamRef) _output];
		[_output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _output.delegate = nil;
        _output = nil;
    }
}

- (void) stream: (NSStream *) aStream handleEvent:(NSStreamEvent) eventCode
{
#pragma unused(aStream)
    assert(aStream == _output);
	switch (eventCode) {
        case NSStreamEventOpenCompleted: {
        }break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);     // should never happen for the output stream
        } break;
        case NSStreamEventHasSpaceAvailable: {
            if (_bufferOffset == _bufferLimit) {
                NSInteger   bytesRead;
                bytesRead = [_input read:_buffer maxLength:BUFFER_SIZE];
                if (bytesRead == -1) {
                    [self stopSendWithError:YES];
                } else if (bytesRead == 0) {
                    [self stopSendWithError:NO];
                } else {
                    _bufferOffset = 0;
                    _bufferLimit  = bytesRead;
                }
            }
			
            if (_bufferOffset != _bufferLimit) {
                NSInteger   bytesWritten;
                bytesWritten = [_output write:&_buffer[_bufferOffset] maxLength:_bufferLimit - _bufferOffset];
                assert(bytesWritten != 0);
                if (bytesWritten == -1) {
                    [self stopSendWithError:YES];
                } else {
                    _bufferOffset += bytesWritten;
                }
            }
		} break;
        case NSStreamEventErrorOccurred: {
            [self stopSendWithError:YES];
        } break;
        case NSStreamEventEndEncountered: {
            // ignore
        } break;
        default: {
            assert(NO);
        } break;
    }
}

@end