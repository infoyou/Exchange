//
//  PostCommentDelegate.h
//  Project
//
//  Created by XXX on 13-7-1.
//
//

#import <Foundation/Foundation.h>

@protocol PostCommentDelegate <NSObject>

@optional
- (void)postComment:(NSString *)content;

@end
