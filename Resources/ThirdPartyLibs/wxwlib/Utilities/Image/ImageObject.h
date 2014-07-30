//
//  ImageObject.h
//  Project
//
//  Created by XXX on 13-4-26.
//
//

#import <Foundation/Foundation.h>

@interface ImageObject : NSObject {
  
}

@property (nonatomic, copy) NSString *thumbnailUrl;
@property (nonatomic, copy) NSString *middleUrl;
@property (nonatomic, copy) NSString *originalUrl;
@property (nonatomic, assign) CGFloat thumbnailWidth;
@property (nonatomic, assign) CGFloat thumbnailHeight;
@property (nonatomic, assign) CGFloat middleSizeWidth;
@property (nonatomic, assign) CGFloat middleSizeHeight;
@property (nonatomic, assign) CGFloat originalSizeWidth;
@property (nonatomic, assign) CGFloat originalSizeHeight;

@end
