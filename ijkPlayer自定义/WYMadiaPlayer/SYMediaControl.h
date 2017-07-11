//
//  SYMediaControl.h
//  ijkPlayer自定义
//
//  Created by wangyue on 16/10/21.
//  Copyright © 2016年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SYMediaGesturesView.h"
@protocol IJKMediaPlayback;


typedef NS_ENUM(NSUInteger, Direction) {
    DirectionLeftOrRight,
    DirectionUpOrDown,
    DirectionNone
};

@protocol SYMediaControlDelegate <NSObject>

- (void)onClickFullscreen:(BOOL)isFull;
- (void)onClickMediaControl:(id)sender;

- (void)onClickHUD:(id)sender;
- (void)onClickDone:(id)sender;
- (void)onClickPlayButton:(id)sender;


- (void)didSliderTouchUpInside;
- (void)didSliderValueChanged;

@end

@interface SYMediaControl : UIView


- (void)showAndFade;
- (void)hide;
- (void)refreshMediaControl;

- (void)beginDragMediaSlider;
- (void)endDragMediaSlider;
- (void)continueDragMediaSlider;

/**
 *  播放失败
 */
- (void)failPlayVideo;
/****************************************/

/**
 * 开始触摸
 */
- (void)touchesBeganWithPoint:(CGPoint)point;

/**
 * 结束触摸
 */
- (void)touchesEndWithPoint:(CGPoint)point;

/**
 * 移动手指
 */
- (void)touchesMoveWithPoint:(CGPoint)point;
/**
 *  单击时/双击时,判断tap的numberOfTapsRequired
 */
- (void)userTapGestureAction:(UITapGestureRecognizer*)xjTap;

//上下左右手势操作
@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) CGPoint startPoint;//手势触摸起始位置
@property (assign, nonatomic) CGFloat startVB;//记录当前音量/亮度
@property (assign, nonatomic) CGFloat startVideoRate;//开始进度
@property (strong, nonatomic) CADisplayLink *link;//以屏幕刷新率进行定时操作
@property (assign, nonatomic) NSTimeInterval lastTime;
@property (strong, nonatomic) MPVolumeView *volumeView;//控制音量的view
@property (strong, nonatomic) UISlider *volumeViewSlider;//控制音量
@property (assign, nonatomic) CGFloat currentRate;//当期视频播放的进度

/*****************************************************************////

@property (nonatomic, weak) id<IJKMediaPlayback> delegatePlayer;
@property (nonatomic, weak) id<SYMediaControlDelegate>delegate;



@property (nonatomic, assign)BOOL autoHideCloseBtn;//是否竖屏状态下隐藏自带的关闭按钮
@property (nonatomic, assign)BOOL showHUDInfo;//是否显示HUD信息按钮
@property (nonatomic, assign)BOOL isFullscreen;//标示是否处于全屏状态


@property (nonatomic, assign)BOOL hasTopMargin;//是否头部预留电池栏高度

@property (nonatomic, assign)BOOL showCenterPlayBtn;//是否显示中心 播放状态按钮 默认

@property (nonatomic, assign)BOOL showActivite;//显示进度条


@property (nonatomic, strong, readonly) UIView    *overlayPanel;


@property (nonatomic, strong, readonly) SYMediaGesturesView  *gesturesView;

@property (nonatomic, strong, readonly) UIView    *topPanel;
@property (nonatomic, strong, readonly) UIButton  *closeBtn;
@property (nonatomic, strong, readonly) UILabel   *titleLabel;


@property (nonatomic, strong, readonly) UIView    *bottomPanel;
@property (nonatomic, strong, readonly) UIButton  *playButton;
@property (nonatomic, strong, readonly) UILabel   *currentTimeLabel;
@property (nonatomic, strong, readonly) UILabel   *totalDurationLabel;
@property (nonatomic, strong, readonly) UISlider  *mediaProgressSlider;

@property (nonatomic, strong, readonly) UIButton  *fullScreenBtn;

@property (nonatomic, strong, readonly) UIButton  *hudInfoBtn;




@end
