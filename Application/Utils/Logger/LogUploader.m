//
//  LogUploader.m
//  Project
//
//  Created by XXX on 13-12-3.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "LogUploader.h"
#import "FileUtils.h"
#import "LogUploader.h"
#import <CrashReporter/CrashReporter.h>
#import "CommonUtils.h"
#import "WXWDebugLogOutput.h"
#import "UIDevice+Hardware.h"
#import "WXWSyncConnectorFacade.h"
#import "AppManager.h"
#import "ZipFile.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"
#import "FileInZipInfo.h"

#define MAX_ONCE_UPLOAD_FILE_COUNT    3
#define MAX_UPLOAD_LOOP_COUNT               2

#define IPHONE_3G_UPLOAD_LOOP_COUNT   1
#define IPHONE_3GS_UPLOAD_LOOP_COUNT  2

#define LOG_FOLDER [[CommonUtils documentsDirectory] stringByAppendingFormat:@"/log"]

@interface LogUploader()
@property (nonatomic, copy) NSString *currentHourTime;
@property (nonatomic, copy) NSString *deviceModel;
@property (nonatomic, copy) NSString *firstUploadedFileName;
@property (nonatomic, retain) NSMutableArray *beDeletedFiles;
@end

@implementation LogUploader

@synthesize currentHourTime = _currentHourTime;
@synthesize deviceModel = _deviceModel;
@synthesize firstUploadedFileName = _firstUploadedFileName;
@synthesize beDeletedFiles = _beDeletedFiles;

#pragma mark - lifecycle methods
- (id)init {
    self = [super init];
    if (self) {
        self.deviceModel = [CommonUtils deviceModel];
    }
    
    return self;
}

- (void)dealloc {
    
    self.beDeletedFiles = nil;
    
    self.deviceModel = nil;
    self.firstUploadedFileName = nil;
    NSLog(@"log uploader released");
    [super dealloc];
}

#pragma mark - entrance point
- (void)triggerUpload {
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    // if no need to continue, the auto release pool will be drained
    [self uploadCrashLogFileIfExisting];
    
    [self uploadErrorLogFileIfExisting];
    
    RELEASE_OBJ(pool);
}

#pragma mark - error log file handlers
- (void)parserResultAndDeleteUploadedLogFiles:(NSData *)data {
    
    if (nil == data || [data length] == 0) {
        return;
    }
    
    NSString *res = [[[NSString alloc] initWithData:data
                                           encoding:NSUTF8StringEncoding] autorelease];
    BOOL ret = [res isEqualToString:[NSString stringWithFormat:@"%d", HTTP_RESP_OK]];
    
    if (ret) {
        NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager];
        for (NSString *logFilePath in self.beDeletedFiles) {
            
            // delete log file
            if (![fm removeItemAtPath:logFilePath error:&error]) {
                debugLog(@"Delete old log file(%@) failed, error: %@", logFilePath, [error localizedDescription]);
            }
            
            // delete .zip file
            NSString *zipFilePath = [logFilePath stringByReplacingOccurrencesOfString:LOG_SUFFIX
                                                                           withString:ZIP_SUFFIX];
            [fm removeItemAtPath:zipFilePath error:nil];
        }
    }
}

