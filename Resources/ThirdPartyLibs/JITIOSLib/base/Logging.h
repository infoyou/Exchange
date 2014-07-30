//
//  Logging.h
//  cpos
//
//  Created by user on 13-1-28.
//  Copyright (c) 2013年 jit. All rights reserved.
//
#import "DDLog.h"
#import "DDFileLogger.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

#define JITLOG(log_func, level_tag, fmt, ...) log_func(@"[%@][%@:%i]: " fmt, level_tag, @__FILE__.lastPathComponent, __LINE__, ##__VA_ARGS__)

#define LOGINFO(fmt,...) JITLOG(DDLogInfo, @" INFO", fmt, ##__VA_ARGS__)
#define LOGWARNING(fmt,...) JITLOG(DDLogWarn, @" WARN", fmt, ##__VA_ARGS__)
#define LOGERROR(fmt,...) JITLOG(DDLogError, @"ERROR", fmt, ##__VA_ARGS__)
#define LOGEXCP(fmt, excp, ...) LOGERROR(@"Exception <Class: %@><Name: %@><Reason: %@> " fmt, excp.class, excp.name, excp.reason, ##__VA_ARGS__)

#ifdef DEBUG
#define LOGDEBUG(fmt,...) JITLOG(DDLogVerbose, @"DEBUG", fmt, ##__VA_ARGS__)
#else
#define LOGDEBUG(fmt,...)
#endif

int ddLogLevel;

void configLumberjack(int level);
