#import "WXWDebugLogOutput.h"
#import <unistd.h>
#import <sys/stat.h>
#import "WXWCommonUtils.h"
#import "WXWSystemInfoManager.h"
#import "WXWSyncConnectorFacade.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"

#define LOG_FOLDER [[WXWCommonUtils documentsDirectory] stringByAppendingFormat:@"/log"]

enum {
  CRASH_LOG_TY,
  ERROR_LOG_TY,
};

@interface WXWDebugLogOutput()
@property (nonatomic, copy) NSString *crashContent;
@property (nonatomic, copy) NSString *errorContent;
@property (nonatomic, copy) NSString *noSuffixErrorFileName;
@property (nonatomic, copy) NSString *noSuffixCrashFileName;
@end

@implementation WXWDebugLogOutput

@synthesize crashContent = _crashContent;
@synthesize errorContent = _errorContent;
@synthesize noSuffixErrorFileName = _noSuffixErrorFileName;
@synthesize noSuffixCrashFileName = _noSuffixCrashFileName;

static WXWDebugLogOutput *sharedDebugInstance = nil;

/*---------------------------------------------------------------------*/
+ (WXWDebugLogOutput *) instance
{
	@synchronized(self)
	{
		if (sharedDebugInstance == nil)
		{
			sharedDebugInstance = [[self alloc] init];
		}
	}
	return sharedDebugInstance;
}

/*---------------------------------------------------------------------*/
+ (id) allocWithZone:(NSZone *) zone
{
	@synchronized(self)
	{
		if (sharedDebugInstance == nil)
		{
			sharedDebugInstance = [super allocWithZone:zone];
			return sharedDebugInstance;
		}
	}
	return nil;
}

/*---------------------------------------------------------------------*/
- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

/*---------------------------------------------------------------------*/
- (id)retain
{
	return self;
}

/*---------------------------------------------------------------------*/
- (oneway void)release
{
	// No action required...
}

/*---------------------------------------------------------------------*/
- (unsigned)retainCount
{
	return UINT_MAX;  // An object that cannot be released
}

/*---------------------------------------------------------------------*/
- (id)autorelease
{
	return self;
}

/*---------------------------------------------------------------------*/

- (void)saveLogContentToFile:(NSString *)logFileName
               logFolderPath:(NSString *)logFolderPath 
                    fileName:(NSString *)fileName
                  lineNumber:(int)lineNumber
                     content:(NSString *)content {
  // Save stderr so it can be restored.
	int stderrSave = dup(STDERR_FILENO);
  
  NSString *logFilePath = [logFolderPath stringByAppendingPathComponent:logFileName];
  
  freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a", stderr);
  
  // Call NSLog, prepending the filename and line number
  NSLog(@"-------- User ID: %lld | Device: %@ | iOS Version: %.1f | APP Version: %@ --------\nFile:%@ Line:%d %@",
        [WXWSystemInfoManager instance].userId,
        [WXWCommonUtils deviceModel], 
        [WXWCommonUtils currentOSVersion], 
        VERSION, 
        fileName, 
        lineNumber, 
        content);
  //----------------- end of save into file ---------------------	   
  
  // only display the debug info on console in debug model, no need to display it in release mode
#if DEBUG
  //----------------- begin of redirect to console ---------------------
  
  // Flush before restoring stderr
  fflush(stderr);
  
  // Now restore stderr, so new output goes to console.
  dup2(stderrSave, STDERR_FILENO);
  close(stderrSave);
  
  NSLog(@"-------- User ID: %lld | Device: %@ | iOS Version: %.1f | APP Version: %@ --------\nFile:%@ Line:%d %@", 
        [WXWSystemInfoManager instance].userId,
        [WXWCommonUtils deviceModel], 
        [WXWCommonUtils currentOSVersion],
        VERSION, 
        fileName, 
        lineNumber, 
        content);
  //----------------- end of redirect to console ---------------------
#endif
}

- (NSDirectoryEnumerator *)checkLogFolder {
  // Get the log file path
	NSString *docDirectory = [WXWCommonUtils documentsDirectory];
	
	NSFileManager *fm = [NSFileManager defaultManager];
	
	// create log folder if it does not exist
	NSString *logFolderPath = [docDirectory stringByAppendingFormat:@"/log"];
	BOOL isDir = YES;
	if (![fm fileExistsAtPath:logFolderPath 
                isDirectory:&isDir]) {
    
    [fm createDirectoryAtPath:logFolderPath
  withIntermediateDirectories:YES
                   attributes:nil
                        error:nil];
	}

  return [fm enumeratorAtPath:logFolderPath];
}

