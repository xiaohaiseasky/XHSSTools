//
//  XHSSShadowView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/19.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

/*
 模块化架构、解耦、分层、响应式编程，函数式编程、异步计算／绘制／加载
 */

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, XHSSDrawGradientDirection) {
    XHSSDrawGradientDirectionNOne,
    XHSSDrawGradientDirectionLinear,
    XHSSDrawGradientDirectionTopToBot,
    XHSSDrawGradientDirectionBotToTop,
    XHSSDrawGradientDirectionLeftToRight,
    XHSSDrawGradientDirectionRightToLeft,
    XHSSDrawGradientDirectionRadial,
};

@interface XHSSShadowView : UIView

// background area
@property (nonatomic, strong) UIColor *backgroundColor;

// center area
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat innerRectRadius;
@property (nonatomic, assign) CGFloat outterRectRadius;
@property (nonatomic, strong) id content;
@property (nonatomic, assign) BOOL cleareCenter;

@property (nonatomic,assign) XHSSDrawGradientDirection gradientDirection;
@property (nonatomic, strong) NSArray<UIColor*> *gradientColors;

@property (nonatomic, assign) CGPoint linearGradientStartPoint;
@property (nonatomic, assign) CGPoint linearGradientEndPoint;

@property (nonatomic, assign) CGPoint radialGradientStartCenterPoint;
@property (nonatomic, assign) CGFloat radialGradientStartRadius;
@property (nonatomic, assign) CGPoint radialGradientEndCenterPoint;
@property (nonatomic, assign) CGFloat radialGradientEndRadius;

// mask area
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) UIEdgeInsets innerEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets outterEdgeInsets;

// shadow area
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;

@end
