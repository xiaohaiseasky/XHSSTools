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
//@class NSLayoutXAxisAnchor,NSLayoutYAxisAnchor,NSLayoutDimension;
@protocol XHSSViewConfigProtocol <NSObject>

@optional
@property(nonatomic,getter=isUserInteractionEnabled) BOOL userInteractionEnabled;
@property(nonatomic)                                 NSInteger tag;                // default is 0
@property(nonatomic,readonly,strong)                 CALayer  * _Nonnull layer;
#if UIKIT_DEFINE_AS_PROPERTIES
@property(nonatomic,readonly) BOOL canBecomeFocused NS_AVAILABLE_IOS(9_0); // NO by default
#else
- (BOOL)canBecomeFocused NS_AVAILABLE_IOS(9_0); // NO by default
#endif
@property (readonly, nonatomic, getter=isFocused) BOOL focused NS_AVAILABLE_IOS(9_0);
@property (nonatomic) UISemanticContentAttribute semanticContentAttribute NS_AVAILABLE_IOS(9_0);
+ (UIUserInterfaceLayoutDirection)userInterfaceLayoutDirectionForSemanticContentAttribute:(UISemanticContentAttribute)attribute NS_AVAILABLE_IOS(9_0);
+ (UIUserInterfaceLayoutDirection)userInterfaceLayoutDirectionForSemanticContentAttribute:(UISemanticContentAttribute)semanticContentAttribute relativeToLayoutDirection:(UIUserInterfaceLayoutDirection)layoutDirection NS_AVAILABLE_IOS(10_0);
@property (readonly, nonatomic) UIUserInterfaceLayoutDirection effectiveUserInterfaceLayoutDirection NS_AVAILABLE_IOS(10_0);

/// *** UIView(UIViewGeometry)
@property(nonatomic) CGRect            frame;
@property(nonatomic) CGRect            bounds;      // default bounds is zero origin, frame size. animatable
@property(nonatomic) CGPoint           center;      // center is center of frame. animatable
@property(nonatomic) CGAffineTransform transform;   // default is CGAffineTransformIdentity. animatable
@property(nonatomic) CGFloat           contentScaleFactor NS_AVAILABLE_IOS(4_0);
@property(nonatomic,getter=isMultipleTouchEnabled) BOOL multipleTouchEnabled __TVOS_PROHIBITED;   // default is NO
@property(nonatomic,getter=isExclusiveTouch) BOOL       exclusiveTouch __TVOS_PROHIBITED;         // default is NO
- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
- (CGPoint)convertPoint:(CGPoint)point toView:(nullable UIView *)view;
- (CGPoint)convertPoint:(CGPoint)point fromView:(nullable UIView *)view;
- (CGRect)convertRect:(CGRect)rect toView:(nullable UIView *)view;
- (CGRect)convertRect:(CGRect)rect fromView:(nullable UIView *)view;
@property(nonatomic) BOOL               autoresizesSubviews;
@property(nonatomic) UIViewAutoresizing autoresizingMask;
- (CGSize)sizeThatFits:(CGSize)size;
- (void)sizeToFit;

/// *** UIView(UIViewHierarchy)
@property(nullable, nonatomic,readonly) UIView       *superview;
@property(nonatomic,readonly,copy) NSArray<__kindof UIView *> * _Nonnull subviews;
@property(nullable, nonatomic,readonly) UIWindow     *window;
- (void)removeFromSuperview;
- (void)insertSubview:(UIView *_Nonnull)view atIndex:(NSInteger)index;
- (void)exchangeSubviewAtIndex:(NSInteger)index1 withSubviewAtIndex:(NSInteger)index2;
- (void)addSubview:(UIView *_Nonnull)view;
- (void)insertSubview:(UIView *_Nonnull)view belowSubview:(UIView *_Nonnull)siblingSubview;
- (void)insertSubview:(UIView *_Nonnull)view aboveSubview:(UIView *_Nonnull)siblingSubview;
- (void)bringSubviewToFront:(UIView *_Nonnull)view;
- (void)sendSubviewToBack:(UIView *_Nonnull)view;
- (void)didAddSubview:(UIView *_Nonnull)subview;
- (void)willRemoveSubview:(UIView *_Nonnull)subview;
- (void)willMoveToSuperview:(nullable UIView *)newSuperview;
- (void)didMoveToSuperview;
- (void)willMoveToWindow:(nullable UIWindow *)newWindow;
- (void)didMoveToWindow;
- (BOOL)isDescendantOfView:(UIView *_Nonnull)view;  // returns YES for self.
- (nullable __kindof UIView *)viewWithTag:(NSInteger)tag; // recursive search. includes self
- (void)setNeedsLayout;
- (void)layoutIfNeeded;
- (void)layoutSubviews;
@property (nonatomic) UIEdgeInsets layoutMargins NS_AVAILABLE_IOS(8_0);
@property (nonatomic) NSDirectionalEdgeInsets directionalLayoutMargins API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic) BOOL preservesSuperviewLayoutMargins NS_AVAILABLE_IOS(8_0);
@property (nonatomic) BOOL insetsLayoutMarginsFromSafeArea API_AVAILABLE(ios(11.0),tvos(11.0));  // Default: YES
- (void)layoutMarginsDidChange NS_AVAILABLE_IOS(8_0);
@property (nonatomic,readonly) UIEdgeInsets safeAreaInsets API_AVAILABLE(ios(11.0),tvos(11.0));
- (void)safeAreaInsetsDidChange API_AVAILABLE(ios(11.0),tvos(11.0));
@property(readonly,strong) UILayoutGuide * _Nonnull layoutMarginsGuide NS_AVAILABLE_IOS(9_0);
@property (nonatomic, readonly, strong) UILayoutGuide * _Nonnull readableContentGuide  NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) UILayoutGuide * _Nonnull safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));

