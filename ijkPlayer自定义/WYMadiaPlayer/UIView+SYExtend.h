//
//  UIView+SYExtend.h
//  ijkPlayer自定义
//
//  Created by wangyue on 16/10/21.
//  Copyright © 2016年 www.hopechina.cc 中和黄埔. All rights reserved.
//

#import <UIKit/UIKit.h>


#if kDHeight
#else

#define kDHeight [UIScreen mainScreen].bounds.size.height

#endif

#if kDWidth
#else

#define kDWidth [UIScreen mainScreen].bounds.size.width

#endif



#define FrameRight(frame) (frame.origin.x + frame.size.width)
#define FrameLeft(frame) (frame.origin.x)
#define FrameTop(frame) (frame.origin.y)
#define FrameBottom(frame) (frame.origin.y + frame.size.height)
#define FrameCenterY(frame) (frame.origin.y + frame.size.height/2)
#define FrameCenterX(frame) (frame.origin.x + frame.size.width/2)


@interface UIView (SYExtend)


@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat right;


@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat radius;


@property (nonatomic, assign) CGFloat   insideCenterX;
@property (nonatomic, assign) CGFloat   insideCenterY;
@property (nonatomic, assign) CGPoint   insideCenter;


/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB;


/*
 *  计算frame
 */
+(CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center;


/**
 *  添加一组子view：
 */
-(void)addSubviewsWithArray:(NSArray *)subViews;


/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+(void)removeViews:(NSArray *)views;

/**
 *  添加边框:四边
 */
-(void)setBorder:(UIColor *)color width:(CGFloat)width;



/**
 *  获取viewController
 */
- (UIViewController*)viewController;


/**
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:	虚线的间距
 ** lineColor:      虚线的颜色
 **/
- (void)drawDashLine:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 *  查找NVG 的分割线 ---- navigationBar
 */
+ (UIImageView*)findHairlineImageViewUnder:(UIView*)view;


#pragma mark - subView操作
/**
 *  查找指定类型的subView 每个族列只有一次有效
 */
- (void)fintSubView:(Class)class action:(void(^)(NSArray *subViews))actionBlock;



@end
