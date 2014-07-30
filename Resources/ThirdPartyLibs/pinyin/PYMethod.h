//
//  PYMethod.h
//  Project
//
//  Created by XXX on 12-11-22.
//
//

#import <Foundation/Foundation.h>

@interface PYMethod : NSObject
+ (NSString*)getPinYin:(NSString *)nsstrHZ;

+ (NSString *)firstCharOfNamePinyin:(NSString *)nsstrHZ;
@end

