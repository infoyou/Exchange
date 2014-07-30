//
//  BaseConfigurableCell.m
//  Project
//
//  Created by XXX on 12-11-18.
//
//

#import "BaseConfigurableCell.h"
#import "WXWUIUtils.h"

#define SHADOW_MARGIN           4
#define DEFAULT_SHADOW_OPACITY  0.7

#define CONTENTVIEW_MARGIN      2

#define DEFAULT_RADIUS          10

#define DEFAULT_BORDER_COLOR                    [UIColor colorWithHex:0xBCBCBC]
#define DEFAULT_SEPARATOR_COLOR                 [UIColor colorWithHex:0xCDCDCD]

#define DEFAULT_SELECTION_GRADIENT_START_COLOR  [UIColor colorWithHex:0x0089F9]
#define DEFAULT_SELECTION_GRADIENT_END_COLOR    [UIColor colorWithHex:0x0054EA]

typedef enum {
  CellBackgroundBehaviorNormal = 0,
  CellBackgroundBehaviorSelected,
} CellBackgroundBehavior;

typedef enum {
  CellBackgroundGradientNormal = 0,
  CellBackgroundGradientSelected,
} CellBackgroundGradient;

@interface BaseConfigurableCell(Private)

- (float) shadowMargin;

@end

@implementation BaseConfigurableCell (Private)

- (float)shadowMargin {
  return [self tableViewIsGrouped] ? SHADOW_MARGIN : 0;
}

@end


#pragma mark - cell background view
@interface ConfigurableTableViewCellBackground : UIView

@property (nonatomic, assign) BaseConfigurableCell *cell;
@property (nonatomic, assign) CellBackgroundBehavior behavior;
@property (nonatomic, assign) CGFloat cellWidth;

- (id) initWithFrame:(CGRect)frame behavior:(CellBackgroundBehavior)behavior;

@end

@implementation ConfigurableTableViewCellBackground
@synthesize cell;
@synthesize behavior;


- (CGPathRef) createRoundedPath:(CGRect)rect
{
	if (!self.cell.cornerRadius) {
		return [UIBezierPath bezierPathWithRect:rect].CGPath;
	}
	
  UIRectCorner corners;
  
  switch (self.cell.position) {
    case ConfigurableTableViewCellPositionTop:
      corners = UIRectCornerTopLeft | UIRectCornerTopRight;
      break;
    case ConfigurableTableViewCellPositionMiddle:
      corners = 0;
      break;
    case ConfigurableTableViewCellPositionBottom:
      corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
      break;
    default:
      corners = UIRectCornerAllCorners;
      break;
  }
  
  UIBezierPath *thePath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                byRoundingCorners:corners
                                                      cornerRadii:CGSizeMake(self.cell.cornerRadius, self.cell.cornerRadius)];
  return thePath.CGPath;
}


- (CGGradientRef) newGradientFromType:(CellBackgroundGradient)type
{
  switch (type)
  {
    case CellBackgroundGradientSelected:
      return [self.cell newSelectionGradient];
    default:
      return [self.cell newNormalGradient];
  }
}

- (void) drawGradient:(CGRect)rect type:(CellBackgroundGradient)type
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  CGPathRef path;
  path = [self createRoundedPath:rect];
  
  CGContextAddPath(ctx, path);
  
  CGGradientRef gradient = [self newGradientFromType:type];
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextClip(ctx);
  CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
  CGGradientRelease(gradient);
  
  CGContextRestoreGState(ctx);
}

- (void) drawBackground:(CGRect)rect
{
  if (self.behavior == CellBackgroundBehaviorSelected
      && self.cell.selectionStyle != UITableViewCellSelectionStyleNone)
  {
    [self drawGradient:rect type:CellBackgroundGradientSelected];
    return;
  }
  
  if (self.cell.gradientStartColor && self.cell.gradientEndColor)
  {
    [self drawGradient:rect type:CellBackgroundGradientNormal];
    return;
  }
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextSaveGState(ctx);
  
  // draws body
  CGPathRef path;
  path = [self createRoundedPath:rect];
  
  CGContextAddPath(ctx, path);
  
  CGContextSetFillColorWithColor(ctx, self.cell.backgroundColor.CGColor);
  CGContextFillPath(ctx);
  
  CGContextRestoreGState(ctx);
}

- (void) drawSingleLineSeparator:(CGRect)rect
{
  [WXWUIUtils drawLineAtHeight:CGRectGetMaxY(rect)
                       rect:rect
                      color:self.cell.customSeparatorColor
                      width:1];
}

