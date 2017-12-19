//
//  UIView+HNAXHSSLayoutTool.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/28.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "UIView+HNAXHSSLayoutTool.h"
#import <objc/runtime.h>

@implementation UIView (HNAXHSSLayoutTool)

#pragma mark - macro
#define kXHSSScreenFitRate [UIScreen mainScreen].bounds.size.width/screeWidth

#pragma mark - ==============SETTER & GETTER===============
/**
 stack
 */
- (NSMutableArray*)stack {
    id returnStack = objc_getAssociatedObject(self, _cmd);
    if (returnStack == nil) {
        returnStack = [NSMutableArray array];
        [self setStack:returnStack];
    }
    return returnStack;
}
- (void)setStack:(NSMutableArray *)stack {
    objc_setAssociatedObject(self, @selector(stack), stack, OBJC_ASSOCIATION_RETAIN);
}

/**
 adaptationRate
 */
- (CGFloat)adaptationRate {
    id adaptationRateObj = objc_getAssociatedObject(self, _cmd);
    
    if (adaptationRateObj == nil) {
        return [UIScreen mainScreen].bounds.size.width/self.baseScreenWidth;
    }
    
    return [adaptationRateObj floatValue];
}

- (void)setAdaptationRate:(CGFloat)adaptationRate {
    objc_setAssociatedObject(self, @selector(adaptationRate), @(adaptationRate), OBJC_ASSOCIATION_ASSIGN);
}

/**
 baseScreenWidth
 */
- (CGFloat)baseScreenWidth {
    id baseScreenWidthObj = objc_getAssociatedObject(self, _cmd);
    return [baseScreenWidthObj floatValue];
}

- (void)setBaseScreenWidth:(CGFloat)baseScreenWidth {
    objc_setAssociatedObject(self, @selector(baseScreenWidth), @(baseScreenWidth), OBJC_ASSOCIATION_ASSIGN);
}

- (UIView*(^)(CGFloat baseScreenWidth))laBaseScreenWidth {
    return ^(CGFloat baseScreenWidth){
        self.baseScreenWidth = baseScreenWidth;
        return self;
    };
}

//////////////////////////////////////////////////////////////////////////

/**
 float
 */
- (CGFloat)laFloatValue {
    id floatObj = objc_getAssociatedObject(self, _cmd);
#warning if nil
    return [floatObj floatValue];
}

- (void)setLaFloatValue:(CGFloat)laFloatValue {
    objc_setAssociatedObject(self, @selector(laFloatValue), @(laFloatValue), OBJC_ASSOCIATION_ASSIGN);
}

/**
 point
 */
- (CGPoint)laPointValue {
    id pointObj = objc_getAssociatedObject(self, _cmd);
    return [pointObj CGPointValue];
}

- (void)setLaPointValue:(CGPoint)laPointValue {
    objc_setAssociatedObject(self, @selector(laPointValue), [NSValue valueWithCGPoint:laPointValue], OBJC_ASSOCIATION_ASSIGN);
}

/**
 size
 */
- (CGSize)laSizeValue {
    id sizeObj = objc_getAssociatedObject(self, _cmd);
    return [sizeObj CGSizeValue];
}

- (void)setLaSizeValue:(CGSize)laSizeValue {
    objc_setAssociatedObject(self, @selector(laSizeValue), [NSValue valueWithCGSize:laSizeValue], OBJC_ASSOCIATION_ASSIGN);
}

/**
 rect
 */
- (CGRect)laRectValue {
    id rectObj = objc_getAssociatedObject(self, _cmd);
    return [rectObj CGRectValue];
}

