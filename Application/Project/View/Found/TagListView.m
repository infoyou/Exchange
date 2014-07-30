//
//  TagListView.m
//  Project
//
//  Created by XXX on 12-6-29.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import "TagListView.h"
#import "UIUtils.h"
#import "WXWLabel.h"
#import "Tag.h"
#import "WXWCommonUtils.h"
#import "WXWConstants.h"
#import "WXWCoreDataUtils.h"

#define ICON_WIDTH  16.0f
#define ICON_HEIGHT 16.0f

#pragma mark - tag button
@interface ItemTagButton : UIButton {
    
}

@property (nonatomic, retain) Tag *bizTag;

+ (id)buttonWithType:(UIButtonType)buttonType;
@end

@implementation ItemTagButton

+ (id)buttonWithType:(UIButtonType)buttonType {
    return [super buttonWithType:buttonType];
}

- (void)setBizTag:(Tag *)bizTag {
    
    if (bizTag == nil) {
        return;
    }
    
    RELEASE_OBJ(_bizTag);
    _bizTag = [bizTag retain];
    
    [self setTitle:bizTag.tagName forState:UIControlStateNormal];
}

- (void)dealloc {
    
    self.bizTag = nil;
    
    [super dealloc];
}

@end

@interface TagListView()
@property (nonatomic, retain) NSMutableDictionary *tagAndLabelDic;
@property (nonatomic, retain) CAGradientLayer *maskLayer;
@end

@implementation TagListView

@synthesize tagAndLabelDic = _tagAndLabelDic;
@synthesize maskLayer = _maskLayer;

#pragma mark - user action
- (void)selectTag:(id)sender {
    ItemTagButton *button = (ItemTagButton *)sender;
    
    if (_selectionDelegate && button.bizTag) {
        [_selectionDelegate selectTagWithName:button.bizTag];
    }
}

#pragma mark - arrange views
- (void)addMaskLayerIfNeeded {
    
    if (_tagsContainerView.frame.size.width >= _tagsContainerView.contentSize.width) {
        // the content width less than the size of scroll view, then no need to add the fading effect for edge
        return;
    }
    
    if (nil == self.maskLayer) {
        self.maskLayer = [CAGradientLayer layer];
        
        CGColorRef innerColor = CELL_COLOR.CGColor;
        
        CGColorRef outerColor = TRANSPARENT_COLOR.CGColor;
        
        self.maskLayer.colors = @[(id)outerColor,
                                  (id)innerColor, (id)innerColor, (id)outerColor];
        self.maskLayer.locations = @[@0.0f,
                                     @0.05f,
                                     @0.95f,
                                     @1.0f];
        
        self.maskLayer.startPoint = CGPointMake(0.0f, 0.5f);
        self.maskLayer.endPoint = CGPointMake(1.0f, 0.5f);
        
        self.maskLayer.bounds = CGRectMake(0, 0, _tagsContainerView.frame.size.width, _tagsContainerView.frame.size.height);
        self.maskLayer.anchorPoint = CGPointZero;
        
        _tagsContainerView.layer.mask = self.maskLayer;
    }
}

- (void)addTagIcon {
    _icon = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    _icon.backgroundColor = TRANSPARENT_COLOR;
    _icon.image = [UIImage imageNamed:@"tag.png"];
    [self addSubview:_icon];
}

