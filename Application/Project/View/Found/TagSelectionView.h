//
//  TagSelectionView.h
//  Project
//
//  Created by XXX on 13-9-16.
//
//

#import <UIKit/UIKit.h>
#import "RootView.h"

@interface TagSelectionView : RootView <UITableViewDataSource, UITableViewDelegate> {
  @private
  
  NSInteger _rowCount;
  
  NSManagedObjectContext *_MOC;
  
  id _tagSelector;
  SEL _confirmAction;
}

- (id)initWithFrame:(CGRect)frame
               tags:(NSArray *)tags
                MOC:(NSManagedObjectContext *)MOC
        tagSelector:(id)tagSelector
      confirmAction:(SEL)confirmAction;

@end
