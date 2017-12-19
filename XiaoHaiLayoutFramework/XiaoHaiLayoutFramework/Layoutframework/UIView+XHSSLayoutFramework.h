//
//  UIView+XHSSLayoutFramework.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

/**
 * 目前没有做完全适配
 * 目前有些逻辑不清／不对
 * 目前功能不全 【如 ：toTopRefView 可以拓展成 toTopRefViewTop , toTopRefViewBottom ,】
 * 目前属性连续调用可能不会出错，但逻辑检测没有做
 */

#import <UIKit/UIKit.h>
#import "UIView+XHSSFrameTools.h"

@interface UIView (XHSSLayoutFramework)

/**
 设置完全适配情况下的基础屏幕尺寸, 如果不设置则当前适配为固定坐标适配
 
 @param screenWidth :   当前布局所在的屏幕宽度
 */
- (void)setAdaptionBaseScreenWidth:(CGFloat)screenWidth;

#pragma mark - ==============参考视图===============
#pragma mark - top
/**
 保存 self 的 top 以备后续使用
 */
- (UIView*(^)(CGFloat topDistance))topDistance;

/**
 设置上边距时，上侧的参考视图
 */
- (UIView*(^)(UIView *topRefView))toTopRefView;             // 固定像素适配
- (UIView*(^)(UIView *topRefView))toTopRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - left
/**
 保存 self 的 left 以备后续使用
 */
- (UIView*(^)(CGFloat leftDistance))leftDistance;

/**
 设置左边距时，左侧的参考视图
 */
- (UIView*(^)(UIView *leftRefView))toLeftRefView;             // 固定像素适配
- (UIView*(^)(UIView *leftRefView))toLeftRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - bottom
/**
 保存 self 的 bottom 以备后续使用
 */
- (UIView*(^)(CGFloat bottomDistance))bottomDistance;

/**
 设置下边距时，下侧的参考视图
 */
- (UIView*(^)(UIView *bottomRefView))toBottomRefView;             // 固定像素适配
- (UIView*(^)(UIView *bottomRefView))toBottomRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - right
/**
 保存 self 的 right 以备后续使用
 */
- (UIView*(^)(CGFloat rightDistance))rightDistance;

/**
 设置右边距时，右侧的参考视图
 */
- (UIView*(^)(UIView *rightRefView))toRightRefView;             // 固定像素适配
- (UIView*(^)(UIView *rightRefView))toRightRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - width
/**
 保存 self 的 width 以备后续使用
 */
- (UIView*(^)(CGFloat widthValue))laWidth;

/**
 设置 width 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewWidth;             // 固定像素适配
                                                                // 无需按比例进行适配

#pragma mark - height
/**
 保存 self 的 height 以备后续使用
 */
- (UIView*(^)(CGFloat heightValue))laHeight;

/**
 设置 height 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewHeight;            // 固定像素适配
                                                                // 无需按比例进行适配

#pragma mark - center
/**
 保存 self 的 center 以备后续使用
 */
- (UIView*(^)(CGPoint centerValue))laCenter;

/**
 设置 center 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewCenter;            // 固定像素适配
                                                                // 无需按比例进行适配


#pragma mark - origin
/**
 保存 self 的 origin 以备后续使用
 */
- (UIView*(^)(CGPoint orignValue))laOrign;

/**
 设置 origin 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewOrigin;            // 固定像素适配
                                                                // 无需按比例进行适配

#pragma mark - bounds
/**
 保存 self 的 bounds 以备后续使用
 */
- (UIView*(^)(CGSize boundsValue))laBounds;

/**
 设置 bounds 时的参考视图
 */
- (UIView*(^)(UIView *refView))equalToRefViewBounds;            // 固定像素适配
                                                                // 无需按比例进行适配

#pragma mark - ==============固定数值===============
/**
 left
 默认只适配 左边到父视图的距离
 */
