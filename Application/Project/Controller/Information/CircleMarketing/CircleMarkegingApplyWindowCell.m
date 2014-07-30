//
//  CircleMarkegingApplyWindowCell.m
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarkegingApplyWindowCell.h"
#import "WXWCommonUtils.h"
#import "WXWLabel.h"
#import "UIColor+expanded.h"
#import "GlobalConstants.h"

@interface CircleMarkegingApplyWindowCell () <UITextFieldDelegate>

@end

@implementation CircleMarkegingApplyWindowCell {
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withInfo:(EventApplyList *)apply indexPth:(NSIndexPath *)indexPath
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _applyList = apply;
        
        self.backgroundColor = TRANSPARENT_COLOR;
//        [self initControlWith];
        [self initControlsWithInfo:apply index:indexPath.row];
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    RELEASE_OBJ(_valueTextField);
    RELEASE_OBJ(_titleLabel);
    _delegate = nil;
    [super dealloc];
}

- (void)initControlsWithInfo:(EventApplyList *)apply index:(int)index
{
    _titleLabel = [[WXWLabel alloc] initWithFrame:CGRectMake(0, 0, 60, DEFAULT_CELL_HEIGHT) textColor:[UIColor colorWithHexString:@"0x333333"] shadowColor:TRANSPARENT_COLOR];
    _titleLabel.text = [NSString stringWithFormat:@"%@:",apply.applyTitle];;
    _titleLabel.font = FONT_SYSTEM_SIZE(16);
    [_titleLabel setTextAlignment:NSTextAlignmentRight];
    
    CGRect rect = _titleLabel.frame;
    int height = rect.size.height*0.8;
    int startX = rect.origin.x + rect.size.width;
    int startY = (rect.size.height - height)/2.0f;
    int width =self.frame.size.width - startX - 80;
    
    _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(startX , startY, width, height)];
    _valueTextField.backgroundColor = [UIColor clearColor];
    _valueTextField.borderStyle = UITextBorderStyleRoundedRect;
    _valueTextField.tag = index;
    _valueTextField.text = apply.applyResult;
    [_valueTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    _valueTextField.textAlignment = UITextAlignmentLeft;
    _valueTextField.delegate = self;
    _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self addSubview:_titleLabel];
    [self addSubview:_valueTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (_delegate && [_delegate respondsToSelector:@selector(didBeginEditingWithIndex:)]) {
        [_delegate didBeginEditingWithIndex:textField.tag];
    }
}

#pragma mark -- 

- (EventApplyList *)getApplyList
{
    _applyList.applyResult = _valueTextField.text;
    return _applyList;
}
@end
