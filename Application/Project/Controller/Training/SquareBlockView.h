//
//  SquareBlockView.h
//  Project
//
//  Created by Jang on 13-10-31.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareBlockView : UIView {
    @private
    id  _target;
    SEL _action;
    NSString *_bgColor;
    NSString *_lbColor;
    NSString *_title;
}

- (id)initWithFrame:(CGRect)frame
            viewTag:(NSInteger)vtag
    backgroundColor:(NSString *)colorString
              title:(NSString *)title
   numberLabelColor:(NSString *)labelColorString
             target:(id)target
             action:(SEL)action;

- (void)updateNumber:(NSInteger)num;

@end