- (void)uploadLogFile:(NSArray *)sortedFiles
        logFolderPath:(NSString *)logFolderPath {
    
    NSInteger count = 0;
    NSMutableString *contents = [[[NSMutableString alloc] init] autorelease];
    
    NSInteger fileCount = sortedFiles.count;
    
    for (NSString *logFile in sortedFiles) {
        
        if ([logFile rangeOfString:ERROR_LOG_PREFIX].length <= 0) {
            continue;
        }
        
        
        if (_uploadLoopCount == MAX_UPLOAD_LOOP_COUNT) {
            break;
        }
        
        // iphone 3G and 1G only upload log once in application lifecycle
        if ((([IPHONE_3G_NAMESTRING isEqualToString:self.deviceModel] ||
              [IPHONE_1G_NAMESTRING isEqualToString:self.deviceModel]) &&
             _uploadLoopCount == IPHONE_3G_UPLOAD_LOOP_COUNT)) {
            break;
        }
        
        // iphone 3GS only upload log twice in application lifecycle
        if (([IPHONE_3GS_NAMESTRING isEqualToString:self.deviceModel] &&
             _uploadLoopCount == IPHONE_3GS_UPLOAD_LOOP_COUNT)) {
            break;
        }
        
        // iphone 4 and iphone 5 no limitation for upload loop count
        NSArray *components = [logFile componentsSeparatedByString:LOG_DATE_SEPARATOR];
        if (components && [components count] > 0) {
            
            NSString *logTime = nil;
            
            NSString *debugInfoStr = components[0];
            NSArray *debugInfoList = [debugInfoStr componentsSeparatedByString:LOG_DEBUG_SEPARATOR];
            if (debugInfoList.count == 2) {
                logTime = debugInfoList[1];
            } else {
                continue;
            }
            
            NSComparisonResult res = [self.currentHourTime caseInsensitiveCompare:logTime];
            //            if (NSOrderedDescending == res)
            if(1)
            {
                NSError *error;
                NSString *logContent = [NSString stringWithContentsOfFile:[logFolderPath stringByAppendingFormat:@"/%@",
                                                                           logFile]
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:&error];
                if (nil == logContent) {
                    if (error) {
                        debugLog(@"Read log file(%@) failed due to", [error localizedDescription]);
                        continue;
                    }
                } else {
                    if (nil == self.beDeletedFiles) {
                        self.beDeletedFiles = [NSMutableArray array];
                    }
                    [self.beDeletedFiles addObject:[logFolderPath stringByAppendingFormat:@"/%@", logFile]];
                    [contents appendString:[NSString stringWithFormat:@"\n%@", logContent]];
                    
                    if (0 == count) {
                        self.firstUploadedFileName = logFile;
                    }
                    count++;
                }
            }
        }
        
        // 1. once upload 3 log files
        // 2. if file count less than 3 but there are some log still need be uploaded, then upload the log files
        if (count >= MAX_ONCE_UPLOAD_FILE_COUNT ||
            (fileCount < MAX_ONCE_UPLOAD_FILE_COUNT && self.beDeletedFiles) ||
            (count == (fileCount - 1) && fileCount == MAX_ONCE_UPLOAD_FILE_COUNT))
        {
            
            WXWSyncConnectorFacade *syncConn = [[[WXWSyncConnectorFacade alloc] init] autorelease];
            
            NSData *data = nil;
            
            NSString *beUploadedZipFileName = nil;
            NSError *error = nil;
            
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[LOG_FOLDER stringByAppendingPathComponent:self.firstUploadedFileName]
                                                                                        error:&error];
            NSDate *date = attributes[NSFileCreationDate];
            
            
            beUploadedZipFileName = [self.firstUploadedFileName stringByReplacingOccurrencesOfString:LOG_SUFFIX withString:ZIP_SUFFIX];
            
            NSString *zipFilePath = [logFolderPath stringByAppendingPathComponent:beUploadedZipFileName];
            ZipFile *zipFile = [[[ZipFile alloc] initWithFileName:zipFilePath
                                                             mode:ZipFileModeCreate] autorelease];
            
            ZipWriteStream *writeStream = [zipFile writeFileInZipWithName:self.firstUploadedFileName
                                                                 fileDate:date
                                                         compressionLevel:ZipCompressionLevelBest];
            [writeStream writeData:[contents dataUsingEncoding:NSUTF8StringEncoding]];
            [writeStream finishedWriting];
            
            [zipFile close];
            
            data = [NSData dataWithContentsOfFile:[LOG_FOLDER stringByAppendingPathComponent:beUploadedZipFileName]];
            
            NSDictionary *dic = nil;
            dic = @{@"action": @"error_upload",
                    @"plat": @"i",
                    @"type": @"Fosun"};
            
            NSData *res = [syncConn uploadLogData:dic data:data logFileName:beUploadedZipFileName];
            [self parserResultAndDeleteUploadedLogFiles:res];
            
            _uploadLoopCount++;
            fileCount -= count;
            count = 0;
        }
    }
}

