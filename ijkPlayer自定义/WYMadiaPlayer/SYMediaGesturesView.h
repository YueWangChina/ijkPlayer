//
//  SYMediaGesturesView.h
//  CloudBusiness
//
//  Created by wang on 17/6/22.
//  Copyright © 2017年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SYMediaGesturesViewDelegate <NSObject>
//移动
-(void)touchesMovedWith:(CGPoint)point;
//开始
-(void)touchesBeganWith:(CGPoint)point;

@end


@interface SYMediaGesturesView : UIView

@property(nonatomic,assign) id<SYMediaGesturesViewDelegate>delegate;

@end
