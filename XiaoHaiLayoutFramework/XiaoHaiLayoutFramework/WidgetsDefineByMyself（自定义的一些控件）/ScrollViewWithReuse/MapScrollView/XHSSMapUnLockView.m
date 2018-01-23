//
//  XHSSMapUnLockView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2018/1/10.
//  Copyright © 2018年 XiaoHai. All rights reserved.
//

#import "XHSSMapUnLockView.h"

@interface XHSSMapUnLockView ()

@property (nonatomic, strong) NSMutableAttributedString *attrStr;

@end

@implementation XHSSMapUnLockView

- (void)setPathArr:(NSMutableArray *)pathArr {
    _pathArr = pathArr;
    
    [self setNeedsDisplay];
}

- (void)setIconArr:(NSMutableArray<UIImage*> *)iconArr {
    _iconArr = iconArr;
    
    [self setNeedsDisplay];
}

- (void)setFinishPercentText:(NSString *)finishPercentText {
    _finishPercentText = finishPercentText;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 0;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.maximumLineHeight = self.finishPercentTextAreaSize.height/2.0;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *str = [self.finishPercentBaseText stringByAppendingString:_finishPercentText ? _finishPercentText : @""];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                                attributes:@{NSFontAttributeName: self.higlightTextFont,
                                                                                             NSForegroundColorAttributeName: self.higlightTextColor,
                                                                                             NSParagraphStyleAttributeName: paragraphStyle}];
    [attrStr addAttributes:@{NSFontAttributeName: self.normalTextFont,
                             NSForegroundColorAttributeName: self.normalTextColor}
                     range:[str rangeOfString:self.finishPercentBaseText]];
    
    _attrStr = attrStr;
}

#pragma mark - UI
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupData];
    [self setupUI];
}

- (void)setupData {
    self.currentPosition = CGPointMake(300, 500);
    self.currentPositionIconSize = CGSizeMake(50, 100);
    self.currentPositionIconYOffset = 20;
    
    self.finishPercentTextAreaSize = CGSizeMake(100, 50);
    self.finishPercentTextAreaYOffset = 10;
    self.normalTextFont = [UIFont systemFontOfSize:14];
    self.higlightTextFont = [UIFont systemFontOfSize:14];
    self.normalTextColor = [UIColor whiteColor];
    self.higlightTextColor = [UIColor orangeColor];
    
    self.finishPercentTextYOffset = 7;
    
    self.finishPercentBaseText = @"距离下一站 已完成";
    self.finishPercentText = @"40%";
    
    self.roadLineWidth = 20;
    self.roadLineColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.iconSize = CGSizeMake(self.roadLineWidth*1.5, self.roadLineWidth*1.5);
    
    self.dashLineWidth = 2;
    self.dashLineEntityLength = 7;
    self.dashLineEmptyLength = 7;
    self.dashLineColor = [UIColor colorWithWhite:1 alpha:0.7];
}

