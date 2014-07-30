//
//  PopupView.m
//  Project
//
//  Created by XXX on 13-5-31.
//
//

#import "PopupView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalConstants.h"
#import "WXWCommonUtils.h"

#define RIGHT_ANGLE_SIDE_LEN  MARGIN * 2

#define WIDTH             140.0f

#define ITEM_HEIGHT       40.0f

@interface PopupView()
@property (nonatomic, retain) NSDictionary *optionDic;
@end

@implementation PopupView

#pragma mark - lifecycle methods
- (id)initWithDelegate:(id)delegate
       selectionAction:(SEL)selectionAction
{
  self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  if (self) {
    _target = delegate;

    _selectionAction = selectionAction;
  }
  return self;
}

- (void)dealloc {
  
  self.optionDic = nil;
  
  _tableView.delegate = nil;
  _tableView.dataSource = nil;
  
  [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
  [super drawRect:rect];
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  CGMutablePathRef outlinePath = CGPathCreateMutable();
  [self drawOutlineWithContext:ctx outlinePath:outlinePath];
 
  //CGContextSaveGState(ctx);
  {
    CGContextSetShadow(ctx, CGSizeMake(0, 3.0f), 5.0f);
    CGContextSetFillColorWithColor(ctx, COLOR(255, 255, 255).CGColor);
    CGContextFillPath(ctx);
  
  }
  //CGContextRestoreGState(ctx);
  
  //CGContextDrawPath(ctx, kCGPathFillStroke);
  
  CGPathRelease(outlinePath);
}

#pragma mark - arrange options
- (void)arrangeOptionDic:(NSDictionary *)optionDic {

  if (optionDic.count > 0) {
    _height = optionDic.count * ITEM_HEIGHT;
    
    self.optionDic = optionDic;
    
    if (nil == _tableView) {
      [self initTableView];
    }
  
    [_tableView reloadData];
  }
}

#pragma mark - arrange table view 
- (void)initTableView {
  _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(_topLeftPoint.x + 1, _topLeftPoint.y + 1, WIDTH - 2, _height - 2)
                                             style:UITableViewStylePlain] autorelease];
  
  _tableView.delegate = self;
  _tableView.dataSource = self;
  [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {

  return self.optionDic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *kCellIdentifier = @"itemCell";
  
  UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
  if (nil == cell) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:kCellIdentifier] autorelease];
    
        cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = BOLD_FONT(15);
  }
  
  if (_selectedIndex == indexPath.row) {

    cell.textLabel.textColor = NAVIGATION_BAR_COLOR;
    UIImageView *icon = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 13)] autorelease];
    icon.image = [UIImage imageNamed:@"redHook.png"];
    cell.accessoryView = icon;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = BASE_INFO_COLOR;
    cell.accessoryView = nil;
  }
  
  cell.textLabel.text = [self.optionDic objectForKey:@(indexPath.row)];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  _selectedIndex = indexPath.row;
  
  if (_target && _selectionAction) {
    [_target performSelector:_selectionAction withObject:@(_selectedIndex)];
  }
  
  [self hidePopupView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return ITEM_HEIGHT;
}


#pragma mark - arrange view

- (void)drawOutlineWithContext:(CGContextRef)ctx outlinePath:(CGMutablePathRef)outlinePath {

  // CGContextSetStrokeColorWithColor(ctx, SEPARATOR_LINE_COLOR.CGColor);
  
  CGPathMoveToPoint(outlinePath, NULL, _topLeftPoint.x, _topLeftPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _arrowBottomLeftPoint.x, _arrowBottomLeftPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _arrowVertexX, _arrowVertexY);
  CGPathAddLineToPoint(outlinePath, NULL, _arrowBottomRightPoint.x, _arrowBottomRightPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _topRightPoint.x, _topRightPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _bottomRightPoint.x, _bottomRightPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _bottomLeftPoint.x, _bottomLeftPoint.y);
  CGPathAddLineToPoint(outlinePath, NULL, _topLeftPoint.x, _topLeftPoint.y);
  
  CGPathCloseSubpath(outlinePath);
  
  CGContextAddPath(ctx, outlinePath);
 
}