- (CGSize)sizeOfUnclickableTagContent:(NSArray *)tags {
    
    self.tagAndLabelDic = [NSMutableDictionary dictionary];
    
    CGFloat labelStartX = 0.0f;
    
    for (Tag *tag in tags) {
        
        WXWLabel *label = [[[WXWLabel alloc] initWithFrame:CGRectZero
                                                 textColor:BASE_INFO_COLOR
                                               shadowColor:[UIColor whiteColor]] autorelease];
        label.textAlignment = UITextAlignmentLeft;
        label.font = FONT(11);
        
        label.text = [NSString stringWithFormat:@"%@", tag.tagName];
        
        CGSize size = [label.text sizeWithFont:label.font
                             constrainedToSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        labelStartX += MARGIN * 2;
        
        label.frame = CGRectMake(labelStartX,
                                 (_tagsContainerView.frame.size.height - size.height)/2.0f,
                                 size.width + MARGIN, size.height);
        
        [_tagsContainerView addSubview:label];
        
        labelStartX += label.frame.size.width;//size.width;
        
        (self.tagAndLabelDic)[tag.tagId] = label;
    }
    
    return CGSizeMake(labelStartX, _tagsContainerView.frame.size.height);
}

- (CGSize)sizeOfClickableTagContent:(NSString *)tagIds {
    
    CGFloat startX = 0;
    
    if (tagIds.length > 0) {
        
        NSArray *tagIdList = [tagIds componentsSeparatedByString:FULL_WIDTH_COMMA];
        
        for (NSString *tagId in tagIdList) {
            
            Tag *bizTag = (Tag *)[WXWCoreDataUtils fetchObjectFromMOC:_MOC
                                                           entityName:@"Tag"
                                                            predicate:[NSPredicate predicateWithFormat:@"(tagId == %@)", tagId]];
            
            CGSize size = [bizTag.tagName sizeWithFont:FONT(10)];
            
            CGFloat width = size.width + 4.0f;
            
            CGFloat x = startX + width + MARGIN * 2;
            //startX += width + MARGIN * 2;
            
            if (x > self.frame.size.width - MARGIN * 6) {
                break;
            }
            
            ItemTagButton *button = [ItemTagButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(startX,
                                      (_tagsContainerView.frame.size.height - size.height)/2.0f,
                                      width, size.height);
            [button setBizTag:bizTag];
            [button setTitleColor:BASE_INFO_COLOR forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:@"darkBlueButton.png"]
                              forState:UIControlStateHighlighted];
            button.titleLabel.font = FONT(10);
            button.backgroundColor = TRANSPARENT_COLOR;
            [button addTarget:self
                       action:@selector(selectTag:)
             forControlEvents:UIControlEventTouchUpInside];
            
            [_tagsContainerView addSubview:button];
            
            // update start x
            startX = x;
        }
    }
    
    return CGSizeMake(startX, _tagsContainerView.frame.size.height);
}

- (void)addScrollView {
    
    _tagsContainerView = [[[UIScrollView alloc] initWithFrame:CGRectZero] autorelease];
    _tagsContainerView.backgroundColor = TRANSPARENT_COLOR;
    _tagsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tagsContainerView.canCancelContentTouches = NO;
    _tagsContainerView.clipsToBounds = YES;
    _tagsContainerView.scrollEnabled = YES;
    _tagsContainerView.showsVerticalScrollIndicator = NO;
    _tagsContainerView.showsHorizontalScrollIndicator = NO;
    _tagsContainerView.delegate = self;
    
    [self addSubview:_tagsContainerView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = TRANSPARENT_COLOR;
        
        [self addTagIcon];
        
        [self addScrollView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
  selectionDelegate:(id<TagSelectionDelegate>)selectionDelegate
                MOC:(NSManagedObjectContext *)MOC {
    self = [self initWithFrame:frame];
    if (self) {
        _selectionDelegate = selectionDelegate;
        
        _MOC = MOC;
    }
    return self;
}

- (void)dealloc {
    
    self.tagAndLabelDic = nil;
    self.maskLayer = nil;
    
    _tagsContainerView.delegate = nil;
    
    [super dealloc];
}

- (void)arrangeContainerView {
    _icon.frame = CGRectMake(MARGIN * 2 + MARGIN * 4 + MARGIN,
                             0,
                             ICON_WIDTH, ICON_HEIGHT);
    
    CGFloat x = MARGIN;
    _tagsContainerView.frame = CGRectMake(x, _icon.frame.size.height,
                                          self.frame.size.width - x - MARGIN * 2,
                                          self.frame.size.height - _icon.frame.size.height);
}

- (void)drawViews:(NSArray *)tags {
    
    [self arrangeContainerView];
    
    if (self.tagAndLabelDic.count == 0) {
        _tagsContainerView.contentSize = [self sizeOfUnclickableTagContent:tags];
    }
    
    [self addMaskLayerIfNeeded];
}

- (void)drawTagIds:(NSString *)tagIds {
    
    [self arrangeContainerView];
    
    _tagsContainerView.contentSize = [self sizeOfClickableTagContent:tagIds];
    
    [self addMaskLayerIfNeeded];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat pattern[2] = {2.0, 2.0};
    
    CGFloat y = ICON_HEIGHT/2.0f + 0.5f;
    [UIUtils draw1PxDashLine:context
                  startPoint:CGPointMake(MARGIN * 2, y)
                    endPoint:CGPointMake(MARGIN * 6, y)
                    colorRef:SEPARATOR_LINE_COLOR.CGColor
                shadowOffset:CGSizeMake(0.0f, 1.0f)
                 shadowColor:[UIColor whiteColor]
                     pattern:pattern];
    
    [UIUtils draw1PxDashLine:context 
                  startPoint:CGPointMake(_icon.frame.origin.x + ICON_WIDTH + MARGIN, y)
                    endPoint:CGPointMake(self.frame.size.width - MARGIN * 2, y)
                    colorRef:SEPARATOR_LINE_COLOR.CGColor
                shadowOffset:CGSizeMake(0.0f, 1.0f)
                 shadowColor:[UIColor whiteColor]
                     pattern:pattern];
}

#pragma mark - UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskLayer.position = CGPointMake(scrollView.contentOffset.x, 0);
    [CATransaction commit];
}

@end