/// *** UIView(UIViewRendering)
- (void)drawRect:(CGRect)rect;
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;
@property(nonatomic)                 BOOL              clipsToBounds;
@property(nullable, nonatomic,copy)            UIColor          *backgroundColor UI_APPEARANCE_SELECTOR;
@property(nonatomic)                 CGFloat           alpha;                      // animatable. default is 1.0
@property(nonatomic,getter=isOpaque) BOOL              opaque;
@property(nonatomic)                 BOOL              clearsContextBeforeDrawing;
@property(nonatomic,getter=isHidden) BOOL              hidden;                     // default is NO. doesn't check superviews
@property(nonatomic)                 UIViewContentMode contentMode;                // default is UIViewContentModeScaleToFill
@property(nonatomic)                 CGRect            contentStretch NS_DEPRECATED_IOS(3_0,6_0) __TVOS_PROHIBITED;
@property(nullable, nonatomic,strong)          UIView           *maskView NS_AVAILABLE_IOS(8_0);
@property(null_resettable, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(7_0);
@property(nonatomic) UIViewTintAdjustmentMode tintAdjustmentMode NS_AVAILABLE_IOS(7_0);
- (void)tintColorDidChange NS_AVAILABLE_IOS(7_0);

/// *** UIView(UIViewAnimation)
+ (void)beginAnimations:(nullable NSString *)animationID context:(nullable void *)context;
+ (void)commitAnimations;
+ (void)setAnimationDelegate:(nullable id)delegate;                          // default = nil
+ (void)setAnimationWillStartSelector:(nullable SEL)selector;
+ (void)setAnimationDidStopSelector:(nullable SEL)selector;
+ (void)setAnimationDuration:(NSTimeInterval)duration;              // default = 0.2
+ (void)setAnimationDelay:(NSTimeInterval)delay;                    // default = 0.0
+ (void)setAnimationStartDate:(NSDate *_Nonnull)startDate;                  // default = now ([NSDate date])
+ (void)setAnimationCurve:(UIViewAnimationCurve)curve;              // default = UIViewAnimationCurveEaseInOut
+ (void)setAnimationRepeatCount:(float)repeatCount;                 // default = 0.0.  May be fractional
+ (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses;    // default = NO. used if repeat count is non-zero
+ (void)setAnimationBeginsFromCurrentState:(BOOL)fromCurrentState;
+ (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(UIView *_Nonnull)view cache:(BOOL)cache;
+ (void)setAnimationsEnabled:(BOOL)enabled;
+ (void)performWithoutAnimation:(void (NS_NOESCAPE ^_Nonnull)(void))actionsWithoutAnimation NS_AVAILABLE_IOS(7_0);

/// *** UIView(UIViewAnimationWithBlocks)
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^_Nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^_Nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0); // delay = 0.0, options = 0
+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^_Nonnull)(void))animations NS_AVAILABLE_IOS(4_0);
+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^_Nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
+ (void)transitionWithView:(UIView *_Nonnull)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
+ (void)transitionFromView:(UIView *_Nonnull)fromView toView:(UIView *_Nonnull)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(4_0);
+ (void)performSystemAnimation:(UISystemAnimation)animation onViews:(NSArray<__kindof UIView *> *_Nonnull)views options:(UIViewAnimationOptions)options animations:(void (^ __nullable)(void))parallelAnimations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);

/// *** UIView (UIViewKeyframeAnimations)
+ (void)animateKeyframesWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewKeyframeAnimationOptions)options animations:(void (^_Nonnull)(void))animations completion:(void (^ __nullable)(BOOL finished))completion NS_AVAILABLE_IOS(7_0);
+ (void)addKeyframeWithRelativeStartTime:(double)frameStartTime relativeDuration:(double)frameDuration animations:(void (^_Nonnull)(void))animations NS_AVAILABLE_IOS(7_0);

