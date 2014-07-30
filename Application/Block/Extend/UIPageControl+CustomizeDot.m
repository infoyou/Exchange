//
//  UIPageControl+CustomizeDot.m
//  Project
//
//  Created by XXX on 13-1-30.
//
//

#import "UIPageControl+CustomizeDot.h"

@implementation UIPageControl (CustomizeDot)

- (void)drawCustomizedDot {

	for (int i=0; i < self.numberOfPages; i++) {
		
		UIImageView *pageIcon = [self.subviews objectAtIndex:i];
		
		/* check for class type, in case of upcomming OS changes */
		if ([pageIcon isKindOfClass:[UIImageView class]]) {
			if (i == self.currentPage) {
				/* use the active image */
				pageIcon.image = [UIImage imageNamed: @"information_pagecontrol_selected.png"];
			} else {
				/* use the inactive image */
				pageIcon.image = [UIImage imageNamed: @"information_pagecontrol_unselect.png"];
			}
		}
	}
}

/* you can alternatively add a methode swizzling, but i better not add the hackish code in case of a bad apple reviewer */
- (void)setCurrentSelectedPage:(NSInteger)page {
  
	[self setCurrentPage:page];
	//[self setNeedsDisplay];
  [self drawCustomizedDot];
}

- (NSInteger)currentSelectedPage {
	return self.currentPage;
}


@end
