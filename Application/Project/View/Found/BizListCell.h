//
//  BizListCell.h
//  Project
//
//  Created by user on 13-9-24.
//  Copyright (c) 2013年 com.jit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHImageView.h"

#define SEARCH_RESULT_CELL_HEIGHT   85

@class WXWLabel;
@class Post;

@interface BizListCell : UITableViewCell {

@private

    id _searchDelegate;
    SEL _searchAction;

}

- (void)updateCell:(Post *)userProfile;

@end
