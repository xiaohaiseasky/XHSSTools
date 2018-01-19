//
//  XHSSUIManager.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/11/29.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSUIManager.h"

@implementation XHSSUIManager

@end

// =============================================
//      ConfigManager
// =============================================
static XHSSConfigManager *configManager;
@implementation XHSSConfigManager

+ (instancetype)shareConfigManager {
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        configManager = [[XHSSConfigManager alloc] init];
    });
    return configManager;
}

#pragma mark - setter & getter
- (void)setTargetView:(UIView *)targetView {
    _targetView = targetView;
    if ([targetView isKindOfClass:[UILabel class]]) {
        self.label = (UILabel*)targetView;
    } else if ([targetView isKindOfClass:[UIButton class]]) {
        self.button = (UIButton*)targetView;
    } else if ([targetView isKindOfClass:[UIImageView class]]) {
        self.imageView = (UIImageView*)targetView;
    } else if ([targetView isKindOfClass:[UISlider class]]) {
        self.slider = (UISlider*)targetView;
    } else if ([targetView isKindOfClass:[UITextField class]]) {
        self.textField = (UITextField*)targetView;
    }
}

#pragma mark - UIView
// UIView
// *** normal ***
- (XHSSConfigManager*(^)(BOOL userInteractionEnabled))userInteractionEnabled {
    return ^(BOOL userInteractionEnabled) {
        self.targetView.userInteractionEnabled = userInteractionEnabled;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSInteger tag))tag {
    return ^(NSInteger tag) {
        self.targetView.tag = tag;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CALayer *layer))layer {
    return ^(CALayer *layer) {
//        self.targetView.layer = layer;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL clipsToBounds))clipsToBounds {
    return ^(BOOL clipsToBounds) {
        self.targetView.clipsToBounds = clipsToBounds;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *backgroundColor))backgroundColor {
    return ^(UIColor *backgroundColor) {
        self.targetView.backgroundColor = backgroundColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat alpha))alpha {
    return ^(CGFloat alpha) {
        self.targetView.alpha = alpha;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL opaque))opaque {
    return ^(BOOL opaque) {
        self.targetView.opaque = opaque;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL hidden))hidden {
    return ^(BOOL hidden) {
        self.targetView.hidden = hidden;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIViewContentMode contentMode))contentMode {
    return ^(UIViewContentMode contentMode) {
        self.targetView.contentMode = contentMode;
        return [XHSSConfigManager shareConfigManager];
    };
}

// *** border ***
- (XHSSConfigManager*(^)(UIColor *borderColor))borderColor {
    return ^(UIColor *borderColor) {
        self.targetView.layer.borderColor = borderColor.CGColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat borderWidth))borderWidth {
    return ^(CGFloat borderWidth) {
        self.targetView.layer.borderWidth = borderWidth;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat cornerRadius))cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.targetView.layer.cornerRadius = cornerRadius;
        return [XHSSConfigManager shareConfigManager];
    };
}