- (void) drawEtchedSeparator:(CGRect)rect
{
  [WXWUIUtils drawLineAtHeight:CGRectGetMaxY(rect)-1
                       rect:rect
                      color:self.cell.customSeparatorColor
                      width:0.5];
  [WXWUIUtils drawLineAtHeight:CGRectGetMaxY(rect)-0.5
                       rect:rect
                      color:[UIColor whiteColor]
                      width:1];
  
}

- (void) drawLineSeparator:(CGRect)rect
{
  switch (self.cell.customSeparatorStyle)
  {
    case UITableViewCellSeparatorStyleSingleLine:
      [self drawSingleLineSeparator:rect];
      break;
    case UITableViewCellSeparatorStyleSingleLineEtched:
      [self drawEtchedSeparator:rect];
    default:
      break;
  }
}

- (void) fixShadow:(CGContextRef)ctx rect:(CGRect)rect
{
  if (self.cell.position == ConfigurableTableViewCellPositionTop || self.cell.position == ConfigurableTableViewCellPositionAlone)
  {
    return;
  }
  
  CGContextSaveGState(ctx);
  CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
  CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMinY(rect));
  CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
  CGContextSetLineWidth(ctx, 5);
  
  UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
  CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 3, shadowColor.CGColor);
  
  CGContextStrokePath(ctx);
  
  CGContextRestoreGState(ctx);
  
}

- (void) drawBorder:(CGRect)rect shadow:(BOOL)shadow
{
  float shadowShift = 0.5 * self.cell.dropsShadow;
  
  CGRect innerRect = CGRectMake(rect.origin.x+shadowShift, rect.origin.y+shadowShift,
                                rect.size.width-shadowShift*2, rect.size.height-shadowShift*2);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  if (shadow)
  {
    [self fixShadow:ctx rect:innerRect];
  }
  
  
  CGContextSaveGState(ctx);
  
  // draws body
  
  CGPathRef path = [self createRoundedPath:innerRect];
  CGContextAddPath(ctx, path);
  
  if (shadow) {
    UIColor *shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.cell.shadowOpacity];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 3, shadowColor.CGColor);
  }
  CGContextSetStrokeColorWithColor(ctx, self.cell.borderColor.CGColor);
  CGContextSetLineWidth(ctx, 2 - shadowShift);
  CGContextStrokePath(ctx);
  
  CGContextRestoreGState(ctx);
}

- (CGRect) innerFrame:(CGRect)frame
{
  float y = 0;
  float h = 0;
  
  float shadowMargin = [self.cell shadowMargin];
  
  switch (self.cell.position)
  {
    case ConfigurableTableViewCellPositionAlone:
      h += shadowMargin;
    case ConfigurableTableViewCellPositionTop:
      y = shadowMargin;
      h += shadowMargin;
      break;
    case ConfigurableTableViewCellPositionBottom:
      h = shadowMargin;
      break;
    default:
      break;
  }
  
  return CGRectMake(frame.origin.x + shadowMargin,
                    frame.origin.y + y,
                    frame.size.width - shadowMargin*2,
                    frame.size.height - h);
}


- (void) drawRect:(CGRect)initialRect
{

  if (CURRENT_OS_VERSION >= IOS7) {
    return;
  }
  CGRect rect = [self innerFrame:initialRect];
  
  [self drawBorder:rect shadow:self.cell.dropsShadow];
  
  [self drawBackground:rect];
  
  switch (self.cell.position)
  {
    case ConfigurableTableViewCellPositionAlone:
    case ConfigurableTableViewCellPositionBottom:
      if (self.cell.tableViewIsGrouped)
      {
        break;
      }
    default:
      [self drawLineSeparator:CGRectMake(rect.origin.x, rect.origin.y,
                                         rect.size.width, rect.size.height)];
      break;
  }
}

- (void) dealloc
{
  self.cell = nil;
  
  [super dealloc];
}

- (id) initWithFrame:(CGRect)frame behavior:(CellBackgroundBehavior)bbehavior
{
  if (self = [super initWithFrame:frame])
  {
    self.contentMode = UIViewContentModeRedraw;
    self.behavior = bbehavior;
    self.backgroundColor = TRANSPARENT_COLOR;
  }
  
  return self;
}


@end


@implementation BaseConfigurableCell

@synthesize position, dropsShadow, borderColor, tableViewBackgroundColor;
@synthesize customSeparatorColor, selectionGradientStartColor, selectionGradientEndColor;
@synthesize cornerRadius;
@synthesize customBackgroundColor, gradientStartColor, gradientEndColor;
@synthesize shadowOpacity, customSeparatorStyle;


