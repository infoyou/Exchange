//
//  AuthorCell.h
//  Project
//
//  Created by XXX on 13-6-4.
//
//

#import "ECImageConsumerCell.h"

@class WXWLabel;

@interface AuthorCell : ECImageConsumerCell {
    
@private
    UIImageView *_authorPhotoImageView;
    
    WXWLabel *_authorLabel;
    WXWLabel *_schoolLabel;
    WXWLabel *_companyLabel;
}

- (void)drawCellWithImageUrl:(NSString *)imageUrl authorName:(NSString *)authorName schoolName:(NSString *)schoolName companyName:(NSString *)companyName;

@end