- (NSString *)parseLogTimestamp:(NSArray *)components {
  
  if (nil == components || 0 == components.count) {
    return nil;
  }

#ifdef DEBUG
  NSString *debugInfoStr = components[0];
  NSArray *debugInfoList = [debugInfoStr componentsSeparatedByString:LOG_DEBUG_SEPARATOR];
  if (debugInfoList.count == 2) {
    return debugInfoList[1];
  } else {
    return nil;
  }
#else
  return components[0];
#endif
  /*
  // WXW_DEBUG defined in 'Building Settings-->Preprocessor Macros'
  if (WXW_DEBUG) {
    NSString *debugInfoStr = components[0];
    NSArray *debugInfoList = [debugInfoStr componentsSeparatedByString:LOG_DEBUG_SEPARATOR];
    if (debugInfoList.count == 2) {
      return debugInfoList[1];
    } else {
      return nil;
    }
  } else {
    return components[0];                         
  }
   */
}

- (NSString *)checkIfNeedDebugPrefix:(NSString *)dateString {
  /*
  // WXW_DEBUG defined in 'Building Settings-->Preprocessor Macros'
  if (WXW_DEBUG) {
    dateString = [NSString stringWithFormat:@"DEBUG%@%@", LOG_DEBUG_SEPARATOR, dateString];
  } else {
    dateString = [NSString stringWithFormat:@"%@%@", LOG_DEBUG_SEPARATOR, dateString];
  }
   */
  
#ifdef DEBUG
  dateString = [NSString stringWithFormat:@"DEBUG%@%@", LOG_DEBUG_SEPARATOR, dateString];
#else
  dateString = [NSString stringWithFormat:@"%@%@", LOG_DEBUG_SEPARATOR, dateString];
#endif
  return dateString;
}

- (void)uploadCrashLog {
  
  NSString *zipFileName = [NSString stringWithFormat:@"%@%@", self.noSuffixCrashFileName, ZIP_SUFFIX];
  
  NSString *zipFilePath = [LOG_FOLDER stringByAppendingPathComponent:zipFileName];
  
  // Upload Crash
  WXWSyncConnectorFacade *syncConn = [[[WXWSyncConnectorFacade alloc] init] autorelease];      
  NSData *data = [syncConn uploadLogData:[NSData dataWithContentsOfFile:zipFilePath] logFileName:zipFileName];
  
  if (nil == data || [data length] == 0) {
    return;
  }

  NSString *res = [[[NSString alloc] initWithData:data 
                                         encoding:NSUTF8StringEncoding] autorelease];
  BOOL ret = [res isEqualToString:[NSString stringWithFormat:@"%d", HTTP_RESP_OK]];
  
  NSFileManager *fm = [NSFileManager defaultManager];
  if (ret) {
    // delete original crash log file if uploaded successfully
    [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@%@", LOG_FOLDER, self.noSuffixCrashFileName, LOG_SUFFIX]
                   error:nil];
  }
  
  // delete .zip file
  [fm removeItemAtPath:zipFilePath
                 error:nil];
}

- (BOOL)saveContentIntoFile:(NSString *)logFile
            currentHourTime:(NSString *)currentHourTime 
               logTimestamp:(NSString *)logTimestamp 
                   fileName:(NSString *)fileName
                 lineNumber:(int)lineNumber {
  
  NSComparisonResult res = [currentHourTime caseInsensitiveCompare:logTimestamp];
  
  if (NSOrderedSame == res) {
    
    NSString *content = nil;
    switch (_logType) {
      case ERROR_LOG_TY:
        content = self.errorContent;
        break;
        
      case CRASH_LOG_TY:
        content = self.crashContent;
        break;
        
      default:
        break;
    }
    
    [self saveLogContentToFile:logFile
                 logFolderPath:LOG_FOLDER
                      fileName:fileName
                    lineNumber:lineNumber
                       content:content];
    
    if (_logType == CRASH_LOG_TY) {
      
      // save into zip file
      [WXWCommonUtils saveToZipFile:[LOG_FOLDER stringByAppendingPathComponent:logFile]
                   logFolderPath:LOG_FOLDER
             zipNoSuffixFileName:self.noSuffixCrashFileName];
      
      // upload crash log with highest priority
      [self uploadCrashLog];
    }
    return YES;
  } 
  return NO;
}