- (void) dealloc
{
  [self.contentView removeObserver:self forKeyPath:@"frame"];
  self.borderColor = nil;
  self.tableViewBackgroundColor = nil;
  self.customSeparatorColor = nil;
  self.selectionGradientStartColor = nil;
  self.selectionGradientEndColor = nil;
  self.customBackgroundColor = nil;
  self.gradientStartColor = nil;
  self.gradientEndColor = nil;
  
  [super dealloc];
}

- (void)initializeVars
{
  // default values
  self.position = ConfigurableTableViewCellPositionMiddle;
  self.dropsShadow = YES;
  self.borderColor = DEFAULT_BORDER_COLOR;
  self.tableViewBackgroundColor = TRANSPARENT_COLOR;
  self.customSeparatorColor = DEFAULT_SEPARATOR_COLOR;
  self.selectionGradientStartColor = DEFAULT_SELECTION_GRADIENT_START_COLOR;
  self.selectionGradientEndColor = DEFAULT_SELECTION_GRADIENT_END_COLOR;
  self.cornerRadius = DEFAULT_RADIUS;
  self.shadowOpacity = DEFAULT_SHADOW_OPACITY;
  self.customSeparatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self.contentView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionOld context:nil];
    
    
    ConfigurableTableViewCellBackground *bg = [[ConfigurableTableViewCellBackground alloc] initWithFrame:self.frame
                                                                                    behavior:CellBackgroundBehaviorNormal];
    bg.cell = self;
    self.backgroundView = bg;
    [bg release];
    
    bg = [[ConfigurableTableViewCellBackground alloc] initWithFrame:self.frame
                                                     behavior:CellBackgroundBehaviorSelected];
    bg.cell = self;
    self.selectedBackgroundView = bg;
    [bg release];
    
    [self initializeVars];
  }
  return self;
}

+ (ConfigurableTableViewCellPosition)positionForTableView:(UITableView *)tableView
                                                indexPath:(NSIndexPath *)indexPath {
  
  if ([tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section] == 1) {
    return ConfigurableTableViewCellPositionAlone;
  }
  if (indexPath.row == 0) {
    return ConfigurableTableViewCellPositionTop;
  }
  if (indexPath.row+1 == [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section])
  {
    return ConfigurableTableViewCellPositionBottom;
  }
  
  return ConfigurableTableViewCellPositionMiddle;
}

+ (CGFloat)neededHeightForPosition:(ConfigurableTableViewCellPosition)position tableStyle:(UITableViewStyle)style
{
  if (style == UITableViewStylePlain)
  {
    return 0;
  }
  
  switch (position)
  {
    case ConfigurableTableViewCellPositionBottom:
    case ConfigurableTableViewCellPositionTop:
      return SHADOW_MARGIN;
    case ConfigurableTableViewCellPositionAlone:
      return SHADOW_MARGIN*2;
    default:
      return 0;
  }
}

+ (CGFloat) tableView:(UITableView *)tableView neededHeightForIndexPath:(NSIndexPath *)indexPath
{
  ConfigurableTableViewCellPosition position = [BaseConfigurableCell positionForTableView:tableView indexPath:indexPath];
  return [BaseConfigurableCell neededHeightForPosition:position tableStyle:tableView.style];
}

- (BOOL)tableViewIsGrouped {
  return _tableViewStyle == UITableViewStyleGrouped;
}

- (void) prepareForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
  _tableViewStyle = tableView.style;
  self.position = [BaseConfigurableCell positionForTableView:tableView indexPath:indexPath];
}

// Avoids contentView's frame auto-updating. It calculates the best size, taking
// into account the cell's margin and so.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"frame"])
  {
    UIView *contentView = (UIView *) object;
    CGRect originalFrame = contentView.frame;
    
    float shadowMargin = [self shadowMargin];
    
    float y = CONTENTVIEW_MARGIN;
    switch (self.position) {
      case ConfigurableTableViewCellPositionTop:
      case ConfigurableTableViewCellPositionAlone:
        y += shadowMargin;
        break;
      default:
        break;
    }
    float diffY = y - originalFrame.origin.y;
    
    if (diffY != 0)
    {
      CGRect rect = CGRectMake(originalFrame.origin.x+shadowMargin,
                               originalFrame.origin.y+diffY,
                               originalFrame.size.width - shadowMargin*2,
                               originalFrame.size.height- CONTENTVIEW_MARGIN*2 - [BaseConfigurableCell neededHeightForPosition:self.position tableStyle:_tableViewStyle]);
      contentView.frame = rect;
    }
  }
}

