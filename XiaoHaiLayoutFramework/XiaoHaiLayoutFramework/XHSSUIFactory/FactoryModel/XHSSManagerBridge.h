//
//  XHSSManagerBridge.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/22.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

/**
 config : label -> labelConfig / button -> buttonConfig / ...
        __Config : __Config<__A__ConfigProtocal, __B__ConfigProtocal, __C__ConfigProtocal ...>
            __N__ConfigProtocal : @optional [property / method]
 
 call -> __Config.property / [__Config method]
        ==> runtime call : __Config.realTarget.property / [__Config method] (__Config dose not implemente the optional protocol method or property method , these optional protocol method or property is implementate in the realTarget object)
 
 */


#import <UIKit/UIKit.h>


#pragma mark - =========== XHSSConfigProtocol ===========
#warning ------- this way dose not implemente protocol method , so can not use chainCall -------
#warning ------- if need new component , add method and property at here -------
// =============================================
//      XHSSConfigProtocol
// =============================================
#pragma mark - =========== XHSSLabelConfigProtocol ===========
@protocol XHSSLabelConfigProtocol <NSObject>

@optional
@property(nullable, nonatomic,copy)   NSString           *text;
@property(null_resettable, nonatomic,strong) UIFont      *font;
@property(null_resettable, nonatomic,strong) UIColor     *textColor;
@property(nullable, nonatomic,strong) UIColor            *shadowColor;
@property(nonatomic)        CGSize             shadowOffset;
@property(nonatomic)        NSTextAlignment    textAlignment;
@property(nonatomic)        NSLineBreakMode    lineBreakMode;
@property(nullable, nonatomic,copy)   NSAttributedString *attributedText NS_AVAILABLE_IOS(6_0);
@property(nullable, nonatomic,strong)               UIColor *highlightedTextColor;
@property(nonatomic,getter=isHighlighted) BOOL     highlighted;
@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
@property(nonatomic,getter=isEnabled)                BOOL enabled;
@property(nonatomic) NSInteger numberOfLines;
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;
@property(nonatomic) UIBaselineAdjustment baselineAdjustment;
@property(nonatomic) CGFloat minimumScaleFactor NS_AVAILABLE_IOS(6_0);
@property(nonatomic) BOOL allowsDefaultTighteningForTruncation NS_AVAILABLE_IOS(9_0);

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines;
- (void)drawTextInRect:(CGRect)rect;

@property(nonatomic) CGFloat preferredMaxLayoutWidth NS_AVAILABLE_IOS(6_0);
@property(nonatomic) CGFloat minimumFontSize NS_DEPRECATED_IOS(2_0, 6_0) __TVOS_PROHIBITED;
@property(nonatomic) BOOL adjustsLetterSpacingToFitWidth NS_DEPRECATED_IOS(6_0,7_0) __TVOS_PROHIBITED;

@end

#pragma mark - =========== XHSSButtonConfigProtocol ===========
@protocol XHSSButtonConfigProtocol <NSObject>
@optional

@end

#pragma mark - =========== XHSSLayoutProtocol ===========
// =============================================
//      XHSSLayoutProtocol
// =============================================
@protocol XHSSLayoutProtocol <NSObject>

@optional
- (UIView*_Nonnull(^_Nonnull)(CGFloat baseScreenWidth))laBaseScreenWidth;

