//
//  JILFTPList.h
//  JITIOSLib
//
//  Created by user on 13-7-5.
//
//

#import <Foundation/Foundation.h>

@interface JILFTPList : NSObject
@property (nonatomic, strong, readwrite) NSMutableArray *  listEntries;
@property (nonatomic) long long resourceSize;
@property (nonatomic, retain) NSURL *resourceURL;

+ (long long) sizeOfFileAtURL:(NSString *) url;
- (id) initWithURL:(NSString *) resourceURL;
- (void) startReceive;
- (void) waitForFinishingReceiving;
@end