- (void) prepareForReuse
{
  [super prepareForReuse];
  [self.backgroundView setNeedsDisplay];
  [self.selectedBackgroundView setNeedsDisplay];
}

- (void) setTableViewBackgroundColor:(UIColor *)aBackgroundColor
{
  [aBackgroundColor retain];
  if (tableViewBackgroundColor != nil) {
    [tableViewBackgroundColor release];
  }
  tableViewBackgroundColor = aBackgroundColor;
  
  self.backgroundView.backgroundColor = aBackgroundColor;
  self.selectedBackgroundView.backgroundColor = aBackgroundColor;
}


- (CGRect) innerFrame
{
  float topMargin = 0;
  float bottomMargin = 0;
  float shadowMargin = [self shadowMargin];
  
  switch (self.position) {
    case ConfigurableTableViewCellPositionTop:
      topMargin = shadowMargin;
    case ConfigurableTableViewCellPositionMiddle:
      // let the separator to be painted, but separator is only painted
      // in grouped table views
      bottomMargin = [self tableViewIsGrouped] ? 1 : 0;
      break;
    case ConfigurableTableViewCellPositionAlone:
      topMargin = shadowMargin;
      bottomMargin = shadowMargin;
      break;
    case ConfigurableTableViewCellPositionBottom:
      bottomMargin = shadowMargin;
      break;
    default:
      break;
  }
  
  
  CGRect frame = CGRectMake(self.backgroundView.frame.origin.x+shadowMargin,
                            self.backgroundView.frame.origin.y+topMargin,
                            self.backgroundView.frame.size.width-shadowMargin*2,
                            self.backgroundView.frame.size.height-topMargin-bottomMargin);
  
  return frame;
}


- (CAShapeLayer *) mask
{
  UIRectCorner corners = 0;
  
  switch (self.position)
  {
    case ConfigurableTableViewCellPositionTop:
      corners = UIRectCornerTopLeft | UIRectCornerTopRight;
      break;
    case ConfigurableTableViewCellPositionAlone:
      corners = UIRectCornerAllCorners;
      break;
    case ConfigurableTableViewCellPositionBottom:
      corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
      break;
    default:
      break;
  }
  
  CGRect maskRect = CGRectMake(0, 0,
                               self.innerFrame.size.width,
                               self.innerFrame.size.height);
  
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                 byRoundingCorners:corners
                                                       cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
  
  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
  maskLayer.frame = maskRect;
  maskLayer.path = maskPath.CGPath;
  
  return [maskLayer autorelease];
}

- (BOOL) dropsShadow
{
  return dropsShadow && [self tableViewIsGrouped];
}

- (float) cornerRadius
{
  return [self tableViewIsGrouped] ? cornerRadius : 0;
}

- (UIColor *) backgroundColor
{
  return customBackgroundColor ? customBackgroundColor : [super backgroundColor];
}

/*
- (CGGradientRef) createSelectionGradient
{
  return [self newSelectionGradient];
}
 */

- (CGGradientRef) newSelectionGradient
{
  CGFloat locations[] = { 0, 1 };
  
  NSArray *colors = [NSArray arrayWithObjects:(id)self.selectionGradientStartColor.CGColor, (id)self.selectionGradientEndColor.CGColor, nil];
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                      (CFArrayRef) colors, locations);
  CGColorSpaceRelease(colorSpace);
  
  return gradient;
}

/*
- (CGGradientRef) createNormalGradient
{
  return [self newNormalGradient];
}
 */

- (CGGradientRef) newNormalGradient
{
  CGFloat locations[] = { 0, 1 };
  
  NSArray *colors = [NSArray arrayWithObjects:(id)self.gradientStartColor.CGColor, (id)self.gradientEndColor.CGColor, nil];
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                      (CFArrayRef) colors, locations);
  CGColorSpaceRelease(colorSpace);
  
  return gradient;
}

#pragma mark - Deprecated stuff

- (BOOL) showsCustomSeparator
{
  return self.customSeparatorStyle != UITableViewCellSeparatorStyleNone;
}

- (void) setShowsCustomSeparator:(BOOL)showsCustomSeparator
{
  switch (showsCustomSeparator)
  {
    case YES:
      self.customSeparatorStyle = UITableViewCellSeparatorStyleSingleLine;
      break;
    case NO:
      self.customSeparatorStyle = UITableViewCellSeparatorStyleNone;
      break;
  }
}

@end
