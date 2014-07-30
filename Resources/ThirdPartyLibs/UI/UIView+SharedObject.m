//
//  UIView+SharedObject.m
//  Project
//
//  Created by Jang on 13-10-11.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "UIView+SharedObject.h"

@implementation UIView (SharedObject)

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (CGFloat)sizeWidth {
    return self.frame.size.width;
}

- (CGFloat)sizeHeight {
    return self.frame.size.height;
}

- (CGFloat)frameRight {
    return [self originX] + [self sizeWidth];
}

- (CGFloat)frameBottom {
    return [self originY] + [self sizeHeight];
}

@end
