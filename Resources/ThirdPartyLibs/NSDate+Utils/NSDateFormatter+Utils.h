//
//  NSDateFormatter+Utils.h
//  cpos
//
//  Created by Jang on 13-9-2.
//  Copyright (c) 2013年 jit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalConstants.h"

@interface NSDateFormatter (Utils)

+ (NSDateFormatter *)defaultsDateFormatterWithType:(FormatType)type;
+ (NSDateFormatter *)defaultsDateTimeFormatterWithType:(FormatType)type;
+ (NSDateFormatter *)defaultsDateTimeEndByMiniuteFormatterWithType:(FormatType)type;
+ (NSDateFormatter *)defaultsDateWipeYearFormatterWithType:(FormatType)type;

+ (NSDateFormatter *)defaultsDateFormatter;
+ (NSDateFormatter *)defaultsDateTimeFormatter;
+ (NSDateFormatter *)defaultsDateTimeEndByMiniuteFormatter;
+ (NSDateFormatter *)defaultsDateWipeYearFormatter;

@end
