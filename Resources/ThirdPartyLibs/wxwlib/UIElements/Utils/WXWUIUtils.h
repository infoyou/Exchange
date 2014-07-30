//
//  WXWUIUtils.h
//  Project
//
//  Created by XXX on 12-5-30.
//  Copyright (c) 2011年 _CompanyName_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WXWConstants.h"

@class WXWPullRefreshTableFooterView;
@class WXWPullRefreshTableHeaderView;

@interface WXWUIUtils : NSObject

#pragma mark - no background view activity view
+ (void)showNoBackgroundActivityView:(UIView *)view;
+ (void)closeNoBackgroundActivityView;

#pragma mark - show notification fade-in fade-out
+ (void)showNotificationWithMsg:(NSString *)msg msgType:(MessageType)msgType;

#pragma mark - alert view
+ (void)alert:(NSString*)title message:(NSString*)message;

#pragma mark - refreshment triggered by footer view, load older posts
+ (BOOL)shouldLoadNewItems:(UIScrollView *)scrollView
                headerView:(WXWPullRefreshTableHeaderView *)headerView
                 reloading:(BOOL)reloading;

+ (BOOL)shouldLoadOlderItems:(UIScrollView *)scrollView
             tableViewHeight:(CGFloat)tableViewHeight
                  footerView:(WXWPullRefreshTableFooterView *)footerView
                   reloading:(BOOL)reloading;

+ (void)dataSourceDidFinishLoadingNewData:(UITableView *)tableView
                               headerView:(WXWPullRefreshTableHeaderView *)headerView;

+ (void)dataSourceDidFinishLoadingOldData:(UITableView *)tableView
                               footerView:(WXWPullRefreshTableFooterView *)footerView;

+ (void)animationForScrollViewDidEndDragging:(UIScrollView *)scrollView
                                   tableView:(UITableView *)tableView
                                  headerView:(WXWPullRefreshTableHeaderView *)headerView;

+ (void)animationForScrollViewDidEndDragging:(UIScrollView *)scrollView
                                   tableView:(UITableView *)tableView
                                  footerView:(WXWPullRefreshTableFooterView *)footerView;

#pragma mark - line
+ (void)draw1PxStroke:(CGContextRef)context
           startPoint:(CGPoint)startPoint
             endPoint:(CGPoint)endPoint
                color:(CGColorRef)color
         shadowOffset:(CGSize)shadowOffset
          shadowColor:(UIColor *)shadowColor;

+ (void)draw1PxDashLine:(CGContextRef)context
             startPoint:(CGPoint)startPoint
               endPoint:(CGPoint)endPoint
               colorRef:(CGColorRef)colorRef
           shadowOffset:(CGSize)shadowOffset
            shadowColor:(UIColor *)shadowColor
                pattern:(CGFloat[])pattern;

#pragma mark - height for news detail view UI elements
+ (CGFloat)reportTitleHeight:(NSString *)title;
+ (CGFloat)contentHeight:(NSString *)content width:(CGFloat)width;

#pragma mark - show notification on screen top
+ (BOOL)showingNotification;

+ (void)hideNotification;

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar;

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar
                      animationEnded:(void (^)(void))animationEnded;

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                      alternativeMsg:(NSString *)alternativeMsg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar;

+ (void)showNotificationOnTopWithMsg:(NSString *)msg
                      alternativeMsg:(NSString *)alternativeMsg
                             msgType:(MessageType)msgType
                  belowNavigationBar:(BOOL)belowNavigationBar
                      animationEnded:(void (^)(void))animationEnded;

#pragma mark - page index indicator for news swipe browser
+ (void)showPageIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount;

#pragma mark - activity view
+ (void)showActivityView:(UIView *)currentView text:(NSString *)text;
+ (void)arrangeActivityViewRotation;
+ (BOOL)activityViewIsAnimating;
+ (void)closeActivityView;

#pragma mark - UISearchBar utilities
+ (void)clearSearchBarBackgroundColor:(UISearchBar *)searchBar;

#pragma mark - core graphic utilities

+ (void)drawGradient:(CGRect)rect
           fromColor:(UIColor *)from
             toColor:(UIColor *)to;

+ (void)drawLineAtPosition:(LinePosition)position
                      rect:(CGRect)rect
                     color:(UIColor *)color;

+ (void)drawLineAtHeight:(float)height
                    rect:(CGRect)rect
                   color:(UIColor *)color
                   width:(float)width;

+ (void)drawGradient:(CGGradientRef)gradient
                rect:(CGRect)rect;
@end

@interface UIColor (WXWWEKit)

/** Returns an autoreleased UIColor instance with the hexadecimal color.
 
 @param hex A color in hexadecimal notation: `0xCCCCCC`, `0xF7F7F7`, etc.
 
 @return A new autoreleased UIColor instance. */
+ (UIColor *) colorWithHex:(int)hex;

@end
