//
//  NSAttributedString+Opetopic.m
//  NSAttributedString+Opetopic
//
//  Created by Brandon Williams on 4/6/12.
//  Copyright (c) 2012 Opetopic. All rights reserved.
//

/*******************************************************************************************
 
 NOTE:  It is not necessarily true that [string isEqualToAttributedString:decoded] due to
        some unsupported features of   attributed strings. Right now we do not properly 
        encode glyph attributes, run delegates (whatever the hell those are), and the tab
        stops specificer of paragraph styles. However, the decoded string is similar enough 
        to the original that you probably won't even notice when rendering.
 
******************************************************************************************/


#import "NSAttributedString+Encoding.h"
#import "NSDictionary+OPCoreText.h"

const struct NSAttributedStringArchiveKeys {
    __unsafe_unretained NSString *rootString;
    __unsafe_unretained NSString *attributes;
    __unsafe_unretained NSString *attributeDictionary;
    __unsafe_unretained NSString *attributeRange;
} NSAttributedStringArchiveKeys;

const struct NSAttributedStringArchiveKeys NSAttributedStringArchiveKeys = {
    .rootString = @"rootString",
    .attributes = @"attributes",
    .attributeDictionary = @"attributeDictionary",
    .attributeRange = @"attributeRange",
};

@interface NSAttributedString (Encoding_Private)
-(NSDictionary*) dictionaryRepresentation;
+(id) attributedStringWithDictionaryRepresentation:(NSDictionary*)dictionary;
@end

@implementation NSAttributedString (Encoding)

+(id) attributedStringWithData:(NSData*)data {
    return [self attributedStringWithDictionaryRepresentation:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
}

-(NSData*) convertToData {
    return [NSKeyedArchiver archivedDataWithRootObject:[self dictionaryRepresentation]];
}

@end


@implementation NSAttributedString (Encoding_Private)

+(id) attributedStringWithDictionaryRepresentation:(NSDictionary*)dictionary {
    
    NSString *string = dictionary[NSAttributedStringArchiveKeys.rootString];
    NSMutableAttributedString *retVal = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSArray *attributes = dictionary[NSAttributedStringArchiveKeys.attributes];
    [attributes enumerateObjectsUsingBlock:^(NSDictionary *attribute, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *attributeDictionary = attribute[NSAttributedStringArchiveKeys.attributeDictionary];
        NSRange range = NSRangeFromString(attribute[NSAttributedStringArchiveKeys.attributeRange]);
        
        [attributeDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id attr, BOOL *stop) {
            
            if ([key isEqual:(NSString*)kCTFontAttributeName])
            {
                CTFontRef fontRef = [attr createFontRef];
                [retVal addAttribute:key value:(__bridge_transfer id)fontRef range:range];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorFromContextAttributeName] ||
                    [key isEqualToString:(NSString*)kCTKernAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeWidthAttributeName] ||
                    [key isEqualToString:(NSString*)kCTLigatureAttributeName] ||
                    [key isEqualToString:(NSString*)kCTSuperscriptAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineStyleAttributeName] ||
                    [key isEqualToString:(NSString*)kCTCharacterShapeAttributeName] ||
                    [key isEqualToString:(NSString*)kCTVerticalFormsAttributeName])
            {
                [retVal addAttribute:key value:attr range:range];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineColorAttributeName])
            {
                [retVal addAttribute:key value:(id)[attr CGColor] range:range];
            }
            else if([key isEqualToString:(NSString*)kCTParagraphStyleAttributeName])
            {
                CTParagraphStyleRef paragraphStyleRef = [attr createParagraphStyleRef];
                [retVal addAttribute:key value:(__bridge_transfer id)paragraphStyleRef range:range];
            }
            else if([key isEqualToString:(NSString*)kCTGlyphInfoAttributeName])
            {
                // TODO
            }
            else if([key isEqualToString:(NSString*)kCTRunDelegateAttributeName])
            {
                // TODO
            }
        }];
        
    }];
    
    return retVal;
}

-(NSDictionary*) dictionaryRepresentation {
    
    NSMutableDictionary *retVal = [NSMutableDictionary new];
    
    retVal[NSAttributedStringArchiveKeys.rootString] = [self string];
    
    NSMutableArray *attributes = [NSMutableArray new];
    retVal[NSAttributedStringArchiveKeys.attributes] = attributes;
    
    [self enumerateAttributesInRange:NSMakeRange(0, [self length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        NSMutableDictionary *attribute = [NSMutableDictionary new];
        [attributes addObject:attribute];
        
        attribute[NSAttributedStringArchiveKeys.attributeRange] = NSStringFromRange(range);
        NSMutableDictionary *attributeDictionary = [NSMutableDictionary new];
        attribute[NSAttributedStringArchiveKeys.attributeDictionary] = attributeDictionary;
        
        [attrs enumerateKeysAndObjectsUsingBlock:^(id key, id attr, BOOL *stop) {
            
            if ([key isEqual:(NSString*)kCTFontAttributeName])
            {
                attributeDictionary[key] = [[NSDictionary alloc] initWithFontRef:(__bridge CTFontRef)attr];
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorFromContextAttributeName] ||
                    [key isEqualToString:(NSString*)kCTKernAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeWidthAttributeName] ||
                    [key isEqualToString:(NSString*)kCTLigatureAttributeName] ||
                    [key isEqualToString:(NSString*)kCTSuperscriptAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineStyleAttributeName] ||
                    [key isEqualToString:(NSString*)kCTCharacterShapeAttributeName] ||
                    [key isEqualToString:(NSString*)kCTVerticalFormsAttributeName])
            {
                attributeDictionary[key] = attr;
            }
            else if([key isEqualToString:(NSString*)kCTForegroundColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTStrokeColorAttributeName] ||
                    [key isEqualToString:(NSString*)kCTUnderlineColorAttributeName])
            {
                attributeDictionary[key] = [UIColor colorWithCGColor:(CGColorRef)attr];
            }
            else if([key isEqualToString:(NSString*)kCTParagraphStyleAttributeName])
            {
                attributeDictionary[key] = [[NSDictionary alloc] initWithParagraphStyleRef:(__bridge CTParagraphStyleRef)attr];
            }
            else if([key isEqualToString:(NSString*)kCTGlyphInfoAttributeName])
            {
                // TODO
            }
            else if([key isEqualToString:(NSString*)kCTRunDelegateAttributeName])
            {
                // TODO
            }
        }];
    }];
    
    return retVal;
}

@end
