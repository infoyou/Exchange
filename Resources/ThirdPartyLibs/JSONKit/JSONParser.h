//
//  JSONParser.h
//  Project
//
//  Created by XXX on 13-4-14.
//
//

#import <Foundation/Foundation.h>
#import "WXWConnectorDelegate.h"
#import "GlobalConstants.h"

@class ImageObject;

@interface JSONParser : NSObject

#pragma mark - entry point
+ (NSInteger)parserResponseJsonData:(NSData *)jsonData
                               type:(WebItemType)type
                                MOC:(NSManagedObjectContext *)MOC
                  connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                                url:(NSString *)url
                            paramID:(int)pid;

#pragma mark - Soft msg
+ (ConnectionAndParserResultCode)handleMsgGet:(NSDictionary *)jsonData;

#pragma mark - upload image
+ (ImageObject *)handleImageUploadResponseData:(NSData *)jsonData
                             connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                                           url:(NSString *)url;
@end
