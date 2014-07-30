//
//  InsertLabel.h
//  Project
//
//  Created by user on 13-10-8.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsertLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;


- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;
- (id)initWithInsets:(UIEdgeInsets)insets;

@end
