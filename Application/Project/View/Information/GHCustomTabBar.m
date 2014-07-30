//
//  CustomTabBar.m
//  CustomTabBar
//
//  Created by XXX Boctor on 1/2/11.
//
// Copyright (c) 2011 XXX Boctor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "GHCustomTabBar.h"
#import "CommonHeader.h"

#define GLOW_IMAGE_TAG 2394858
#define TAB_ARROW_IMAGE_TAG 2394859
#define SELECTED_ITEM_TAG 2394860

@interface GHCustomTabBar (PrivateMethods)
- (CGFloat)horizontalLocationFor:(NSUInteger)tabIndex;
- (void)addTabBarArrowAtIndex:(NSUInteger)itemIndex;
- (UIButton *)buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
- (UIImage *)tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
- (UIImage *)blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;
- (UIImage *)tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
@end

@implementation GHCustomTabBar {
    CGSize _titleSize;
}
@synthesize buttons;
@synthesize texts;
@synthesize countLabel = _countLabel;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize buttonSize:(CGSize)buttonSize  tag:(NSInteger)objectTag delegate:(NSObject <GHCustomTabBarDelegate>*)customTabBarDelegate
{
    if (self = [super init])
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bottom_tab_background.png"]];
        //        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithCIImage:[UIImage imageNamed:@"bottom_tab_background.png"].CIImage scale:1.0f orientation:1.0f]];
        
        
        // The tag allows callers withe multiple controls to distinguish between them
        self.tag = objectTag;
        
        // Set the delegate
        delegate = customTabBarDelegate;
        
        // Adjust our width based on the number of items & the width of each item
        self.frame = CGRectMake(0, 0, itemSize.width * itemCount, itemSize.height);
        
        
        
        // Add the background image
        UIImage* backgroundImage = [delegate backgroundImage:self.frame];
        UIImageView* backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        backgroundImageView.frame = self.frame;
        [self addSubview:backgroundImageView];
        
        // Initalize the array we use to store our buttons
        self.buttons = [[[NSMutableArray alloc] initWithCapacity:itemCount] autorelease];
        self.texts = [[[NSMutableArray alloc] initWithCapacity:itemCount] autorelease];
        
        // horizontalOffset tracks the proper x value as we add buttons as subviews
        CGFloat horizontalOffset = (self.frame.size.width - itemCount * buttonSize.width ) / 2;
        
        
        _titleSize.height = buttonSize.height*1/4.0;
        _titleSize.width = buttonSize.width;
        
        CGSize btnSize = CGSizeMake(buttonSize.width, buttonSize.height - _titleSize.height);
        // Iterate through each item
        for (NSUInteger i = 0 ; i < itemCount ; i++)
        {
            // Create a button
            UIButton* button = [self buttonAtIndex:i width:btnSize.width];
            button.tag = i;
            
            // Register for touch events
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            
            [button setTitle:[delegate nameFor:self atIndex:i] forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor colorWithHexString:@"0xee6e47"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithHexString:@"0xffffff"] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor colorWithHexString:@"0xffffff"] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:FONT_SYSTEM_SIZE(14)];
            button.titleEdgeInsets = UIEdgeInsetsMake(3, 5, 0, 0);
//            button.backgroundColor = [UIColor clearColor];
            // Add the button to our buttons array
            [buttons addObject:button];
            
            // Set the button's x offset
            
            
            int dist = 0;
            button.frame = CGRectMake(horizontalOffset , -dist, buttonSize.width, buttonSize.height);
            
            
            NSLog(@"%f:%f", button.frame.size.width, button.frame.size.height);
            
            //        button.frame = CGRectMake(horizontalOffset + (buttonSize.width - buttonImageSize.width) / 2, -buttonSize.height + buttonImageSize.height , buttonImageSize.width, buttonImageSize.height);
            
            
            // Add the button as our subview
            [self addSubview:button];
            
            
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(horizontalOffset + buttonSize.width / 4 + 2, buttonSize.height - _titleSize.height, buttonSize.width  / 2.0f, _titleSize.height);
            
            textLabel.text = [delegate nameFor:self atIndex:i];
            textLabel.textColor = [UIColor whiteColor];
            [textLabel setHighlightedTextColor:[UIColor colorWithHexString:@"0xe64125"]];
            textLabel.backgroundColor = TRANSPARENT_COLOR;
            textLabel.textAlignment = NSTextAlignmentCenter;
            [textLabel setFont:FONT_SYSTEM_SIZE(14)];
            [textLabel setNumberOfLines:1];
            [textLabel sizeToFit];
            
            CGRect textRect = textLabel.frame;
            textRect.origin.y = (buttonSize.height - textRect.size.height) / 2.0f;
            textLabel.frame = textRect;
            
            
            [texts addObject:textLabel];
