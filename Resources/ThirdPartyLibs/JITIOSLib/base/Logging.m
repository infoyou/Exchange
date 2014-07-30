//----------------------------------------------------------------------------//
// Logger.m
// Created by Xie Chenghao On 2012-11-12
#import "Logging.h"

int ddLogLevel;

void configLumberjack(int level)
{
	ddLogLevel = level;
	/*if(mFileLogger) {
		[DDLog removeAllLoggers];
		[mFileLogger release];
	}
	mFileLogger = [[DDFileLogger alloc] init];
	mFileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
	mFileLogger.logFileManager.maximumNumberOfLogFiles = 5;
	
	[DDLog addLogger:mFileLogger];*/
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
}
//----------------------------------END---------------------------------------//
