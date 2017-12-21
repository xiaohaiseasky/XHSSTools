//
//  UIView+XHSSShadowMask.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+XHSSShadowMask.h"
#import <objc/runtime.h>

@implementation UIView (XHSSShadowMask)

#pragma mark - setter & getter
- (XHSSShadowView*)shadowView {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setShadowView:(XHSSShadowView *)shadowView {
    objc_setAssociatedObject(self, @selector(shadowView), shadowView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public
- (void)addShadowMask:(void(^)(XHSSShadowMaskViewConfigManager *manager))managerConfigBlock {
    self.shadowView = [[XHSSShadowView alloc] initWithFrame:self.bounds];
    [self addSubview:self.shadowView];
    self.shadowView.rect = self.bounds;
    XHSSShadowMaskViewConfigManager *manager = [[XHSSShadowMaskViewConfigManager alloc] init];
    manager.targetView = self;
    if (managerConfigBlock) {
        managerConfigBlock(manager);
    }
}

@end





/**
 阴影遮罩视图的配置管理
 */
@implementation XHSSShadowMaskViewConfigManager

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *backgroundColor))backgroundColor {
    return ^(UIColor *backgroundColor) {
        self.targetView.shadowView.backgroundColor = backgroundColor;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(CGRect rect))rect {
    return ^(CGRect rect) {
        self.targetView.shadowView.rect = rect;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat innerRectRadius))innerRectRadius {
    return ^(CGFloat innerRectRadius) {
        self.targetView.shadowView.innerRectRadius = innerRectRadius;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat outterRectRadius))outterRectRadius {
    return ^(CGFloat outterRectRadius) {
        self.targetView.shadowView.outterRectRadius = outterRectRadius;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(id content))content {
    return ^(id content) {
        self.targetView.shadowView.content = content;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(BOOL cleareCenter))cleareCenter {
    return ^(BOOL cleareCenter) {
        self.targetView.shadowView.cleareCenter = cleareCenter;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(XHSSDrawGradientDirection gradientDirection))gradientDirection {
    return ^(XHSSDrawGradientDirection gradientDirection) {
        self.targetView.shadowView.gradientDirection = gradientDirection;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(NSArray<UIColor*> *gradientColors))gradientColors {
    return ^(NSArray<UIColor*> *gradientColors) {
        self.targetView.shadowView.gradientColors = gradientColors;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(CGPoint linearGradientStartPoint))linearGradientStartPoint {
    return ^(CGPoint linearGradientStartPoint) {
        self.targetView.shadowView.linearGradientStartPoint = linearGradientStartPoint;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGPoint linearGradientEndPoint))linearGradientEndPoint {
    return ^(CGPoint linearGradientEndPoint) {
        self.targetView.shadowView.linearGradientEndPoint = linearGradientEndPoint;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(CGPoint radialGradientStartCenterPoint))radialGradientStartCenterPoint {
    return ^(CGPoint radialGradientStartCenterPoint) {
        self.targetView.shadowView.radialGradientStartCenterPoint = radialGradientStartCenterPoint;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat radialGradientStartRadius))radialGradientStartRadius {
    return ^(CGFloat radialGradientStartRadius) {
        self.targetView.shadowView.radialGradientStartRadius = radialGradientStartRadius;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGPoint radialGradientEndCenterPoint))radialGradientEndCenterPoint {
    return ^(CGPoint radialGradientEndCenterPoint) {
        self.targetView.shadowView.radialGradientEndCenterPoint = radialGradientEndCenterPoint;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat radialGradientEndRadius))radialGradientEndRadius {
    return ^(CGFloat radialGradientEndRadius) {
        self.targetView.shadowView.radialGradientEndRadius = radialGradientEndRadius;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *maskColor))maskColor {
    return ^(UIColor *maskColor) {
        self.targetView.shadowView.maskColor = maskColor;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(UIEdgeInsets innerEdgeInsets))innerEdgeInsets {
    return ^(UIEdgeInsets innerEdgeInsets) {
        self.targetView.shadowView.innerEdgeInsets = innerEdgeInsets;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(UIEdgeInsets outterEdgeInsets))outterEdgeInsets {
    return ^(UIEdgeInsets outterEdgeInsets) {
        self.targetView.shadowView.outterEdgeInsets = outterEdgeInsets;
        return self;
    };
}

- (XHSSShadowMaskViewConfigManager*(^)(UIColor *shadowColor))shadowColor {
    return ^(UIColor *shadowColor) {
        self.targetView.shadowView.shadowColor = shadowColor;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGSize shadowOffset))shadowOffset {
    return ^(CGSize shadowOffset) {
        self.targetView.shadowView.shadowOffset = shadowOffset;
        return self;
    };
}
- (XHSSShadowMaskViewConfigManager*(^)(CGFloat shadowBlur))shadowBlur {
    return ^(CGFloat shadowBlur) {
        self.targetView.shadowView.shadowBlur = shadowBlur;
        return self;
    };
}

@end
