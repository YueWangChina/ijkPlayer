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

- (BOOL)playerViewWillBeginPlay:(SYMediaPlayerView *)player;

@end


@interface SYMediaPlayerView : UIView


@property (nonatomic, weak)   id<SYMediaPlayerViewDelegate> delegate;
@property (nonatomic, strong) id<IJKMediaPlayback>   player;
@property (nonatomic, strong) SYMediaControl   *mediaControl;
@property (nonatomic, assign) BOOL              shouldAutoplay;
@property (nonatomic, assign) BOOL              isFullScreen;
@property (nonatomic, assign) BOOL              pushPlayerPause;//是否push到下个界面
@property (nonatomic, assign) NSString  *     historyPlayingTime;//历史播放时间


- (instancetype)initWithFrame:(CGRect)frame uRL:(NSURL *)url title:(NSString *)title;
-(void)playerViewWithUrl:(NSString*)urlString WithTitle:(NSString*)title WithView:(UIView*)view WithDelegate:(UIViewController*)viewController;
- (void)setIsFullScreen:(BOOL)isFullScreen;


- (void)playerWillShow;
- (void)playerWillHide;




/**
 *  预览图
 */
- (void)showPreviewImage:(NSString *)imagePath;
- (void)showLocalPreviewImage:(NSString *)imageName;

@end