// *** shadow ***
- (XHSSConfigManager*(^)(UIColor *shadowColor))shadowColor {
    return ^(UIColor *shadowColor) {
        self.targetView.layer.shadowColor = shadowColor.CGColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(float shadowOpacity))shadowOpacity {
    return ^(float shadowOpacity) {
        self.targetView.layer.shadowOpacity = shadowOpacity;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGSize shadowOffset))shadowOffset {
    return ^(CGSize shadowOffset) {
        self.targetView.layer.shadowOffset = shadowOffset;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat shadowRadius))shadowRadius {
    return ^(CGFloat shadowRadius) {
        self.targetView.layer.shadowRadius = shadowRadius;
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(id target, SEL action))addTapGestureWithTargetAndAction {
    return ^(id target, SEL action) {
        self.targetView.userInteractionEnabled = YES;
        [self.targetView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:target action:action]];
        return [XHSSConfigManager shareConfigManager];
    };
}

#pragma mark - UILabel
// label
- (XHSSConfigManager*(^)(NSString *text))label_text {
    return ^(NSString *text) {
        self.label.text = text;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIFont *font))label_font {
    return ^(UIFont *font) {
        self.label.font = font;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *textColor))label_textColor {
    return ^(UIColor *textColor) {
        self.label.textColor = textColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *shadowColor))label_shadowColor {
    // at UIView
    return ^(UIColor *shadowColor) {
        self.label.shadowColor = shadowColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGSize shadowOffset))label_shadowOffset {
    // at UIView
    return ^(CGSize shadowOffset) {
        self.label.shadowOffset = shadowOffset;
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(NSTextAlignment textAlignment))label_textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.label.textAlignment = textAlignment;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSLineBreakMode lineBreakMode))label_lineBreakMode {
    return ^(NSLineBreakMode lineBreakMode) {
        self.label.lineBreakMode = lineBreakMode;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSAttributedString *attributedText))label_attributedText {
    return ^(NSAttributedString *attributedText) {
        self.label.attributedText = attributedText;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *highlightedTextColor))label_highlightedTextColor {
    return ^(UIColor *highlightedTextColor) {
        self.label.highlightedTextColor = highlightedTextColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL highlighted))label_highlighted {
    return ^(BOOL highlighted) {
        self.label.highlighted = highlighted;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL enabled))label_enabled {
    return ^(BOOL enabled) {
        self.label.enabled = enabled;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSInteger numberOfLines))label_numberOfLines {
    return ^(NSInteger numberOfLines) {
        self.label.numberOfLines = numberOfLines;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL adjustsFontSizeToFitWidth))label_adjustsFontSizeToFitWidth {
    return ^(BOOL adjustsFontSizeToFitWidth) {
        self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIBaselineAdjustment baselineAdjustment))label_baselineAdjustment {
    return ^(UIBaselineAdjustment baselineAdjustment) {
        self.label.baselineAdjustment = baselineAdjustment;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat minimumScaleFactor))label_minimumScaleFactor {
    return ^(CGFloat minimumScaleFactor) {
        self.label.minimumScaleFactor = minimumScaleFactor;
        return [XHSSConfigManager shareConfigManager];
    };
}

