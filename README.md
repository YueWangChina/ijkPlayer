# ijkPlayer

自定义播放器   创建方法   
    _playerView = [[SYMediaPlayerView alloc] initWithFrame:CGRectMake(0, TopMargin, kDWidth, MinPlayerHeight) uRL:[NSURL URLWithString:mvUrl] title:@"这是视频标题"];
    _playerView.delegate=self;
    [self.view addSubview:_playerView];
    代理自己实现 。我也不多说了
   写的 不是很好，只是完成了简单的一些功能。如有建议，请给我留言。大家共同学习，共同进步！
   
   
![Alt text](https://github.com/Wang454431208/ijkPlayer/blob/master/ijkPlayer自定义/9E1581A2-32E8-4692-92C0-FFF8BC1A3A73.png)

![Alt text](https://github.com/Wang454431208/ijkPlayer/blob/master/ijkPlayer自定义/EF7F5C8A-F7D2-4BF5-95D5-FD1B25BFBA80.png)