//            [self addSubview:textLabel];
            [textLabel release];
            
            
            //-------------
            int countLabelHeight = 15;
            int countLabelWidth = 15;
            int countLabelStartX = horizontalOffset + buttonSize.width - countLabelWidth - 5;
            int countLabelStartY = 7;
            
            _countLabel = [[UILabel alloc] init];
            _countLabel.frame = CGRectMake(countLabelStartX, countLabelStartY, countLabelWidth , countLabelHeight);
            
            if ([delegate infoCount:i] == 0)
                [_countLabel setHidden:YES];
            
            _countLabel.text =[NSString stringWithFormat:@"%d", [delegate infoCount:i]];
            _countLabel.textColor = [UIColor whiteColor];
            _countLabel.backgroundColor = [UIColor redColor];
            _countLabel.textAlignment = NSTextAlignmentCenter;
            [_countLabel setFont:FONT_BOLD_SYSTEM_SIZE(10)];
            
            
            [self addSubview:_countLabel];
            
            // Advance the horizontal offset
            horizontalOffset = horizontalOffset + buttonSize.width;
            
            UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalOffset, 0, 1, buttonSize.height)];
            lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xec643c"];
            [self addSubview:lineLabel];
            [lineLabel release];
            
        }
    }
    
    return self;
}

- (void)dimAllButtonsExcept:(UIButton*)selectedButton
{
    for (UIButton* button in buttons)
    {
        if (button == selectedButton)
        {
            button.selected = YES;
            button.highlighted = button.selected ? NO : YES;
            button.tag = SELECTED_ITEM_TAG;
            
            UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
            NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
            if (tabBarArrow)
            {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect frame = tabBarArrow.frame;
                frame.origin.x = [self horizontalLocationFor:selectedIndex];
                tabBarArrow.frame = frame;
                [UIView commitAnimations];
            }
            else
            {
                [self addTabBarArrowAtIndex:selectedIndex];
            }
        }
        else
        {
            button.selected = NO;
            button.highlighted = NO;
            button.tag = 0;
        }
    }
}


#pragma mark -- button events
- (void)touchDownAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    [self dimAllTextLabelExcept:[texts objectAtIndex:[buttons indexOfObject:button]]];
    
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
        [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    [self dimAllTextLabelExcept:[texts objectAtIndex:[buttons indexOfObject:button]]];
    
    if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    
    [self dimAllTextLabelExcept:[texts objectAtIndex:[buttons indexOfObject:button]]];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    // Get the right button to select
    UIButton* button = [buttons objectAtIndex:index];
    
    [self dimAllButtonsExcept:button];
    [self dimAllTextLabelExcept:[texts objectAtIndex:[buttons indexOfObject:button]]];
    
    
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
        [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
    
    
}

- (void)dimAllTextLabelExcept:(UILabel*)selectedLabel
{
    for (UILabel *label in texts) {
        if (label == selectedLabel) {
            label.textColor = [UIColor colorWithHexString:@"0xe83e0b"];
        }else{
            label.textColor = [UIColor whiteColor];
        }
        [self bringSubviewToFront:label];
    }
}

// Add a glow at the bottom of the specified item
- (void)glowItemAtIndex:(NSInteger)index
{
    // Get the right button. We'll use to calculate where to put the glow
    UIButton* button = [buttons objectAtIndex:index];
    
    // Ask the delegate for the glow image
    UIImage* glowImage = [delegate glowImage];
    
    // Create the image view that will hold the glow image
    UIImageView* glowImageView = [[[UIImageView alloc] initWithImage:glowImage] autorelease];
    
    // Center the glow image at the center of the button horizontally and at the bottom of the button vertically
    
    
    glowImageView.frame = CGRectMake(button.frame.origin.x + button.frame.size.width - glowImage.size.width + 3, button.frame.origin.y + button.frame.size.height - glowImage.size.height, glowImage.size.width - 6, glowImage.size.height - 0);
    
    // Set the glow image view's tag so we can find it later when we want to remove the glow
    glowImageView.tag = GLOW_IMAGE_TAG;
    
    
    // Add the glow image view to the button
    //    [button insertSubview:glowImageView belowSubview:button];
    //  [button addSubview:glowImageView];
    
    [self insertSubview:glowImageView belowSubview:button];
}

// Remove the glow at the bottom of the specified item
- (void) removeGlowAtIndex:(NSInteger)index
{
    // Find the right button
    //    UIButton* button = [buttons objectAtIndex:index];
    // Find the glow image view
    UIImageView* glowImageView = (UIImageView*)[self viewWithTag:GLOW_IMAGE_TAG];
    // Remove it from the button
    [glowImageView removeFromSuperview];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    //    UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
    
    // A single tab item's width is the same as the button's width
    UIButton* button = [buttons objectAtIndex:tabIndex];
    //    CGFloat tabItemWidth = button.frame.size.width;
    
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    //    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return button.frame.origin.x + 0;
}

- (void) addTabBarArrowAtIndex:(NSUInteger)itemIndex
{
    UIImage* tabBarArrowImage = [delegate tabBarArrowImage];
    UIImageView* tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
    tabBarArrow.tag = TAB_ARROW_IMAGE_TAG;
    // To get the vertical location we go up by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
    CGFloat verticalLocation = -tabBarArrowImage.size.height;
    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:itemIndex], verticalLocation + 4, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    
    [self addSubview:tabBarArrow];
}

