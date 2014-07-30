//
//  TabBarView.m
//  Module
//
//  Created by XXX on 14-1-4.
//
//

#import "TabBarView.h"
#import <QuartzCore/QuartzCore.h>
#import "WXWLabel.h"
#import "TabBarItem.h"
#import "GlobalConstants.h"
#import "WXWTextPool.h"
#import "TextPool.h"
#import "UIColor+Expanded.h"

//#define TAB_WIDTH       63.0f
//#define TAB_COUNT       5

//#define TAB_WIDTH       79.25f
//#define TAB_COUNT       4

//#define TAB_WIDTH       106.6f
//#define TAB_COUNT       3

#if APP_TYPE == APP_TYPE_BASE
    #define TAB_WIDTH       79.25f
    #define TAB_COUNT       4
#elif APP_TYPE == APP_TYPE_FOSUN
    #define TAB_WIDTH       106.6f
    #define TAB_COUNT       3
#else
    #define TAB_WIDTH       79.25f
    #define TAB_COUNT       4
#endif

#define SELECTED_INDICATOR_HEIGHT       3.0f

#define SEPARATOR_WIDTH             1.0f

#if APP_TYPE == APP_TYPE_FOSUN
    #define IMAGE_NAME_FIRST_NORMAL   @"bottom_bar_business_normal.png"
    #define IMAGE_NAME_FIRST_SELECTED   @"bottom_bar_business_highlight.png"
    #define IMAGE_NAME_SECOND_NORMAL   @"bottom_bar_information_normal.png"
    #define IMAGE_NAME_SECOND_SELECTED   @"bottom_bar_information_highlight.png"
    #define IMAGE_NAME_THIRD_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_THIRD_SELECTED   @"bottom_bar_more_highlight.png"
    #define IMAGE_NAME_FOURTH_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_FOURTH_SELECTED   @"bottom_bar_more_highlight.png"
    #define IMAGE_NAME_FIFTH_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_FIFTH_SELECTED   @"bottom_bar_more_highlight.png"

    #define TABBAR_FIRST_NAME   @"聊天"
    #define TABBAR_SECOND_NAME   @"办公"
    #define TABBAR_THIRD_NAME   @"我"
    #define TABBAR_FOURTH_NAME   @"我"
    #define TABBAR_FIFTH_NAME   @"我"

#else
    #define IMAGE_NAME_FIRST_NORMAL   @"bottom_bar_information_normal.png"
    #define IMAGE_NAME_FIRST_SELECTED     @"bottom_bar_information_highlight.png"
    #define IMAGE_NAME_SECOND_NORMAL   @"bottom_bar_business_normal.png"
    #define IMAGE_NAME_SECOND_SELECTED   @"bottom_bar_business_highlight.png"
    #define IMAGE_NAME_THIRD_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_THIRD_SELECTED   @"bottom_bar_more_highlight.png"
    #define IMAGE_NAME_FOURTH_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_FOURTH_SELECTED   @"bottom_bar_more_highlight.png"
    #define IMAGE_NAME_FIFTH_NORMAL   @"bottom_bar_more_normal.png"
    #define IMAGE_NAME_FIFTH_SELECTED   @"bottom_bar_more_highlight.png"

    #define TABBAR_FIRST_NAME   @"首页"
    #define TABBAR_SECOND_NAME   @"交流"
    #define TABBAR_THIRD_NAME   @"活动"
    #define TABBAR_FOURTH_NAME   @"我"
    #define TABBAR_FIFTH_NAME   @"我"

#endif

@interface TabBarView()
@property (nonatomic, retain) NSMutableArray *tabItemList;

@end

@implementation TabBarView {
    float _tableWidth;
}

#pragma mark - selection action

