//
//  TabBarItem.m
//  Project
//
//  Created by XXX on 14-1-10.
//
//

#import "TabBarItem.h"
#import "UIColor+Expanded.h"
#import "WXWLabel.h"
#import "WXWNumberBadge.h"
#import "WXWTextPool.h"
#import "WXWCommonUtils.h"
#import "GlobalConstants.h"

#define ICON_SIDE_LENGTH_W      24.0f //27.0f
#define ICON_SIDE_LENGTH_H      24.0f //19.5f

//选择中后，字体是否变色
#if APP_TYPE != APP_TYPE_FOSUN
    #define HIGHLIGHT_COLOR         NAVIGATION_BAR_COLOR
    #define NORMAL_COLOR             COLOR(26,26,26)
    #define OFFSET_Y                        0
#else
    #define HIGHLIGHT_COLOR         COLOR(153,153,153)
    #define NORMAL_COLOR            COLOR(153,153,153)
    #define OFFSET_Y                        3
#endif

#define BADGE_HEIGHT    16.0f

@implementation TabBarItem

- (void)setTitle:(NSString *)title image:(UIImage *)image {
  
  _titleLabel.text = title;
  
  CGSize size = [_titleLabel.text sizeWithFont:_titleLabel.font
                             constrainedToSize:CGSizeMake(self.frame.size.width, self.frame.size.height)
                                 lineBreakMode:NSLineBreakByWordWrapping];
  _titleLabel.frame = CGRectMake((self.frame.size.width - size.width)/2.0f,
                                 (self.frame.size.height - size.height) - OFFSET_Y,
                                 size.width, size.height);
  [self setImage:image];
}

- (void)setTitleColorForHighlight:(BOOL)highlight {
  if (highlight) {
    _titleLabel.textColor = HIGHLIGHT_COLOR;
  } else {
    _titleLabel.textColor = NORMAL_COLOR;
  }
}

- (void)setImage:(UIImage *)image {
  _imageView.image = image;
  _imageView.frame = CGRectMake(_imageView.frame.origin.x,
                                _titleLabel.frame.origin.y - ICON_SIDE_LENGTH_H - 1.0f - OFFSET_Y,
                                ICON_SIDE_LENGTH_W, ICON_SIDE_LENGTH_H);
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
    selectionAction:(SEL)selectionAction
                tag:(NSInteger)tag {
  
  self = [super initWithFrame:frame];
  
  if (self) {
    
    self.tag = tag;
    
    self.backgroundColor = [UIColor colorWithHexString:@"0xf0eeef"];
    
    _titleLabel = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                         textColor:NORMAL_COLOR
                                       shadowColor:TRANSPARENT_COLOR] autorelease];
      
    _titleLabel.font = FONT(11);
      
    [self addSubview:_titleLabel];
    
    _imageView = [[[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - ICON_SIDE_LENGTH_W)/2.0f, 0, ICON_SIDE_LENGTH_W, ICON_SIDE_LENGTH_H)] autorelease];
    [self addSubview:_imageView];
    
    _delegate = delegate;
    _selectionAction = selectionAction;
  }
  
  return self;
}

- (void)dealloc {
  
  [super dealloc];
}

#pragma mark - set number badge
- (void)setNumberBadgeWithCount:(NSInteger)count {
  
  if (nil == _numberBadge) {
    _numberBadge = [[[WXWNumberBadge alloc] initWithFrame:CGRectMake(0,
                                                                     _imageView.frame.origin.y,
                                                                     0,
                                                                     BADGE_HEIGHT)
                                          backgroundColor:NUMBER_BADGE_COLOR
                                                     font:BOLD_FONT(12)] autorelease];
    [self addSubview:_numberBadge];
  }
  
  if (count > 0)
  {
    _numberBadge.hidden = NO;
    
    [_numberBadge setNumberWithTitle:[NSString stringWithFormat:@"%d", count]];
    
    _numberBadge.frame = CGRectMake(self.frame.size.width - _numberBadge.frame.size.width - MARGIN,
                                    _imageView.frame.origin.y,
                                    _numberBadge.frame.size.width,
                                    _numberBadge.frame.size.height);
  } else {
    _numberBadge.hidden = NO;
  }
}

#pragma mark - override touch event
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if (_delegate && _selectionAction) {
    [_delegate performSelector:_selectionAction
                    withObject:@(self.tag)];
  }
}


@end
