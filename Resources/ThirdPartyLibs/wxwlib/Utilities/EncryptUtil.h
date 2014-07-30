//
//  EncryptUtil.h
//  Project
//
//  Created by fnicole on 11-11-6.
//  Copyright (c) 2011年 CEIBS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface EncryptUtil : NSObject

+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
+ (NSData*)TripleDESforNSData:(NSData*)plainData encryptOrDecrypt:(CCOperation)encryptOrDecrypt;
@end
