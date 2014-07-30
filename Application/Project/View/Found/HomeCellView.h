//
//  HomeCellView.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeCellView : UIView {
    @private
    
    id  _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action backColor:(NSString*)backColor logoFrame:(CGRect)logoFrame logoImg:(NSString*)logoImg labelFrame:(CGRect)labelFrame labelEdge:(UIEdgeInsets)labelEdge labelText:(NSString*)labelText labelColor:(NSString*)labelColor;

@end