- (void)uploadErrorLogFileIfExisting {
    NSString *docDir = [CommonUtils documentsDirectory];
    NSString *logFolderPath = [docDir stringByAppendingFormat:@"/%@", LOG];
    
    self.currentHourTime = [CommonUtils currentHourTime];
    
	NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *fileEnumerator = [fm enumeratorAtPath:logFolderPath];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:nil
                                                                     ascending:NO
                                                                      selector:@selector(localizedCompare:)];
    NSArray *sortedFiles = [fileEnumerator.allObjects sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // upload error log files
    [self uploadLogFile:sortedFiles logFolderPath:logFolderPath];
    
    /*
     // upload remained crash log files
     self.beDeletedFiles = nil;
     fileEnumerator = [fm enumeratorAtPath:logFolderPath];
     sortedFiles = [fileEnumerator.allObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
     [self uploadCrashFile:sortedFiles];
     */
    
    self.currentHourTime = nil;
}

#pragma mark - crash log file handlers
- (void)finishCrashLogUpload {
    [[PLCrashReporter sharedReporter] purgePendingCrashReport];
}

- (NSString *)parserCrashLogFile {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    NSError *error;
    NSData *crashData = [NSData dataWithData:[crashReporter loadPendingCrashReportDataAndReturnError:&error]];
    if (nil == crashData) {
        debugLog(@"Could not load crash report: %@", error);
        
        [self finishCrashLogUpload];
        return nil;
    }
    
    // decode data
    PLCrashReport *crashLog = [[[PLCrashReport alloc] initWithData:crashData
                                                             error:&error] autorelease];
    if (nil == crashLog) {
        [self finishCrashLogUpload];
        return nil;
    }
    
    // map to Apple OS
    const char *osName;
    switch (crashLog.systemInfo.operatingSystem) {
        case PLCrashReportOperatingSystemiPhoneOS:
			osName = "iPhone OS";
			break;
		case PLCrashReportOperatingSystemiPhoneSimulator:
			osName = "Mac OS X";
			break;
		default:
			osName = "iPhone OS";
			break;
    }
    
    // map to Apple code type
    NSString *codeType = nil;
    /* Header */
    boolean_t lp64;
    switch (crashLog.systemInfo.architecture)
    {
        case PLCrashReportArchitectureARM:
            codeType = @"armv6";
            lp64 = false;
            break;
            
        case PLCrashReportArchitectureX86_32:
            codeType = @"X86";
            lp64 = true;
            break;
            
        case PLCrashReportArchitectureX86_64:
            codeType = @"X86-64";
            lp64 = false;
            break;
            
        case PLCrashReportArchitecturePPC:
            codeType = @"PPC";
            lp64 = false;
            break;
            
        case PLCrashReportArchitectureARMv7:
            codeType = @"armv7";
            lp64 = false;
            break;
            
        default:
            codeType = @"ARM (Native)";
            lp64 = false;
            break;
    }
    
    NSString *uuid = nil;
    CFUUIDRef theUUID = CFUUIDCreate(kCFAllocatorDefault);
    if (theUUID) {
        uuid = NSMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, theUUID));
    }
	
	NSMutableString *xmlString = [NSMutableString string];
    [xmlString appendFormat:@"Incident Identifier: %@\n", uuid];
	
    [xmlString appendFormat:@"CrashReporter Key:   %@\n", @"17008267d813d5ffed53f3e05fc2209c32ffb1de"];
    
    [xmlString appendFormat:@"Hardware Model:       %@,%@\n", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]];
	
    [xmlString appendFormat:@"Process:         %@ [%d]\n", crashLog.processInfo.processName, crashLog.processInfo.processID];
	
    [xmlString appendFormat:@"Path:            %@\n", crashLog.processInfo.processPath];
    
    [xmlString appendFormat:@"Identifier:      %@\n", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
    
    [xmlString appendFormat:@"Version:         %@\n", crashLog.applicationInfo.applicationVersion];
    
    [xmlString appendFormat:@"Code Type:       %@\n", codeType];
	
    [xmlString appendFormat:@"Parent Process:  %@ [%d]\n", crashLog.processInfo.parentProcessName, crashLog.processInfo.parentProcessID];
	
    [xmlString appendFormat:@"\n"];
    
    // System info
    [xmlString appendFormat:@"Date/Time:       %s\n", [[crashLog.systemInfo.timestamp description] UTF8String]];
    
    [xmlString appendFormat:@"OS Version:      %s %s\n", osName, [crashLog.systemInfo.operatingSystemVersion UTF8String]];
    
    [xmlString appendFormat:@"Report Version:  104\n"];
	
    [xmlString appendFormat:@"\n"];
	
    // Exception code
    [xmlString appendFormat:@"Exception Type:  %s\n", [crashLog.signalInfo.name UTF8String]];
    
    [xmlString appendFormat:@"Exception Codes: %@ at 0x%" PRIx64 "\n", crashLog.signalInfo.code, crashLog.signalInfo.address];
	
	for (PLCrashReportThreadInfo *thread in crashLog.threads) {
		if (thread.crashed) {
            [xmlString appendFormat:@"Crashed Thread:  %ld\n", (long)thread.threadNumber];
			break;
		}
	}
	
    [xmlString appendFormat:@"\n"];
    
    if (crashLog.hasExceptionInfo) {
        [xmlString appendString:@"Application Specific Information:\n"];
        [xmlString appendFormat:@"*** Terminating app due to uncaught exception '%@', reason: '%@'\n",
         crashLog.exceptionInfo.exceptionName, crashLog.exceptionInfo.exceptionReason];
        [xmlString appendString:@"\n"];
    }
	
    // Threads
    PLCrashReportThreadInfo *crashed_thread = nil;
	for (PLCrashReportThreadInfo *thread in crashLog.threads) {
		if (thread.crashed) {
            [xmlString appendFormat:@"Thread %ld Crashed:\n", (long)thread.threadNumber];
            
            crashed_thread = thread;
        } else {
            [xmlString appendFormat:@"Thread %ld:\n", (long)thread.threadNumber];
        }
        
		for (NSUInteger frame_idx = 0; frame_idx < [thread.stackFrames count]; frame_idx++) {
			PLCrashReportStackFrameInfo *frameInfo = (thread.stackFrames)[frame_idx];
			PLCrashReportBinaryImageInfo *imageInfo;
			
            // Base image address containing instrumention pointer, offset of the IP from that base
            // address, and the associated image name
			uint64_t baseAddress = 0x0;
			uint64_t pcOffset = 0x0;
			NSString *imageName = @"\?\?\?";
			
			imageInfo = [crashLog imageForAddress:frameInfo.instructionPointer];
			if (imageInfo != nil) {
				imageName = [imageInfo.imageName lastPathComponent];
				baseAddress = imageInfo.imageBaseAddress;
				pcOffset = frameInfo.instructionPointer - imageInfo.imageBaseAddress;
			}
			
            [xmlString appendFormat:@"%-4ld%-36s0x%08" PRIx64 " 0x%" PRIx64 " + %" PRId64 "\n", (long)frame_idx, imageName.UTF8String, frameInfo.instructionPointer, baseAddress, pcOffset];
		}
        [xmlString appendFormat:@"\n"];
	}
    
    /* Registers */
    if (crashed_thread != nil)
    {
        [xmlString appendFormat:@"Thread %ld crashed with %@ Thread State:\n", (long)crashed_thread.threadNumber, codeType];
        
        int regColumn = 1;
        for (PLCrashReportRegisterInfo *reg in crashed_thread.registers)
        {
            NSString *reg_fmt;
            
            /* Use 32-bit or 64-bit fixed width format for the register values */
            if (lp64)
                reg_fmt = @"%6s:\t0x%016" PRIx64 " ";
            else
                reg_fmt = @"%6s:\t0x%08" PRIx64 " ";
            
            [xmlString appendFormat:reg_fmt, [reg.registerName UTF8String], reg.registerValue];
            
            if (regColumn % 4 == 0)
                [xmlString appendString:@"\n"];
            regColumn++;
        }
        
        if (regColumn % 3 != 0)
            [xmlString appendString:@"\n"];
        
        [xmlString appendString:@"\n"];
    }
	
    // Images
    [xmlString appendFormat:@"Binary Images:\n"];
    
	for (PLCrashReportBinaryImageInfo *imageInfo in crashLog.images) {
		NSString *uuid;
        // Fetch the UUID if it exists
		if (imageInfo.hasImageUUID) {
			uuid = imageInfo.imageUUID;
        } else {
			uuid = @"???";
        }
        
        // base_address - terminating_address file_name identifier (<version>) <uuid> file_path
        [xmlString appendFormat:@"0x%" PRIx64 " - 0x%" PRIx64 "  %s %@ <%s> %s\n",
         imageInfo.imageBaseAddress,
         imageInfo.imageBaseAddress + imageInfo.imageSize,
         [[imageInfo.imageName lastPathComponent] UTF8String],
         codeType,
         [uuid UTF8String],
         [imageInfo.imageName UTF8String]];
        
	}
	
	if ([xmlString length] == 0) {
		xmlString = [NSMutableString stringWithFormat:@"Memory Warning!"];
	}
    
    CFRelease(theUUID);
    
    return xmlString;
}

