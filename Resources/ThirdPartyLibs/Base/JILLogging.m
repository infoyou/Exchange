//----------------------------------------------------------------------------//
// Logger.m
// Created by Xie Chenghao On 2012-11-12
#import "JILLogging.h"

int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation JILLoggingCofiguration {
	DDFileLogger *_fileLogger;
}

- (void) configLumberjack: (int) level {
	ddLogLevel = level;
	if(!_fileLogger) {
		_fileLogger = [[DDFileLogger alloc] init];
		_fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
		_fileLogger.logFileManager.maximumNumberOfLogFiles = 5;
		[DDLog addLogger:_fileLogger];
		[DDLog addLogger:[DDTTYLogger sharedInstance]];
	}
}

- (void) dealloc
{
	[_fileLogger release];
	[super dealloc];
}

- (void) printLogFileInfos
{
	NSLog(@"Log Directory %@", [_fileLogger.logFileManager logsDirectory]);
	NSArray *files = [_fileLogger.logFileManager sortedLogFileInfos];
	for(DDLogFileInfo *f in files) {
		NSLog(@"Log files %@, %@", f.fileName, f.creationDate);
	}
}
@end

//----------------------------------END---------------------------------------//
