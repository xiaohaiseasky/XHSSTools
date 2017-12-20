//
//  XHSSShadowView.m
//  XiaoHaiLayoutFramework
//
//  Created by Apple on 2017/12/19.
//  Copyright © 2017年 XiaoHai. All rights reserved.
//

#import "XHSSShadowView.h"

@interface XHSSShadowView ()

// background area
//@property (nonatomic, strong) UIColor *backgroundColor;

// center area
//@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGRect innerRect;
@property (nonatomic, assign) CGRect outterRect;
//@property (nonatomic, assign) CGFloat innerRectRadius;
//@property (nonatomic, assign) CGFloat outterRectRadius;
//@property (nonatomic, strong) id content;

//@property (nonatomic,assign) XHSSDrawGradientDirection gradientDirection;
//@property (nonatomic, strong) NSArray<UIColor*> *gradientColors;
//
//@property (nonatomic, assign) CGPoint linearGradientStartPoint;
//@property (nonatomic, assign) CGPoint linearGradientEndPoint;
//
//@property (nonatomic, assign) CGPoint radialGradientStartCenterPoint;
//@property (nonatomic, assign) CGFloat radialGradientStartRadius;
//@property (nonatomic, assign) CGPoint radialGradientEndCenterPoint;
//@property (nonatomic, assign) CGFloat radialGradientEndRadius;

// mask area
//@property (nonatomic, strong) UIColor *maskColor;
//@property (nonatomic, assign) UIEdgeInsets innerEdgeInsets;
//@property (nonatomic, assign) UIEdgeInsets outterEdgeInsets;
//@property (nonatomic, strong) UIColor *borderColor;
//@property (nonatomic, assign) CGFloat borderWidth;
//@property (nonatomic, assign) CGFloat cornerRadius;

// shadow area
//@property (nonatomic, strong) UIColor *shadowColor;
//@property (nonatomic, assign) CGSize shadowOffset;
//@property (nonatomic, assign) CGFloat shadowBlur;

@end

@implementation XHSSShadowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor blueColor];
        self.opaque = NO;
        
        [self setupData];
    }
    return self;
}

- (void)setupData {
    
    /// *** background area ***
//    self.backgroundColor;
    
    /// *** center area ***
    self.rect = self.bounds;
    //self.innerRect = CGRectZero;
    //self.outterRect = self.rect;
    self.innerRectRadius = 0;
    self.outterRectRadius = 0;
//    self.content;
    
    self.gradientDirection = XHSSDrawGradientDirectionNOne;
//    self.gradientColors;
    
    //self.linearGradientStartPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMinY(self.innerRect));
    //self.linearGradientEndPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMaxY(self.innerRect));;

    //self.radialGradientStartCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));
    //self.radialGradientStartRadius = CGRectGetWidth(self.innerRect)/2.0f;
    //self.radialGradientEndCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));;
    //self.radialGradientEndRadius = CGRectGetWidth(self.outterRect)/2.0f;;
    
    /// *** mask area ***
//    self.maskColor;
    self.innerEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.outterEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //self.borderColor;
    //self.borderWidth;
    //self.cornerRadius;
    
    /// *** shadow area ***
//    self.shadowColor;
    self.shadowOffset = CGSizeZero;
    self.shadowBlur = 17;
    

    
    self.innerEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    
    
    self.innerRect = CGRectMake(self.rect.origin.x +self.innerEdgeInsets.left,
                                self.rect.origin.y +self.innerEdgeInsets.top,
                                self.rect.size.width -self.innerEdgeInsets.left -self.innerEdgeInsets.right,
                                self.rect.size.height -self.innerEdgeInsets.top -self.innerEdgeInsets.bottom);
    self.outterRect = CGRectMake(self.rect.origin.x -self.outterEdgeInsets.left,
                                 self.rect.origin.y -self.outterEdgeInsets.top,
                                 self.rect.size.width +self.outterEdgeInsets.left +self.outterEdgeInsets.right,
                                 self.rect.size.height +self.outterEdgeInsets.top +self.outterEdgeInsets.bottom);
    
    self.linearGradientStartPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMinY(self.innerRect));
    self.linearGradientEndPoint = CGPointMake(CGRectGetMinX(self.innerRect), CGRectGetMaxY(self.innerRect));
    
    self.radialGradientStartCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));
    self.radialGradientStartRadius = 0; // CGRectGetWidth(self.innerRect)/2.0f;
    self.radialGradientEndCenterPoint = CGPointMake(CGRectGetMidX(self.innerRect), CGRectGetMidY(self.innerRect));
    self.radialGradientEndRadius = CGRectGetWidth(self.outterRect)/2.0f;
    
    
    self.backgroundColor = [UIColor cyanColor];
    self.maskColor= [UIColor blueColor];
    self.shadowColor = [UIColor redColor];
    self.gradientColors = @[[UIColor blueColor], [UIColor redColor], [UIColor magentaColor]];
    self.gradientDirection = XHSSDrawGradientDirectionRadial;
}

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
                                    self.shadowOffset/*CGSizeZero*//*CGSizeMake(7, 7)*/,
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
    if (self.content == nil) {
        CGContextClearRect(currentContext, self.innerRect);
    }
    // ** set center background color **
    else if ([self.content isKindOfClass:[UIColor class]]) {
        CGContextSetFillColorWithColor(currentContext, [(UIColor*)self.content CGColor]);
        CGContextDrawPath(currentContext, kCGPathFill);
    }
    // ** set center background image **
    else if ([self.content isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage*)self.content;
        [image drawInRect:self.innerRect];
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
    }
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
    CGContextDrawLinearGradient(context,
                                gradient,
                                startPoint,
                                endPoint,
                                options);
}

- (void)drawRadialGradientInContext:(CGContextRef)context withGradient:(CGGradientRef)gradient startCenter:(CGPoint)startCenter startRadius:(CGFloat)startRadius endCenter:(CGPoint)endCenter endRadius:(CGFloat)endRadius options:(CGGradientDrawingOptions)options {
    CGContextDrawRadialGradient(context,
                                gradient,
                                startCenter,
                                startRadius,
                                endCenter,
                                endRadius,
                                options);
}

@end