- (NSString *)checkIfNeedDebugPrefix:(NSString *)dateString {
    // EC_DEBUG defined in 'Building Settings-->Preprocessor Macros'
    if (EC_DEBUG) {
        dateString = [NSString stringWithFormat:@"DEBUG%@%@", LOG_DEBUG_SEPARATOR, dateString];
    } else {
        dateString = [NSString stringWithFormat:@"%@%@", LOG_DEBUG_SEPARATOR, dateString];
    }
    return dateString;
}

- (void)uploadCrashLog:(NSString *)logContent {
    NSString *userId = [CommonUtils fetchStringValueFromLocal:USER_ID_LOCAL_KEY];
    if (nil == userId || 0 == userId.length) {
        userId = @"0";
    }
    
    NSMutableString *logFileName = [[[NSMutableString alloc] initWithFormat:@"%@%@%@%@_%f_%@_iOS%.1f_APP%@",
                                     CRASH_LOG_PREFIX,
                                     [self checkIfNeedDebugPrefix:[CommonUtils currentHourMinSecondTime]],
                                     LOG_DATE_SEPARATOR,
                                     userId,
                                     [CommonUtils convertToUnixTS:[NSDate date]],
                                     [CommonUtils deviceModel],
                                     [CommonUtils currentOSVersion],
                                     VERSION] autorelease];
    
    [logFileName appendString:CRASH_SUFFIX];
    
    WXWSyncConnectorFacade *syncConn = [[[WXWSyncConnectorFacade alloc] init] autorelease];
    NSData *logData = [logContent dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"length: %d", logData.length);
    
    NSDictionary *dic = nil;
    dic = @{@"action": @"error_upload",
            @"plat": @"i",
            @"type": @"Fosun"};
    
    [syncConn uploadLogData:dic data:logData
                logFileName:logFileName];
}

- (void)uploadCrashLogFileIfExisting {
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    if ([crashReporter hasPendingCrashReport]) {
        NSString *logContent = [self parserCrashLogFile];
        
        if (logContent && logContent.length > 0) {
            [self uploadCrashLog:logContent];
        }
        
        [self finishCrashLogUpload];
    }
}

@end

