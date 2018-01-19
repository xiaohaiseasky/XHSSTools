//
//  XHSSUIManager.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/11/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//
//
//
// 每一种控件的属性都加了前缀表示是哪种控件的属性，只有 UIView 的属性没有前缀，标示 UIView 及其子类都具备该属性
//
//
// *** XHSSConfigManager 都是单例返回的 ，这造成 XHSSConfigManager 复用时无法单独进行独立配置 ***
// *** 负数参照未处理 ***
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - =============macro===============

#pragma mark - color
#define XHSS_COLOR_BLACK                        [UIColor blackColor]
#define XHSS_COLOR_DARK_GRAY                    [UIColor darkGrayColor]
#define XHSS_COLOR_LIGHT_GRAY                   [UIColor lightGrayColor]
#define XHSS_COLOR_WHITE                        [UIColor whiteColor]
#define XHSS_COLOR_GRAY                         [UIColor grayColor]
#define XHSS_COLOR_RED                          [UIColor redColor]
#define XHSS_COLOR_GREEN                        [UIColor greenColor]
#define XHSS_COLOR_BLUE                         [UIColor blueColor]
#define XHSS_COLOR_CYAN                         [UIColor cyanColor]
#define XHSS_COLOR_YELLOW                       [UIColor yellowColor]
#define XHSS_COLOR_MAGENTA                      [UIColor magentaColor]
#define XHSS_COLOR_ORANGE                       [UIColor orangeColor]
#define XHSS_COLOR_PURPLR                       [UIColor purpleColor]
#define XHSS_COLOR_BROWN                        [UIColor brownColor]
#define XHSS_COLOR_CLEAR                        [UIColor clearColor]
#define XHSS_COLOR_WITH_WHITE_ALPHA(white,a)    [UIColor colorWithWhite:white alpha:a]
#define XHSS_COLOR_WITH_RGBA(r,g,b,a)           [UIColor colorWithRed:r green:g blue:b alpha:a]

#pragma mark - textAligment
#define XHSS_TEXT_ALIGNMENT_LEFT            NSTextAlignmentLeft
#define XHSS_TEXT_ALIGNMENT_CENTER          NSTextAlignmentCenter
#define XHSS_TEXT_ALIGNMENT_RIGHT           NSTextAlignmentRight
#define XHSS_TEXT_ALIGNMENT_JUSTIFIED       NSTextAlignmentJustified
#define XHSS_TEXT_ALIGNMENT_NATURAL         NSTextAlignmentNatural

#pragma mark - UIViewContentMode
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_FILL              UIViewContentModeScaleToFill
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_ASPECT_FIT           UIViewContentModeScaleAspectFit
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_ASPECT_FILL          UIViewContentModeScaleAspectFill
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_REDRAW            UIViewContentModeRedraw
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_CENTER            UIViewContentModeCenter
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_TOP               UIViewContentModeTop
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_BOTTOM            UIViewContentModeBottom
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_LEFT              UIViewContentModeLeft
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_RIGHT             UIViewContentModeRight
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_TOP_LEFT          UIViewContentModeTopLeft
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_TOP_RIGHT         UIViewContentModeTopRight
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_BOTTOM_LEFT       UIViewContentModeBottomLeft
#define XHSS_UIVIEW_CONTENT_MODE_SCALE_TO_BOTTOM_RIGHT      UIViewContentModeBottomRight

#pragma mark - UIFont
#define XHSS_FONT_SYSTEM_WITH_SIZE(size)    [UIFont systemFontOfSize:size]
#define XHSS_FONT_BOLD_WITH_SIZE(size)      [UIFont boldSystemFontOfSize:size]
#define XHSS_FONT_ITALIC_WITH_SIZE(size)    [UIFont italicSystemFontOfSize:size]

#pragma mark - NSLineBreakMode
#define XHSS_LINE_BREAK_MODE_WORD_WRAPPING          NSLineBreakByWordWrapping
#define XHSS_LINE_BREAK_MODE_CHAR_WRAPPING          NSLineBreakByCharWrapping
#define XHSS_LINE_BREAK_MODE_CLIPPING               NSLineBreakByClipping
#define XHSS_LINE_BREAK_MODE_TRUNCATING_HEAD        NSLineBreakByTruncatingHead
#define XHSS_LINE_BREAK_MODE_TRUNCATING_TAIL        NSLineBreakByTruncatingTail
#define XHSS_LINE_BREAK_MODE_TRUNCATING_MIDDLE      NSLineBreakByTruncatingMiddle

