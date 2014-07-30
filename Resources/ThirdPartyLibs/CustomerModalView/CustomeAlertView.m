//
//  CustomeAlertView.m
//  Project
//
//  Created by XXX on 13-9-30.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//
#import "CustomeAlertView.h"
#import "CommonHeader.h"
#import "WXWConstants.h"

@implementation CustomeAlertView {
    
    int _marginX;
    int _marginY;
    UILabel *_tipLabel;
    UILabel *_messageLabel;
    UIButton *_okButton;
}

@synthesize myView;
@synthesize activityIndicator;
@synthesize animation;
@synthesize delegate;

-(id)init{
    
    if ( self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        
        //-----------------------------------------------------------------
        UIView *backgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 40)];
        backgroudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        [self addSubview:backgroudView];
        [backgroudView release];
        
        //UIWindow的层级 总共有三种
        self.windowLevel = UIWindowLevelAlert;
        myView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.1,SCREEN_HEIGHT*0.2, SCREEN_WIDTH*0.8, SCREEN_HEIGHT*0.4)];
        
        
        //-------------------------------------------------------------
        _marginX = 10;
        _marginY = 10;
        int startX = 0;
        int startY = 0;
        int width = SCREEN_WIDTH * 0.8;
        int height = 30;
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        [_messageLabel setText:@"提示"];
        [_messageLabel setFont:FONT_SYSTEM_SIZE(20)];
        [_messageLabel setTextColor:[UIColor whiteColor]];
        [_messageLabel setBackgroundColor:[UIColor blackColor]];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        
        [myView addSubview:_messageLabel];
        //        [tipTitleLabel release];
        
        //--------------------------------
        startX = _marginX;
        startY += height + 10;
        height = 1;
        
        //--------------------------------
        startY += height + 10;
        height = 80;
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, width, height)];
        [_tipLabel setFont:FONT_SYSTEM_SIZE(16)];
        [_tipLabel setTextColor:[UIColor colorWithHexString:@"797979"]];
        [_tipLabel setBackgroundColor:TRANSPARENT_COLOR];
        //        [_tipLabel setNumberOfLines:0];
        
        
        [myView addSubview:_tipLabel];
        
        
        //-------------------------------button------------------------------
        _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [okButton setBackgroundImage:[UIImage imageNamed:@"alert-view-ok-button"] forState:UIControlStateNormal];
        [_okButton setBackgroundColor:WHITE_COLOR];
        [_okButton setBackgroundImage:IMAGE_WITH_IMAGE_NAME(@"communication_alert_ok.png") forState:UIControlStateNormal];
        //        [_okButton setBackgroundImage:[CommonMethod createImageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(pressoKButton:) forControlEvents:UIControlEventTouchUpInside];
        _okButton.frame = CGRectMake(startX, startY, width - 2*_marginX, 39);
        [_okButton setTitle:@"确定" forState:UIControlStateNormal];
        //        _okButton.layer.allowsEdgeAntialiasing = YES;
        //        _okButton.layer.cornerRadius= 5.0f;
        [myView addSubview:_okButton];
        // [okButton release];
        
        activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(105, 75, 50, 50)];
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyleWhite;
        [myView addSubview:activityIndicator];
        [activityIndicator release];
        
        
        animation = [[CustomizedAlertAnimation alloc] customizedAlertAnimationWithUIview:myView];
        animation.delegate = self;
        [self addSubview:myView];
    }
    
    return self;
}


-(void)show{
    [self makeKeyAndVisible];
    //    [animation showAlertAnimation];
}

-(void)dismiss:(AlertDoneType)type{
    
    [myView release];
    [self resignKeyWindow];
    [animation dismissAlertAnimation:type];
    
}

-(void) pressoKButton:(id)sender{
    [self dismiss:ALERT_DONE_TYPE_OK];
}


#pragma mark -- CustomizedAlertAnimationDelegate


//自定义的alert view出现动画结束后调用
-(void)showCustomizedAlertAnimationIsOverWithUIView:(UIView *)v{
    NSLog(@"showCustomizedAlertAnimationIsOverWithUIView");
    //    [activityIndicator startAnimating];
}

//自定义的alert view消失动画结束后调用
-(void)dismissCustomizedAlertAnimationIsOverWithUIView:(UIView *)v type:(AlertDoneType)type{
    NSLog(@"dismissCustomizedAlertAnimationIsOverWithUIView");
    //    [activityIndicator stopAnimating];
    
    [self.delegate CustomeAlertViewDismiss:self];
    
}



- (void)updateInfoWithColor:(NSDictionary *)info
{
    NSArray *tipsArray = [info objectForKey:CUSTOMIZED_TIP_ARRAY];
    
    NSString *tipStr = @"";
    for (int i = 0; i < tipsArray.count; ++i) {
        tipStr = [NSString stringWithFormat:@"%@%@", tipStr, [[tipsArray objectAtIndex:i] objectForKey:CUSTOMIZED_TIP ]];
    }
    
    
    if (CURRENT_OS_VERSION >= IOS6) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tipStr];
        
        for (int i = 0; i < tipsArray.count; ++i) {
            NSDictionary *tip = [tipsArray objectAtIndex:i];
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:[tip objectForKey:CUSTOMIZED_COLOR]] range:[tipStr rangeOfString:[tip objectForKey:CUSTOMIZED_TIP ]]];
        }
        
        _tipLabel.attributedText = str;
        [str release];
        
    } else {
        _tipLabel.text = tipStr;
    }
    [_messageLabel setText:[info objectForKey:CUSTOMIZED_TITLE]];
    
    
    [self adjustHeight];
    
}

- (void)updateInfo:(NSDictionary *)info
{
    [_messageLabel setText:[info objectForKey:CUSTOMIZED_TITLE]];
    [_tipLabel setText:[info objectForKey:CUSTOMIZED_TIP]];
    
    [self adjustHeight];
}

- (void)adjustHeight
{
    //------调整宽度
    CGRect rect = _tipLabel.frame;
    rect.size.width = SCREEN_WIDTH*0.8 - 2*10;
    _tipLabel.frame = rect;
    [_tipLabel setNumberOfLines:0];
    [_tipLabel sizeToFit];
    
    rect = _okButton.frame;
    rect.origin.y =_tipLabel.frame.origin.y + _tipLabel.frame.size.height + _marginY;
    _okButton.frame = rect;
    
    rect = myView.frame;
    rect.size.height = _okButton.frame.origin.y + _okButton.frame.size.height + _marginY;
    rect.origin.y = (SCREEN_HEIGHT - rect.size.height ) / 2.0f;
    myView.frame = rect;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:myView.bounds];
    //        [imageView setImage:[[UIImage imageNamed:@"alert-view-bg-portrait"] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [imageView setImage:[[CommonMethod createImageWithColor:[UIColor whiteColor] withRect:CGRectMake(0, 0, 100, 30)] stretchableImageWithLeftCapWidth:100 topCapHeight:30]];
    [myView insertSubview:imageView atIndex:0];
    [imageView release];
    
    //    myView.layer.allowsEdgeAntialiasing=TRUE;
    //    myView.layer.cornerRadius= 5.0f;
}
@end
