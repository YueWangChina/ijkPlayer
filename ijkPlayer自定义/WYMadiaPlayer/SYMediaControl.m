//
//  SYMediaControl.m
//  ijkPlayer自定义
//
//  Created by wangyue on 16/10/21.
//  Copyright © 2016年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import "SYMediaControl.h"
#import "UIView+SYExtend.h"

#import <IJKMediaFramework/IJKMediaFramework.h>



#define MARGIN		5

#define HEAD_H		44

#define LABEL_W		45
#define LABEL_H		(HEAD_H - 2*MARGIN)
#define BTN_H		(HEAD_H - 2*MARGIN)






@interface SYMediaControl()

@property (nonatomic, strong) UIView    *overlayPanel;


@property (nonatomic, strong) UIView    *topPanel;
@property (nonatomic, strong) UIButton  *closeBtn;
@property (nonatomic, strong) UILabel   *titleLabel;


@property (nonatomic, strong) UIView    *bottomPanel;
@property (nonatomic, strong) UIButton  *playButton;
@property (nonatomic, strong) UILabel   *currentTimeLabel;
@property (nonatomic, strong) UILabel   *totalDurationLabel;
@property (nonatomic, strong) UISlider  *mediaProgressSlider;

@property (nonatomic, strong) UIButton  *fullScreenBtn;

@property (nonatomic, strong) SYMediaGesturesView  *gesturesView;
@property (nonatomic, strong) UIButton  *hudInfoBtn;
@property (nonatomic, strong) UIButton  *centerPlayBtn;


@property (nonatomic, strong) UIActivityIndicatorView *activiteView;



@property (strong, nonatomic) id        appBackstageObserver;

@end


@implementation SYMediaControl

{
    BOOL _isMediaSliderBeingDragged;
}

- (MPVolumeView *)volumeView {
    if (_volumeView == nil) {
        _volumeView  = [[MPVolumeView alloc] init];
        [_volumeView sizeToFit];
        for (UIView *view in [_volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                self.volumeViewSlider = (UISlider*)view;
                break;
            }
        }
    }
    return _volumeView;
}
#pragma mark-- SYMediaGesturesViewdelegate 代理
//移动
-(void)touchesMovedWith:(CGPoint)point{
    [self touchesMoveWithPoint:point];

   
}
//开始
-(void)touchesBeganWith:(CGPoint)point{
    //记录首次触摸坐标
    self.startPoint = point;
    //检测用户是触摸屏幕的左边还是右边，以此判断用户是要调节音量还是亮度，左边是音量，右边是亮度
    if (self.startPoint.x <= self.frame.size.width / 2.0) {
        //音/量
        self.startVB = self.volumeViewSlider.value;
    } else {
        //亮度
        self.startVB = [UIScreen mainScreen].brightness;
    }
    //方向置为无
    self.direction = DirectionNone;
    //记录当前视频播放的进度
    //    CMTime ctime = self.currentTime;
    //    self.startVideoRate = ctime.value / ctime.timescale / CMTimeGetSeconds(self.xjPlayer.currentItem.duration);;
    //    [self.touchDelegate touchesBeganWithPoint:currentP];
}