/// *** UIView (UIViewGestureRecognizers)
@property(nullable, nonatomic,copy) NSArray<__kindof UIGestureRecognizer *> *gestureRecognizers NS_AVAILABLE_IOS(3_2);
- (void)addGestureRecognizer:(UIGestureRecognizer*_Nonnull)gestureRecognizer NS_AVAILABLE_IOS(3_2);
- (void)removeGestureRecognizer:(UIGestureRecognizer*_Nonnull)gestureRecognizer NS_AVAILABLE_IOS(3_2);
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *_Nonnull)gestureRecognizer NS_AVAILABLE_IOS(6_0);

/// *** UIView (UIViewMotionEffects)
- (void)addMotionEffect:(UIMotionEffect *_Nonnull)effect NS_AVAILABLE_IOS(7_0);
- (void)removeMotionEffect:(UIMotionEffect *_Nonnull)effect NS_AVAILABLE_IOS(7_0);
@property (copy, nonatomic) NSArray<__kindof UIMotionEffect *> * _Nonnull motionEffects NS_AVAILABLE_IOS(7_0);
//
// UIView Constraint-based Layout Support
//typedef NS_ENUM(NSInteger, UILayoutConstraintAxis) {
//    UILayoutConstraintAxisHorizontal = 0,
//    UILayoutConstraintAxisVertical = 1
//};

/// *** UIView (UIConstraintBasedLayoutInstallingConstraints)
@property(nonatomic,readonly) NSArray<__kindof NSLayoutConstraint *> * _Nonnull constraints NS_AVAILABLE_IOS(6_0);
- (void)addConstraint:(NSLayoutConstraint *_Nonnull)constraint NS_AVAILABLE_IOS(6_0);
- (void)addConstraints:(NSArray<__kindof NSLayoutConstraint *> *_Nonnull)constraints NS_AVAILABLE_IOS(6_0);
- (void)removeConstraint:(NSLayoutConstraint *_Nonnull)constraint NS_AVAILABLE_IOS(6_0);
- (void)removeConstraints:(NSArray<__kindof NSLayoutConstraint *> *_Nonnull)constraints NS_AVAILABLE_IOS(6_0);

/// *** UIView (UIConstraintBasedLayoutCoreMethods)
//- (void)updateConstraintsIfNeeded NS_AVAILABLE_IOS(6_0);
//- (void)updateConstraints NS_AVAILABLE_IOS(6_0) NS_REQUIRES_SUPER;
//- (BOOL)needsUpdateConstraints NS_AVAILABLE_IOS(6_0);
//- (void)setNeedsUpdateConstraints NS_AVAILABLE_IOS(6_0);

/// *** UIView (UIConstraintBasedCompatibility)
@property(nonatomic) BOOL translatesAutoresizingMaskIntoConstraints NS_AVAILABLE_IOS(6_0); // Default YES

/// *** UIView (UIConstraintBasedLayoutLayering)
- (CGRect)alignmentRectForFrame:(CGRect)frame NS_AVAILABLE_IOS(6_0);
- (CGRect)frameForAlignmentRect:(CGRect)alignmentRect NS_AVAILABLE_IOS(6_0);
- (UIView *_Nonnull)viewForBaselineLayout NS_DEPRECATED_IOS(6_0, 9_0, "Override -viewForFirstBaselineLayout or -viewForLastBaselineLayout as appropriate, instead") __TVOS_PROHIBITED;
@property(readonly,strong) UIView * _Nonnull viewForFirstBaselineLayout NS_AVAILABLE_IOS(9_0);
@property(readonly,strong) UIView * _Nonnull viewForLastBaselineLayout NS_AVAILABLE_IOS(9_0);

//UIKIT_EXTERN const CGFloat UIViewNoIntrinsicMetric NS_AVAILABLE_IOS(6_0); // -1
- (void)invalidateIntrinsicContentSize NS_AVAILABLE_IOS(6_0);
- (UILayoutPriority)contentHuggingPriorityForAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(6_0);
- (void)setContentHuggingPriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(6_0);
- (UILayoutPriority)contentCompressionResistancePriorityForAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(6_0);
- (void)setContentCompressionResistancePriority:(UILayoutPriority)priority forAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(6_0);

//UIKIT_EXTERN const CGSize UILayoutFittingCompressedSize NS_AVAILABLE_IOS(6_0);
//UIKIT_EXTERN const CGSize UILayoutFittingExpandedSize NS_AVAILABLE_IOS(6_0);

