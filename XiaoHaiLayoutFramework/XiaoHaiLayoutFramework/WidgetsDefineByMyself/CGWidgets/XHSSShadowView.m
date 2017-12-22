//
//  XHSSShadowView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/19.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSShadowView.h"

@interface XHSSShadowView ()

@property (nonatomic, assign) CGRect innerRect;
@property (nonatomic, assign) CGRect outterRect;

@end

@implementation XHSSShadowView
#pragma mark - setter & getter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    _rect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    [self setNeedsDisplay];
}
- (void)setRect:(CGRect)rect {
    _rect = rect;
}
- (void)setInnerRectRadius:(CGFloat)innerRectRadius {
    _innerRectRadius = innerRectRadius;
    [self setNeedsDisplay];
}
- (void)setOutterRectRadius:(CGFloat)outterRectRadius {
    _outterRectRadius = outterRectRadius;
    [self setNeedsDisplay];
}
- (void)setContent:(id)content {
    _content = content;
    [self setNeedsDisplay];
}
- (void)setCleareCenter:(BOOL)cleareCenter {
    _cleareCenter = cleareCenter;
    [self setNeedsDisplay];
}
- (void)setGradientDirection:(XHSSDrawGradientDirection)gradientDirection {
    _gradientDirection = gradientDirection;
    [self setNeedsDisplay];
}
- (void)setGradientColors:(NSArray<UIColor *> *)gradientColors {
    _gradientColors = gradientColors;
    [self setNeedsDisplay];
}
- (void)setLinearGradientStartPoint:(CGPoint)linearGradientStartPoint {
    _linearGradientStartPoint = linearGradientStartPoint;
    [self setNeedsDisplay];
}
- (void)setLinearGradientEndPoint:(CGPoint)linearGradientEndPoint {
    _linearGradientEndPoint = linearGradientEndPoint;
    [self setNeedsDisplay];
}
- (void)setRadialGradientStartRadius:(CGFloat)radialGradientStartRadius {
    _radialGradientStartRadius = radialGradientStartRadius;
    [self setNeedsDisplay];
}
- (void)setRadialGradientEndRadius:(CGFloat)radialGradientEndRadius {
    _radialGradientEndRadius = radialGradientEndRadius;
    [self setNeedsDisplay];
}
- (void)setRadialGradientStartCenterPoint:(CGPoint)radialGradientStartCenterPoint {
    _radialGradientStartCenterPoint = radialGradientStartCenterPoint;
    [self setNeedsDisplay];
}
- (void)setRadialGradientEndCenterPoint:(CGPoint)radialGradientEndCenterPoint {
    _radialGradientEndCenterPoint = radialGradientEndCenterPoint;
    [self setNeedsDisplay];
}
- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    [self setNeedsDisplay];
}
- (void)setInnerEdgeInsets:(UIEdgeInsets)innerEdgeInsets {
    _innerEdgeInsets = innerEdgeInsets;
    [self refreshRect];
    [self refreshPointAndRadius];
    [self setNeedsDisplay];
}
- (void)setOutterEdgeInsets:(UIEdgeInsets)outterEdgeInsets {
    _outterEdgeInsets = outterEdgeInsets;
    [self refreshFrame];
    [self refreshRect];
    [self refreshPointAndRadius];
    [self setNeedsDisplay];
}
- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    [self setNeedsDisplay];
}
- (void)setShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    [self setNeedsDisplay];
}
- (void)setShadowBlur:(CGFloat)shadowBlur {
    _shadowBlur = shadowBlur;
    [self setNeedsDisplay];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        [self setupData];
    }
    return self;
}

- (void)setupData {
    
    /// *** background area ***
    
    /// *** center area ***
    self.rect = self.bounds;
    self.innerRectRadius = 0;
    self.outterRectRadius = 0;
    self.cleareCenter = NO;
    
    self.gradientDirection = XHSSDrawGradientDirectionNOne;

    /// *** mask area ***
    self.innerEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.outterEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    /// *** shadow area ***
    self.shadowOffset = CGSizeZero;
    self.shadowBlur = 17;
    
    [self refreshPointAndRadius];
}

- (void)refreshPointAndRadius {
    _linearGradientStartPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMinY(self.innerRect));
    _linearGradientEndPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMaxY(self.innerRect));
    
    _radialGradientStartCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));
    _radialGradientStartRadius = 0;
    _radialGradientEndCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));
    _radialGradientEndRadius = CGRectGetWidth(self.outterRect)/2.0f;
}