- (UIImage *)adjustImage:(CGSize )size withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(size);
    
    [image  drawInRect:CGRectMake(size.height / 8.0f, size.height / 4.0f, size.height /2.0f , size.height/2.0f)];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return theImage;
}

-(UIImage *)addText:(UIImage *)img text:(NSString *)someText color:(UIColor *)color{
	int w = img.size.width;
	int h = img.size.height;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
	
    CGContextSetRGBFillColor(context, color.red, color.green, color.blue, 1);
	char* text= (char *)[someText cStringUsingEncoding:NSASCIIStringEncoding];
	CGContextSelectFont(context, "Arial",20, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextSetRGBFillColor(context, 0, 0, 0, 1);
	CGContextShowTextAtPoint(context,10,10,text, strlen(text));
	CGImageRef imgCombined = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	
	UIImage *retImage = [UIImage imageWithCGImage:imgCombined];
	CGImageRelease(imgCombined);
	
	return retImage;
}


// Create a button at the provided index
- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
    // Create a new button with the right dimensions
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height);
    
    // Ask the delegate for the button's image
    UIImage* rawButtonImage = [delegate imageFor:self atIndex:itemIndex];
    
    //---------------------------------
    
    // Create the normal state image by converting the image's background to gray
    UIImage* buttonImage = [self adjustImage:button.frame.size withImage:rawButtonImage];;// [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:nil];
    // And create the pressed state image by converting the image's background to the background image we get from the delegate
    //    UIImage* buttonPressedImage = [self tabBarImage:[delegate imageForSelected:self atIndex:itemIndex] size:button.frame.size backgroundImage:nil];
    UIImage* buttonPressedImage = [self adjustImage:button.frame.size withImage:[delegate imageForSelected:self atIndex:itemIndex]] ;//[self tabBarImage:[delegate imageForSelected:self atIndex:itemIndex] size:button.frame.size backgroundImage:nil];
    //    UIImage* buttonPressedImage = [delegate imageForSelected:self atIndex:itemIndex];
    
    // Set the gray & blue images as the button states
//    buttonImage = [self addText:buttonImage text:@"xxxx" color:[UIColor redColor]];
//    buttonPressedImage = [self addText:buttonPressedImage text:@"xxxx" color:[UIColor whiteColor]];
    
//    [button setImage:buttonImage forState:UIControlStateNormal];
//    [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
//    [button setImage:buttonPressedImage forState:UIControlStateSelected];
    
    // Ask the delegate for the highlighted/selected state image & set it as the selected background state
    [button setBackgroundImage:[delegate selectedItemImage:itemIndex] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[delegate selectedItemImage:itemIndex] forState:UIControlStateSelected];
    
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

// Create a tab bar image
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource
{
    float scaleX = 0.5;
    float scaleY = 0.8;
    
    int imageWidth = targetSize.width*scaleX;
    int imageHeight = (targetSize.height - _titleSize.height)*scaleY;
    
    // Create a new context with the right size
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    
    // Draw the new tab bar image at the center
    [startImage drawInRect:CGRectMake((targetSize.width - imageWidth) / 2, (targetSize.height - _titleSize.height - imageHeight) / 2, imageWidth, imageHeight)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

// Convert the image's fill color to black and background to white
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage
{
    //    return startImage;;
    
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    
    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    
    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color to black: R:0 G:0 B:0 alpha:1
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    // Fill with black
    CGContextFillRect(context, imageRect);
    
    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    
    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    
    return newImage;
}

-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage
{
    // The background is either the passed in background image (for the blue selected state) or gray (for the non-selected state)
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backgroundImage)
    {
        // Draw the background image centered
        //    [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
        
        [backgroundImage drawInRect:CGRectMake(0,0,1000,190)];
        
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
        //        UIRectFill(CGRectMake(0, 0, 120, 90));
    }
    else
    {
        [[UIColor lightGrayColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalBackgroundImage;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGFloat itemWidth = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)  ? self.window.frame.size.height : self.window.frame.size.width)/buttons.count;
    // horizontalOffset tracks the x value
    CGFloat horizontalOffset = 0;
    
    // Iterate through each button
    for (UIButton* button in buttons)
    {
        // Set the button's x offset
        button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
        
        // Advance the horizontal offset
        horizontalOffset = horizontalOffset + itemWidth;
    }
    
    // Move the arrow to the new button location
    UIButton* selectedButton = (UIButton*)[self viewWithTag:SELECTED_ITEM_TAG];
    [self dimAllButtonsExcept:selectedButton];
}

- (void)dealloc
{
    [texts release];
    [buttons release];
    [_countLabel release];
    [super dealloc];
}


@end
