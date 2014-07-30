//
//  CircleMarkegingApplyWindow.m
//  Project
//
//  Created by XXX on 13-10-26.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import "CircleMarkegingApplyWindow.h"
#import "CommonHeader.h"
#import "CircleMarkegingApplyWindowCell.h"
#import "GCPlaceholderTextView.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"

#define kMaxCharacterCount 200

#define kAnimateInDuration 0.4
#define kAnimateOutDuration 0.3

@interface CircleMarkegingApplyWindow()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, CircleMarkegingApplyCellDelegate>

@end

@implementation CircleMarkegingApplyWindow {
    
    int _marginX;
    int _marginY;
    UILabel *_messageLabel;
    UILabel *_contentLabel;
    UIButton *_cancelButton;
    UIButton *_okButton;
    UITableView *_tableView;
    GCPlaceholderTextView *_textView;
    
    EventList *_detailList;
    
    // The character counter
	UILabel *characterCountLabel;
	
	// The character count
	int characterCount;
    
    int idx;
}

@synthesize myView;
@synthesize activityIndicator;
@synthesize animation;
@synthesize applyDelegate = _applyDelegate;

- (id)initWithType:(AlertType)type {
    
    if ( self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        
        //-----------------------------------------------------------------
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 40)];
        backgroudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        [self addSubview:backgroudView];
        [backgroudView release];
        
        //UIWindow的层级 总共有三种
        self.windowLevel = UIWindowLevelAlert;
        myView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.1,SCREEN_HEIGHT*0.15, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.4)];
        myView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        myView.layer.cornerRadius = 4.f;
        myView.layer.masksToBounds = YES;
        
        //-------------------------------------------------------------
        _marginX = 10;
        _marginY = 10;
        int startX = 0;
        int startY = 0;
        int width = SCREEN_WIDTH * 0.8;
        int height = 40;
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        [_messageLabel setText:@"提示"];
        [_messageLabel setFont:FONT_SYSTEM_SIZE(15)];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [_messageLabel setBackgroundColor:[UIColor blackColor]];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        
        [myView addSubview:_messageLabel];
        //        [tipTitleLabel release];
        
        //--------------------------------
//        startX = _marginX;
        startY += height + 10;
        height = 1;
        
        //--------------------------------
        startY += height + 10;
        height = 80;
        startX = 0;
        
        if (type == AlertType_TableView) {
            [self addMainTable:myView rect:CGRectMake(startX, startY, width, height)];
        }else if (type == AlertType_TextView) {
            [self addTextView:myView rect:CGRectMake(10, _messageLabel.frame.origin.y + _messageLabel.frame.size.height, width - 20, myView.frame.size.height - _messageLabel.frame.size.height - _okButton.frame.size.height - 56)];
            [self setupView];
        }else if (type == AlertType_Default) {
            [self addMessageLabel:myView rect:CGRectMake(10, _messageLabel.frame.origin.y + _messageLabel.frame.size.height, width - 20, myView.frame.size.height - _messageLabel.frame.size.height - _okButton.frame.size.height - 50)];
        }
        
        //-------------------------------cancel button------------------------------
        int distX = 10;
        int buttonWidth = (width - 2*_marginX - distX) / 2.0f;
        int buttonHeight = 35;
        startX = _marginX;
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
        [_cancelButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"0x333333"]] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [myView addSubview:_cancelButton];

        //-------------------------------ok button------------------------------
        startX += buttonWidth + distX;
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okButton setBackgroundColor:[UIColor whiteColor]];
        [_okButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(pressOKButton:) forControlEvents:UIControlEventTouchUpInside];
        _okButton.frame = CGRectMake(startX, startY, buttonWidth, buttonHeight);
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        [myView addSubview:_okButton];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(105, 75, 50, 50)];
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
        [myView addSubview:activityIndicator];
        [activityIndicator release];
        
        [self addSubview:myView];
    }
    
    return self;
}

- (void)dealloc {
    RELEASE_OBJ(_tableView);
    RELEASE_OBJ(_textView);
    RELEASE_OBJ(_contentLabel);
    RELEASE_OBJ(_cancelButton);
    RELEASE_OBJ(_okButton);
    RELEASE_OBJ(characterCountLabel);
    RELEASE_OBJ(_messageLabel);
    _applyDelegate = nil;
    [super dealloc];
}