- (void)refreshRect {
    _innerRect = CGRectMake(CGRectGetMinX(_rect) -self.frame.origin.x +self.innerEdgeInsets.left,
                            CGRectGetMinY(_rect) -self.frame.origin.y +self.innerEdgeInsets.top,
                            self.rect.size.width -self.innerEdgeInsets.left -self.innerEdgeInsets.right,
                            self.rect.size.height -self.innerEdgeInsets.top -self.innerEdgeInsets.bottom);
    _outterRect = CGRectMake(CGRectGetMinX(_rect) -CGRectGetMinX(self.frame) -self.outterEdgeInsets.left,
                             CGRectGetMinY(_rect) -CGRectGetMinY(self.frame) -self.outterEdgeInsets.top,
                             _rect.size.width +self.outterEdgeInsets.left +self.outterEdgeInsets.right,
                             _rect.size.height +self.outterEdgeInsets.top +self.outterEdgeInsets.bottom);
}

- (void)refreshFrame {
    /// *** it is not deal with taht if edgeInsets components is a value smaller than zero ***
    self.frame = CGRectMake(CGRectGetMinX(_rect) -self.outterEdgeInsets.left,
                            CGRectGetMinY(_rect) -self.outterEdgeInsets.top,
                            _rect.size.width +self.outterEdgeInsets.left +self.outterEdgeInsets.right,
                            _rect.size.height +self.outterEdgeInsets.top +self.outterEdgeInsets.bottom);
}

#pragma mark - draw
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // *** background area ***
    if (self.backgroundColor) {
        CGContextSaveGState(currentContext);
        CGContextSetFillColorWithColor(currentContext, self.backgroundColor.CGColor);
        CGContextFillRect(currentContext, rect);
        CGContextRestoreGState(currentContext);
    }

    // *** mask area ***
    if (self.maskColor) {
        CGContextSaveGState(currentContext);
        UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:self.outterRect cornerRadius:self.outterRectRadius];
        CGContextAddPath(currentContext, outterPath.CGPath);
        UIBezierPath *innerPath = [UIBezierPath bezierPathWithRoundedRect:self.innerRect cornerRadius:self.innerRectRadius];
        CGContextAddPath(currentContext, innerPath.CGPath);
        CGContextSetFillColorWithColor(currentContext, self.maskColor.CGColor);
        CGContextDrawPath(currentContext, kCGPathEOFill);
        CGContextRestoreGState(currentContext);
    }

    // *** shadow area ***
    if (self.shadowColor) {
        CGContextSaveGState(currentContext);
        CGContextSetShadowWithColor(currentContext,
                                    self.shadowOffset,
                                    self.shadowBlur,
                                    self.shadowColor.CGColor);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.innerRect cornerRadius:self.innerRectRadius];
        CGContextAddPath(currentContext, path.CGPath);
        CGContextDrawPath(currentContext, kCGPathFill);
        CGContextRestoreGState(currentContext);
    }

    // *** center area ***
    CGContextSaveGState(currentContext);
    // ** clear center background color **
    if (self.content == nil && self.cleareCenter) {
        //CGContextClearRect(currentContext, self.innerRect);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.innerRect cornerRadius:self.innerRectRadius];
        [self clearInnerRect:currentContext withPath:path];
    }
    // ** set center background color **
    else if ([self.content isKindOfClass:[UIColor class]]) {
        CGContextSetFillColorWithColor(currentContext, [(UIColor*)self.content CGColor]);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.innerRect cornerRadius:self.innerRectRadius];
        CGContextAddPath(currentContext, path.CGPath);
        CGContextDrawPath(currentContext, kCGPathFill);
    }
    // ** set center background image **
    else if ([self.content isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage*)self.content;
        [image drawInRect:self.innerRect];
    }
    else {
        
    }
    CGContextRestoreGState(currentContext);

    // ** set center background gradient **
    if (self.gradientDirection != XHSSDrawGradientDirectionNOne) {
        CGContextSaveGState(currentContext);

        CGContextClipToRect(currentContext, self.innerRect);

        CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
        NSArray *colors = @[(__bridge id)[UIColor blueColor].CGColor, (__bridge id)[UIColor redColor].CGColor];
        colors = [self convertColorsIntoCGColorInArr:self.gradientColors];
        CGFloat locations[] = {0.0, 1.0};
        CGGradientRef gradient = CGGradientCreateWithColors(colorRef, (__bridge CFArrayRef)colors, locations);

        switch (self.gradientDirection) {
            // * no gradient *
            case XHSSDrawGradientDirectionNOne:{

            }
                break;
            // * LinearGradient *
            case XHSSDrawGradientDirectionLinear:{
                [self drawLinearGradientInContext:currentContext withGradient:gradient startPoint:self.linearGradientStartPoint endPoint:self.linearGradientEndPoint options:0];
            }
                break;
            case XHSSDrawGradientDirectionTopToBot:{
                [self drawLinearGradientInContext:currentContext withGradient:gradient startPoint:self.linearGradientStartPoint endPoint:self.linearGradientEndPoint options:0];

            }
                break;
            case XHSSDrawGradientDirectionBotToTop:{
                [self drawLinearGradientInContext:currentContext withGradient:gradient startPoint:self.linearGradientStartPoint endPoint:self.linearGradientEndPoint options:0];

            }
                break;
            case XHSSDrawGradientDirectionLeftToRight:{
                [self drawLinearGradientInContext:currentContext withGradient:gradient startPoint:self.linearGradientStartPoint endPoint:self.linearGradientEndPoint options:0];

            }
                break;
            case XHSSDrawGradientDirectionRightToLeft:{
                [self drawLinearGradientInContext:currentContext withGradient:gradient startPoint:self.linearGradientStartPoint endPoint:self.linearGradientEndPoint options:0];

            }
                break;
            // * RadialGradient *
            case XHSSDrawGradientDirectionRadial:{
                [self drawRadialGradientInContext:currentContext withGradient:gradient startCenter:self.radialGradientStartCenterPoint startRadius:self.radialGradientStartRadius endCenter:self.radialGradientEndCenterPoint endRadius:self.radialGradientEndRadius options:0];
            }
                break;

            default:
                break;
        }

        CGColorSpaceRelease(colorRef);
        CGGradientRelease(gradient);
        CGContextRestoreGState(currentContext);

//        CGContextSaveGState(currentContext);
//        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.innerRect cornerRadius:self.innerRectRadius];
//        UIBezierPath *outterPath = [UIBezierPath bezierPathWithRoundedRect:self.outterRect cornerRadius:self.outterRectRadius];
//        CGContextAddPath(currentContext, path.CGPath);
//        CGContextAddPath(currentContext, outterPath.CGPath);
//        CGContextSetBlendMode(currentContext, kCGBlendModeClear);
//        CGContextDrawPath(currentContext, kCGPathEOFill);
//        CGContextRestoreGState(currentContext);
    }
}

