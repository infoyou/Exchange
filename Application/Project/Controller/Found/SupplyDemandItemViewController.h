//
//  SupplyDemandItemViewController.h
//  Project
//
//  Created by XXX on 13-12-25.
//
//

#import "BaseListViewController.h"
#import "JSCoreTextView.h"
#import "ECClickableElementDelegate.h"
#import "WXApi.h"
#import "TagListView.h"

@class Post;
@class SupplyDemandItemToolbar;

@interface SupplyDemandItemViewController : BaseListViewController <TagSelectionDelegate,JSCoreTextViewDelegate, ECClickableElementDelegate, WXApiDelegate, UIActionSheetDelegate> {
  
  @private
  SupplyDemandItemToolbar *_toolbar;
  
  id _target;
  SEL _triggerRefreshAction;
}

- (id)initMOC:(NSManagedObjectContext *)MOC
         item:(Post *)item
       target:(id)target
triggerRrefreshAction:(SEL)triggerRrefreshAction;

@end