- (void)touchesMoveWithPoint:(CGPoint)point {
    if (self.delegatePlayer==nil) {
        return;
    }
    
    
    //得出手指在Button上移动的距离
    CGPoint panPoint = CGPointMake(point.x - self.startPoint.x, point.y - self.startPoint.y);
    //分析出用户滑动的方向
    if (self.direction == DirectionNone) {
        if (panPoint.x >= 30 || panPoint.x <= -30) {
            //进度
            self.direction = DirectionLeftOrRight;
        } else if (panPoint.y >= 30 || panPoint.y <= -30) {
            //音量和亮度
            self.direction = DirectionUpOrDown;
        }
    }
    
    if (self.direction == DirectionNone) {
        return;
    } else if (self.direction == DirectionUpOrDown&&self.isFullscreen) {
        //音量和亮度
        if (self.startPoint.x <= self.frame.size.width / 2.0) {
            //音量
            if (panPoint.y < 0) {
                //增大音量
                [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                if (self.startVB + (-panPoint.y / 30 / 10) - self.volumeViewSlider.value >= 0.1) {
                    [self.volumeViewSlider setValue:0.1 animated:NO];
                    [self.volumeViewSlider setValue:self.startVB + (-panPoint.y / 30.0 / 10) animated:YES];
                }
                
            } else {
                //减少音量
                [self.volumeViewSlider setValue:self.startVB - (panPoint.y / 30.0 / 10) animated:YES];
            }
            
        } else if(self.isFullscreen){
            
            //调节亮度
            if (panPoint.y < 0) {
                //增加亮度
                [[UIScreen mainScreen] setBrightness:self.startVB + (-panPoint.y / 30.0 / 10)];
            } else {
                //减少亮度
                [[UIScreen mainScreen] setBrightness:self.startVB - (panPoint.y / 30.0 / 10)];
            }
        }
    } else if (self.direction == DirectionLeftOrRight) {
        //进度
        CGFloat rate = self.startVideoRate + (panPoint.x / 30.0 / 200.0);
        if (rate > 1) {
            rate = 1;
        } else if (rate < 0) {
            //            rate = 0;
        }
        
        NSLog(@"进度 条%f",rate);
        self.currentRate = rate;
        
        NSTimeInterval DragTime=(self.delegatePlayer.duration-self.delegatePlayer.currentPlaybackTime)*rate;
        //
        //        NSLog(@"滑动获得的%f",DragTime);
        //
        self.delegatePlayer.currentPlaybackTime=self.delegatePlayer.currentPlaybackTime+DragTime;
    }
    
}
#pragma mark - publick

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = YES;
        
        [self creatSubviews];
        [self refreshMediaControl];
        self.volumeView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height * 9.0 / 16.0);
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        
        
        
        
        
        [self addGestureRecognizer:gesture];
        
        //添加进入后台的监听
        [self addAppBackstageObserverForPlayer];
    }
    return self;
}


- (void)showNoFade
{
    if (self.fullScreenBtn.selected) {
        self.topPanel.hidden = NO;
        self.bottomPanel.hidden = NO;
    }else{
        self.topPanel.hidden = YES;
        self.bottomPanel.hidden = NO;
    }
    //    self.topPanel.hidden = NO;
    //    self.bottomPanel.hidden = NO;
    
    [self cancelDelayedHide];
    [self refreshMediaControl];
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}

- (void)showAndFade
{
    if (self.bottomPanel.hidden) {
        
        [self showNoFade];
    }else{
        [self hide];
    }
}

- (void)hide
{
    
    
    
    
    
    
    self.topPanel.hidden = YES;
    self.bottomPanel.hidden = YES;
    [self cancelDelayedHide];
}

- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.delegatePlayer.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        self.mediaProgressSlider.maximumValue = duration;
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.totalDurationLabel.text = @"--:--";
        self.mediaProgressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.mediaProgressSlider.value;
    } else {
        position = self.delegatePlayer.currentPlaybackTime;
        
        if (intDuration > 0) {
            self.mediaProgressSlider.value = position;
        } else {
            self.mediaProgressSlider.value = 0.0f;
        }
    }
    
    NSInteger intPosition = position + 0.5;
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    
    // status
    BOOL isPlaying = [self.delegatePlayer isPlaying];
    self.playButton.selected = isPlaying;
    _centerPlayBtn.hidden = (isPlaying || [self.activiteView isAnimating]);
    
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (!self.bottomPanel.hidden && self.delegatePlayer) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}

- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
    _isMediaSliderBeingDragged = NO;
}

- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}


/**
 *  播放失败
 */