- (UIView*(^)(CGFloat leftValue))leftEqualToNum;                // 固定像素适配
- (UIView*(^)(CGFloat leftValue))leftEqualToNumScreenFit;       // 按屏幕比例适配

/**
 right
 默认只适配 右边到父视图的距离
 */
- (UIView*(^)(CGFloat rightValue))rightEqualToNum;              // 固定像素适配
- (UIView*(^)(CGFloat rightValue))rightEqualToNumScreenFit;     // 按屏幕比例适配

/**
 top
 默认只适配 上边到父视图的距离
 */
- (UIView*(^)(CGFloat topValue))topEqualToNum;                  // 固定像素适配
- (UIView*(^)(CGFloat topValue))topEqualToNumScreenFit;         // 按屏幕比例适配

/**
 bottom
 默认只适配 底边到父视图的距离
 */
- (UIView*(^)(CGFloat bottomValue))bottomEqualToNum;            // 固定像素适配
- (UIView*(^)(CGFloat bottomValue))bottomEqualToNumScreenFit;   // 按屏幕比例适配

/**
 width
 适配宽度到具体数值
 */
- (UIView*(^)(CGFloat widthValue))widthEqualToNum;              // 固定像素适配
- (UIView*(^)(CGFloat widthValue))widthEqualToNumScreenFit;     // 按屏幕比例适配

/**
 height
 适配高度到具体数值
 */
- (UIView*(^)(CGFloat heightValue))heightEqualToNum;            // 固定像素适配
- (UIView*(^)(CGFloat heightValue))heightEqualToNumScreenFit;   // 按屏幕比例适配

/**
 center
 适配中心点到具体位置
 */
- (UIView*(^)(CGPoint centerValue))centerEqualToNum;            // 固定像素适配
- (UIView*(^)(CGPoint centerValue))centerEqualToNumScreenFit;   // 按屏幕比例适配

/**
 origin
 适配原点到具体位置
 */
- (UIView*(^)(CGPoint originValue))originEqualToNum;            // 固定像素适配
- (UIView*(^)(CGPoint originValue))originEqualToNumScreenFit;   // 按屏幕比例适配

/**
 bounds
  适配边框到具体尺寸
 */
- (UIView*(^)(CGSize sizeValue))sizeEqualToNum;                 // 固定像素适配
- (UIView*(^)(CGSize sizeValue))sizeEqualToNumScreenFit;        // 按屏幕比例适配

#pragma mark - ==============视图相等==============
/**
 top
 */
- (UIView*(^)(UIView  *refView))topEqualToView;                 // 固定像素适配
                                                                // 无需按比例进行适配

/**
 left
 */
- (UIView*(^)(UIView  *refView))leftEqualToView;                // 固定像素适配
                                                                // 无需按比例进行适配

/**
 bottom
 */
- (UIView*(^)(UIView  *refView))bottomEqualToView;              // 固定像素适配
                                                                // 无需按比例进行适配

/**
 right
 */
- (UIView*(^)(UIView  *refView))rightEqualToView;               // 固定像素适配
                                                                // 无需按比例进行适配

/**
 width
 */
- (UIView*(^)(UIView  *refView))widthEqualToView;               // 固定像素适配
                                                                // 无需按比例进行适配

/**
 height
 */
- (UIView*(^)(UIView  *refView))heightEqualToView;              // 固定像素适配
                                                                // 无需按比例进行适配

/**
 center
 */
- (UIView*(^)(UIView  *refView))centerEqualToView;              // 固定像素适配
                                                                // 无需按比例进行适配

/**
 center point
 */
- (UIView*(^)(UIView  *refView))centerEqualToViewCenterPoint;   // 固定像素适配
                                                                // 无需按比例进行适配

/**
 origin
 */
- (UIView*(^)(UIView  *refView))originEqualToView;              // 固定像素适配
                                                                // 无需按比例进行适配

/**
 size
 */
- (UIView*(^)(UIView  *refView))sizeEqualToView;                // 固定像素适配
                                                                // 无需按比例进行适配

@end
