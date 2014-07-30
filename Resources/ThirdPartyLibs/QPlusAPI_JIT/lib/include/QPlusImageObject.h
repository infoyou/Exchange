//
//  QPlusBigImageMessage.h
//  QPlusAPI
//
//  Created by ouyang on 13-4-23.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QPlusImageObject : NSObject

@property (nonatomic, copy) NSString *resPath;
@property (nonatomic, copy) NSString *resURL;
@property (nonatomic, strong) NSData *thumbData;

@end
