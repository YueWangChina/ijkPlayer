//
//  SYMediaPlayerView.h
//  ijkPlayer自定义
//
//  Created by wangyue on 16/10/21.
//  Copyright © 2016年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

#import "SYMediaControl.h"

@class SYMediaPlayerView;

@protocol SYMediaPlayerViewDelegate <NSObject>

/**
 *  点击关闭按钮
 */
- (void)playerViewClosed:(SYMediaPlayerView *)player;

/**
 *  全屏/非全屏切换
 */
- (void)playerView:(SYMediaPlayerView *)player fullscreen:(BOOL)fullscreen;
/**
 *  播放失败
 */
- (void)playerViewFailePlay:(SYMediaPlayerView *)player;

@optional
- (BOOL)playerViewWillBeginPlay:(SYMediaPlayerView *)player;

@end


@interface SYMediaPlayerView : UIView


@property (atomic, weak)   id<SYMediaPlayerViewDelegate> delegate;
@property (atomic, retain) id<IJKMediaPlayback>   player;
@property (nonatomic, strong) SYMediaControl   *mediaControl;
@property (nonatomic, assign) BOOL              shouldAutoplay;
@property (nonatomic, assign) BOOL              isFullScreen;


- (instancetype)initWithFrame:(CGRect)frame uRL:(NSURL *)url title:(NSString *)title;

- (void)setIsFullScreen:(BOOL)isFullScreen;


- (void)playerWillShow;
- (void)playerWillHide;

/**
 *  预览图
 */
- (void)showPreviewImage:(NSString *)imagePath;
- (void)showLocalPreviewImage:(NSString *)imageName;

@end