- (BOOL)findExistingLogFileAndSave:(NSString *)currentHourTime
                         logPrefix:(NSString *)logPrefix
                          fileName:(NSString *)fileName
                        lineNumber:(int)lineNumber {
  NSDirectoryEnumerator *fileCountEnumerator = [self checkLogFolder];
  
  NSInteger count = 0;
  
  for (NSString *logFile in fileCountEnumerator) {
    
    if (![logFile hasPrefix:logPrefix]) {
      continue;
    }
    
    count++;
    
    NSString *logTime = nil;
    NSArray *components = [logFile componentsSeparatedByString:LOG_DATE_SEPARATOR];
    if (components && components.count > 0) {
      
      logTime = [self parseLogTimestamp:components];
      
      if (nil == logTime) {
        continue;
      }
            
      // found the crash file, then save content and return;
      if ([self saveContentIntoFile:logFile
                    currentHourTime:currentHourTime
                       logTimestamp:logTime
                           fileName:fileName
                         lineNumber:lineNumber]) {
        return YES;
      }
    }
  }
  
  return NO;
}

- (void)createLogFileAndSave:(NSString *)logPrefix
             currentHourTime:(NSString *)currentHourTime
                    fileName:(NSString *)fileName
                  lineNumber:(int)lineNumber {
  
  NSString *userId = LLINT_TO_STRING([WXWSystemInfoManager instance].userId);
  if (nil == userId || 0 == userId.length) {
    userId = @"0";
  }
  
  
  NSMutableString *logFileName = [[[NSMutableString alloc] initWithFormat:@"%@%@%@%@_%f_%@_iOS%.1f_APP%@",
                            logPrefix,
                            [self checkIfNeedDebugPrefix:currentHourTime],
                            LOG_DATE_SEPARATOR,
                            userId,
                            [WXWCommonUtils convertToUnixTS:[NSDate date]],
                            [WXWCommonUtils deviceModel],
                            [WXWCommonUtils currentOSVersion],
                            VERSION] autorelease];
  
  NSString *content = nil;
  switch (_logType) {
    case ERROR_LOG_TY:
      content = self.errorContent;
      self.noSuffixErrorFileName = logFileName;
      break;
      
    case CRASH_LOG_TY:
      content = self.crashContent;
      self.noSuffixCrashFileName = logFileName;
      break;
      
    default:
      break;
  }
  
  [logFileName appendString:LOG_SUFFIX];
  
  NSString *withSlashLogFileName = [NSString stringWithFormat:@"/%@", logFileName];
  
  [self saveLogContentToFile:withSlashLogFileName
               logFolderPath:LOG_FOLDER
                    fileName:fileName
                  lineNumber:lineNumber
                     content:content];
  
  if (_logType == CRASH_LOG_TY) {
    
    // save into zip file
    [WXWCommonUtils saveToZipFile:[LOG_FOLDER stringByAppendingPathComponent:logFileName]
                 logFolderPath:LOG_FOLDER
           zipNoSuffixFileName:self.noSuffixCrashFileName];
    
    // upload crash log with highest priority
    [self uploadCrashLog];
  }

}

- (void)outputCrash:(char *)fileName
         lineNumber:(int)lineNumber 
              input:(NSString*)input {
  
  _logType = CRASH_LOG_TY;
  
  self.crashContent = input;
  
  //----------------- begin of save into file ---------------------
	// Set permissions for our NSLog file
	umask(022);
	
  NSString *currentHourTime = [WXWCommonUtils currentHourTime];
    
  if ([self findExistingLogFileAndSave:currentHourTime
                             logPrefix:CRASH_LOG_PREFIX
                              fileName:[[[NSString alloc] initWithUTF8String:fileName] autorelease]
                            lineNumber:lineNumber]) {
    return;
  }
  
  [self createLogFileAndSave:CRASH_LOG_PREFIX
             currentHourTime:currentHourTime
                    fileName:[[[NSString alloc] initWithUTF8String:fileName] autorelease]
                  lineNumber:lineNumber];
  
  self.noSuffixCrashFileName = nil;
}

- (void)output:(char*)fileName
    lineNumber:(int)lineNumber 
         input:(NSString*)input, ... {
  
  _logType = ERROR_LOG_TY;
	
	// Process arguments, resulting in a format string
  va_list argList;
	va_start(argList, input);
	self.errorContent = [[[NSString alloc] initWithFormat:input
                                              arguments:argList] autorelease];
	va_end(argList);
		
	//----------------- begin of save into file ---------------------
	// Set permissions for our NSLog file
	umask(022);
  
  NSString *currentHourTime = [WXWCommonUtils currentHourTime];
  
  if ([self findExistingLogFileAndSave:currentHourTime
                             logPrefix:ERROR_LOG_PREFIX
                              fileName:[[[NSString alloc] initWithUTF8String:fileName] autorelease]
                            lineNumber:lineNumber]) {
    return;
  }
  
  [self createLogFileAndSave:ERROR_LOG_PREFIX
             currentHourTime:currentHourTime
                    fileName:[[[NSString alloc] initWithUTF8String:fileName] autorelease]
                  lineNumber:lineNumber];
  
  self.noSuffixErrorFileName = nil;
}

@end