//
//  SupplyDemandItemToolbar.h
//  Project
//
//  Created by XXX on 13-6-5.
//
//

#import <UIKit/UIKit.h>

@class Post;

@interface SupplyDemandItemToolbar : UIView {
@private
    
    id _target;
    SEL _favAction;
    SEL _dmAction;
    SEL _shareAction;
    SEL _deleteAction;
    
    UIButton *_favButton;
    UIButton *_dmButton;
    UIButton *_shareButton;
    UIButton *_deleteButton;
    
    BOOL _selfSentItem;
}

- (id)initWithFrame:(CGRect)frame
               item:(Post *)item
       selfSentItem:(BOOL)selfSentItem
             target:(id)target
          favAction:(SEL)favAction
           dmAction:(SEL)dmAction
        shareAction:(SEL)shareAction
       deleteAction:(SEL)deleteAction;

- (void)updateFavButtonWithStatus:(BOOL)favorited;

@end
