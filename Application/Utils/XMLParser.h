//
//  XMLParser.h
//  Project
//
//  Created by XXX on 11-11-3.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GlobalConstants.h"
#import "WXWConnectorDelegate.h"
#import "CXMLElement.h"
#import "CXMLDocument.h"



@interface XMLParser : NSObject {
  
}


+ (BOOL)parserSyncResponseXml:(NSData *)xmlData
                         type:(WebItemType)type
                          MOC:(NSManagedObjectContext *)MOC;

#pragma mark - entry points
+ (BOOL)parserResponseXml:(NSData *)xmlData
                     type:(WebItemType)type
                      MOC:(NSManagedObjectContext *)MOC
        connectorDelegate:(id<WXWConnectorDelegate>)connectorDelegate
                      url:(NSString *)url;
@end
