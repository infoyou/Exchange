//
//  UIImage+ResizableImage.m
//  FFStock
//
//  Created by Jelly on 1/3/14.
//  Copyright (c) 2014 Jelly. All rights reserved.
//

#import "UIImage+ResizableImage.h"

@implementation UIImage (ResizableImage)

- (UIImage*) resizableImage:(UIEdgeInsets)insets {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
        return [self resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    }
    
    return [self stretchableImageWithLeftCapWidth:insets.left topCapHeight:insets.top];
}
@end