- (void) clearInnerRect:(CGContextRef)context withPath:(UIBezierPath*)path {
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextAddPath(context, path.CGPath);
    CGContextDrawPath(context, kCGPathFill);
    CGContextRestoreGState(context);
}

- (CGGradientRef)gradientWithColors:(NSArray*)colors {
    CGColorSpaceRef colorRef = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};
    CGGradientRef gradient = CGGradientCreateWithColors(colorRef, (__bridge CFArrayRef)colors, locations);
    CGColorSpaceRelease(colorRef);
    return gradient;
}

- (NSArray*)convertColorsIntoCGColorInArr:(NSArray<UIColor*>*)colors {
    NSMutableArray *resultArr = [NSMutableArray array];
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull color, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultArr addObject:(__bridge id)color.CGColor];
    }];
    return [NSArray arrayWithArray:resultArr];
}

- (void)drawLinearGradientInContext:(CGContextRef)context withGradient:(CGGradientRef)gradient startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint options:(CGGradientDrawingOptions)options {
    CGContextSetBlendMode(context, kCGBlendModeColorDodge);
    CGContextDrawLinearGradient(context,
                                gradient,
                                startPoint,
                                endPoint,
                                options);
}

- (void)drawRadialGradientInContext:(CGContextRef)context withGradient:(CGGradientRef)gradient startCenter:(CGPoint)startCenter startRadius:(CGFloat)startRadius endCenter:(CGPoint)endCenter endRadius:(CGFloat)endRadius options:(CGGradientDrawingOptions)options {
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawRadialGradient(context,
                                gradient,
                                startCenter,
                                startRadius,
                                endCenter,
                                endRadius,
                                options);
}

@end
