// Show full path of filename?
#define DEBUG_SHOW_FULLPATH YES
 
// Enable debug (NSLog) wrapper code?
#define DEBUG 1
  
@interface WXWDebugLogOutput : NSObject {
  @private
  NSString *_crashContent;
  
  NSString *_errorContent;
  
  NSString *_noSuffixErrorFileName;
  
  NSString *_noSuffixCrashFileName;
  
  NSInteger _logType;
}
+ (WXWDebugLogOutput *) instance;
- (void)output:(char*)fileName 
    lineNumber:(int)lineNumber
         input:(NSString*)input, ...;

- (void)outputCrash:(char*)fileName
         lineNumber:(int)lineNumber 
              input:(NSString*)input;
@end

#define debugLog(format,...) [[WXWDebugLogOutput instance] output:__FILE__ lineNumber:__LINE__ input:(format), ##__VA_ARGS__]

#define crashLog(CRASH_CONTENT) [[WXWDebugLogOutput instance] outputCrash:__FILE__ lineNumber:__LINE__ input:CRASH_CONTENT]
