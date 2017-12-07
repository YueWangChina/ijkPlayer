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
#import "AppDelegate.h"
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
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.fullScreen = YES;

    NSString *mvUrl = @"http://flv2.bn.netease.com/videolib3/1604/28/fVobI0704/SD/fVobI0704-mobile.mp4";
    
    //    _playerView = [[SYMediaPlayerView alloc] initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight) uRL:[NSURL URLWithString:mvUrl] title:@"这是视频标题"];
    //    _playerView.delegate=self;
    //    [self.view addSubview:_playerView];
    
    _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight)];
    _headerView.backgroundColor=[UIColor redColor];
    [self.view addSubview:_headerView];
    
    _playerView=[[SYMediaPlayerView alloc]init];
    
    
    [_playerView playerViewWithUrl:mvUrl WithTitle:@"这是视频标题" WithView:_headerView  WithDelegate:self];
    
    //    [playerView setHistoryPlayingTime:@"1000"];
    
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    if ([UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeLeft||[UIDevice currentDevice].orientation ==UIDeviceOrientationLandscapeRight){
         UIWindow*window= [UIApplication sharedApplication].keyWindow;
        _playerView.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.player.view.frame=CGRectMake(0, 0, size.width,size.height);
        _playerView.mediaControl.fullScreenBtn.selected=YES;
        _playerView.isFullScreen=YES;
        [window addSubview:_playerView];
    }else{
       _playerView.frame=CGRectMake(0, 0, size.width, size.width/16*9);
       _playerView.player.view.frame=CGRectMake(0, 0, size.width, size.width/16*9);
        _playerView.mediaControl.fullScreenBtn.selected=NO;
        _playerView.isFullScreen=NO;
        [_headerView addSubview:_playerView];
        
        
        
        
    }
}

- (void)playerViewClosed:(SYMediaPlayerView *)player{
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    
}

- (void)playerView:(SYMediaPlayerView *)player fullscreen:(BOOL)fullscreen{
    
    
    
    if (fullscreen==YES) {
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    }else{
      
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