#pragma mark - ==============参考视图===============
// => distance().to***View().to***ViewScreenFit() << [top/left/bottom/right] not design yet >>
#pragma mark - top
/**
 保存 self 的 top 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat topDistance))topDistance;

/**
 设置上边距时，上侧的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull topRefView))toTopRefView;             // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull topRefView))toTopRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - left
/**
 保存 self 的 left 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat leftDistance))leftDistance;

/**
 设置左边距时，左侧的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull leftRefView))toLeftRefView;             // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull leftRefView))toLeftRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - bottom
/**
 保存 self 的 bottom 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat bottomDistance))bottomDistance;

/**
 设置下边距时，下侧的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull bottomRefView))toBottomRefView;             // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull bottomRefView))toBottomRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - right
/**
 保存 self 的 right 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat rightDistance))rightDistance;

/**
 设置右边距时，右侧的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull rightRefView))toRightRefView;             // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull rightRefView))toRightRefViewScreenFit;    // 按屏幕比例适配

#pragma mark - width
/**
 保存 self 的 width 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat widthValue))widthValue;

/**
 设置 width 时的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull refView))equalToRefViewWidth;             // 固定像素适配
// 无需按比例进行适配

#pragma mark - height
/**
 保存 self 的 height 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat heightValue))heightValue;

/**
 设置 height 时的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull refView))equalToRefViewHeight;            // 固定像素适配
// 无需按比例进行适配

#pragma mark - center
/**
 保存 self 的 center 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGPoint centerValue))centerValue;

/**
 设置 center 时的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull refView))equalToRefViewCenter;            // 固定像素适配
// 无需按比例进行适配


#pragma mark - origin
/**
 保存 self 的 origin 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGPoint orignValue))originValue;

/**
 设置 origin 时的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull refView))equalToRefViewOrigin;            // 固定像素适配
// 无需按比例进行适配

#pragma mark - bounds
/**
 保存 self 的 bounds 以备后续使用
 */
- (UIView*_Nonnull(^_Nonnull)(CGSize boundsValue))boundsValue;

/**
 设置 bounds 时的参考视图
 */
- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull refView))equalToRefViewBounds;            // 固定像素适配
// 无需按比例进行适配

#pragma mark - ==============固定数值===============
// => equalToNum().equalToNumScreenFit()
/**
 left
 默认只适配 左边到父视图的距离
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat leftValue))leftEqualToNum;                // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat leftValue))leftEqualToNumScreenFit;       // 按屏幕比例适配

/**
 right
 默认只适配 右边到父视图的距离
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat rightValue))rightEqualToNum;              // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat rightValue))rightEqualToNumScreenFit;     // 按屏幕比例适配

/**
 top
 默认只适配 上边到父视图的距离
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat topValue))topEqualToNum;                  // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat topValue))topEqualToNumScreenFit;         // 按屏幕比例适配

/**
 bottom
 默认只适配 底边到父视图的距离
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat bottomValue))bottomEqualToNum;            // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat bottomValue))bottomEqualToNumScreenFit;   // 按屏幕比例适配

/**
 width
 适配宽度到具体数值
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat widthValue))widthEqualToNum;              // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat widthValue))widthEqualToNumScreenFit;     // 按屏幕比例适配

/**
 height
 适配高度到具体数值
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat heightValue))heightEqualToNum;            // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat heightValue))heightEqualToNumScreenFit;   // 按屏幕比例适配

/**
 center
 适配中心点到具体位置
 */
- (UIView*_Nonnull(^_Nonnull)(CGPoint centerValue))centerEqualToNum;            // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGPoint centerValue))centerEqualToNumScreenFit;   // 按屏幕比例适配

/**
 origin
 适配原点到具体位置
 */
- (UIView*_Nonnull(^_Nonnull)(CGPoint originValue))originEqualToNum;            // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGPoint originValue))originEqualToNumScreenFit;   // 按屏幕比例适配

/**
 bounds
  适配边框到具体尺寸
 */
- (UIView*_Nonnull(^_Nonnull)(CGSize sizeValue))sizeEqualToNum;                 // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGSize sizeValue))sizeEqualToNumScreenFit;        // 按屏幕比例适配

