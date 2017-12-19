//
//  XHSSDoubleControlSlider.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/10/30.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSDoubleControlSlider : UIView

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat leftValue;
@property (nonatomic, assign) CGFloat rightValue;

@property (nonatomic, copy) void(^valueChangeCallback)(CGFloat leftValue, CGFloat rightValue);
@property (nonatomic, copy) void(^leftValueChangeCallback)(CGFloat leftValue);
@property (nonatomic, copy) void(^rightValueChangeCallback)(CGFloat rightValue);

- (void)addTarget:(id)target action:(SEL)action;

@end
