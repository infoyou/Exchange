//----------------------------------------------------------------------------//
// Logger.h
// Created by Xie Chenghao On 2012-09-06
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#ifdef JIL_USING_NSLOG
#define JILLOG(log_func, level_tag, fmt, ...) NSLog(@"[%@][%@:%i]: " fmt, level_tag, @__FILE__.lastPathComponent, __LINE__, ##__VA_ARGS__)
#else
#define JILLOG(log_func, level_tag, fmt, ...) log_func(@"[%@][%@:%i]: " fmt, level_tag, @__FILE__.lastPathComponent, __LINE__, ##__VA_ARGS__)
#endif

#define JILINFO(fmt,...) JILLOG(DDLogInfo, @" INFO", fmt, ##__VA_ARGS__)
#define JILWARN(fmt,...) JILLOG(DDLogWarn, @" WARN", fmt, ##__VA_ARGS__)
#define JILERROR(fmt,...) JILLOG(DDLogError, @"ERROR", fmt, ##__VA_ARGS__)
#define JILEX(fmt, excp, ...) JILERROR(@"Exception <Class: %@><Name: %@><Reason: %@> " fmt, excp.class, excp.name, excp.reason, ##__VA_ARGS__)

#ifdef DEBUG
#define JILDEBUG(fmt,...) JILLOG(DDLogVerbose, @"DEBUG", fmt, ##__VA_ARGS__)
#else
#define JILDEBUG(fmt,...)
#endif

int ddLogLevel;

@interface JILLoggingCofiguration : NSObject
- (void) configLumberjack: (int) level;
- (void) printLogFileInfos;
@end
//----------------------------------END---------------------------------------//
