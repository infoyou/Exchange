//
//  FTPClientSyn.h
//  IOSLib
//
//  Created by user on 13-3-11.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JILFTPUpload : NSObject
+ (BOOL) uploadFile:(NSString *) localFile
	   toRemoteFile:(NSString *) remoteFile;
+ (BOOL) uploadFile:(NSString *) localFile
	   toRemoteDir:(NSString *) remoteDir;
- (id) initWithLocalFile:(NSString *) localFile
			  remoteFile:(NSString *) remoteFile;
- (id) initWithLocalFile:(NSString *) localFile
			   remoteDir:(NSString *) remoteDir;
- (BOOL) uploadSynchronizedly;
@end