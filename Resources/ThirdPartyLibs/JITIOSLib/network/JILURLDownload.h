//
//  FileDownload.h
//  cpos
//
//  Created by user on 13-1-24.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JILURLDownload : NSObject
@property (nonatomic, readonly) NSString *localfile;
@property (nonatomic) long long remoteFileSize;
@property (nonatomic) long long receivedDataLength;
@property (nonatomic) BOOL finished;

//@property (nonatomic)
- (id) initWithURL:(NSString *) url
			   dir:(NSString *) dir;
- (id) initWithURL:(NSString *) url
		 localFile:(NSString *) localfile;
- (NSError *) error;
- (BOOL) downloadSynchronizedlly;
- (BOOL) downloadAsynchronizedlly;
- (float) downloadProgress;
- (NSUInteger) fileSizeInKB;
- (NSUInteger) downloadedLengthInKB;
@end
