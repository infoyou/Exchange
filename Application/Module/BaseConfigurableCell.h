//
//  BaseConfigurableCell.h
//  Project
//
//  Created by XXX on 12-11-18.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "GlobalConstants.h"

typedef enum {
  ConfigurableTableViewCellPositionTop = 0,
  ConfigurableTableViewCellPositionMiddle,
  ConfigurableTableViewCellPositionBottom,
  ConfigurableTableViewCellPositionAlone
} ConfigurableTableViewCellPosition;


@interface BaseConfigurableCell : UITableViewCell {
@private
  UITableViewStyle _tableViewStyle;
}

/** @name Customizing appearance */

/** Indicates if the cell should drop a shadow or not.
 
 Its value is YES by default. */
@property (nonatomic, assign) BOOL dropsShadow;

/** Indicates the shadow opacity to use.
 
 Its value is 0.7 by default. */
@property (nonatomic, assign) float shadowOpacity;

/** Specifies the background color to use.
 
 By default is set to `nil`, so the background color will be the UITableViewCell's
 `backgroundColor` property.
 
 Change this property to override the background color in plain table views. */
@property (nonatomic, retain) UIColor *customBackgroundColor;

/** Specifies the background gradient start color to use. */
@property (nonatomic, retain) UIColor *gradientStartColor;

/** Specifies the background gradient end color to use. */
@property (nonatomic, retain) UIColor *gradientEndColor;

/** Specifies the color used for the cell's border.
 
 If dropsShadow is set to `YES`, borderColor will be ignored. This property
 has a gray color by default. */
@property (nonatomic, retain) UIColor *borderColor;

/** Specifies the radio used for the cell's corners.
 
 By default it is set to 10. */
@property (nonatomic, assign) float cornerRadius;

/** Specifies the color used for the tableView's background.
 
 This property has a clearColor by default.  */
@property (nonatomic, retain) UIColor *tableViewBackgroundColor;

/** Specifies the style of the separator.
 
 By default it's set to `UITableViewCellSeparatorStyleSingleLine`.*/
@property (nonatomic, assign) UITableViewCellSeparatorStyle customSeparatorStyle;


/** Specifies the color used for the cell's separator line.
 
 This property has a light gray color by default. */
@property (nonatomic, retain) UIColor *customSeparatorColor;


/** Specifies the start color for the selection gradient.
 
 This property has a blue color by default.
 
 If UITableViewCell's `selectionStyle` property is set to
 `UITableViewCellSelectionStyleNone`, no gradient will be shown. */
@property (nonatomic, retain) UIColor *selectionGradientStartColor;

/** Specifies the end color for the selection gradient.
 
 This property has a blue color by default.
 
 If UITableViewCell's `selectionStyle` property is set to
 `UITableViewCellSelectionStyleNone`, no gradient will be shown. */
@property (nonatomic, retain) UIColor *selectionGradientEndColor;


/** @name Cell configuration */



/** Tells the cell how it should draw the background shape.
 
 This call is mandatory. Include it in your tableView dataSource's
 `tableView:cellForRowAtIndexPath:`. */
- (void) prepareForTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;


/** Returns the needed height for a cell placed in the given indexPath.
 
 You should always implement `tableView:heightForRowAtIndexPath:` method of
 your tableView's delegate. Inside get your cell's normal height, add the
 result of calling `tableView:neededHeightForIndexPath:` and return the resulting
 value.
 
 You should always add the result of calling it, even if you set dropShadow
 property to NO. */
+ (CGFloat) tableView:(UITableView *)tableView neededHeightForIndexPath:(NSIndexPath *)indexPath;



/** @name Cell status */

/** Sets the cell's position to help the background drawing.
 
 You can change this property manually, but you should preferably use
 `prepareForTableView:indexPath:` instead.
 
 Possible values are:
 - `ConfigurableTableViewCellPositionTop`
 - `ConfigurableTableViewCellPositionMiddle`
 - `ConfigurableTableViewCellPositionBottom`
 - `ConfigurableTableViewCellPositionAlone`
 */
@property (nonatomic, assign) ConfigurableTableViewCellPosition position;

/** Returns the shadows' innerFrame. */
@property (nonatomic, readonly) CGRect innerFrame;

/** Returns a mask with the rounded corners. */
@property (nonatomic, readonly) CAShapeLayer *mask;

/** Returns a new gradient with the configured selection gradient colors. */
- (CGGradientRef) newSelectionGradient;

/** Returns a new gradient with the configured normal gradient colors. */
- (CGGradientRef) newNormalGradient;

- (BOOL)tableViewIsGrouped;

@end
