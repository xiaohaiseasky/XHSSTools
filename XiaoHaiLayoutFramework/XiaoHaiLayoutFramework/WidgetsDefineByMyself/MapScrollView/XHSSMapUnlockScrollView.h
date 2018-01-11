//
//  XHSSMapUnlockScrollView.h
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/10.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHSSMapUnlockScrollView : UIScrollView

@property (nonatomic, strong) UIImage *bgImage;                     // 背景地图图片

@property (nonatomic, assign) CGPoint currentPosition;              // 当前位置坐标
@property (nonatomic, strong) UIImage *currentPositionIcon;         // 当前位置图标
@property (nonatomic, assign) CGSize currentPositionIconSize;       // 当前位置图标尺寸
@property (nonatomic, assign) CGFloat currentPositionIconYOffset;   // 当前位置图标Y轴偏移量
@property (nonatomic, strong) NSString *finishPercentText;          // 当前位置信息
@property (nonatomic, assign) CGSize finishPercentTextAreaSize;     // 当前位置信息绘制区域尺寸
@property (nonatomic, assign) CGFloat finishPercentTextAreaYOffset;  // 当前位置信息绘制区域尺寸Y轴偏移量

@property (nonatomic, strong) NSMutableArray *pathArr;              // 路径数组
@property (nonatomic, strong) NSMutableArray<UIImage*> *iconArr;    // 路径中拐点处的图片icon数组

@property (nonatomic, assign) CGSize iconSize;                      // 路径中拐点处的图片icon的尺寸

@property (nonatomic, assign) CGFloat roadLineWidth;                // 路线宽度
@property (nonatomic, strong) UIColor *roadLineColor;               // 路线颜色

@property (nonatomic, assign) CGFloat dashLineWidth;                // 虚线宽度
@property (nonatomic, assign) CGFloat dashLineEntityLength;         // 虚线实体部分的宽度
@property (nonatomic, assign) CGFloat dashLineEmptyLength;          // 虚线空白部分的宽度
@property (nonatomic, strong) UIColor *dashLineColor;               // 虚线的颜色

- (void)addNextStep:(CGPoint)stepPoint;
- (void)addNextStepIcon:(UIImage*)icon;
- (void)addNextStep:(CGPoint)stepPoint withIcon:(UIImage*)icon;
- (void)refreshPath;

@end
