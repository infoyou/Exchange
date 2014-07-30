//
//  FileUtils.h
//  cpos
//
//  Created by user on 13-1-14.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject
+ (NSString *) pathOfDocumentDir;
+ (NSString *) pathForDocumentFiles:(NSString *) path;;
+ (BOOL) createFileAt:(NSString *) path withData:(NSData *) data;
+ (BOOL) copyFileAt:(NSString *) path toDir:(NSString *) dir;
+ (BOOL) createLinkToFileAt:(NSString *) path underDir:(NSString *) dir;
+ (BOOL) mkdir:(NSString *) path;
+ (BOOL) fileExistsAtPath:(NSString *) path;
+ (BOOL) rm:(NSString *) file;
+ (long long) sizeOfFileAtPath:(NSString *) path;
@end