- (void)refreshBadges {
    
    for (TabBarItem *item in self.tabItemList) {
        NSInteger numberBadge = 0;
        
        switch (item.tag) {
            case TAB_BAR_FIRST_TAG:
            {
                break;
            }
                
            case TAB_BAR_SECOND_TAG:
            {
                break;
            }
                
#if APP_TYPE == APP_TYPE_BASE
            case TAB_BAR_THIRD_TAG:
            {
                //numberBadge = [AppManager instance].comingEventCount;
                break;
            }
                
#elif APP_TYPE == APP_TYPE_CIO || APP_TYPE == APP_TYPE_IALUMNIUSA || APP_TYPE == APP_TYPE_INEARBY || APP_TYPE == APP_TYPE_FOSUN
                
#elif APP_TYPE == APP_TYPE_O2O
            case TAB_BAR_THIRD_TAG:
            {
                //numberBadge = [AppManager instance].comingEventCount;
                break;
            }
#endif
                
            case TAB_BAR_FOURTH_TAG:
            {
                break;
            }
                
            case TAB_BAR_FIFTH_TAG:
            {
                //numberBadge = [AppManager instance].msgNumber.intValue;
                break;
            }
                
            default:
                break;
        }
        
        [item setNumberBadgeWithCount:numberBadge];
    }
}

- (BOOL)tagSelected:(NSInteger)tag item:(TabBarItem *)item {
    return tag == item.tag ? YES : NO;
}

- (void)doSwitchAction:(NSInteger)tag {
    
    switch (tag) {

        case TAB_BAR_FIRST_TAG:
        {
            [_delegate selectFirstTabBar];
            break;
        }
            
        case TAB_BAR_SECOND_TAG:
        {
            [_delegate selectSecondTabBar];
            break;
        }
            
        case TAB_BAR_THIRD_TAG:
        {
            [_delegate selectThirdTabBar];
            break;
        }
            
        case TAB_BAR_FOURTH_TAG:
        {
            [_delegate selectFourthTabBar];
            break;
        }
            
        case TAB_BAR_FIFTH_TAG:
        {
            [_delegate selectFifthTabBar];
        }
            break;
            
        default:
            break;
    }
}

- (void)switchTabHighlightStatus:(NSInteger)tag {
    CGFloat x = (_tableWidth + SEPARATOR_WIDTH) * tag;
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         
                         CGFloat width = _tableWidth;
                         
                         if (tag == TAB_BAR_FIFTH_TAG) {
                             width += 1.0f;
                         }
                         _selectedIndicator.frame = CGRectMake(x,
                                                               _selectedIndicator.frame.origin.y,
                                                               width,
                                                               _selectedIndicator.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         
                         for (TabBarItem *item in self.tabItemList) {
                             NSString *imageName = nil;
                             NSInteger numberBadge = 0;
                             
                             switch (item.tag) {
                                 case TAB_BAR_FIRST_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FIRST_SELECTED;
                                     } else {
                                         imageName = IMAGE_NAME_FIRST_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_SECOND_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_SECOND_SELECTED;
                                     } else {
                                         imageName = IMAGE_NAME_SECOND_NORMAL;
                                     }
                                     break;
                                 }

                                 case TAB_BAR_THIRD_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_THIRD_SELECTED;
                                     } else {
                                         imageName = IMAGE_NAME_THIRD_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_FOURTH_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FOURTH_SELECTED;
                                     } else {
                                         imageName = IMAGE_NAME_FOURTH_NORMAL;
                                     }
                                     break;
                                 }
                                     
                                 case TAB_BAR_FIFTH_TAG:
                                 {
                                     if ([self tagSelected:tag item:item]) {
                                         imageName = IMAGE_NAME_FIFTH_SELECTED;
                                     } else {
                                         imageName = IMAGE_NAME_FIFTH_NORMAL;
                                     }
                                     
                                     break;
                                 }
                                     
                                 default:
                                     break;
                             }
                             
                             if ([self tagSelected:tag item:item]) {
                                 [item setTitleColorForHighlight:YES];
                             } else {
                                 [item setTitleColorForHighlight:NO];
                             }
                             
                             [item setImage:[UIImage imageNamed:imageName]];
                             [item setNumberBadgeWithCount:numberBadge];
                         }
                     }];
}

- (void)selectTag:(NSNumber *)tag {
    
    if (nil == _delegate) {
        return;
    }
    
    [self doSwitchAction:tag.intValue];
    
    [self switchTabHighlightStatus:tag.intValue];
}