- (void)failPlayVideo
{
    //停止状态刷新
    [self cancelDelayedRefresh];
    self.playButton.selected = NO;
    self.showActivite = NO;
    /**
     *  移除手势响应
     */
    for (UIGestureRecognizer *gesture in [self gestureRecognizers]) {
        [self removeGestureRecognizer:gesture];
    }
    
    /**
     *  禁用底部控制栏
     */
    self.bottomPanel.userInteractionEnabled = NO;
    
}


#pragma mark - UI

- (void)creatSubviews
{
    self.overlayPanel = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.overlayPanel];
    
    
    /**
     *  头视图
     */
    self.topPanel = ({
        UIView *header = [[UIView alloc] init];
        header.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        header;
        
    });
    [self.overlayPanel addSubview:self.topPanel];
    
    
    self.closeBtn = ({
        
        UIButton *closeBtn = [[UIButton alloc] init];
//        [closeBtn setTitle:@"返回" forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"icon_communicate_reply"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onClickDone) forControlEvents:UIControlEventTouchUpInside];
        closeBtn;
    });
    [self.topPanel addSubview:self.closeBtn];
    

    [self.topPanel addSubview:self.titleLabel];
    
    if (self.fullScreenBtn.selected==YES) {
        self.topPanel.hidden=NO;
    }else{
        self.topPanel.hidden=YES;
    }
    
    /**
     *  尾视图
     */
    self.bottomPanel = ({
        
        UIView *footer = [[UIView alloc] init];
        
        footer.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        
        footer.userInteractionEnabled = YES;
        footer;
        
    });
    [self.overlayPanel addSubview:self.bottomPanel];
    
    
    self.playButton = ({
        
        UIButton *playBtn = [[UIButton alloc] init];
        [playBtn setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateSelected];
        
        [playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
        playBtn;
    });
    [self.bottomPanel addSubview:self.playButton];
    
    
    self.currentTimeLabel  = ({
        
        UILabel *label	= [[UILabel alloc] init];
        label.font		= [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor whiteColor]];
        
        label;
    });
    [self.bottomPanel addSubview:self.currentTimeLabel];
    
    
    self.totalDurationLabel = ({
        
        UILabel *label	= [[UILabel alloc] init];
        label.font		= [UIFont systemFontOfSize:8];
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor whiteColor]];
        
        label;
        
    });
    [self.bottomPanel addSubview:self.totalDurationLabel];
    
    
    self.mediaProgressSlider = ({
        
        UISlider *slider = [[UISlider alloc] init];
        slider.minimumValue = 0.0;
        slider.maximumValue = 1.0;
        [slider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
        [slider addTarget:self action:@selector(slideTouchDown) forControlEvents:UIControlEventTouchDown];
        [slider addTarget:self action:@selector(slideTouchCancel) forControlEvents:UIControlEventTouchCancel | UIControlEventTouchUpOutside];
        [slider addTarget:self action:@selector(slideTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        
        [slider addTarget:self action:@selector(slideValueChanged) forControlEvents:UIControlEventValueChanged];
        
        
        
        slider;
    });
    [self.bottomPanel addSubview:self.mediaProgressSlider];
    

 //全屏按钮
    self.fullScreenBtn = ({
        UIButton *btn		= [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"icon_full"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"icon_full"] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self.bottomPanel addSubview:self.fullScreenBtn];
    
    
    self.activiteView = ({
        
        UIActivityIndicatorView *activiteView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];//UIActivityIndicatorViewStyleWhiteLarge
        activiteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        
        activiteView.size = CGSizeMake(40, 40);
        [activiteView stopAnimating];
        
        activiteView;
        
    });
    [self.overlayPanel addSubview:self.activiteView];
    

    self.gesturesView = ({
        
        SYMediaGesturesView *view =[SYMediaGesturesView new];
        view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0];

        
        view;
        
        
    });
            self.gesturesView.delegate=self;
    
       [self.overlayPanel addSubview:self.gesturesView];
}
-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [_titleLabel setTextColor:[UIColor whiteColor]];
 
    }
    return _titleLabel;
    
}
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    // 0. |c|s|t|y|
    
    CGFloat mWidth = self.width;
    self.overlayPanel.frame = self.bounds;
    
    CGFloat topHeight = HEAD_H;
    CGFloat topMaigin = MARGIN;
    if (_hasTopMargin) {
        topHeight += 20;
        topMaigin = topHeight - BTN_H - MARGIN;
    }
    
    self.topPanel.frame = CGRectMake(0, 0, mWidth, topHeight);
    self.closeBtn.frame = CGRectMake(MARGIN, topMaigin, BTN_H,  BTN_H);
    
    CGFloat ttW = mWidth - _closeBtn.right - 2*MARGIN;
    if (self.showHUDInfo) {
        self.hudInfoBtn.frame = CGRectMake(mWidth - MARGIN, topMaigin, LABEL_W, BTN_H);
        ttW = ttW - self.hudInfoBtn.width - MARGIN;
    }
    
    self.titleLabel.frame = CGRectMake(_closeBtn.right + MARGIN, topMaigin, ttW, LABEL_H);
    
    
    
    // bottom
    self.bottomPanel.frame = CGRectMake(0,self.height - HEAD_H, mWidth, HEAD_H);
    self.gesturesView.frame=CGRectMake(0, topHeight, mWidth, self.height-topHeight-HEAD_H);
    
    self.playButton.frame = CGRectMake(MARGIN, MARGIN, BTN_H, BTN_H);
    self.fullScreenBtn.frame = CGRectMake(mWidth - HEAD_H, 0, HEAD_H, HEAD_H);
    
    self.currentTimeLabel.frame = CGRectMake(self.playButton.right + MARGIN, MARGIN, LABEL_W, LABEL_H);
    
    CGFloat ttLeft = self.fullScreenBtn.left - MARGIN - LABEL_W;
    self.totalDurationLabel.frame = CGRectMake(ttLeft, MARGIN, LABEL_W, LABEL_H);
    
    // sliderView
    CGFloat slidW = ttLeft - 2*MARGIN - self.currentTimeLabel.right;
    self.mediaProgressSlider.frame = CGRectMake(self.currentTimeLabel.right + MARGIN, MARGIN, slidW, LABEL_H);
    
    if (self.autoHideCloseBtn &&! _isFullscreen) {
        self.closeBtn.hidden = YES;
    }else{
        self.closeBtn.hidden = NO;
    }
    
    if (_showCenterPlayBtn) {
        _centerPlayBtn.frame = [UIView frameWithW:HEAD_H h:HEAD_H center:self.overlayPanel.insideCenter];
    }
    
    
    self.activiteView.center = self.overlayPanel.insideCenter;
    
    

    
    
    
}

