//
//  XHSSUIFactory.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/5.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+XHSSFrameTool.h"
#import "UIView+XHSSLayoutTool.h"
#import "UIView+XHSSUIManagerTool.h"
#import "XHSSUIManager.h"

@interface XHSSUIFactory : NSObject

// target view to config
//@property (nonatomic, strong) UIView *configTargetView;

#pragma mark - singletone
//+ (instancetype)shareUIFactory;

//////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIView
// UIView
+ (instancetype)viewBySubClass:(NSString*)subClassName;
+ (UIView*)view;

+ (XHSSConfigBlock)viewConfigBlockWithCornerRadius:(CGFloat)cornerRadius;

#pragma mark - UILabel
// label
+ (UILabel*)label;

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment;

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                                 lineNumber:(NSInteger)lineNumber;

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(UIColor*)borderColor
                                borderWidth:(CGFloat)borderWidth;

+ (XHSSConfigBlock)labelConfigBlockWithFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                               textAligment:(NSTextAlignment)textAligment
                               cornerRadius:(CGFloat)cornerRadius
                                borderColor:(UIColor*)borderColor
                                borderWidth:(CGFloat)borderWidth
                                     target:(id)target
                                     action:(SEL)action;

#pragma mark - UIButton
// button
+ (UIButton*)buttonWithCustomStyle;
+ (UIButton*)buttonWithType:(UIButtonType)type;

+ (XHSSConfigBlock)buttonConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                       state:(UIControlState)state;

+ (XHSSConfigBlock)buttonConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                       state:(UIControlState)state
                                      target:(id)target
                                   tapAction:(SEL)action
                                       event:(UIControlEvents)event;

#pragma mark - UIImageView
// imageView
+ (UIImageView*)imageView;

+ (XHSSConfigBlock)imageViewConfigBlockWithTarget:(id)target
                                     tapAction:(SEL)action;

+ (XHSSConfigBlock)imageViewConfigBlockWithTarget:(id)target
                                     tapAction:(SEL)action
                                            image:(UIImage*)image;

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius;

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                               image:(UIImage*)image;

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                         borderWidth:(CGFloat)borderWidth
                                         borderColor:(UIColor*)borderColor;

+ (XHSSConfigBlock)imageViewConfigBlockWithCornerRadius:(CGFloat)cornerRadius
                                              target:(id)target
                                           tapAction:(SEL)action;

#pragma mark - UISlider
// slider
+ (UISlider*)slider;

+ (XHSSConfigBlock)sliderConfigBlockWithMinValue:(CGFloat)minValue
                                        maxValue:(CGFloat)maxValue
                                           value:(CGFloat)value
                                      isContinue:(BOOL)isContinue;

#pragma mark - UITextField
// UITextField
+ (UITextField*)textfield;

+ (XHSSConfigBlock)textFieldConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                textAligment:(NSTextAlignment)textAligment;

+ (XHSSConfigBlock)textFieldConfigBlockWithFont:(UIFont*)font
                                   textColor:(UIColor*)textColor
                                textAligment:(NSTextAlignment)textAligment
                                 placeHolder:(NSString*)placeHolder;

@end