#pragma mark - UIBaselineAdjustment
#define XHSS_BASE_LINE_ADJUSTMENT_ALIGN_BASELINES   UIBaselineAdjustmentAlignBaselines
#define XHSS_BASE_LINE_ADJUSTMENT_ALIGN_CENTERS     UIBaselineAdjustmentAlignCenters
#define XHSS_BASE_LINE_ADJUSTMENT_NONE              UIBaselineAdjustmentNone

#pragma mark - UITextBorderStyle
#define XHSS_TEXT_BORDER_STYLE_NONE             UITextBorderStyleNone,
#define XHSS_TEXT_BORDER_STYLE_LINE             UITextBorderStyleLine,
#define XHSS_TEXT_BORDER_STYLE_BEZEL            UITextBorderStyleBezel,
#define XHSS_TEXT_BORDER_STYLE_ROUNDED_RECT     UITextBorderStyleRoundedRect

#pragma mark - UITextFieldViewMode
#define XHSS_TEXT_FIELD_VIEW_MODE_NERVER            UITextFieldViewModeNever
#define XHSS_TEXT_FIELD_VIEW_MODE_WHILE_EDITING     UITextFieldViewModeWhileEditing
#define XHSS_TEXT_FIELD_VIEW_MODE_UNLESS_EDITING    UITextFieldViewModeUnlessEditing
#define XHSS_TEXT_FIELD_VIEW_MODE_ALWAYS            UITextFieldViewModeAlways



@class XHSSConfigManager, XHSSLayoutManager;

typedef void(^XHSSLayoutBlock)(UIView *layoutView);
//typedef void(^XHSSConfigBlock)(UIView *layoutView);
typedef void(^XHSSConfigBlock)(XHSSConfigManager *layoutView);


#pragma mark - =========== XHSSUIManager ===========
// =============================================
//      XHSSUIManager
// =============================================
@interface XHSSUIManager : NSObject

/// *** below mark info should be define whith varibles which are extern const ***

// color

// textAligment

// UIViewContentMode

// UIFont

// NSLineBreakMode

// UIBaselineAdjustment

// UITextBorderStyle

// UITextFieldViewMode

@end



#pragma mark - =========== ConfigManager ============
// =============================================
//      ConfigManager
// =============================================
@interface XHSSConfigManager : NSObject

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UITextField *textField;

// 需要配置的目标视图
@property (nonatomic, strong) UIView *targetView;

#pragma mark - UIView
// UIView
- (XHSSConfigManager*(^)(BOOL userInteractionEnabled))userInteractionEnabled;
- (XHSSConfigManager*(^)(NSInteger tag))tag;
- (XHSSConfigManager*(^)(BOOL clipsToBounds))clipsToBounds;
- (XHSSConfigManager*(^)(UIColor *backgroundColor))backgroundColor;
- (XHSSConfigManager*(^)(CGFloat alpha))alpha;
- (XHSSConfigManager*(^)(BOOL opaque))opaque;
- (XHSSConfigManager*(^)(BOOL hidden))hidden;
- (XHSSConfigManager*(^)(UIViewContentMode contentMode))contentMode;
// border
- (XHSSConfigManager*(^)(UIColor *borderColor))borderColor;
- (XHSSConfigManager*(^)(CGFloat borderWidth))borderWidth;
- (XHSSConfigManager*(^)(CGFloat cornerRadius))cornerRadius;
// shadow
- (XHSSConfigManager*(^)(UIColor *shadowColor))shadowColor;
- (XHSSConfigManager*(^)(float shadowOpacity))shadowOpacity;
- (XHSSConfigManager*(^)(CGSize shadowOffset))shadowOffset;
- (XHSSConfigManager*(^)(CGFloat shadowRadius))shadowRadius;

