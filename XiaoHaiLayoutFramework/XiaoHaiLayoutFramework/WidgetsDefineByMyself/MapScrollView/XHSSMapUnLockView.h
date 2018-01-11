//
//  XHSSMapUnLockView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/10.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSMapUnLockView : UIView

@property (nonatomic, strong) UIImage *bgImage;

@property (nonatomic, assign) CGPoint currentPosition;              // 当前位置坐标
@property (nonatomic, strong) UIImage *currentPositionIcon;         // 当前位置图标
@property (nonatomic, assign) CGSize currentPositionIconSize;       // 当前位置图标尺寸
@property (nonatomic, assign) CGFloat currentPositionIconYOffset;   // 当前位置图标Y轴偏移量

@property (nonatomic, strong) NSString *finishPercentBaseText;
@property (nonatomic, strong) NSString *finishPercentText;          // 当前位置信息
@property (nonatomic, assign) CGFloat finishPercentTextYOffset;     // 当前位置信息文本绘制距离背景区域顶部偏移量
@property (nonatomic, assign) CGSize finishPercentTextAreaSize;     // 当前位置信息绘制区域尺寸
@property (nonatomic, assign) CGFloat finishPercentTextAreaYOffset;  // 当前位置信息绘制区域尺寸Y轴偏移量

@property (nonatomic, strong) UIFont *normalTextFont;
@property (nonatomic, strong) UIFont *higlightTextFont;
@property (nonatomic, strong) UIColor *normalTextColor;
@property (nonatomic, strong) UIColor *higlightTextColor;

@property (nonatomic, strong) NSMutableArray *pathArr;
@property (nonatomic, strong) NSMutableArray<UIImage*> *iconArr;

@property (nonatomic, assign) CGSize iconSize;

@property (nonatomic, assign) CGFloat roadLineWidth;
@property (nonatomic, strong) UIColor *roadLineColor;

@property (nonatomic, assign) CGFloat dashLineWidth;
@property (nonatomic, assign) CGFloat dashLineEntityLength;
@property (nonatomic, assign) CGFloat dashLineEmptyLength;
@property (nonatomic, strong) UIColor *dashLineColor;

@end