- (void)addMainTable:(UIView *)parentView rect:(CGRect)rect {
    
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = TRANSPARENT_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [parentView addSubview:_tableView];
}

- (void)addTextView:(UIView *)parentView rect:(CGRect)rect {
    _textView = [[GCPlaceholderTextView alloc] initWithFrame:rect];
    _textView.delegate = self;
    _textView.showsHorizontalScrollIndicator = NO;
    _textView.backgroundColor = TRANSPARENT_COLOR;
    _textView.placeholder =[NSString stringWithFormat:@"请输入评论内容，不超过%d字。",kMaxCharacterCount];
    _textView.font = FONT_SYSTEM_SIZE(14);
    _textView.scrollEnabled = YES;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [parentView addSubview:_textView];
}

- (void)addMessageLabel:(UIView *)parentView rect:(CGRect)rect {
    _contentLabel = [[UILabel alloc] initWithFrame:rect];
    _contentLabel.backgroundColor = TRANSPARENT_COLOR;
    _contentLabel.font = FONT_SYSTEM_SIZE(17);
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.contentMode = UIViewContentModeCenter;
    [parentView addSubview:_contentLabel];
}

- (void)setupView {
    
    // Set the max character count
	characterCount = kMaxCharacterCount;
    
    // Add a character label
	float characterCountLabelWidth = 45.0f;
	float characterCountLabelHeight = 18.0f;
	characterCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.frame.origin.x + _textView.frame.size.width - characterCountLabelWidth, _textView.frame.origin.y + _textView.frame.size.height - 12, characterCountLabelWidth, characterCountLabelHeight)];
	[characterCountLabel setTextAlignment:NSTextAlignmentRight];
	[characterCountLabel setFont:FONT_SYSTEM_SIZE(10)];
	[characterCountLabel setBackgroundColor:[UIColor clearColor]];
    [characterCountLabel setTextColor:[UIColor colorWithHexString:@"0x666666"]];
	[characterCountLabel setText:[NSString stringWithFormat:@"0/%d", characterCount]];
	[myView addSubview:characterCountLabel];
}

- (void)show{
    [self makeKeyAndVisible];
//    [animation showAlertAnimation];
    
    CAKeyframeAnimation *animations = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animations.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animations.keyTimes = @[ @0, @0.5, @1 ];
    animations.fillMode = kCAFillModeForwards;
    animations.removedOnCompletion = NO;
    animations.duration = .3;
    [myView.layer addAnimation:animations forKey:@"showAlert"];
}

- (void)dismiss:(AlertDoneType)type{
    if (_textView) {
        [_textView resignFirstResponder];
    }else if (_tableView) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        CircleMarkegingApplyWindowCell *cell = (CircleMarkegingApplyWindowCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [cell.valueTextField resignFirstResponder];
    }
    
    
    [myView release];
    [self resignKeyWindow];
//    [animation dismissAlertAnimation:type];
    
    [UIView animateWithDuration:kAnimateOutDuration animations:^{self.alpha = 0.0;}];
    
    myView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:1.0],
                              [NSNumber numberWithFloat:1.1],
                              [NSNumber numberWithFloat:0.5],
                              [NSNumber numberWithFloat:0.0], nil];
    bounceAnimation.duration = kAnimateOutDuration;
    bounceAnimation.removedOnCompletion = NO;
    bounceAnimation.delegate = self;
    [myView.layer addAnimation:bounceAnimation forKey:@"bounce"];
    
    myView.layer.transform = CATransform3DIdentity;
    
//    if (type == ALERT_DONE_TYPE_OK) {
//        if (_delegate && [_delegate respondsToSelector:@selector(circleMarkegingApplyWindowDismiss:applyList:)]) {
//            
////            [_delegate circleMarkegingApplyWindowCancelDismiss:<#(CircleMarkegingApplyWindow *)#>];
////            - (void)circleMarkegingApplyWindowDismiss:(CircleMarkegingApplyWindow *)alertView applyList:(NSArray *)applyArray;
//            [_delegate circleMarkegingApplyWindowDismiss:self applyList:<#(NSArray *)#>];
//        }
//    }
    [self dismissCustomizedAlertAnimationIsOverWithUIView:nil type:type];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (flag)
        [self removeFromSuperview];
    
}

- (void)pressCancelButton:(id)sender{
    [self dismiss:ALERT_DONE_TYPE_CANCEL];
}


