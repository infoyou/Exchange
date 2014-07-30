//
//  FileUtils.m
//  cpos
//
//  Created by user on 13-1-14.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import "FileUtils.h"
#import "JILLogging.h"

static NSString *DOCUMENT_DIR = nil;

@implementation FileUtils

+ (NSString *) pathOfDocumentDir
{
	if(!DOCUMENT_DIR)
		DOCUMENT_DIR = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)
						 objectAtIndex:0] retain];
	
	return DOCUMENT_DIR;
}

+ (NSString *) pathForDocumentFiles:(NSString *) path
{
	return [[self pathOfDocumentDir] stringByAppendingPathComponent:path];
}

+ (BOOL) createFileAt:(NSString *) path withData:(NSData *) data
{
	return [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

+ (BOOL) copyFileAt:(NSString *) path toDir:(NSString *) dir
{
	NSString *newfile = [dir stringByAppendingPathComponent:[path lastPathComponent]];
	JILDEBUG(@"Copying file from %@ to %@", path, newfile);
	return [[NSFileManager defaultManager] copyItemAtPath:path toPath:newfile error:nil];
}

+ (BOOL) createLinkToFileAt:(NSString *) path underDir:(NSString *) dir
{
	NSString *link = [dir stringByAppendingPathComponent:[path lastPathComponent]];
	JILDEBUG(@"Ctreate link %@ of %@", link, path);
	return [[NSFileManager defaultManager] createSymbolicLinkAtPath:link
												withDestinationPath:path error:nil];
}

+ (BOOL) mkdir:(NSString *) path
{
	return [[NSFileManager defaultManager] createDirectoryAtPath:path 
									 withIntermediateDirectories:NO
													  attributes:nil
														   error:nil];
}

+ (BOOL) fileExistsAtPath:(NSString *) path
{
	return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL) rm:(NSString *) file
{
	return [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
}

+ (long long) sizeOfFileAtPath:(NSString *) path
{
	long long size = -1;
	NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path
																					error:nil];
	if(fileAttributes) {
		NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
		size = [fileSizeNumber longLongValue];
	}
	return size;
}
@end