#pragma mark - customize tab bar item

- (void)setTabItem:(TabBarItem *)item index:(NSInteger)index forInit:(BOOL)forInit{
    
    NSString *title = nil;
    NSString *imageName = nil;
    NSInteger numberBadge = 0;
    
    switch (index) {
        case TAB_BAR_FIRST_TAG:
        {
            title = TABBAR_FIRST_NAME;
            
            if (forInit) {
                imageName = IMAGE_NAME_FIRST_NORMAL;
                [item setTitleColorForHighlight:YES];
            } else {
                imageName = IMAGE_NAME_FIRST_SELECTED;
                [item setTitleColorForHighlight:NO];
            }
            
            break;
        }
            
        case TAB_BAR_SECOND_TAG:
        {
            title = TABBAR_SECOND_NAME;
            imageName = IMAGE_NAME_SECOND_NORMAL;
            break;
        }

        case TAB_BAR_THIRD_TAG:
        {
            title = TABBAR_THIRD_NAME;
            imageName = IMAGE_NAME_THIRD_NORMAL;
            break;
        }

        case TAB_BAR_FOURTH_TAG:
        {
            title = TABBAR_FOURTH_NAME;
            imageName = IMAGE_NAME_FOURTH_NORMAL;
            break;
        }
            
        case TAB_BAR_FIFTH_TAG:
        {
            title = TABBAR_FIFTH_NAME;
            imageName = IMAGE_NAME_FIFTH_NORMAL;
            //numberBadge = [AppManager instance].msgNumber.intValue;
            break;
        }
            
        default:
            break;
    }
    
    [item setTitle:title image:[UIImage imageNamed:imageName]];
    
    [item setNumberBadgeWithCount:numberBadge];
}

- (void)refreshItems {
    for (int i = 0; i < TAB_COUNT; i++) {
        TabBarItem *item = self.tabItemList[i];
        [self setTabItem:item index:i forInit:NO];
    }
}

- (void)initTabs {
    
    self.tabItemList = [NSMutableArray array];
    
    for (int i = 0; i < TAB_COUNT; i++) {
        CGFloat x = (_tableWidth + SEPARATOR_WIDTH) * i;
        
        CGFloat width = _tableWidth;
        if (i == TAB_COUNT - 1) {
            width += 1.0f;
        }
        
        TabBarItem *item = [[[TabBarItem alloc] initWithFrame:CGRectMake(x, 0, width, HOMEPAGE_TAB_HEIGHT)
                                                     delegate:self
                                              selectionAction:@selector(selectTag:)
                                                          tag:i] autorelease];
        
        [self setTabItem:item index:i forInit:YES];
        
        [self addSubview:item];
        
        [self.tabItemList addObject:item];
    }
}

#pragma mark - lifecycle methods

- (void)addShadow {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.shadowPath = shadowPath.CGPath;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOpacity = 0.7f;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.masksToBounds = NO;
}

- (void)initSelectedIndicator {
    _selectedIndicator = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                   _tableWidth,
                                                                   SELECTED_INDICATOR_HEIGHT)] autorelease];
    _selectedIndicator.backgroundColor = NAVIGATION_BAR_COLOR;
    
    [self addSubview:_selectedIndicator];
}

- (id)initWithFrame:(CGRect)frame delegate:(id<TabDelegate>)delegate;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _delegate = delegate;
        _tableWidth = TAB_WIDTH;
        
#if APP_TYPE != APP_TYPE_FOSUN
        self.backgroundColor = COLOR(178, 178, 178);
#else
        self.backgroundColor = [UIColor colorWithHexString:@"0xf0eeef"];
#endif
        
        [self addShadow];
        
        [self initTabs];
        
// 上面缺省选择条
//#if APP_TYPE != APP_TYPE_FOSUN
//        [self initSelectedIndicator];
//#endif
    }
    return self;
}

- (void)dealloc {
    
    self.tabItemList = nil;
    
    [super dealloc];
}

@end