- (void)setLaRectValue:(CGRect)laRectValue {
    objc_setAssociatedObject(self, @selector(laRectValue), [NSValue valueWithCGRect:laRectValue], OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - ==============参考视图===============
//===========================================================
//===========================================================
//====    　参考视图
//===========================================================
//===========================================================

#pragma mark - top
/**
 保存 self 的 top 以备后续使用
 */
- (UIView*(^)(CGFloat topDistance))topDistance {
    return ^(CGFloat topDistance) {
        self.laFloatValue = topDistance;
        return self;
    };
}


/**
 设置上边距时，上侧的参考视图
 */
- (UIView*(^)(UIView *topRefView))toTopRefView {
    return ^(UIView *topRefView) {
        self.y = topRefView.maxY + self.laFloatValue;
        return self;
    };
}

- (UIView*(^)(UIView *topRefView))toTopRefViewScreenFit {
    return ^(UIView *topRefView) {
        self.y = topRefView.maxY + self.laFloatValue * self.adaptationRate;
        return self;
    };
}

#pragma mark - left
/**
 保存 self 的 left 以备后续使用
 */
- (UIView*(^)(CGFloat leftDistance))leftDistance {
    return ^(CGFloat leftDistance) {
        self.laFloatValue = leftDistance;
        return self;
    };
}

/**
 设置左边距时，左侧的参考视图
 */
- (UIView*(^)(UIView *leftRefView))toLeftRefView {
    return ^(UIView *leftRefView) {
        self.x = leftRefView.maxX + self.laFloatValue;
        return self;
    };
}

- (UIView*(^)(UIView *leftRefView))toLeftRefViewScreenFit {
    return ^(UIView *leftRefView) {
        self.x = leftRefView.maxX + self.laFloatValue * self.adaptationRate;
        return self;
    };
}

#pragma mark - bottom
/**
 保存 self 的 bottom 以备后续使用
 */
- (UIView*(^)(CGFloat bottomDistance))bottomDistance {
    return ^(CGFloat bottomDistance) {
        self.laFloatValue = bottomDistance;
        return self;
    };
}

/**
 设置下边距时，下侧的参考视图
 */
- (UIView*(^)(UIView *bottomRefView))toBottomRefView {
    return ^(UIView *bottomRefView) {
        self.maxY = bottomRefView.y - self.laFloatValue;
        return self;
    };
}

- (UIView*(^)(UIView *bottomRefView))toBottomRefViewScreenFit {
    return ^(UIView *bottomRefView) {
        self.maxY = bottomRefView.y - self.laFloatValue * self.adaptationRate;
        return self;
    };
}

#pragma mark - right
/**
 保存 self 的 right 以备后续使用
 */
- (UIView*(^)(CGFloat rightDistance))rightDistance {
    return ^(CGFloat rightDistance) {
        self.laFloatValue = rightDistance;
        return self;
    };
}

/**
 设置右边距时，右侧的参考视图
 */
- (UIView*(^)(UIView *rightRefView))toRightRefView {
    return ^(UIView *rightRefView) {
        self.maxX = rightRefView.x - self.laFloatValue;
        return self;
    };
}

- (UIView*(^)(UIView *rightRefView))toRightRefViewScreenFit {
    return ^(UIView *rightRefView) {
        self.maxX = rightRefView.x - self.laFloatValue * self.adaptationRate;
        return self;
    };
}

#pragma mark - width
/**
 保存 self 的 width 以备后续使用
 */
- (UIView*(^)(CGFloat widthValue))laWidth {
    return ^(CGFloat widthValue) {
        self.laFloatValue = widthValue;
        return self;
    };
}

/**
 设置 width 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewWidth {
    return ^(UIView *refView) {
        self.width = refView.width;
        return self;
    };
}

#pragma mark - height
/**
 保存 self 的 height 以备后续使用
 */
- (UIView*(^)(CGFloat heightValue))laHeight {
    return ^(CGFloat heightValue) {
        self.laFloatValue = heightValue;
        return self;
    };
}

/**
 设置 height 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewHeight {
    return ^(UIView *refView) {
        self.height = refView.height;
        return self;
    };
}

#pragma mark - center
/**
 保存 self 的 center 以备后续使用
 */
- (UIView*(^)(CGPoint centerValue))laCenter {
    return ^(CGPoint centerValue) {
        self.laPointValue = centerValue;
        return self;
    };
}

/**
 设置 center 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewCenter {
    return ^(UIView *refView) {
        self.selCenter = refView.center;
        return self;
    };
}

#pragma mark - origin
/**
 保存 self 的 origin 以备后续使用
 */
- (UIView*(^)(CGPoint orignValue))laOrign {
    return ^(CGPoint orignValue) {
        self.laPointValue = orignValue;
        return self;
    };
}

/**
 设置 origin 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewOrigin {
    return ^(UIView *refView) {
        self.selOrigin = refView.frame.origin;
        return self;
    };
}

#pragma mark - bounds
/**
 保存 self 的 bounds 以备后续使用
 */
- (UIView*(^)(CGSize boundsValue))laBounds {
    return ^(CGSize boundsValue) {
        self.laSizeValue = boundsValue;
        return self;
    };
}

/**
 设置 bounds 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewBounds {
    return ^(UIView *refView) {
        self.selBounds = refView.bounds.size;
        return self;
    };
}


#pragma mark - ==============固定数值===============
//===========================================================
//===========================================================
//====    固定数值
//===========================================================
//===========================================================

/**
 left
 默认只适配 左边到父视图的距离
 */
- (UIView*(^)(CGFloat leftValue))leftEqualToNum {
    return ^(CGFloat leftValue) {
        self.x = leftValue;
        return self;
    };
}

- (UIView*(^)(CGFloat leftValue))leftEqualToNumScreenFit {
    return ^(CGFloat leftValue) {
        self.x = leftValue * self.adaptationRate;
        return self;
    };
}


/**
 right
 默认只适配 右边到父视图的距离
 */
- (UIView*(^)(CGFloat rightValue))rightEqualToNum {
    return ^(CGFloat rightValue) {
        self.maxX = self.superview.width - rightValue;
        return self;
    };
}

- (UIView*(^)(CGFloat rightValue))rightEqualToNumScreenFit {
    return ^(CGFloat rightValue) {
        self.maxX = self.superview.width - rightValue * self.adaptationRate;
        return self;
    };
}

/**
 top
 默认只适配 上边到父视图的距离
 */
- (UIView*(^)(CGFloat topValue))topEqualToNum {
    return ^(CGFloat topValue) {
        self.y = topValue;
        return self;
    };
}

- (UIView*(^)(CGFloat topValue))topEqualToNumScreenFit {
    return ^(CGFloat topValue) {
        self.y = topValue * self.adaptationRate;
        return self;
    };
}

/**
 bottom
 默认只适配 底边到父视图的距离
 */
- (UIView*(^)(CGFloat bottomValue))bottomEqualToNum {
    return ^(CGFloat bottomValue) {
        self.maxY = self.superview.height - bottomValue;
        return self;
    };
}

- (UIView*(^)(CGFloat bottomValue))bottomEqualToNumScreenFit {
    return ^(CGFloat bottomValue) {
        self.maxY = self.superview.height - bottomValue * self.adaptationRate;
        return self;
    };
}

/**
 width
 适配宽度到具体数值
 */
- (UIView*(^)(CGFloat widthValue))widthEqualToNum {
    return ^(CGFloat widthValue) {
        self.width = widthValue;
        return self;
    };
}

- (UIView*(^)(CGFloat widthValue))widthEqualToNumScreenFit {
    return ^(CGFloat widthValue) {
        self.width = widthValue * self.adaptationRate;
        return self;
    };
}

/**
 height
 适配高度到具体数值
 */
- (UIView*(^)(CGFloat heightValue))heightEqualToNum {
    return ^(CGFloat heightValue) {
        self.height = heightValue;
        return self;
    };
}

- (UIView*(^)(CGFloat heightValue))heightEqualToNumScreenFit {
    return ^(CGFloat heightValue) {
        self.height = heightValue * self.adaptationRate;
        return self;
    };
}

/**
 center
 适配中心点到具体位置
 */
- (UIView*(^)(CGPoint centerValue))centerEqualToNum {
    return ^(CGPoint centerValue) {
        self.selCenter = centerValue;
        return self;
    };
}

- (UIView*(^)(CGPoint centerValue))centerEqualToNumScreenFit {
    return ^(CGPoint centerValue) {
        self.selCenter = CGPointMake(centerValue.x * self.adaptationRate, centerValue.y * self.adaptationRate);
        return self;
    };
}


/**
 origin
 适配原点到具体位置
 */
- (UIView*(^)(CGPoint originValue))originEqualToNum {
    return ^(CGPoint originValue) {
        self.selOrigin = originValue;
        return self;
    };
}

- (UIView*(^)(CGPoint originValue))originEqualToNumScreenFit {
    return ^(CGPoint originValue) {
        self.selOrigin = CGPointMake(originValue.x * self.adaptationRate, originValue.y * self.adaptationRate);
        return self;
    };
}


/**
 bounds
  适配边框到具体尺寸
 */
- (UIView*(^)(CGSize sizeValue))sizeEqualToNum {
    return ^(CGSize sizeValue) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = sizeValue;
        self.bounds = oldBounds;
        return self;
    };
}

- (UIView*(^)(CGSize sizeValue))sizeEqualToNumScreenFit {
    return ^(CGSize sizeValue) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = CGSizeMake(sizeValue.width * self.adaptationRate, sizeValue.height * self.adaptationRate);
        self.bounds = oldBounds;
        return self;
    };
}