#pragma mark - UIButton
// button
- (XHSSConfigManager*(^)(UIEdgeInsets contentEdgeInsets))button_contentEdgeInsets {
    return ^(UIEdgeInsets contentEdgeInsets) {
        self.button.contentEdgeInsets = contentEdgeInsets;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIEdgeInsets titleEdgeInsets))button_titleEdgeInsets {
    return ^(UIEdgeInsets titleEdgeInsets) {
        self.button.titleEdgeInsets = titleEdgeInsets;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL reversesTitleShadowWhenHighlighted))button_reversesTitleShadowWhenHighlighted {
    return ^(BOOL reversesTitleShadowWhenHighlighted) {
        self.button.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIEdgeInsets imageEdgeInsets))button_imageEdgeInsets {
    return ^(UIEdgeInsets imageEdgeInsets) {
        self.button.imageEdgeInsets = imageEdgeInsets;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL adjustsImageWhenHighlighted))button_adjustsImageWhenHighlighted {
    return ^(BOOL adjustsImageWhenHighlighted) {
        self.button.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL adjustsImageWhenDisabled))button_adjustsImageWhenDisabled {
    return ^(BOOL adjustsImageWhenDisabled) {
        self.button.adjustsImageWhenDisabled = adjustsImageWhenDisabled;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL showsTouchWhenHighlighted))button_showsTouchWhenHighlighted {
    return ^(BOOL showsTouchWhenHighlighted) {
        self.button.showsTouchWhenHighlighted = showsTouchWhenHighlighted;
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(UIColor *tintColor))button_tintColor {
    return ^(UIColor *tintColor) {
        self.button.tintColor = tintColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
// title
- (XHSSConfigManager*(^)(NSString *title, UIControlState state))button_titleForState {
    return ^(NSString *title, UIControlState state) {
        [self.button setTitle:title forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *color, UIControlState state))button_titleColorForState {
    return ^(UIColor *color, UIControlState state) {
        [self.button setTitleColor:color forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *color, UIControlState state))button_titleShadowColorForState {
    return ^(UIColor *color, UIControlState state) {
        [self.button setTitleShadowColor:color forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSAttributedString *title, UIControlState state))button_AttributedTitleForState {
    return ^(NSAttributedString *title, UIControlState state) {
        [self.button setAttributedTitle:title forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
// image
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))button_imageForState {
    return ^(UIImage *image, UIControlState state) {
        [self.button setImage:image forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))button_backgroundImageForState {
    return ^(UIImage *image, UIControlState state) {
        [self.button setBackgroundImage:image forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(id target, SEL action, UIControlEvents event))button_addActionForTargetWithEvent {
    return ^(id target, SEL action, UIControlEvents event) {
        [self.button addTarget:target action:action forControlEvents:event];
        return [XHSSConfigManager shareConfigManager];
    };
}

#pragma mark - UIImageView
// imageView
- (XHSSConfigManager*(^)(UIImage *image))imageView_image {
    return ^(UIImage *image) {
        self.imageView.image = image;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *highlightedImage))imageView_highlightedImage {
    return ^(UIImage *highlightedImage) {
        self.imageView.highlightedImage = highlightedImage;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL userInteractionEnabled))imageView_userInteractionEnabled {
    // at UIView
    return ^(BOOL userInteractionEnabled) {
        self.imageView.userInteractionEnabled = userInteractionEnabled;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL highlighted))imageView_highlighted {
    return ^(BOOL highlighted) {
        self.imageView.highlighted = highlighted;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSArray<UIImage *> *animationImages))imageView_animationImages {
    return ^(NSArray<UIImage *> *animationImages) {
        self.imageView.animationImages = animationImages;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSArray<UIImage *> *highlightedAnimationImages))imageView_highlightedAnimationImages {
    return ^(NSArray<UIImage *> *highlightedAnimationImages) {
        self.imageView.highlightedAnimationImages = highlightedAnimationImages;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSTimeInterval animationDuration))imageView_animationDuration {
    return ^(NSTimeInterval animationDuration) {
        self.imageView.animationDuration = animationDuration;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSInteger animationRepeatCount))imageView_animationRepeatCount {
    return ^(NSInteger animationRepeatCount) {
        self.imageView.animationRepeatCount = animationRepeatCount;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *tintColor))imageView_tintColor {
    return ^(UIColor *tintColor) {
        self.imageView.tintColor = tintColor;
        return [XHSSConfigManager shareConfigManager];
    };
}

#pragma mark - UISlider
// slider
- (XHSSConfigManager*(^)(float value))slider_value {
    return ^(float value) {
        self.slider.value = value;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(float minimumValue))slider_minimumValue {
    return ^(float minimumValue) {
        self.slider.minimumValue = minimumValue;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(float maximumValue))slider_maximumValue {
    return ^(float maximumValue) {
        self.slider.maximumValue = maximumValue;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *minimumValueImage))slider_minimumValueImage {
    return ^(UIImage *minimumValueImage) {
        self.slider.minimumValueImage = minimumValueImage;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *maximumValueImage))slider_maximumValueImage {
    return ^(UIImage *maximumValueImage) {
        self.slider.maximumValueImage = maximumValueImage;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL continuous))slider_continuous {
    return ^(BOOL continuous) {
        self.slider.continuous = continuous;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *minimumTrackTintColor))slider_minimumTrackTintColor {
    return ^(UIColor *minimumTrackTintColor) {
        self.slider.minimumTrackTintColor = minimumTrackTintColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *maximumTrackTintColor))slider_maximumTrackTintColor {
    return ^(UIColor *maximumTrackTintColor) {
        self.slider.maximumTrackTintColor = maximumTrackTintColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *thumbTintColor))slider_thumbTintColor {
    return ^(UIColor *thumbTintColor) {
        self.slider.thumbTintColor = thumbTintColor;
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_thumbImageForState {
    return ^(UIImage *image, UIControlState state) {
        [self.slider setThumbImage:image forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_minimumTrackImageForState {
    return ^(UIImage *image, UIControlState state) {
        [self.slider setMinimumTrackImage:image forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *image, UIControlState state))slider_maximumTrackImageForState {
    return ^(UIImage *image, UIControlState state) {
        [self.slider setMaximumTrackImage:image forState:state];
        return [XHSSConfigManager shareConfigManager];
    };
}

- (XHSSConfigManager*(^)(id target, SEL action, UIControlEvents event))slider_addActionForTargetWithEvent {
    return ^(id target, SEL action, UIControlEvents event) {
        [self.slider addTarget:target action:action forControlEvents:event];
        return [XHSSConfigManager shareConfigManager];
    };
}

#pragma mark - UITextField
// UITextField
- (XHSSConfigManager*(^)(NSString *text))textField_text {
    return ^(NSString *text) {
        self.textField.text = text;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSAttributedString *attributedText))textField_attributedText {
    return ^(NSAttributedString *attributedText) {
        self.textField.attributedText = attributedText;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIColor *textColor))textField_textColor {
    return ^(UIColor *textColor) {
        self.textField.textColor = textColor;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIFont *font))textField_font {
    return ^(UIFont *font) {
        self.textField.font = font;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSTextAlignment textAlignment))textField_textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.textField.textAlignment = textAlignment;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UITextBorderStyle borderStyle))textField_borderStyle {
    return ^(UITextBorderStyle borderStyle) {
        self.textField.borderStyle = borderStyle;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSDictionary<NSString *, id> *defaultTextAttributes))textField_defaultTextAttributes {
    return ^(NSDictionary<NSString *, id> *defaultTextAttributes) {
        self.textField.defaultTextAttributes = defaultTextAttributes;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSString *placeholder))textField_placeholder {
    return ^(NSString *placeholder) {
        self.textField.placeholder = placeholder;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSAttributedString *attributedPlaceholder))textField_attributedPlaceholder {
    return ^(NSAttributedString *attributedPlaceholder) {
        self.textField.attributedPlaceholder = attributedPlaceholder;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL clearsOnBeginEditing))textField_clearsOnBeginEditing {
    return ^(BOOL clearsOnBeginEditing) {
        self.textField.clearsOnBeginEditing = clearsOnBeginEditing;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL adjustsFontSizeToFitWidth))textField_adjustsFontSizeToFitWidth {
    return ^(BOOL adjustsFontSizeToFitWidth) {
        self.textField.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(CGFloat minimumFontSize))textField_minimumFontSize {
    return ^(CGFloat minimumFontSize) {
        self.textField.minimumFontSize = minimumFontSize;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(id<UITextFieldDelegate> delegate))textField_delegate {
    return ^(id<UITextFieldDelegate> delegate) {
        self.textField.delegate = delegate;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *background))textField_background {
    return ^(UIImage *background) {
        self.textField.background = background;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIImage *disabledBackground))textField_disabledBackground {
    return ^(UIImage *disabledBackground) {
        self.textField.disabledBackground = disabledBackground;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL allowsEditingTextAttributes))textField_allowsEditingTextAttributes {
    return ^(BOOL allowsEditingTextAttributes) {
        self.textField.allowsEditingTextAttributes = allowsEditingTextAttributes;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(NSDictionary<NSString *, id> *typingAttributes))textField_typingAttributes {
    return ^(NSDictionary<NSString *, id> *typingAttributes) {
        self.textField.typingAttributes = typingAttributes;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UITextFieldViewMode clearButtonMode))textField_clearButtonMode {
    return ^(UITextFieldViewMode clearButtonMode) {
        self.textField.clearButtonMode = clearButtonMode;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIView *leftView))textField_leftView {
    return ^(UIView *leftView) {
        self.textField.leftView = leftView;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UITextFieldViewMode leftViewMode))textField_leftViewMode {
    return ^(UITextFieldViewMode leftViewMode) {
        self.textField.leftViewMode = leftViewMode;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIView *rightView))textField_rightView {
    return ^(UIView *rightView) {
        self.textField.rightView = rightView;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UITextFieldViewMode rightViewMode))textField_rightViewMode {
    return ^(UITextFieldViewMode rightViewMode) {
        self.textField.rightViewMode = rightViewMode;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIView *inputView))textField_inputView {
    return ^(UIView *inputView) {
        self.textField.inputView = inputView;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(UIView *inputAccessoryView))textField_inputAccessoryView {
    return ^(UIView *inputAccessoryView) {
        self.textField.inputAccessoryView = inputAccessoryView;
        return [XHSSConfigManager shareConfigManager];
    };
}
- (XHSSConfigManager*(^)(BOOL clearsOnInsertion))textField_clearsOnInsertion {
    return ^(BOOL clearsOnInsertion) {
        self.textField.clearsOnInsertion = clearsOnInsertion;
        return [XHSSConfigManager shareConfigManager];
    };
}

@end




// =============================================
//      LayoutManager
// =============================================
static XHSSLayoutManager *layoutManager;
@implementation XHSSLayoutManager

+ (instancetype)shareLayoutManager {
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        layoutManager = [[XHSSLayoutManager alloc] init];
    });
    return layoutManager;
}

@end