- (void)pressOKButton:(id)sender{
    [self dismiss:ALERT_DONE_TYPE_OK];
}


#pragma mark -- CustomizedAlertAnimationDelegate


//自定义的alert view出现动画结束后调用
- (void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v{
    NSLog(@"showCustomizedAlertAnimationIsOverWithUIView");
    //    [activityIndicator startAnimating];
}

////自定义的alert view消失动画结束后调用
- (void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v type:(AlertDoneType)type
{
    NSLog(@"dismissCustomizedAlertAnimationIsOverWithUIView");
    //    [activityIndicator stopAnimating];

    switch (type) {
        case ALERT_DONE_TYPE_CANCEL:
            
            if (_applyDelegate && [_applyDelegate respondsToSelector:@selector(circleMarkegingApplyWindowCancelDismiss:)]) {
                [_applyDelegate circleMarkegingApplyWindowCancelDismiss:self];
            }
            break;
            
        case ALERT_DONE_TYPE_OK: {
            
            if (_applyDelegate && [_applyDelegate respondsToSelector:@selector(circleMarkegingApplyWindowDismiss:applyList:)]) {
                
                NSMutableArray *applyArray = [[NSMutableArray alloc] init];
              
                for (int i = 0 ; i < _detailList.eventApplyList.count; ++i) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    CircleMarkegingApplyWindowCell *cell = (CircleMarkegingApplyWindowCell *) [self tableView:_tableView cellForRowAtIndexPath:indexPath];
//                    [cell.valueTextField resignFirstResponder];
                    [applyArray addObject:[cell getApplyList]];
                }
                
                if (_applyDelegate && [_applyDelegate respondsToSelector:@selector(circleMarketingApplyWindow:didEndEditing:)]) {
                    [_applyDelegate circleMarketingApplyWindow:self didEndEditing:_textView.text];
                }
                
                [_applyDelegate circleMarkegingApplyWindowDismiss:self applyList:applyArray];
                [applyArray release];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)updateInfo:(EventList *)detail
{
    _detailList = detail;
    [_messageLabel setText:@"报名信息"];
    //    [_messageLabel sizeToFit];
    
    [_tableView reloadData];
    
    
    CGRect rect = _tableView.frame;
    rect.size.height = DEFAULT_CELL_HEIGHT * detail.eventApplyList.count;//MIN(detail.eventApplyList.count, 3);
    rect.size.width = myView.frame.size.width - 2*rect.origin.x;
    _tableView.frame = rect;
    
    
    rect = _okButton.frame;
    rect.origin.y =_tableView.frame.origin.y + _tableView.frame.size.height + _marginY;
    _okButton.frame = rect;
    
    rect = _cancelButton.frame;
    rect.origin.y =_tableView.frame.origin.y + _tableView.frame.size.height + _marginY;
    _cancelButton.frame = rect;
    
    rect = myView.frame;
    rect.size.height = _okButton.frame.origin.y + _okButton.frame.size.height + _marginY;
    rect.origin.y = (SCREEN_HEIGHT - rect.size.height ) / 2.0f;
    myView.frame = rect;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:myView.bounds];
    //        [imageView setImage:[[UIImage imageNamed:@"alert-view-bg-portrait"] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [imageView setImage:[[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"f2f2f2"] withRect:CGRectMake(0, 0, 100, 30)] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [myView insertSubview:imageView atIndex:0];
    [imageView release];
    
    //    myView.layer.allowsEdgeAntialiasing=TRUE;
    //    myView.layer.cornerRadius= 5.0f;
    
}

- (void)setMessage:(NSString *)message title:(NSString *)title {
    _contentLabel.text = message;
    _messageLabel.text = title;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    
    CGSize size = [WXWCommonUtils sizeForText:_contentLabel.text font:_contentLabel.font
                            constrainedToSize:CGSizeMake(_contentLabel.frame.size.width, MAXFLOAT)
                                lineBreakMode:NSLineBreakByCharWrapping
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName : _contentLabel.font}];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y + 15, _contentLabel.frame.size.width, MIN(size.height, _contentLabel.frame.size.height + 20));
    
    _cancelButton.frame = CGRectMake(_cancelButton.frame.origin.x, myView.frame.size.height - _cancelButton.frame.size.height - 10, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    _okButton.frame = CGRectMake(_okButton.frame.origin.x, myView.frame.size.height - _okButton.frame.size.height - 10, _okButton.frame.size.width, _okButton.frame.size.height);
    
    CGRect rect = _contentLabel.frame;
    rect.size.width = myView.frame.size.width - 2*rect.origin.x;
    _contentLabel.frame = rect;
    
    
    rect = _okButton.frame;
    rect.origin.y =_contentLabel.frame.origin.y + _contentLabel.frame.size.height + _marginY * 2;
    _okButton.frame = rect;
    
    rect = _cancelButton.frame;
    rect.origin.y =_contentLabel.frame.origin.y + _contentLabel.frame.size.height + _marginY * 2;
    _cancelButton.frame = rect;
    
    rect = myView.frame;
    rect.size.height = _okButton.frame.origin.y + _okButton.frame.size.height + _marginY;
    rect.origin.y = (SCREEN_HEIGHT - rect.size.height ) / 2.0f;
    myView.frame = rect;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:myView.bounds];
    //        [imageView setImage:[[UIImage imageNamed:@"alert-view-bg-portrait"] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [imageView setImage:[[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"f2f2f2"] withRect:CGRectMake(0, 0, 100, 30)] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [myView insertSubview:imageView atIndex:0];
    [imageView release];
}

- (void)resetContentView:(NSString *)text {
    [_messageLabel setText:text];
    _cancelButton.frame = CGRectMake(_cancelButton.frame.origin.x, myView.frame.size.height - _cancelButton.frame.size.height - 10, _cancelButton.frame.size.width, _cancelButton.frame.size.height);
    _okButton.frame = CGRectMake(_okButton.frame.origin.x, myView.frame.size.height - _okButton.frame.size.height - 10, _okButton.frame.size.width, _okButton.frame.size.height);
    
    
    CGRect f = myView.bounds;
    f.size.height -= 30.f;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:f];
    //        [imageView setImage:[[UIImage imageNamed:@"alert-view-bg-portrait"] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [imageView setImage:[[CommonMethod createImageWithColor:[UIColor colorWithHexString:@"f2f2f2"] withRect:CGRectMake(0, 0, 100, 30)] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [myView insertSubview:imageView atIndex:0];
    [imageView release];
    
//    [_textView becomeFirstResponder];
}