#pragma mark - ==============视图相等==============
//===========================================================
//===========================================================
//====    　视图相等
//===========================================================
//===========================================================

/**
 top
 */
- (UIView*(^)(UIView  *refView))topEqualToView {
    return ^(UIView  *refView) {
        self.y = refView.y;
        return self;
    };
}

/**
 left
 */
- (UIView*(^)(UIView  *refView))leftEqualToView {
    return ^(UIView  *refView) {
        self.x = refView.x;
        return self;
    };
}

/**
 bottom
 */
- (UIView*(^)(UIView  *refView))bottomEqualToView {
    return ^(UIView  *refView) {
        self.maxY = refView.maxY;
        return self;
    };
}

/**
 right
 */
- (UIView*(^)(UIView  *refView))rightEqualToView {
    return ^(UIView  *refView) {
        self.maxX = refView.maxX;
        return self;
    };
}

/**
 width
 */
- (UIView*(^)(UIView  *refView))widthEqualToView {
    return ^(UIView  *refView) {
        self.width = refView.width;
        return self;
    };
}

/**
 height
 */
- (UIView*(^)(UIView  *refView))heightEqualToView {
    return ^(UIView  *refView) {
        self.height = refView.height;
        return self;
    };
}

/**
 center
 */
- (UIView*(^)(UIView  *refView))centerEqualToView {
    return ^(UIView  *refView) {
        self.selCenter = refView.center;
        return self;
    };
}

/**
 center point
 */
- (UIView*(^)(UIView  *refView))centerEqualToViewCenterPoint {
    return ^(UIView  *refView) {
        self.selCenter = CGPointMake(refView.frame.size.width/2.0, refView.frame.size.height/2.0);
        return self;
    };
}

/**
 origin
 */
- (UIView*(^)(UIView  *refView))originEqualToView {
    return ^(UIView  *refView) {
        self.selOrigin = refView.frame.origin;
        return self;
    };
}

/**
 size
 */
- (UIView*(^)(UIView  *refView))sizeEqualToView {
    return ^(UIView  *refView) {
        CGRect oldBounds = self.bounds;
        oldBounds.size = refView.bounds.size;
        self.bounds = oldBounds;
        return self;
    };
}

@end
