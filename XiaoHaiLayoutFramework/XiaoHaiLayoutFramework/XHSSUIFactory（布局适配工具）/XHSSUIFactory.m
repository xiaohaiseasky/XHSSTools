//
//  XHSSUIFactory.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/5.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSUIFactory.h"

static XHSSUIFactory *uiFactory;

@implementation XHSSUIFactory

#pragma mark - gingletone
+ (instancetype)shareUIFactory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiFactory = [[XHSSUIFactory alloc] init];
    });
    return uiFactory;
}

#pragma mark - UIView
// UIView
+ (instancetype)viewBySubClass:(NSString*)subClassName {
    return [[NSClassFromString(subClassName) alloc] init];
}
+ (UIView*)view {
    return [[UIView alloc] init];
}

+ (XHSSConfigBlock)viewConfigBlockWithCornerRadius:(CGFloat)cornerRadius {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.cornerRadius(cornerRadius);
    };
}

#pragma mark - UILabel
// label
+ (UILabel*)label {
    return [[UILabel alloc] init];
}

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.label_font(font);
        layoutView.label_textColor(textColor);
        layoutView.label_textAlignment(textAligment);
    };
}

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                                 lineNumber:(NSInteger)lineNumber {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.label_font(font);
        layoutView.label_textColor(textColor);
        layoutView.label_textAlignment(textAligment);
        layoutView.label_numberOfLines(lineNumber);
    };
}

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(UIColor*)borderColor
                                borderWidth:(CGFloat)borderWidth {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.label_font(font);
        layoutView.label_textColor(textColor);
        layoutView.label_textAlignment(textAligment);
        layoutView.cornerRadius(cornerRadius);
        layoutView.borderColor(borderColor);
        layoutView.borderWidth(borderWidth);
    };
}

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(UIColor*)borderColor
                                borderWidth:(CGFloat)borderWidth
                                     target:(id)target
                                     action:(SEL)action {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.label_font(font);
        layoutView.label_textColor(textColor);
        layoutView.label_textAlignment(textAligment);
        layoutView.cornerRadius(cornerRadius);
        layoutView.borderColor(borderColor);
        layoutView.borderWidth(borderWidth);
        layoutView.addTapGestureWithTargetAndAction(target, action);
    };
}

#pragma mark - UIButton
// button
+ (UIButton*)buttonWithCustomStyle {
    return [UIButton buttonWithType:UIButtonTypeCustom];
}
+ (UIButton*)buttonWithType:(UIButtonType)type {
    return [UIButton buttonWithType:type];
}

+ (XHSSConfigBlock)buttonConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                       state:(UIControlState)state {
    return ^(XHSSConfigManager *layoutView) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:@""
                                              attributes:@{NSForegroundColorAttributeName: textColor,
                                                           NSFontAttributeName: font}];
        layoutView.button_AttributedTitleForState(attrStr, state);
    };
}

+ (XHSSConfigBlock)buttonConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                       state:(UIControlState)state
                                      target:(id)target
                                   tapAction:(SEL)action
                                       event:(UIControlEvents)event {
    return ^(XHSSConfigManager *layoutView) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:@""
                                              attributes:@{NSForegroundColorAttributeName: textColor,
                                                           NSFontAttributeName: font}];
        layoutView.button_AttributedTitleForState(attrStr, state);
        layoutView.button_addActionForTargetWithEvent(target, action, event);
    };
}

#pragma mark - UIImageView
// imageView
+ (UIImageView*)imageView {
    return [[UIImageView alloc] init];
}

+ (XHSSConfigBlock)imageViewConfigBlockWithTarget:(id)target
                                        tapAction:(SEL)action {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.addTapGestureWithTargetAndAction(target, action);
    };
}

+ (XHSSConfigBlock)imageViewConfigBlockWithTarget:(id)target
                                        tapAction:(SEL)action
                                            image:(UIImage*)image {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.addTapGestureWithTargetAndAction(target, action);
        layoutView.imageView_image(image);
    };
}

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.cornerRadius(cornerRadius);
    };
}

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                                  image:(UIImage*)image {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.cornerRadius(cornerRadius);
        layoutView.imageView_image(image);
    };
}

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                            borderWidth:(CGFloat)borderWidth
                                            borderColor:(UIColor*)borderColor {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.cornerRadius(cornerRadius);
        layoutView.borderColor(borderColor);
        layoutView.borderWidth(borderWidth);
    };
}

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                                 target:(id)target
                                              tapAction:(SEL)action {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.cornerRadius(cornerRadius);
        layoutView.addTapGestureWithTargetAndAction(target, action);
    };
}

#pragma mark - UISlider
// slider
+ (UISlider*)slider {
    return [[UISlider alloc] init];
}

+ (XHSSConfigBlock)sliderConfigBlockWithMinValue:(CGFloat)minValue
                                        maxValue:(CGFloat)maxValue
                                           value:(CGFloat)value
                                      isContinue:(BOOL)isContinue {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.slider_minimumValue(minValue);
        layoutView.slider_maximumValue(maxValue);
        layoutView.slider_value(value);
        layoutView.slider_continuous(isContinue);
    };
}

#pragma mark - UITextField
// UITextField
+ (UITextField*)textfield {
    return [[UITextField alloc] init];
}

+ (XHSSConfigBlock)textFieldConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                textAligment:(NSTextAlignment)textAligment {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.textField_font(font);
        layoutView.textField_textColor(textColor);
        layoutView.textField_textAlignment(textAligment);
    };
}

+ (XHSSConfigBlock)textFieldConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                textAligment:(NSTextAlignment)textAligment
                                 placeHolder:(NSString*)placeHolder {
    return ^(XHSSConfigManager *layoutView) {
        layoutView.textField_font(font);
        layoutView.textField_textColor(textColor);
        layoutView.textField_textAlignment(textAligment);
        layoutView.textField_placeholder(placeHolder);
    };
}

@end
