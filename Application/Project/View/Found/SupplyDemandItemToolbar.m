//
//  SupplyDemandItemToolbar.m
//  Project
//
//  Created by XXX on 13-6-5.
//
//

#import "SupplyDemandItemToolbar.h"
#import <QuartzCore/QuartzCore.h>
#import "Post.h"
#import "WXWLabel.h"
#import "TextPool.h"
#import "WXWCommonUtils.h"

#define TITLE_LABEL_TAG   1000

@interface SupplyDemandItemToolbar()
@property (nonatomic, retain) Post *item;
@end

@implementation SupplyDemandItemToolbar

#pragma mark - arrange views

- (void)addShadow {
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = path.CGPath;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.layer.shadowOpacity = 0.9f;
    self.layer.masksToBounds = NO;
}

- (UIButton *)createButtonWithTitle:(NSString *)title
                          imageName:(NSString *)imageName
                                  x:(CGFloat)x
                             target:(id)target
                             action:(SEL)action {
    
    
    CGFloat width = SCREEN_WIDTH/3.0f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, 0, width, self.frame.size.height);
    button.backgroundColor = TRANSPARENT_COLOR;
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.imageEdgeInsets = UIEdgeInsetsMake(-5, 0, 8, 0);
    
    WXWLabel *titleLabel = [[[WXWLabel alloc] initWithFrame:CGRectMake(0, 30, width, 14)
                                                  textColor:BASE_INFO_COLOR
                                                shadowColor:TRANSPARENT_COLOR
                                                       font:BOLD_FONT(11)] autorelease];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.tag = TITLE_LABEL_TAG;
    [button addSubview:titleLabel];
    
    titleLabel.text = title;
    
    return button;
}

- (void)arrangeButtons {
    
    NSString *title = nil;
    NSString *imageName = nil;
    
    // arrange favorite button;
    if (self.item.favorited.boolValue) {
        title = LocaleStringForKey(NSDeleteFavoriteTitle, nil);
        imageName = @"followed.png";
        
    } else {
        title = LocaleStringForKey(NSFavoriteStatusTitle, nil);
        imageName = @"unfollowed.png";
    }
    
    _favButton = [self createButtonWithTitle:title
                                   imageName:imageName
                                           x:0
                                      target:_target
                                      action:_favAction];
    [self addSubview:_favButton];
    
    // arrange share button
    _shareButton = [self createButtonWithTitle:LocaleStringForKey(NSWeChatShareTitle, nil)
                                     imageName:@"sendShare.png"
                                             x:_favButton.frame.size.width
                                        target:_target
                                        action:_shareAction];
    [self addSubview:_shareButton];
    
    if (!_selfSentItem) {
        
        // arrange direct message button
        _dmButton = [self createButtonWithTitle:LocaleStringForKey(NSChatTitle, nil)
                                      imageName:@"sendDM.png"
                                              x:_favButton.frame.size.width * 2
                                         target:_target
                                         action:_dmAction];
        [self addSubview:_dmButton];
    } else {
        
        // arrange delete button
        _deleteButton = [self createButtonWithTitle:LocaleStringForKey(NSDeleteActionTitle, nil)
                                          imageName:@"delete.png"
                                                  x:_favButton.frame.size.width * 2
                                             target:_target
                                             action:_deleteAction];
        [self addSubview:_deleteButton];
    }
}

- (void)updateFavButtonWithStatus:(BOOL)favorited {
    if (_favButton) {
        WXWLabel *titleLabel = (WXWLabel *)[_favButton viewWithTag:TITLE_LABEL_TAG];
        
        NSString *imageName = nil;
        if (favorited) {
            titleLabel.text = LocaleStringForKey(NSDeleteFavoriteTitle, nil);
            imageName = @"followed.png";
            
        } else {
            titleLabel.text = LocaleStringForKey(NSFavoriteStatusTitle, nil);
            imageName = @"unfollowed.png";
        }
        
        [_favButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

#pragma mark - lifecycle methods
- (id)initWithFrame:(CGRect)frame
               item:(Post *)item
       selfSentItem:(BOOL)selfSentItem
             target:(id)target
          favAction:(SEL)favAction
           dmAction:(SEL)dmAction
        shareAction:(SEL)shareAction
       deleteAction:(SEL)deleteAction {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _selfSentItem = selfSentItem;
        
        self.item = item;
        
        _favAction = favAction;
        _dmAction = dmAction;
        _shareAction = shareAction;
        _deleteAction = deleteAction;
        
        [self addShadow];
        
        [self arrangeButtons];
    }
    return self;
}

- (void)dealloc {
    
    self.item = nil;
    
    [super dealloc];
}

@end