- (void)setupUI {
    self.backgroundColor = [UIColor cyanColor];
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(currentContext, [UIColor redColor].CGColor);
    CGContextFillRect(currentContext, self.bounds);
    
    /// *** background image ***
    CGContextSaveGState(currentContext);
    if (self.bgImage) {
        [self.bgImage drawInRect:self.bounds];
    }
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** road line ***
    CGContextSaveGState(currentContext);
    // color
    CGContextSetStrokeColorWithColor(currentContext, self.roadLineColor.CGColor);
    // line
    CGContextSetLineWidth(currentContext, self.roadLineWidth);
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGContextSetLineJoin(currentContext, kCGLineJoinRound);
    [self.pathArr enumerateObjectsUsingBlock:^(id  _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint currentPoint = [point CGPointValue];
        if (idx == 0) {
            CGContextMoveToPoint(currentContext, currentPoint.x, currentPoint.y);
        } else {
            CGContextAddLineToPoint(currentContext, currentPoint.x, currentPoint.y);
        }
    }];
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** dash line ***
    CGContextSaveGState(currentContext);
    // color
    CGContextSetStrokeColorWithColor(currentContext, self.dashLineColor.CGColor);
    // line
    CGContextSetLineWidth(currentContext, self.dashLineWidth);
    CGContextSetLineCap(currentContext, kCGLineCapSquare);
    CGFloat length[] = {self.dashLineEntityLength, self.dashLineEmptyLength};
    CGContextSetLineDash(currentContext, 0, length, 2);
    [self.pathArr enumerateObjectsUsingBlock:^(id  _Nonnull point, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint currentPoint = [point CGPointValue];
        if (idx == 0) {
            CGContextMoveToPoint(currentContext, currentPoint.x, currentPoint.y);
        } else {
            CGContextAddLineToPoint(currentContext, currentPoint.x, currentPoint.y);
        }
    }];
    CGContextStrokePath(currentContext);
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** road icon ***
    CGContextSaveGState(currentContext);
    __weak typeof(self) weakSelf = self;
    [self.iconArr enumerateObjectsUsingBlock:^(UIImage * _Nonnull icon, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < weakSelf.pathArr.count) {
            [icon drawInRect:CGRectMake([weakSelf.pathArr[idx] CGPointValue].x -self.iconSize.width/2.0,
                                        [weakSelf.pathArr[idx] CGPointValue].y -self.iconSize.height/2.0,
                                        self.iconSize.width,
                                        self.iconSize.height)];
        }
    }];
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** current position shadow ***
    CGContextSaveGState(currentContext);
    CGContextAddArc(currentContext, self.currentPosition.x, self.currentPosition.y, 10, 0, M_PI*2, YES);
    CGContextSetFillColorWithColor(currentContext, [UIColor colorWithWhite:0 alpha:1].CGColor);
    CGContextSetFillColorWithColor(currentContext, [UIColor redColor].CGColor);
    CGContextFillPath(currentContext);
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** current position icon ***
    CGContextSaveGState(currentContext);
    if (self.currentPositionIcon) {
        [self.currentPositionIcon drawInRect:CGRectMake(self.currentPosition.x -self.currentPositionIconSize.width/2.0,
                                                        self.currentPosition.y -self.currentPositionIconSize.height -self.currentPositionIconYOffset,
                                                        self.currentPositionIconSize.width,
                                                        self.currentPositionIconSize.height)];
    }
    CGContextRestoreGState(currentContext);
    
    
    
    /// *** current position info ***
    // background
    CGContextSaveGState(currentContext);
    CGContextSetFillColorWithColor(currentContext, [UIColor colorWithWhite:0 alpha:0.7].CGColor);
    CGPoint starPoint = CGPointMake(self.currentPosition.x -self.finishPercentTextAreaSize.width/2.0,
                                    self.currentPosition.y -self.currentPositionIconYOffset -self.currentPositionIconSize.height -self.finishPercentTextAreaYOffset -self.finishPercentTextAreaSize.height);
    CGContextMoveToPoint(currentContext, starPoint.x, starPoint.y);
    CGContextAddLineToPoint(currentContext, starPoint.x +self.finishPercentTextAreaSize.width, starPoint.y);
    CGContextAddArc(currentContext,
                    starPoint.x +self.finishPercentTextAreaSize.width,
                    starPoint.y +self.finishPercentTextAreaSize.height/2.0,
                    self.finishPercentTextAreaSize.height/2.0,
                    M_PI/2.0,
                    M_PI/2.0*3,
                    YES);
    CGContextAddLineToPoint(currentContext,
                            starPoint.x +self.finishPercentTextAreaSize.width,
                            starPoint.y +self.finishPercentTextAreaSize.height);
    CGContextAddLineToPoint(currentContext,
                            starPoint.x/* +self.finishPercentTextAreaSize.width*/,
                            starPoint.y +self.finishPercentTextAreaSize.height);
    CGContextAddArc(currentContext,
                    starPoint.x,
                    starPoint.y +self.finishPercentTextAreaSize.height/2.0,
                    self.finishPercentTextAreaSize.height/2.0,
                    -M_PI/2.0,
                    M_PI/2.0,
                    YES);
    CGContextClosePath(currentContext);
    CGContextFillPath(currentContext);
    CGContextRestoreGState(currentContext);
    
    
    
    // text
    CGContextSaveGState(currentContext);
    if (self.attrStr) {
        CGFloat textOffset = self.finishPercentTextYOffset;
        [self.attrStr drawInRect:CGRectMake(starPoint.x,
                                       starPoint.y +textOffset,
                                       self.finishPercentTextAreaSize.width,
                                       self.finishPercentTextAreaSize.height -textOffset*2)];
    }
    CGContextRestoreGState(currentContext);
}

@end