- (XHSSConfigManager*(^)(id target, SEL action))addTapGestureWithTargetAndAction;

#pragma mark - UILabel
// label
- (XHSSConfigManager*(^)(NSString *text))label_text;
- (XHSSConfigManager*(^)(UIFont *font))label_font;
- (XHSSConfigManager*(^)(UIColor *textColor))label_textColor;
- (XHSSConfigManager*(^)(UIColor *shadowColor))label_shadowColor;                           // at UIView
- (XHSSConfigManager*(^)(CGSize shadowOffset))label_shadowOffset;                           // at UIView
- (XHSSConfigManager*(^)(NSTextAlignment textAlignment))label_textAlignment;
- (XHSSConfigManager*(^)(NSLineBreakMode lineBreakMode))label_lineBreakMode;
- (XHSSConfigManager*(^)(NSAttributedString *attributedText))label_attributedText;
- (XHSSConfigManager*(^)(UIColor *highlightedTextColor))label_highlightedTextColor;
- (XHSSConfigManager*(^)(BOOL highlighted))label_highlighted;
- (XHSSConfigManager*(^)(BOOL enabled))label_enabled;
- (XHSSConfigManager*(^)(NSInteger numberOfLines))label_numberOfLines;
- (XHSSConfigManager*(^)(BOOL adjustsFontSizeToFitWidth))label_adjustsFontSizeToFitWidth;
- (XHSSConfigManager*(^)(UIBaselineAdjustment baselineAdjustment))label_baselineAdjustment;
- (XHSSConfigManager*(^)(CGFloat minimumScaleFactor))label_minimumScaleFactor;

#pragma mark - UIButton
// button
- (XHSSConfigManager*(^)(UIEdgeInsets contentEdgeInsets))button_contentEdgeInsets;
- (XHSSConfigManager*(^)(UIEdgeInsets titleEdgeInsets))button_titleEdgeInsets;
- (XHSSConfigManager*(^)(BOOL reversesTitleShadowWhenHighlighted))button_reversesTitleShadowWhenHighlighted;
- (XHSSConfigManager*(^)(UIEdgeInsets imageEdgeInsets))button_imageEdgeInsets;
- (XHSSConfigManager*(^)(BOOL adjustsImageWhenHighlighted))button_adjustsImageWhenHighlighted;
- (XHSSConfigManager*(^)(BOOL adjustsImageWhenDisabled))button_adjustsImageWhenDisabled;
- (XHSSConfigManager*(^)(BOOL showsTouchWhenHighlighted))button_showsTouchWhenHighlighted;
- (XHSSConfigManager*(^)(UIColor *tintColor))button_tintColor;
// title
- (XHSSConfigManager*(^)(NSString *title, UIControlState state))button_titleForState;
- (XHSSConfigManager*(^)(UIColor *color, UIControlState state))button_titleColorForState;
- (XHSSConfigManager*(^)(UIColor *color, UIControlState state))button_titleShadowColorForState;
- (XHSSConfigManager*(^)(NSAttributedString *title, UIControlState state))button_AttributedTitleForState;
// image
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))button_imageForState;
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))button_backgroundImageForState;
// action
- (XHSSConfigManager*(^)(id target, SEL action, UIControlEvents event))button_addActionForTargetWithEvent;

#pragma mark - UIImageView
// imageView
- (XHSSConfigManager*(^)(UIImage *image))imageView_image;
- (XHSSConfigManager*(^)(UIImage *highlightedImage))imageView_highlightedImage;
- (XHSSConfigManager*(^)(BOOL userInteractionEnabled))imageView_userInteractionEnabled;                         // at UIView
- (XHSSConfigManager*(^)(BOOL highlighted))imageView_highlighted;                                               // not at UIView
- (XHSSConfigManager*(^)(NSArray<UIImage *> *animationImages))imageView_animationImages;
- (XHSSConfigManager*(^)(NSArray<UIImage *> *highlightedAnimationImages))imageView_highlightedAnimationImages;
- (XHSSConfigManager*(^)(NSTimeInterval animationDuration))imageView_animationDuration;
- (XHSSConfigManager*(^)(NSInteger animationRepeatCount))imageView_animationRepeatCount;
- (XHSSConfigManager*(^)(UIColor *tintColor))imageView_tintColor;                                               // not at UIView