#pragma mark -- UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _textView.text = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < kMaxCharacterCount) {
        return TRUE;
    }
    int count = kMaxCharacterCount - [[textView text] length];
    if (count <=0)
        return FALSE;
    
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)textView {
    
	// Update the character count
	int count = kMaxCharacterCount - [[textView text] length];
    if (count < 0) {
        textView.text = [textView.text substringToIndex:kMaxCharacterCount];
        count = 0;
    }
	[characterCountLabel setText:[NSString stringWithFormat:@"%d/%d", kMaxCharacterCount - count,kMaxCharacterCount]];
	
	// Check if the count is over the limit
	if(count < 0) {
		// Change the color
		[characterCountLabel setTextColor:[UIColor redColor]];
	}
	else if(count < 20) {
		// Change the color to yellow
		[characterCountLabel setTextColor:[UIColor orangeColor]];
	}
	else {
		// Set normal color
		[characterCountLabel setTextColor:[UIColor colorWithHexString:@"0x666666"]];
	}
}
#pragma mark - cell delegate

- (void)didBeginEditingWithIndex:(int)index {
    DLog(@"%d",index);
    idx = index;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DLog(@"%d", _detailList.eventApplyList.count);
    
    return _detailList.eventApplyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString * tableIdentifier = @"CircleMarkegingApplyWindowCell";
//    
//    CircleMarkegingApplyWindowCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
//    if(cell == nil)
//    {
//        cell = [[[CircleMarkegingApplyWindowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier withInfo:[_detailList.eventApplyList.allObjects objectAtIndex:indexPath.row] indexPth:indexPath] autorelease];
//        cell.delegate = self;
//        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        //        cell.imageView.image= IMAGE_WITH_IMAGE_NAME(@"view_cell_background.png");
//    }
    
    CircleMarkegingApplyWindowCell *cell = [[[CircleMarkegingApplyWindowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil withInfo:[[_detailList.eventApplyList.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"applyId" ascending:YES]]] objectAtIndex:indexPath.row] indexPth:indexPath] autorelease];
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"dfasfdasfsd");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return DEFAULT_CELL_HEIGHT;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss:ALERT_DONE_TYPE_CANCEL];
}

@end

