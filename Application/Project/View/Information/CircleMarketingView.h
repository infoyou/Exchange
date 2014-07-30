//
//  CircleMarketingView.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleMarketingView : UIView {
    @private
    id  _target;
    SEL _action;
}

- (id)initWithFrame:(CGRect)frame target:(id)target action:(SEL)action;

@end
