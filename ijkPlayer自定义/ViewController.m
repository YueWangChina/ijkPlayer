//
//  ViewController.m
//  ijkPlayer自定义
//
//  Created by wangyue on 16/10/21.
//  Copyright © 2016年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SYExtend.h"

#import "SYMediaPlayerView.h"
#define TopMargin 20

#define MinPlayerHeight (kDWidth / 16 * 9)
@interface ViewController ()
<SYMediaPlayerViewDelegate>
@property (nonatomic, strong)SYMediaPlayerView  *playerView;
@property (nonatomic, strong)UIView             *headerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *mvUrl = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
    
//    _playerView = [[SYMediaPlayerView alloc] initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight) uRL:[NSURL URLWithString:mvUrl] title:@"这是视频标题"];
//    _playerView.delegate=self;
//    [self.view addSubview:_playerView];
    
    _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight)];
    _headerView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_headerView];
    
    SYMediaPlayerView *playerView=[[SYMediaPlayerView alloc]init];
    
    
    
    [playerView playerViewWithUrl:mvUrl WithTitle:@"这是视频标题" WithView:_headerView  WithDelegate:self];
    
    
}


- (void)playerViewClosed:(SYMediaPlayerView *)player{
    
    UIApplication *application=[UIApplication sharedApplication];
    [application setStatusBarOrientation:UIInterfaceOrientationPortrait];
    application.keyWindow.transform=CGAffineTransformRotate( application.keyWindow.transform, -M_PI_2);
    application.keyWindow.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    _playerView.frame=CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight);
    _playerView.player.view.frame=CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight);
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    _playerView.isFullScreen=NO;
    [_playerView.player pause];
    
    
}

- (void)playerView:(SYMediaPlayerView *)player fullscreen:(BOOL)fullscreen{
    
    
    
    if (fullscreen==YES) {
        UIApplication *application=[UIApplication sharedApplication];
        [application setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
        application.keyWindow.transform=CGAffineTransformRotate( application.keyWindow.transform, M_PI_2);
        application.keyWindow.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
        _playerView.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        _playerView.player.view.frame=CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }else{
        UIApplication *application=[UIApplication sharedApplication];
        [application setStatusBarOrientation:UIInterfaceOrientationPortrait];
        application.keyWindow.transform=CGAffineTransformRotate( application.keyWindow.transform, -M_PI_2);
        application.keyWindow.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _playerView.frame=CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight);
        _playerView.player.view.frame=CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight);
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}

// 只支持竖屏
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
