//
//  PlainTabView.m
//  Project
//
//  Created by XXX on 13-2-18.
//
//

#import "PlainTabView.h"
#import <QuartzCore/QuartzCore.h>
#import "PlainTabButton.h"
#import "WXWConstants.h"
#import "UIColor+expanded.h"

@interface PlainTabView()
@property (nonatomic, retain) NSArray *titles;
@property (nonatomic, retain) NSMutableDictionary *buttonDic;
@end

@implementation PlainTabView

#pragma mark - lifecycle methods

- (void)initTabButtons {
    
    self.buttonDic = [NSMutableDictionary dictionary];
    
    NSInteger averageWidth = (self.frame.size.width + self.titles.count - 1)/self.titles.count;
    
    for (int i = 0; i < self.titles.count; i++) {
        BOOL needBorder = YES;
        
        NSInteger buttonWidth = averageWidth;
        if (i == self.titles.count - 1) {
            needBorder = NO;
            
            buttonWidth = self.frame.size.width - (self.titles.count - 1) * averageWidth;
        }
        
        PlainTabButton *button = [[[PlainTabButton alloc] initWithFrame:CGRectMake(averageWidth * i, 0, buttonWidth, self.frame.size.height)
                                                         needLeftBorder:needBorder
                                                                  title:(NSString *)self.titles[i]
                                                                 parent:self
                                                        selectionAction:@selector(selectButtonWithTag:)
                                                            buttonIndex:i] autorelease];
        [self addSubview:button];
        
        [self.buttonDic setObject:button forKey:@(i)];
    }
}

- (void)addBorder {
    self.layer.borderColor = [UIColor colorWithHexString:@"0xea5123"].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
}

- (id)initWithFrame:(CGRect)frame
       buttonTitles:(NSArray *)buttonTitles
  tapSwitchDelegate:(id<TapSwitchDelegate>)tapSwitchDelegate {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addBorder];
        
        self.backgroundColor = TRANSPARENT_COLOR;
        
        _tapSwitchDelegate = tapSwitchDelegate;
        
        self.titles = buttonTitles;
        
        if (self.titles.count > 0) {
            [self initTabButtons];
        }
    }
    return self;
}

- (void)dealloc {
    
    self.titles = nil;
    self.buttonDic = nil;
    
    [super dealloc];
}

#pragma mark - user action
- (void)selectButtonWithIndex:(NSInteger)index {
    
    [self selectButtonWithIndexWithoutTriggerEvent:index];
    
    // trigger event
    if (_tapSwitchDelegate) {
        [_tapSwitchDelegate selectTapByIndex:index];
    }
}

- (void)selectButtonWithIndexWithoutTriggerEvent:(NSInteger)index {
    if (index < 0 || index >= self.buttonDic.count) {
        return;
    }
    
    for (int i = 0; i < self.buttonDic.count; i++) {
        
        PlainTabButton *button = (PlainTabButton *)[self.buttonDic objectForKey:@(i)];
        
        if (i == index) {
            [button select];
        } else {
            [button deselect];
        }
    }
    
}

- (void)selectButtonWithTag:(NSNumber *)tag {
    [self selectButtonWithIndex:tag.intValue];
}

@end