#pragma mark - ==============视图相等==============
// => equalToView()/centerEqualToViewCenterPoint()
/**
 top
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topEqualToView;                     // 固定像素适配
#if 1
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topEqualToViewTop;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topEqualToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topEqualToViewBottom;
#endif

/**
 left
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftEqualToView;                    // 固定像素适配
#if 1
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftEqualToViewLeft;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftEqualToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftEqualToViewRight;
#endif

/**
 bottom
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomEqualToView;                  // 固定像素适配
#if 1
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomEqualToViewTop;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomEqualToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomEqualToViewBottom;
#endif

/**
 right
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightEqualToView;                   // 固定像素适配
#if 1
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightEqualToViewLeft;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightEqualToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightEqualToViewRight;
#endif

/**
 width
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))widthEqualToView;                   // 固定像素适配

/**
 height
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))heightEqualToView;                  // 固定像素适配

/**
 center
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))centerEqualToView;                  // 固定像素适配

/**
 center point
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))centerEqualToViewCenterPoint;       // 固定像素适配

/**
 origin
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))originEqualToView;                  // 固定像素适配

/**
 size
 */
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))sizeEqualToView;                    // 固定像素适配

#pragma mark - ==============对齐===============
// => alignmentTo[by]Num().alignmentTo[by]NumScreenFit().alignmentToView[top/left/bottom/right]()
/**
 top
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))topAligmentToNum;               // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))topAligmentToNumScreenFit;      // 按屏幕比例适配

- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topAligmentToView;                  // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topAligmentToViewTop;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topAligmentToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))topAligmentToViewBotton;

/**
 left
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))leftAligmentToNum;              // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))leftAligmentToNumScreenFit;     // 按屏幕比例适配

- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftAligmentToView;                 // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftAligmentToViewLeft;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftAligmentToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))leftAligmentToViewRight;

/**
 bottom
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))bottomAligmentToNum;            // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat  bottomValue))bottomAligmentToNumScreenFit;   // 按屏幕比例适配

- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomAligmentToView;               // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomAligmentToViewTop;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomAligmentToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))bottomAligmentToViewBotton;

/**
 right
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))rightAligmentToNum;              // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))rightAligmentToNumScreenFit;     // 按屏幕比例适配

- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightAligmentToView;                // 固定像素适配
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightAligmentToViewLeft;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightAligmentToViewCenter;
- (UIView*_Nonnull(^_Nonnull)(UIView  * _Nonnull refView))rightAligmentToViewRight;


#pragma mark - ==============平移===============
// => moveBY[to]Num().moveBY[to]NumScreenFit()[top/left/bottom/right].
/**
 up
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  topValue))moveUpByNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  topValue))moveUpByNumScreenFit;

- (UIView*_Nonnull(^_Nonnull)(CGFloat  topValue))moveUpToNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  topValue))moveUpToNumScreenFit;

/**
 left
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  leftValue))moveLeftByNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  leftValue))moveLeftByNumScreenFit;

- (UIView*_Nonnull(^_Nonnull)(CGFloat  leftValue))moveLeftToNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  leftValue))moveLeftToNumScreenFit;

/**
 dwon
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  dwonValue))moveDwonByNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  dwonValue))moveDwonByNumScreenFit;

- (UIView*_Nonnull(^_Nonnull)(CGFloat  dwonValue))moveDwonToNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  dwonValue))moveDwonToNumScreenFit;

/**
 right
 */
- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))moveRightByNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))moveRightByNumScreenFit;

- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))moveRightToyNum;
- (UIView*_Nonnull(^_Nonnull)(CGFloat  rightValue))moveRightToNumScreenFit;

@end



////////////////////////////////////////////////////////////////////////////////



#pragma mark - =========== XHSSManagerBridge ===========
// =============================================
//      XHSSManagerBridge
// =============================================
@interface XHSSManagerBridge : NSObject

@end




#pragma mark - =========== XHSSConfigManagerBridge ===========
// =============================================
//      XHSSConfigManagerBridge
// =============================================
@interface XHSSConfigManagerBridge : NSObject <XHSSLabelConfigProtocol, XHSSButtonConfigProtocol>

@property (nonatomic, strong) UIView * _Nonnull targetView;

@end





#pragma mark - =========== XHSSLayoutManagerBridge ===========
// =============================================
//      XHSSLayoutManagerBridge
// =============================================
@interface XHSSLayoutManagerBridge : NSObject <XHSSLayoutProtocol>

@property (nonatomic, strong) UIView * _Nonnull targetView;

@end





