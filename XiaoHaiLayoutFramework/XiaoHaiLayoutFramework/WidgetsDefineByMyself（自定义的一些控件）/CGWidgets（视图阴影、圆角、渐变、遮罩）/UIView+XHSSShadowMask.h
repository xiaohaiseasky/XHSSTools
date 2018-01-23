//
//  UIView+XHSSShadowMask.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSSShadowView.h"


@class XHSSShadowMaskViewConfigManager;


/**
 带阴影遮罩视图的 UIView 分类
 */
@interface UIView (XHSSShadowMask)

@property (nonatomic, strong) XHSSShadowView *shadowView;

- (void)addShadowMask:(void(^)(XHSSShadowMaskViewConfigManager *manager))managerConfigBlock;

@end




/**
 阴影遮罩视图的配置管理
 */
@interface XHSSShadowMaskViewConfigManager : NSObject

@property (nonatomic, strong) UIView *targetView;

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *backgroundColor))backgroundColor;

//- (XHSSShadowMaskViewConfigManager*(^)(CGRect rect))rect;
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat innerRectRadius))innerRectRadius;
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat outterRectRadius))outterRectRadius;
- (XHSSShadowMaskViewConfigManager*(^)(id content))content;
- (XHSSShadowMaskViewConfigManager*(^)(BOOL cleareCenter))cleareCenter;

- (XHSSShadowMaskViewConfigManager*(^)(XHSSDrawGradientDirection gradientDirection))gradientDirection;
- (XHSSShadowMaskViewConfigManager*(^)(NSArray<UIColor*> *gradientColors))gradientColors;

- (XHSSShadowMaskViewConfigManager*(^)(CGPoint linearGradientStartPoint))linearGradientStartPoint;
- (XHSSShadowMaskViewConfigManager*(^)(CGPoint linearGradientEndPoint))linearGradientEndPoint;

- (XHSSShadowMaskViewConfigManager*(^)(CGPoint radialGradientStartCenterPoint))radialGradientStartCenterPoint;
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat radialGradientStartRadius))radialGradientStartRadius;
- (XHSSShadowMaskViewConfigManager*(^)(CGPoint radialGradientEndCenterPoint))radialGradientEndCenterPoint;
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat radialGradientEndRadius))radialGradientEndRadius;

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *maskColor))maskColor;
- (XHSSShadowMaskViewConfigManager*(^)(UIEdgeInsets innerEdgeInsets))innerEdgeInsets;
- (XHSSShadowMaskViewConfigManager*(^)(UIEdgeInsets outterEdgeInsets))outterEdgeInsets;

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *shadowColor))shadowColor;
- (XHSSShadowMaskViewConfigManager*(^)(CGSize shadowOffset))shadowOffset;
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat shadowBlur))shadowBlur;

@end





