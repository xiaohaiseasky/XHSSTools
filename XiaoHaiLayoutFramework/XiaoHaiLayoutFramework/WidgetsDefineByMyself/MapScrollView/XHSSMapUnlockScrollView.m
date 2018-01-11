//
//  XHSSMapUnlockScrollView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/10.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSMapUnlockScrollView.h"
#import "XHSSMapUnLockView.h"

@interface XHSSMapUnlockScrollView ()

@property (nonatomic, strong) XHSSMapUnLockView *mapView;

@end

@implementation XHSSMapUnlockScrollView

#pragma mark - setter & getter
- (NSMutableArray*)pathArr {
    if (_pathArr == nil) {
        _pathArr = [NSMutableArray array];
    }
    return _pathArr;
}

- (NSMutableArray<UIImage*>*)iconArr {
    if (_iconArr == nil) {
        _iconArr = [NSMutableArray array];
    }
    return _iconArr;
}

/////////////////////////////////////////////////////
- (void)setCurrentPosition:(CGPoint)currentPosition {
    _currentPosition = currentPosition;
    self.mapView.currentPosition = _currentPosition;
}

- (void)setCurrentPositionIcon:(UIImage *)currentPositionIcon {
    _currentPositionIcon = currentPositionIcon;
    self.mapView.currentPositionIcon = _currentPositionIcon;
}

- (void)setCurrentPositionIconSize:(CGSize)currentPositionIconSize {
    _currentPositionIconSize = currentPositionIconSize;
    self.mapView.currentPositionIconSize = _currentPositionIconSize;
}

- (void)setCurrentPositionIconYOffset:(CGFloat)currentPositionIconYOffset {
    _currentPositionIconYOffset = currentPositionIconYOffset;
    self.mapView.currentPositionIconYOffset = _currentPositionIconYOffset;
}

- (void)setFinishPercentText:(NSString *)finishPercentText {
    _finishPercentText = finishPercentText;
    self.mapView.finishPercentText = _finishPercentText;
}

- (void)setFinishPercentTextAreaSize:(CGSize)finishPercentTextAreaSize {
    _finishPercentTextAreaSize = finishPercentTextAreaSize;
    self.mapView.finishPercentTextAreaSize = _finishPercentTextAreaSize;
}

- (void)setFinishPercentTextAreaYOffset:(CGFloat)finishPercentTextAreaYOffset {
    _finishPercentTextAreaYOffset = finishPercentTextAreaYOffset;
    self.mapView.finishPercentTextAreaYOffset = _finishPercentTextAreaYOffset;
}

/////////////////////////////////////////////////////

- (void)setBgImage:(UIImage *)bgImage {
    _bgImage = bgImage;
    self.mapView.bgImage = _bgImage;
}

- (void)setIconSize:(CGSize)iconSize {
    _iconSize = iconSize;
    self.mapView.iconSize = _iconSize;
}

- (void)setRoadLineWidth:(CGFloat)roadLineWidth {
    _roadLineWidth = roadLineWidth;
    self.mapView.roadLineWidth = _roadLineWidth;
}

- (void)setRoadLineColor:(UIColor *)roadLineColor {
    _roadLineColor = roadLineColor;
    self.mapView.roadLineColor = _roadLineColor;
}

- (void)setDashLineWidth:(CGFloat)dashLineWidth {
    _dashLineWidth = dashLineWidth;
    self.mapView.dashLineWidth = _dashLineWidth;
}

- (void)setDashLineColor:(UIColor *)dashLineColor {
    _dashLineColor = dashLineColor;
    self.mapView.dashLineColor = _dashLineColor;
}

- (void)setDashLineEntityLength:(CGFloat)dashLineEntityLength {
    _dashLineEntityLength = dashLineEntityLength;
    self.mapView.dashLineEntityLength = _dashLineEntityLength;
}

- (void)setDashLineEmptyLength:(CGFloat)dashLineEmptyLength {
    _dashLineEmptyLength = dashLineEmptyLength;
    self.mapView.dashLineEmptyLength = _dashLineEmptyLength;
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.mapView = [[XHSSMapUnLockView alloc] init];
    self.mapView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:self.mapView];
}

- (void)layoutSubviews {
    self.mapView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
}

#pragma mark - path
- (void)addNextStep:(CGPoint)stepPoint {
    [self.pathArr addObject:@(stepPoint)];
}

- (void)addNextStepIcon:(UIImage*)icon {
    [self.iconArr addObject:icon];
}

- (void)addNextStep:(CGPoint)stepPoint withIcon:(UIImage*)icon {
    [self.pathArr addObject:@(stepPoint)];
    [self.iconArr addObject:icon];
}

- (void)refreshPath {
    [self setNeedsDisplay];
    
    self.mapView.pathArr = self.pathArr;
    self.mapView.iconArr = self.iconArr;
}

@end