- (void)calculateVertexCoordinate {
  
  CGFloat halfWidth = WIDTH/2.0f;
  CGFloat halfHeight = _height/2.0f;
  
  _topLeftPoint = CGPointMake(_midX - halfWidth, _midY - halfHeight);
  _topRightPoint = CGPointMake(_midX + halfWidth, _midY - halfHeight);
  _bottomLeftPoint = CGPointMake(_midX - halfWidth, _midY + halfHeight);
  _bottomRightPoint = CGPointMake(_midX + halfWidth, _midY + halfHeight);
  
}

- (void)presentFromFrame:(CGRect)frame
               optionDic:(NSDictionary *)optionDic
    currentSelectedIndex:(NSInteger)currentSelectedIndex {
  
  if (optionDic.count == 0) {
    return;
  }
  
  _selectedIndex = currentSelectedIndex;
  
  _height = optionDic.count * ITEM_HEIGHT;
  
  self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
  //self.backgroundColor = TRANSPARENT_COLOR;
  
  // calculate mid y
  _displayAbove = YES;
  CGFloat poperMidY = frame.origin.y + frame.size.height/2.0f;
  if (poperMidY < SCREEN_HEIGHT/2.0f) {
    _displayAbove = NO;
  }
  
  if (_displayAbove) {
    _arrowVertexY = frame.origin.y - 2.0f;
    _midY = _arrowVertexY - RIGHT_ANGLE_SIDE_LEN - _height/2.0f;
    
  } else {
    _arrowVertexY = frame.origin.y + frame.size.height + 2.0f;
    _midY = _arrowVertexY + RIGHT_ANGLE_SIDE_LEN + _height/2.0f;
  }
  
  // calculate mid x
  _displayLeft = YES;
  CGFloat poperMidX = frame.origin.x + frame.size.width/2.0f;
  if (poperMidX < SCREEN_WIDTH/2.0f) {
    _displayLeft = NO;
  }

  CGFloat screenMidX = SCREEN_WIDTH/2.0f;
  
  if (_displayLeft) {
    
    _arrowVertexX = frame.origin.x;
    
    _midX = screenMidX - (screenMidX - _arrowVertexX)/2.0f;
  } else {
    
    _arrowVertexX = frame.origin.x + frame.size.width;
    
    _midX = screenMidX + (_arrowVertexX - screenMidX)/2.0f;
  }
  
  // calculate vertex points
  [self calculateVertexCoordinate];
  
  // calculate arrow bottom side coordinate
  CGFloat bottomY = 0;
  if (_displayAbove) {
    bottomY = _arrowVertexY - RIGHT_ANGLE_SIDE_LEN;
  } else {
    bottomY = _arrowVertexY + RIGHT_ANGLE_SIDE_LEN;
  }

  _arrowBottomLeftPoint = CGPointMake(_arrowVertexX - RIGHT_ANGLE_SIDE_LEN, bottomY);
  _arrowBottomRightPoint = CGPointMake(_arrowVertexX + RIGHT_ANGLE_SIDE_LEN, bottomY);
  
  self.alpha = 0.0f;
  
  [self arrangeOptionDic:optionDic];
  
  [APP_WINDOW addSubview:self];
  
  [self displayPopupView];
}

#pragma mark - display/hide pop up view
- (void)displayPopupView {

  [UIView animateWithDuration:0.2f
                   animations:^{
                     self.alpha = 1.0f;
                   }];

}

- (void)hidePopupView {
  [UIView animateWithDuration:0.2f
                   animations:^{
                     self.alpha = 0.0f;
                   }
                   completion:^(BOOL finished){
                     [self removeFromSuperview];
                   }];
}

#pragma mark - touch event
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  
  if (_tableView) {
    CGPoint locationPoint = [touches.anyObject locationInView:self];
    
    if ([_tableView pointInside:[self convertPoint:locationPoint
                                            toView:_tableView]
                      withEvent:event]) {

      // touch inside the pop up view
    } else {
      
      // touch outside the pop up view;
      
      [self hidePopupView];
    }
  }
}

@end