/// *** UIView (UIConstraintBasedLayoutFittingSize)
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize NS_AVAILABLE_IOS(6_0);
- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority NS_AVAILABLE_IOS(8_0);

/// *** UIView (UILayoutGuideSupport)
@property(nonatomic,readonly,copy) NSArray<__kindof UILayoutGuide *> * _Nonnull layoutGuides NS_AVAILABLE_IOS(9_0);
- (void)addLayoutGuide:(UILayoutGuide *_Nonnull)layoutGuide NS_AVAILABLE_IOS(9_0);
- (void)removeLayoutGuide:(UILayoutGuide *_Nonnull)layoutGuide NS_AVAILABLE_IOS(9_0);

/// *** UIView (UIViewLayoutConstraintCreation)
@property(nonatomic,readonly,strong) NSLayoutXAxisAnchor * _Nonnull leadingAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutXAxisAnchor * _Nonnull trailingAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutXAxisAnchor * _Nonnull leftAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutXAxisAnchor * _Nonnull rightAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutYAxisAnchor * _Nonnull topAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutYAxisAnchor * _Nonnull bottomAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutDimension * _Nonnull widthAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutDimension * _Nonnull heightAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutXAxisAnchor * _Nonnull centerXAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutYAxisAnchor * _Nonnull centerYAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutYAxisAnchor * _Nonnull firstBaselineAnchor NS_AVAILABLE_IOS(9_0);
@property(nonatomic,readonly,strong) NSLayoutYAxisAnchor * _Nonnull lastBaselineAnchor NS_AVAILABLE_IOS(9_0);

/// *** UIView (UIConstraintBasedLayoutDebugging)
- (NSArray<__kindof NSLayoutConstraint *> *_Nonnull)constraintsAffectingLayoutForAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(6_0);
- (void)exerciseAmbiguityInLayout NS_AVAILABLE_IOS(6_0);

/// UILayoutGuide (UIConstraintBasedLayoutDebugging)
//- (NSArray<__kindof NSLayoutConstraint *> *_Nonnull)constraintsAffectingLayoutForAxis:(UILayoutConstraintAxis)axis NS_AVAILABLE_IOS(10_0);

/// *** UIView (UIStateRestoration)
@property (nullable, nonatomic, copy) NSString *restorationIdentifier NS_AVAILABLE_IOS(6_0);
- (void) encodeRestorableStateWithCoder:(NSCoder *_Nonnull)coder NS_AVAILABLE_IOS(6_0);
- (void) decodeRestorableStateWithCoder:(NSCoder *_Nonnull)coder NS_AVAILABLE_IOS(6_0);

/// *** UIView (UISnapshotting)
- (nullable UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates NS_AVAILABLE_IOS(7_0);
- (nullable UIView *)resizableSnapshotViewFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterUpdates withCapInsets:(UIEdgeInsets)capInsets NS_AVAILABLE_IOS(7_0);  // Resizable snapshots will default to stretching the center
- (BOOL)drawViewHierarchyInRect:(CGRect)rect afterScreenUpdates:(BOOL)afterUpdates NS_AVAILABLE_IOS(7_0);

@end
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
@class XHSSConfigManagerBridge, XHSSLayoutManagerBridge;

typedef void(^XHSSConfigBridgeBlock)(XHSSConfigManagerBridge * _Nonnull configManager);
typedef void(^XHSSLayoutBridgeBlock)(XHSSLayoutManagerBridge * _Nonnull layoutManager);

@interface XHSSManagerBridge : NSObject

@property (nonatomic, strong) UIView * _Nonnull targetView;

+ (UIView*_Nonnull)createComponentWithClass:(Class _Nonnull)componentClazz;

//- (UIView*_Nonnull(^_Nonnull)(UIView * _Nonnull superView))addToSuperView;
//- (UIView*_Nonnull(^_Nonnull)(XHSSLayoutBridgeBlock _Nonnull layout))addLayout;
//- (UIView*_Nonnull(^_Nonnull)(XHSSConfigBridgeBlock _Nonnull config))addConfig;

@end




#pragma mark - =========== XHSSConfigManagerBridge ===========
// =============================================
//      XHSSConfigManagerBridge
// =============================================
@interface XHSSConfigManagerBridge : XHSSManagerBridge <XHSSViewConfigProtocol, XHSSLabelConfigProtocol, XHSSButtonConfigProtocol>

//@property (nonatomic, strong) UIView * _Nonnull targetView;

@end





#pragma mark - =========== XHSSLayoutManagerBridge ===========
// =============================================
//      XHSSLayoutManagerBridge
// =============================================
@interface XHSSLayoutManagerBridge : XHSSManagerBridge <XHSSLayoutProtocol>

//@property (nonatomic, strong) UIView * _Nonnull targetView;

@end