#pragma mark - Action


- (void)tapClick
{
    //    if (_mediaProgressSlider) {
    //        return;
    //    }
    if ([self.delegate respondsToSelector:@selector(onClickMediaControl:)]) {
        [self.delegate onClickMediaControl:self];
    }
    
}

- (void)onClickDone
{
    self.centerPlayBtn.hidden = YES;
    self.topPanel.hidden=YES;
    if ([self.delegate respondsToSelector:@selector(onClickDone:)]) {
        [self.delegate onClickDone:self.closeBtn];
    }
    
}

- (void)onClickHUD
{
    if ([self.delegate respondsToSelector:@selector(onClickHUD:)]) {
        [self.delegate onClickDone:self.hudInfoBtn];
    }
    
}

- (void)fullScreen
{
    
    self.fullScreenBtn.selected = !self.fullScreenBtn.selected;
    
    
    if ([self.delegate respondsToSelector:@selector(onClickFullscreen:)]) {
        [self.delegate onClickFullscreen:self.fullScreenBtn.selected];
    }
    
    self.isFullscreen = self.fullScreenBtn.selected;
    if (self.isFullscreen) {
        self.topPanel.hidden=NO;
    }else{
        self.topPanel.hidden=YES;
    }
    
    
    
    
}

- (void)playControl
{
    _centerPlayBtn.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(onClickPlayButton:)]) {
        [self.delegate onClickPlayButton:self.playButton];
    }
}