#pragma mark - UISlider
// slider
- (XHSSConfigManager*(^)(float value))slider_value;
- (XHSSConfigManager*(^)(float minimumValue))slider_minimumValue;
- (XHSSConfigManager*(^)(float maximumValue))slider_maximumValue;
- (XHSSConfigManager*(^)(UIImage *minimumValueImage))slider_minimumValueImage;
- (XHSSConfigManager*(^)(UIImage *maximumValueImage))slider_maximumValueImage;
- (XHSSConfigManager*(^)(BOOL continuous))slider_continuous;
- (XHSSConfigManager*(^)(UIColor *minimumTrackTintColor))slider_minimumTrackTintColor;
- (XHSSConfigManager*(^)(UIColor *maximumTrackTintColor))slider_maximumTrackTintColor;
- (XHSSConfigManager*(^)(UIColor *thumbTintColor))slider_thumbTintColor;
//
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_thumbImageForState;
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_minimumTrackImageForState;
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_maximumTrackImageForState;
// action
- (XHSSConfigManager*(^)(id target, SEL action, UIControlEvents event))slider_addActionForTargetWithEvent;

#pragma mark - UITextField
// UITextField
- (XHSSConfigManager*(^)(NSString *text))textField_text;
- (XHSSConfigManager*(^)(NSAttributedString *attributedText))textField_attributedText;
- (XHSSConfigManager*(^)(UIColor *textColor))textField_textColor;
- (XHSSConfigManager*(^)(UIFont *font))textField_font;
- (XHSSConfigManager*(^)(NSTextAlignment textAlignment))textField_textAlignment;
- (XHSSConfigManager*(^)(UITextBorderStyle borderStyle))textField_borderStyle;
- (XHSSConfigManager*(^)(NSDictionary<NSString *, id> *defaultTextAttributes))textField_defaultTextAttributes;
- (XHSSConfigManager*(^)(NSString *placeholder))textField_placeholder;
- (XHSSConfigManager*(^)(NSAttributedString *attributedPlaceholder))textField_attributedPlaceholder;
- (XHSSConfigManager*(^)(BOOL clearsOnBeginEditing))textField_clearsOnBeginEditing;
- (XHSSConfigManager*(^)(BOOL adjustsFontSizeToFitWidth))textField_adjustsFontSizeToFitWidth;
- (XHSSConfigManager*(^)(CGFloat minimumFontSize))textField_minimumFontSize;
- (XHSSConfigManager*(^)(id<UITextFieldDelegate> delegate))textField_delegate;
- (XHSSConfigManager*(^)(UIImage *background))textField_background;
- (XHSSConfigManager*(^)(UIImage *disabledBackground))textField_disabledBackground;
- (XHSSConfigManager*(^)(BOOL allowsEditingTextAttributes))textField_allowsEditingTextAttributes;
- (XHSSConfigManager*(^)(NSDictionary<NSString *, id> *typingAttributes))textField_typingAttributes;
- (XHSSConfigManager*(^)(UITextFieldViewMode clearButtonMode))textField_clearButtonMode;
- (XHSSConfigManager*(^)(UIView *leftView))textField_leftView;
- (XHSSConfigManager*(^)(UITextFieldViewMode leftViewMode))textField_leftViewMode;
- (XHSSConfigManager*(^)(UIView *rightView))textField_rightView;
- (XHSSConfigManager*(^)(UITextFieldViewMode rightViewMode))textField_rightViewMode;
- (XHSSConfigManager*(^)(UIView *inputView))textField_inputView;
- (XHSSConfigManager*(^)(UIView *inputAccessoryView))textField_inputAccessoryView;
- (XHSSConfigManager*(^)(BOOL clearsOnInsertion))textField_clearsOnInsertion;

#pragma mark - shareConfigManager
+ (instancetype)shareConfigManager;

@end



#pragma mark - =========== LayoutManager ===========
// =============================================
//      LayoutManager
// =============================================
@interface XHSSLayoutManager : NSObject

+ (instancetype)shareLayoutManager;

@end

