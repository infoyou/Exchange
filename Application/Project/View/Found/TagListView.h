//
//  TagListView.h
//  Project
//
//  Created by XXX on 12-6-29.
//  Copyright (c) 2012年 _MyCompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GlobalConstants.h"
#import "Tag.h"

@protocol TagSelectionDelegate <NSObject>

- (void)selectTagWithName:(Tag *)tag;

@end


@interface TagListView : UIView <UIScrollViewDelegate> {
@private
    
    UIImageView *_icon;
    
    UIScrollView *_tagsContainerView;
    
    NSMutableDictionary *_tagAndLabelDic;
    
    CAGradientLayer *_maskLayer;
    
    id<TagSelectionDelegate> _selectionDelegate;
    
    NSManagedObjectContext *_MOC;
}

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame
  selectionDelegate:(id<TagSelectionDelegate>)selectionDelegate
                MOC:(NSManagedObjectContext *)MOC;

- (void)drawViews:(NSArray *)tags;

- (void)drawTagIds:(NSString *)tagIds;

@end