- (void)slideTouchDown
{
    [self beginDragMediaSlider];
}

- (void)slideTouchCancel
{
    [self endDragMediaSlider];
}

- (void)slideTouchUpInside
{
    if ([self.delegate respondsToSelector:@selector(didSliderTouchUpInside)]) {
        [self.delegate didSliderTouchUpInside];
    }
}

- (void)slideValueChanged
{
    
    [self showNoFade];
    if ([self.delegate respondsToSelector:@selector(didSliderValueChanged)]) {
        [self.delegate didSliderValueChanged];
    }
    
}


#pragma mark set/get

- (void)setShowHUDInfo:(BOOL)showHUDInfo
{
    if (showHUDInfo && !_hudInfoBtn) {
        
        _hudInfoBtn = [[UIButton alloc] init];
        [_hudInfoBtn setTitle:@"HUD信息" forState:UIControlStateNormal];
        
        [_hudInfoBtn addTarget:self action:@selector(onClickHUD) forControlEvents:UIControlEventTouchUpInside];
        [self.topPanel addSubview:_hudInfoBtn];
        
        
    }else if (_hudInfoBtn){
        _hudInfoBtn.hidden = !showHUDInfo;
    }
    
    _showHUDInfo = showHUDInfo;
    
}

- (void)setShowCenterPlayBtn:(BOOL)showCenterPlayBtn
{
    if (_showCenterPlayBtn == showCenterPlayBtn) {
        return;
    }
    
    _showCenterPlayBtn = showCenterPlayBtn;
    
    if (showCenterPlayBtn &&  !_centerPlayBtn) {
        _centerPlayBtn = ({
            
            UIButton *playBtn = [[UIButton alloc] init];
            [playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            [playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
            
            [playBtn addTarget:self action:@selector(playControl) forControlEvents:UIControlEventTouchUpInside];
            playBtn;
        });
        
        [self.overlayPanel addSubview:_centerPlayBtn];
        
    }
    
    
    
    _centerPlayBtn.hidden = !showCenterPlayBtn;
    
    
}

- (void)setShowActivite:(BOOL)showActivite
{
    if (showActivite) {
        self.centerPlayBtn.hidden = YES;
        [_activiteView startAnimating];
    }else{
        [_activiteView stopAnimating];
    }
    
}

- (void)setIsFullscreen:(BOOL)isFullscreen
{
    if (_isFullscreen != isFullscreen) {
        _isFullscreen = isFullscreen;
        _fullScreenBtn.selected = isFullscreen;
    }
}

#pragma mark - pravite


//要进入后台
- (void)addAppBackstageObserverForPlayer
{
    NSString *name = UIApplicationWillResignActiveNotification;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    __weak typeof(self) weakSelf = self;
    void (^callback)(NSNotification *note) = ^(NSNotification *notification) {
        NSLog(@"======播放器进入后台");
        
        if (weakSelf.delegatePlayer) {
            
            [weakSelf.delegatePlayer pause];
            
            weakSelf.topPanel.hidden = NO;
            weakSelf.bottomPanel.hidden = NO;
            weakSelf.centerPlayBtn.hidden = NO;
            weakSelf.playButton.selected = NO;
            weakSelf.showActivite = NO;
            
            [weakSelf cancelDelayedHide];
            [weakSelf cancelDelayedRefresh];
        }
        
    };
    
    self.appBackstageObserver =
    [[NSNotificationCenter defaultCenter] addObserverForName:name
                                                      object:self.delegatePlayer
                                                       queue:queue
                                                  usingBlock:callback];
}


- (void)cancelDelayedHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
}

- (void)cancelDelayedRefresh
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}


- (void)dealloc
{
    if (self.appBackstageObserver) {
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self.appBackstageObserver
                      name:UIApplicationWillResignActiveNotification
                    object:nil];
        self.appBackstageObserver = nil;
    }
}

@end

