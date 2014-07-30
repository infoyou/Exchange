//
//  JILWCFHelper.h
//  JITIPadQudao
//
//  Created by user on 13-4-19.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>
static const int JILDTRESPONSE_RESULTCODE_NETWORKERROR = -2;
static const int JILDTRESPONSE_RESULTCODE_WRONGDATA = -1;

@interface NSMutableURLRequest (JILMSWCF)
+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url;
+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
										  withJSONData:(NSData *) data;
+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
												method:(NSString *) method
										  withJSONData:(NSData *) data;
+ (NSMutableURLRequest *) POSTRequestToWCFServiceAtURL:(NSString *) url
												method:(NSString *) method
											 JSONParam:(id) param;
@end

@interface JILDTResponse : NSObject
@property (nonatomic) BOOL isSuccessful;
@property (nonatomic) NSInteger serviceType;
@property (nonatomic) NSInteger resultCode;
@property (nonatomic, retain) NSString *errorMessage;

- (id) init;
- (id) initWithData:(NSData *) data;
- (id) initWithStatusCode:(int) statusCode;
- (id) initWithStatusCode:(int) statusCode data:(NSData *) data;
- (id) valueForKey:(NSString *) key;
- (NSString *) stringValueForKey:(NSString *) key;
- (NSArray *) arrayValueForKey:(NSString *) key;
- (NSInteger) intValueForKey:(NSString *) key;
- (NSString *) lastUpdateTime;
- (NSString *) downloadFile;

- (void) setValue:(id)value forKey:(NSString *)key;
@end

@interface JILWCFHelper : NSObject
+ (JILDTResponse *) responseFromWCFServiceAtURL:(NSString *) url
										 method:(NSString *) method
										 params:(NSDictionary *) params;
+ (JILDTResponse *) responseFromRequest:(NSURLRequest *) request;
+ (NSData *) dataFromRequest:(NSURLRequest *) request;
@end
