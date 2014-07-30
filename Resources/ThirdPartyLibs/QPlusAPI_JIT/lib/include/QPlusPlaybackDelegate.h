//
//  QPlusPlaybackDelegate.h
//  QPlusAPI
//
//  Created by ouyang on 13-5-11.
//  Copyright (c) 2013年 ouyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QPlusPlaybackDelegate <NSObject>

@optional
/**
 * 播放开始的回调
 */
- (void)onPlayStart;

/**
 * 播放中的回调
 *
 * @param postion 当前播放的位置，单位毫秒
 */
- (void)onPlaying:(float)postion;

/**
 * 播放结束的回调
 */
- (void)onPlayStop;

/**
 * 播放错误的回调
 */
- (void)onError;

@end
