//
//  UIView+XHSSShadowMask.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/20.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSSShadowView.h"

@interface UIView (XHSSShadowMask)

@property (nonatomic, strong) XHSSShadowView *shadowView;

// background area
@property (nonatomic, strong) UIColor *backgroundColor;

// center area
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGFloat innerRectRadius;
@property (nonatomic, assign) CGFloat outterRectRadius;
@property (nonatomic, strong) id content;

@property (nonatomic,assign) XHSSDrawGradientDirection gradientDirection;
@property (nonatomic, strong) NSArray<UIColor*> *gradientColors;

@property (nonatomic, assign) CGPoint linearGradientStartPoint;
@property (nonatomic, assign) CGPoint linearGradientEndPoint;

@property (nonatomic, assign) CGPoint radialGradientStartCenterPoint;
@property (nonatomic, assign) CGFloat radialGradientStartRadius;
@property (nonatomic, assign) CGPoint radialGradientEndCenterPoint;
@property (nonatomic, assign) CGFloat radialGradientEndRadius;

// mask area
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) UIEdgeInsets innerEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets outterEdgeInsets;

// shadow area
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;

@end
